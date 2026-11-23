import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piggywalletspinearn/PSTool/PSLocale.dart';
import 'package:piggywalletspinearn/PSTool/PSNoticeHelp.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('dexterous.com/flutter/local_notifications');
  final calls = <MethodCall>[];
  var enabled = false;
  var failSubscription = false;
  Future<void>? pendingSubscription;
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PSLocale.initialize(const Locale('pt', 'BR'));
    calls.clear();
    enabled = false;
    failSubscription = false;
    pendingSubscription = null;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) async {
          calls.add(call);
          if (call.method == 'areNotificationsEnabled') return enabled;
          if (call.method == 'subscribeToTopic') {
            await pendingSubscription;
            return !failSubscription;
          }
          if (call.method == 'unsubscribeFromTopic') return true;
          return null;
        });
  });
  tearDown(
    () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null),
  );

  test('cold-start callers share one permission request', () async {
    await Future.wait([
      PSNoticeHelp().requestPermissionOnce(),
      PSNoticeHelp().requestPermissionOnce(),
    ]);
    expect(
      calls.where((c) => c.method == 'requestNotificationsPermission').length,
      1,
    );
  });

  test(
    'country change unsubscribes old topics and retains localized buttons',
    () async {
      await PSNoticeHelp().syncFcmTopics();
      expect(
        calls
            .where((c) => c.method == 'unsubscribeFromTopic')
            .map((c) => c.arguments['topic']),
        PSLocale.fallback.topics,
      );
      final subscribed = calls
          .where((c) => c.method == 'subscribeToTopic')
          .toList();
      expect(
        subscribed.map((c) => c.arguments['topic']),
        PSLocale.current.topics,
      );
      expect(
        subscribed
            .first
            .arguments['platformSpecifics']['styleInformation']['button'],
        PSLocale.tr('Withdraw'),
      );
      expect(
        subscribed
            .last
            .arguments['platformSpecifics']['styleInformation']['button'],
        PSLocale.tr('Claim'),
      );
      final oldTopics = PSLocale.current.topics;
      calls.clear();
      PSLocale.current = PSLocale.countries['PH']!;
      await PSNoticeHelp().syncFcmTopics();
      expect(
        calls
            .where((c) => c.method == 'unsubscribeFromTopic')
            .map((c) => c.arguments['topic']),
        oldTopics,
      );
      expect(
        (await SharedPreferences.getInstance()).getStringList('ps_fcm_topics'),
        PSLocale.current.topics,
      );
    },
  );

  test(
    'failed subscriptions are retried instead of being marked as active',
    () async {
      failSubscription = true;
      await PSNoticeHelp().syncFcmTopics();
      expect(
        (await SharedPreferences.getInstance()).getStringList('ps_fcm_topics'),
        isEmpty,
      );
      calls.clear();
      failSubscription = false;
      await PSNoticeHelp().syncFcmTopics();
      expect(calls.where((c) => c.method == 'subscribeToTopic').length, 2);
      expect(
        (await SharedPreferences.getInstance()).getStringList('ps_fcm_topics'),
        PSLocale.current.topics,
      );
    },
  );

  test(
    'foreground notification sends the local wallet copy and payout logo',
    () async {
      const copy = '{p0} is waiting in your wallet.';
      const expectedLogos = {
        'US': 'paypal',
        'ID': 'gopay',
        'PH': 'gcash',
        'BR': 'pix',
        'MX': 'paypal',
        'JP': 'paypal',
        'AR': 'mercado',
        'RU': 'sbp',
        'DE': 'paypal',
        'FR': 'paypal',
      };
      final provider = PSLocalProvider.instance;
      final oldBalance = provider.ps_dolas_number;
      provider.ps_dolas_number = 12.5;
      addTearDown(() => provider.ps_dolas_number = oldBalance);

      for (final country in [PSLocale.fallback, ...PSLocale.countries.values]) {
        PSLocale.current = country;
        calls.clear();
        await PSNoticeHelp().startSJForegroundService();

        final amount = PSLocale.money(12.5, country: country);
        final title = PSLocale.tr(copy, {'p0': amount});
        final fallbackTitle = PSLocale.translate(copy, PSLocale.fallback, {
          'p0': amount,
        });
        final channel = PSLocale.tr('Wallet balance');
        final data = calls
            .singleWhere((c) => c.method == 'startForegroundService')
            .arguments['notificationData'];
        final platform = data['platformSpecifics'];
        expect(data['id'], 1200);
        expect(data['title'], title);
        expect(data['title'], contains(amount));
        if (country != PSLocale.fallback) expect(title, isNot(fallbackTitle));
        expect(platform['channelId'], 'pigwalletForeground');
        expect(platform['channelName'], channel);
        expect(platform['styleInformation']['value'], amount);
        expect(platform['styleInformation']['button'], PSLocale.tr('Withdraw'));
        final logo = 'ps_foreground_${expectedLogos[country.country]!}';
        expect(platform['styleInformation']['logo'], logo);
        expect(platform['styleInformation']['image'], 'ps_freground');
        expect(
          File(
            'android/app/src/main/res/drawable-nodpi/$logo.png',
          ).existsSync(),
          isTrue,
          reason: 'Missing Android logo for ${country.country}',
        );
        final systemChannel = calls.singleWhere(
          (c) => c.method == 'createNotificationChannel',
        );
        expect(systemChannel.arguments['id'], 'pigwalletForeground');
        expect(systemChannel.arguments['name'], channel);
      }
    },
  );

  test(
    'granting permission resumes future schedules once without replaying missed alerts',
    () async {
      await PSNoticeHelp().refreshNotificationPermission();
      expect(
        calls.where((c) => c.method == 'periodicallyShowWithDuration'),
        isEmpty,
      );
      calls.clear();
      enabled = true;
      final subscription = Completer<void>();
      pendingSubscription = subscription.future;
      try {
        await PSNoticeHelp().refreshNotificationPermission().timeout(
          const Duration(seconds: 2),
        );
      } finally {
        subscription.complete();
      }
      expect(
        calls.where((c) => c.method == 'periodicallyShowWithDuration').length,
        8,
      );
      expect(
        calls.where((c) => c.method == 'showBroadcastNotification').length,
        2,
      );
      expect(
        calls.where((c) => c.method == 'startForegroundService'),
        hasLength(1),
      );
      expect(calls.where((c) => c.method == 'show'), isEmpty);
      expect(
        calls.where((c) => c.method == 'pendingNotificationRequests'),
        isEmpty,
      );
      await PSNoticeHelp().syncFcmTopics();
      calls.clear();
      await PSNoticeHelp().refreshNotificationPermission();
      expect(calls.map((c) => c.method), ['areNotificationsEnabled']);
    },
  );
}
