import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:piggywalletspinearn/PSBase/PSTbaBar.dart';
import 'package:piggywalletspinearn/PSDialog/PSDialog.dart';
import 'package:piggywalletspinearn/PSDialog/PSGuideDialog.dart';
import 'package:piggywalletspinearn/PSTool/PSLocale.dart';
import 'package:piggywalletspinearn/PSTool/PSNumberHelpers.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import 'package:piggywalletspinearn/PSTool/ps_img.dart';
import 'package:piggywalletspinearn/PSTool/ps_stroke_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'widget_test.dart' show host;

Finder paragraphContaining(String text) => find.byWidgetPredicate(
  (widget) => widget is RichText && widget.text.toPlainText().contains(text),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    await PSLocale.initialize(const Locale('en', 'US'));
    await PSNumberHelpers().initNumberModel();
    for (final font in [
      ('Black_mianfeiziti', 'Black_mianfeiziti.ttf'),
      ('PSFallback', 'NotoSans-Regular.ttf'),
      ('PSJapanese', 'NotoSansJP.ttf'),
    ]) {
      await (FontLoader(
        font.$1,
      )..addFont(rootBundle.load('assets/File/${font.$2}'))).load();
    }
  });
  testWidgets('localized button labels remain centered and fit their width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final country in [PSLocale.fallback, ...PSLocale.countries.values]) {
      PSLocale.current = country;
      for (final text in [
        PSLocale.tr('Withdraw'),
        PSLocale.tr('Confirm'),
        PSLocale.money(150000),
      ]) {
        final key = GlobalKey();
        await tester.pumpWidget(
          host(
            Scaffold(
              body: Center(
                child: SizedBox(
                  key: key,
                  width: 115,
                  height: 36,
                  child: PSStrokeText(
                    text: text,
                    size: 20,
                    color: Colors.white,
                    weight: FontWeight.w900,
                    skWidth: 1,
                    skColor: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        );
        final paragraphs = find.descendant(
          of: find.byKey(key),
          matching: find.byType(RichText),
        );
        for (final element in paragraphs.evaluate()) {
          final box = element.renderObject! as RenderParagraph;
          expect(
            box.getMaxIntrinsicWidth(36),
            lessThanOrEqualTo(115.1),
            reason: '${country.country} $text',
          );
          final center = box.localToGlobal(box.size.center(Offset.zero));
          expect(
            (center - tester.getRect(find.byKey(key)).center).distance,
            lessThan(1),
            reason: '${country.country} $text',
          );
        }
        expect(tester.takeException(), isNull);
      }
    }
  });

  testWidgets(
    'localized guidance paragraphs remain readable through the last line',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      SharedPreferences.setMockInitialValues({});
      final messenger =
          TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
      const channel = MethodChannel('flutter_tba_info');
      messenger.setMockMethodCallHandler(channel, (_) async => 'preview');
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
      const account = '1long_private_account_2334';
      final provider = PSLocalProvider.instance;
      final previousAccount = provider.ps_account_id;
      final previousBalance = provider.ps_dolas_number;
      provider.ps_account_id = account;
      provider.ps_dolas_number = 30.15;
      addTearDown(() {
        provider.ps_account_id = previousAccount;
        provider.ps_dolas_number = previousBalance;
      });

      const notice =
          'Your payment information has been confirmed successfully. As a new user, it will be super easy to withdraw cash today!';
      const wheel =
          'interest bonus in your savings. More bonus, faster withdrawals!';
      for (final size in [const Size(320, 568), const Size(768, 1024)]) {
        tester.view.physicalSize = size;
        for (final country in [
          PSLocale.fallback,
          ...PSLocale.countries.values,
        ]) {
          PSLocale.current = country;
          for (final (dialog, message, fontSize) in <(Widget, String, double)>[
            (const PSGuideNew7Dialog(), 'more to cash out!', 14),
            (const PSGuideNew11Dialog(), notice, 12),
            (const PSGuideNew13Dialog(), wheel, 16),
            (
              const PSQuizRankTwoDialog(quiz_num: 3),
              'Withdrawal Made Easy!!',
              22,
            ),
            (const PSTXRankDialog(), 'No need to wait,', 14),
          ]) {
            await tester.pumpWidget(host(dialog));
            await tester.pump();
            final result = paragraphContaining(PSLocale.tr(message));
            final reason = '${country.country} $size ${dialog.runtimeType}';
            expect(result, findsOneWidget, reason: reason);
            final paragraph = tester.renderObject<RenderParagraph>(result);
            final text = paragraph.text.toPlainText();
            final end = text.trimRight().length;
            expect(paragraph.didExceedMaxLines, isFalse, reason: reason);
            expect(
              paragraph.textScaler.scale(fontSize),
              greaterThanOrEqualTo(10),
              reason: reason,
            );
            final lastGlyph = paragraph.getBoxesForSelection(
              TextSelection(baseOffset: end - 1, extentOffset: end),
            );
            expect(lastGlyph, isNotEmpty, reason: reason);
            expect(
              lastGlyph.last.bottom,
              lessThanOrEqualTo(paragraph.size.height + 0.5),
              reason: reason,
            );
            if (dialog is PSGuideNew11Dialog) {
              expect(
                text,
                contains(PSLocale.tr('Dear User{p0}:', {'p0': ' 1***2334'})),
              );
              expect(text, isNot(contains(account)));
            }
            expect(tester.takeException(), isNull, reason: reason);
            await tester.pumpWidget(const SizedBox.shrink());
          }
        }
      }
      await tester.pump(const Duration(milliseconds: 500));
    },
  );

  testWidgets('reward checkmarks and each localized label are centered', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    const channel = MethodChannel('flutter_tba_info');
    messenger.setMockMethodCallHandler(channel, (_) async => 'preview');
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final size in [const Size(320, 568), const Size(768, 1024)]) {
      tester.view.physicalSize = size;
      for (final country in [PSLocale.fallback, ...PSLocale.countries.values]) {
        PSLocale.current = country;
        await tester.pumpWidget(
          host(
            const PSPopAwardToolDialog(type: .quiz, isGuide: false, award: 6),
          ),
        );
        await tester.pump();
        final center = tester.getCenter(find.byType(PSPopAwardToolDialog)).dx;
        for (final message in [
          'Ensure Safety',
          'Arrived within 24 hours',
          '1M+ User Trusted',
        ]) {
          final translation = PSLocale.tr(message);
          final label = paragraphContaining(translation);
          final row = find
              .ancestor(of: label, matching: find.byType(Row))
              .first;
          final reason = '${country.country} $size $message';
          expect(
            tester.getCenter(row).dx,
            closeTo(center, 0.5),
            reason: reason,
          );
          final paragraph = tester.renderObject<RenderParagraph>(label);
          expect(paragraph.didExceedMaxLines, isFalse, reason: reason);
          final lastGlyph = paragraph.getBoxesForSelection(
            TextSelection(
              baseOffset: translation.length - 1,
              extentOffset: translation.length,
            ),
          );
          expect(lastGlyph, isNotEmpty, reason: reason);
          expect(
            lastGlyph.last.right,
            lessThanOrEqualTo(paragraph.size.width + 0.5),
            reason: reason,
          );
        }
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
      }
    }
  });

  testWidgets('growth bonus actions stay in the blue footer for each locale', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});
    var permissionGranted = true;
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    const notifications = MethodChannel(
      'dexterous.com/flutter/local_notifications',
    );
    const analytics = MethodChannel('flutter_tba_info');
    messenger.setMockMethodCallHandler(notifications, (call) async {
      if (call.method == 'areNotificationsEnabled') return permissionGranted;
      return null;
    });
    messenger.setMockMethodCallHandler(analytics, (_) async => 'preview');
    addTearDown(() {
      messenger.setMockMethodCallHandler(notifications, null);
      messenger.setMockMethodCallHandler(analytics, null);
    });
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    for (final size in [
      const Size(320, 568),
      const Size(375, 812),
      const Size(768, 1024),
    ]) {
      tester.view.physicalSize = size;
      for (final country in [PSLocale.fallback, ...PSLocale.countries.values]) {
        PSLocale.current = country;
        for (final old in [false, true]) {
          for (final enabled in [true, false]) {
            permissionGranted = enabled;
            await tester.pumpWidget(host(PSGuideNew12Dialog(is_old: old)));
            await tester.pump();
            final label = paragraphContaining(
              PSLocale.tr(enabled ? 'Go Earn' : 'Reminder Me'),
            );
            final action = find
                .ancestor(of: label, matching: find.byType(ParticleButton))
                .first;
            final card = find
                .ancestor(of: action, matching: find.byType(Stack))
                .first;
            final button = tester.getRect(action);
            final bounds = tester.getRect(card);
            final reason =
                '${country.country} $size old=$old permission=$enabled';

            expect(
              button.center.dx,
              closeTo(bounds.center.dx, 0.5),
              reason: reason,
            );
            // The background's cream panel ends at 77% of the card height.
            final footerTop = bounds.top + bounds.height * 0.77;
            expect(button.top, greaterThan(footerTop), reason: reason);
            expect(
              button.center.dy,
              closeTo((footerTop + bounds.bottom) / 2, 1),
              reason: reason,
            );
            expect(button.bottom, lessThan(bounds.bottom), reason: reason);
            for (final element in label.evaluate()) {
              final paragraph = element.renderObject! as RenderParagraph;
              expect(paragraph.didExceedMaxLines, isFalse, reason: reason);
              expect(
                paragraph.textScaler.scale(24),
                greaterThanOrEqualTo(16),
                reason: reason,
              );
            }
            expect(tester.takeException(), isNull, reason: reason);
            await tester.pumpWidget(const SizedBox.shrink());
          }
        }
      }
    }
  });

  testWidgets(
    'wheel guide follows the bottom tab through viewport and inset changes',
    (tester) async {
      PSLocale.current = PSLocale.fallback;
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(375, 812);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetPadding);
      addTearDown(() => PigTabController.switchTo(0));
      PigTabController.switchTo(0);
      await tester.pumpWidget(
        host(
          Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: TextButton(
                  onPressed: () => context.tipShow2(const PSGuideNew13Dialog()),
                  child: const Text('Open guide'),
                ),
              ),
              bottomNavigationBar: ValueListenableBuilder<int>(
                valueListenable: PigTabController.currentIndex,
                builder: (_, index, _) => CustomNavBarWidget(
                  [
                    for (final name in ['Earn', 'Quiz', 'Wheel', 'Cash'])
                      PersistentBottomNavBarItem(
                        icon: const PSImg(name: 'ps_wheel_icon'),
                        title: name,
                      ),
                  ],
                  selectedIndex: index,
                  onItemSelected: PigTabController.switchTo,
                  wheelIconLink: PigTabController.wheelIconLink,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open guide'));
      await tester.pumpAndSettle();
      final target = find.byWidgetPredicate(
        (widget) =>
            widget is CompositedTransformTarget &&
            widget.link == PigTabController.wheelIconLink,
      );
      Finder guideImage(String name) => find.descendant(
        of: find.byType(PSGuideNew13Dialog),
        matching: find.byWidgetPredicate(
          (widget) => widget is PSImg && widget.name == name,
        ),
      );
      final highlight = guideImage('ps_wheel_icon');
      final arrow = guideImage('ps_guide4_3');
      for (final (size, inset) in [
        (const Size(375, 812), 0.0),
        (const Size(320, 568), 16.0),
        (const Size(430, 932), 34.0),
        (const Size(768, 1024), 24.0),
      ]) {
        tester.view.physicalSize = size;
        tester.view.padding = FakeViewPadding(bottom: inset);
        await tester.pumpAndSettle();
        final tabRect = tester.getRect(target);
        final navRect = tester.getRect(find.byType(CustomNavBarWidget));
        final highlightRect = tester.getRect(highlight);
        final arrowRect = tester.getRect(arrow);
        expect(navRect.bottom, closeTo(size.height, 0.5));
        expect(tabRect.bottom, lessThanOrEqualTo(navRect.bottom - inset));
        expect(
          (highlightRect.topLeft - tabRect.topLeft).distance,
          lessThan(0.5),
        );
        expect(
          (highlightRect.bottomRight - tabRect.bottomRight).distance,
          lessThan(0.5),
        );
        expect(arrowRect.center.dx, closeTo(tabRect.center.dx, 0.5));
        expect(arrowRect.bottom, lessThan(tabRect.top));
        expect(tester.takeException(), isNull);
      }
      await tester.tapAt(tester.getCenter(highlight));
      await tester.pumpAndSettle();
      expect(find.byType(PSGuideNew13Dialog), findsNothing);
      expect(PigTabController.currentIndex.value, PigTabController.wheelIndex);
    },
  );
}
