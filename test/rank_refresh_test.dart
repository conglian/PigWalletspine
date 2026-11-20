import 'dart:convert';
import 'package:fake_async/fake_async.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piggywalletspinearn/PSTool/PSRankData.dart';

List<PSUserData> fixture() => List.generate(
  56,
  (i) => PSUserData(
    id: i,
    username: 'Fixture $i',
    totalEarning: 180.0 - i,
    adsWatched: 100 - i,
  ),
);
String snapshot(List<PSUserData> data) =>
    jsonEncode(data.map((item) => item.toJson()).toList());

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('foreground refreshes exactly at local midnight', () {
    fakeAsync((clock) {
      var refreshes = 0;
      final start = DateTime(2026, 11, 19, 23, 59, 30);
      final refresher = PSDailyRankRefresher(
        now: () => start.add(clock.elapsed),
        onRefresh: () async {
          refreshes++;
        },
      )..start();
      clock.flushMicrotasks();
      expect(refreshes, 1);
      clock.elapse(const Duration(seconds: 29));
      expect(refreshes, 1);
      clock.elapse(const Duration(seconds: 1));
      clock.flushMicrotasks();
      expect(refreshes, 2);
      clock.elapse(const Duration(hours: 23));
      clock.flushMicrotasks();
      expect(refreshes, 2);
      refresher.dispose();
    });
  });

  test('background stops the timer and next-day resume refreshes once', () {
    fakeAsync((clock) {
      var refreshes = 0;
      final start = DateTime(2026, 11, 19, 23, 59, 30);
      final refresher = PSDailyRankRefresher(
        now: () => start.add(clock.elapsed),
        onRefresh: () async {
          refreshes++;
        },
      )..start();
      clock.flushMicrotasks();
      refresher.didChangeAppLifecycleState(AppLifecycleState.paused);
      clock.elapse(const Duration(hours: 25));
      clock.flushMicrotasks();
      expect(refreshes, 1);
      refresher.didChangeAppLifecycleState(AppLifecycleState.resumed);
      clock.flushMicrotasks();
      expect(refreshes, 2);
      refresher.didChangeAppLifecycleState(AppLifecycleState.resumed);
      clock.flushMicrotasks();
      expect(refreshes, 2);
      refresher.dispose();
      clock.elapse(const Duration(days: 2));
      expect(refreshes, 2);
    });
  });

  test(
    'same-day cached rankings survive reopening; next-day concurrent calls share data',
    () async {
      final old = fixture();
      await PSUserDataManager.savePSUserData(
        old,
        now: DateTime(2026, 11, 19, 23, 59),
      );
      expect(
        snapshot(
          await PSUserDataManager.getPSUserData(
            now: DateTime(2026, 11, 19, 23, 59, 59),
          ),
        ),
        snapshot(old),
      );
      final results = await Future.wait(
        List.generate(
          3,
          (_) => PSUserDataManager.getPSUserData(now: DateTime(2026, 11, 20)),
        ),
      );
      expect(results.every((data) => data.length == 56), isTrue);
      expect(snapshot(results.first), isNot(snapshot(old)));
      expect(results.map(snapshot).toSet().length, 1);
      expect(
        (await SharedPreferences.getInstance()).getString('ps_rank_day'),
        '2026-11-20',
      );
      expect(
        snapshot(
          await PSUserDataManager.getPSUserData(
            now: DateTime(2026, 11, 20, 22),
          ),
        ),
        snapshot(results.first),
      );
    },
  );

  test('legacy date cache and corrupt cache are handled', () async {
    final prefs = await SharedPreferences.getInstance();
    await PSUserDataManager.savePSUserData(
      fixture(),
      now: DateTime(2026, 11, 19, 23),
    );
    await prefs.remove('ps_rank_day');
    expect(
      snapshot(
        await PSUserDataManager.getPSUserData(
          now: DateTime(2026, 11, 19, 23, 30),
        ),
      ),
      snapshot(fixture()),
    );
    await prefs.setString('lastUpdate', 'broken-date');
    await prefs.setStringList('PSUserData', ['not-json']);
    expect(
      (await PSUserDataManager.getPSUserData(
        now: DateTime(2026, 11, 20),
      )).length,
      56,
    );
    expect(
      PSUserDataManager.nextRefreshAt(DateTime(2026, 12, 31, 23, 59)),
      DateTime(2027, 1, 1),
    );
  });
}
