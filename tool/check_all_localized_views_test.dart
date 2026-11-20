// Run: python3 tool/run_localization_qa.py /absolute/path/to/flutter
import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_local_notifications_platform_interface/flutter_local_notifications_platform_interface.dart';
import 'package:spine_flutter/spine_flutter.dart' as spine;
import 'package:piggywalletspinearn/PSDialog/PSDialog.dart';
import 'package:piggywalletspinearn/PSBase/PSLuanch.dart';
import 'package:piggywalletspinearn/PSBase/PSTbaBar.dart';
import 'package:piggywalletspinearn/PSDialog/PSGuideDialog.dart';
import 'package:piggywalletspinearn/PSGuide/PSGuideAOne.dart';
import 'package:piggywalletspinearn/PSGuide/PSGuideATwo.dart';
import 'package:piggywalletspinearn/PSGuide/PSGuideAThree.dart';
import 'package:piggywalletspinearn/PSHome/PSHome.dart';
import 'package:piggywalletspinearn/PSHome/PSQuiz.dart';
import 'package:piggywalletspinearn/PSHome/PSWheel.dart';
import 'package:piggywalletspinearn/PSPigVC/PSPigHome.dart';
import 'package:piggywalletspinearn/PSPigVC/PSPigQuiz.dart';
import 'package:piggywalletspinearn/PSPigVC/PSPigWheel.dart';
import 'package:piggywalletspinearn/PSPigVC/PSPigCash.dart';
import 'package:piggywalletspinearn/PSTool/PSArtwork.dart';
import 'package:piggywalletspinearn/PSTool/PSLocale.dart';
import 'package:piggywalletspinearn/PSTool/PSNumberHelpers.dart';
import 'package:piggywalletspinearn/PSTool/PSRankData.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import '../test/widget_test.dart' show host;
import 'render_localization_previews_test.dart' show page;

Widget atLevel(int level, Widget Function() build) {
  PSLocalProvider.instance.ps_pig_level = level;
  return build();
}

List<(String, Widget Function())> cases() => [
  ('launch', () => PSLaunch.preview()),
  ('home', () => const PSPigHome.preview()),
  ('quiz', () => const PSPigQuiz()),
  ('wheel', () => const PSPigWheel()),
  ('cash', () => const PSPigCash()),
  for (final level in [1, 2]) ...[
    ('home_level$level', () => atLevel(level, () => const PSPigHome.preview())),
    ('quiz_level$level', () => atLevel(level, () => const PSPigQuiz())),
    ('wheel_level$level', () => atLevel(level, () => const PSPigWheel())),
    ('cash_level$level', () => atLevel(level, () => const PSPigCash())),
  ],
  ('legacy_home', () => const PSHome()),
  ('legacy_quiz', () => const PSQuiz()),
  ('legacy_wheel', () => const PSWheel()),
  ('onboarding_1', () => const PSGuideOne()),
  ('onboarding_2', () => const PSGuideTwo()),
  ('onboarding_3', () => const PSGuideThree()),
  ('confirm_information', () => PSConfirmInformationDialog(onApply: () {})),
  ('about_payout', () => const PSAboutTXDialog(isConfim: false)),
  ('payout_form', () => const PSInfoSubmitDialog()),
  ('quiz_rank_1', () => const PSQuizRankOneDialog()),
  ('quiz_rank_2', () => const PSQuizRankTwoDialog(quiz_num: 3)),
  (
    'confirmed',
    () => PSConfimOneDialog(
      isConfim: true,
      contentStr: PSLocale.tr(
        'Payout details confirmed. Quiz to release your {p0} cash out.',
        {'p0': PSLocale.money(100)},
      ),
    ),
  ),
  ('confirm_2', () => const PSConfimTwoDialog()),
  ('not_enough', () => const PSTXOutDialog(seletcd_row: 0)),
  for (var i = 0; i < 3; i++) ('last_task_$i', () => PSTXLastDialog(type: i)),
  ('queue', () => const PSTXRankDialog()),
  ('gold_unlocked', () => const PSGuide4Dialog()),
  ('diamond_unlocked', () => const PSdolls100Dialog()),
  for (final s in AdStatus.values)
    ('tip_${s.name}', () => PSPopTipsToolDialog(adStatus: s)),
  for (final t in AwardType.values)
    (
      'award_${t.name}',
      () => PSPopAwardToolDialog(type: t, isGuide: false, award: 6),
    ),
  ('review', () => const PSReviewingDialog()),
  ('review_failed', () => const PSReviewFaildDialog()),
  ('diamond_reward', () => PSPopDomandAwardADialog()),
  ('more_chances', () => PSPopMoreChanceDialog()),
  (
    'wheel_reward',
    () => PSPopWheelAwaradDialog(
      award: 6,
      is_wheel: true,
      is_rv: false,
      type: AwardType.wheel,
    ),
  ),
  (
    'bubble_reward',
    () => PSPopWheelAwaradDialog(
      award: 6,
      is_wheel: false,
      is_rv: true,
      type: AwardType.buble,
    ),
  ),
  ('wheel_empty', () => PSPopWheelOldDog()),
  for (final gold in [false, true])
    (
      'pig_story_$gold',
      () => PSPopCunCashDog(
        userData: PSUserData(
          id: 0,
          username: 'User ****1234',
          totalEarning: 180,
          adsWatched: 160,
        ),
        is_gold: gold,
      ),
    ),
  ('get_award', () => PSPoGetAwardDog(award: 6)),
  ('guide_1', () => const PSGuideNew1Dialog()),
  ('guide_2', () => const PSGuideNew2Dialog()),
  ('guide_3', () => const PSGuideNew3Dialog()),
  ('guide_4', () => const PSGuideNew4Dialog()),
  ('guide_5', () => const PSGuideNew5Dialog()),
  ('guide_6', () => const PSGuideNew6Dialog()),
  ('guide_7', () => const PSGuideNew7Dialog()),
  ('guide_8', () => const PSGuideNew8Dialog()),
  ('guide_9', () => const PSGuideNew9Dialog()),
  ('guide_10', () => const PSGuideNew10Dialog(showToast: false)),
  ('guide_11', () => const PSGuideNew11Dialog()),
  for (final old in [false, true])
    ('guide_12_$old', () => PSGuideNew12Dialog(is_old: old)),
  (
    'guide_13',
    () => Stack(
      fit: StackFit.expand,
      children: [
        page(home: true, wheelIconLink: PigTabController.wheelIconLink),
        const ColoredBox(color: Colors.black54),
        const PSGuideNew13Dialog(),
      ],
    ),
  ),
];
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await PSLocale.initialize(const Locale('en', 'US'));
    await PSNumberHelpers().initNumberModel();
    await PSLocalProvider.instance.init();
    await spine.initSpineFlutter();
    FlutterLocalNotificationsPlatform.instance =
        AndroidFlutterLocalNotificationsPlugin();
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(
      const MethodChannel('flutter_tba_info'),
      (_) async => 'preview',
    );
    messenger.setMockMethodCallHandler(
      const MethodChannel('dexterous.com/flutter/local_notifications'),
      (call) async {
        if (call.method == 'getNotificationAppLaunchDetails') return null;
        if (call.method == 'extractMessageReceivedNum') return 0;
        return true;
      },
    );
    for (final item in [
      ('Black_mianfeiziti', 'Black_mianfeiziti.ttf'),
      ('PSFallback', 'NotoSans-Regular.ttf'),
      ('PSJapanese', 'NotoSansJP.ttf'),
      ('Roboto', 'NotoSans-Regular.ttf'),
    ]) {
      await (FontLoader(
        item.$1,
      )..addFont(rootBundle.load('assets/File/${item.$2}'))).load();
    }
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lastUpdate', DateTime.now().toIso8601String());
    await prefs.setStringList('PSUserData', [
      for (var i = 0; i < 56; i++)
        jsonEncode({
          'id': i,
          'username': 'User ****${1234 + i}',
          'totalEarning': 180.0 - i * 2,
          'adsWatched': 160 - i,
        }),
    ]);
  });
  testWidgets(
    'all localized page and dialog layouts',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      final failures = <Map<String, String>>[],
          checked = <Map<String, String>>[];
      final output = Directory('artifacts/qa')..createSync(recursive: true);
      for (final size in [
        const Size(375, 812),
        const Size(320, 568),
        const Size(768, 1024),
      ]) {
        tester.view.physicalSize = size;
        for (final country in [
          PSLocale.fallback,
          ...PSLocale.countries.values,
        ]) {
          PSLocale.current = country;
          await tester.pumpWidget(host(const SizedBox.shrink()));
          await tester.runAsync(() async {
            final context = tester.element(find.byType(MaterialApp));
            for (final asset in {
              ...PSArtwork.labels.keys,
              ...PSArtwork.buttons.keys,
              ...PSArtwork.composites,
            })
              await precacheImage(PSArtwork.provider(asset), context);
          });
          for (final entry in cases()) {
            final key = GlobalKey();
            PSLocalProvider.instance.ps_pig_level = 0;
            PSLocalProvider.instance.ps_dolas_number = 12.75;
            PSLocalProvider.instance.ps_pig_level_index = 3;
            PSLocalProvider.instance.ps_tx_ing_account = 0;
            PSLocalProvider.instance.ps_account_seled_index = 0;
            PSLocalProvider.instance.ps_account_id = entry.$1 == 'guide_11'
                ? '1234562334'
                : '';
            final info = {
              'country': country.country,
              'view': entry.$1,
              'size': '${size.width.toInt()}x${size.height.toInt()}',
            };
            try {
              await tester.pumpWidget(
                host(
                  RepaintBoundary(
                    key: key,
                    child: Scaffold(
                      backgroundColor: const Color(0xFF292B32),
                      body: Center(child: entry.$2()),
                    ),
                  ),
                ),
              );
              await tester.runAsync(() async {
                await Future<void>.delayed(const Duration(milliseconds: 25));
              });
              await tester.pump(const Duration(milliseconds: 700));
              await tester.runAsync(() async {
                await Future<void>.delayed(const Duration(milliseconds: 25));
              });
              await tester.pump();
              Object? error;
              while ((error = tester.takeException()) != null)
                failures.add({...info, 'error': '$error'});
              if (size.width == 375) {
                final boundary =
                    key.currentContext!.findRenderObject()!
                        as RenderRepaintBoundary;
                final img = await tester.runAsync(
                  () => boundary.toImage(pixelRatio: 1),
                );
                final bytes = await tester.runAsync(
                  () => img!.toByteData(format: ui.ImageByteFormat.png),
                );
                File(
                  '${output.path}/${country.country}_${entry.$1}.png',
                ).writeAsBytesSync(bytes!.buffer.asUint8List());
                img!.dispose();
              }
              checked.add(info);
            } catch (error) {
              failures.add({...info, 'error': '$error'});
            }
            await tester.pumpWidget(host(const SizedBox.shrink()));
            Object? error;
            while ((error = tester.takeException()) != null)
              failures.add({...info, 'error': '$error'});
          }
        }
      }
      // The final guide preview mounts the homepage's delayed button animations.
      await tester.pump(const Duration(seconds: 2));
      File('${output.path}/results.json').writeAsStringSync(
        const JsonEncoder.withIndent(
          '  ',
        ).convert({'checked': checked, 'failures': failures}),
      );
      expect(failures, isEmpty, reason: 'See artifacts/qa/results.json');
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );
}
