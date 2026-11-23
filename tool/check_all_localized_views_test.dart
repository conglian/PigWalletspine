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
import 'package:piggywalletspinearn/PSPigVC/PSPigQuiz.dart';
import 'package:piggywalletspinearn/PSPigVC/PSPigWheel.dart';
import 'package:piggywalletspinearn/PSTool/PSArtwork.dart';
import 'package:piggywalletspinearn/PSTool/PSInAppNotification.dart';
import 'package:piggywalletspinearn/PSTool/ps_WebKitView.dart';
import 'package:piggywalletspinearn/PSModel/PSQuestionModel.dart';
import 'package:piggywalletspinearn/PSTool/AESHelper.dart';
import 'package:piggywalletspinearn/main.dart'
    show
        mathString,
        dailyLifeString,
        natureLifeString,
        scienceString,
        animalString;
import 'package:piggywalletspinearn/PSTool/PSLocale.dart';
import 'package:piggywalletspinearn/PSTool/PSNumberHelpers.dart';
import 'package:piggywalletspinearn/PSTool/PSRankData.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart'
    show ParticleButton;
import 'package:piggywalletspinearn/PSTool/ps_stroke_text.dart';
import '../test/widget_test.dart' show host;
import 'render_localization_previews_test.dart' show page;

Widget atLevel(int level, Widget Function() build) {
  PSLocalProvider.instance.ps_pig_level = level;
  return build();
}

List<(String, Widget Function())> cases() => [
  ('launch', () => PSLaunch.preview()),
  for (final level in [0, 1, 2]) ...[
    (
      level == 0 ? 'home' : 'home_level$level',
      () => atLevel(level, () => page(home: true)),
    ),
    (
      level == 0 ? 'quiz' : 'quiz_level$level',
      () => atLevel(level, () => page(body: const PSPigQuiz(), tabIndex: 1)),
    ),
    (
      level == 0 ? 'wheel' : 'wheel_level$level',
      () => atLevel(level, () => page(body: const PSPigWheel(), tabIndex: 2)),
    ),
    (level == 0 ? 'cash' : 'cash_level$level', () => atLevel(level, page)),
  ],
  ('quiz_first_question', () => page(body: const PSPigQuiz(), tabIndex: 1)),
  for (final (name, title) in [
    ('web_privacy', 'Privacy Policy'),
    ('web_game', 'Game'),
    ('web_gameplay', 'GamePlay'),
  ])
    (
      name,
      () => PSWebkitScaffold(
        title: PSLocale.tr(title),
        child: const SizedBox.expand(),
      ),
    ),
  (
    'in_app_notice',
    () => Stack(
      fit: StackFit.expand,
      children: [
        page(home: true),
        SafeArea(
          minimum: const EdgeInsets.fromLTRB(7, 8, 7, 0),
          child: Align(
            alignment: Alignment.topCenter,
            child: PSInAppNotificationCard(
              row: 0,
              title: PSLocale.tr('Withdrawal Sent'),
              content: PSLocale.tr('{p0} received {p1} via {p2} successfully', {
                'p0': 'Michael',
                'p1': PSLocale.money(200),
                'p2': PSLocale.current.payments.reduce(
                  (first, second) =>
                      first.length > second.length ? first : second,
                ),
              }),
            ),
          ),
        ),
      ],
    ),
  ),
  ('legacy_home', () => const PSHome()),
  ('legacy_quiz', () => page(body: const PSQuiz(), tabIndex: 1)),
  ('legacy_wheel', () => const PSWheel()),
  ('onboarding_1', () => const PSGuideOne()),
  ('onboarding_2', () => const PSGuideTwo()),
  ('onboarding_3', () => const PSGuideThree()),
  ('confirm_information', () => PSConfirmInformationDialog(onApply: () {})),
  ('about_payout', () => const PSAboutTXDialog(isConfim: false)),
  ('about_saved_payout', () => const PSAboutTXDialog(isConfim: true)),
  ('payout_form', () => const PSInfoSubmitDialog()),
  ('payout_form_keyboard', () => const PSInfoSubmitDialog()),
  ('payout_form_pagbank', () => const PSInfoSubmitDialog()),
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
  for (var i = 0; i < 9; i++) ('last_task_$i', () => PSTXLastDialog(type: i)),
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
  ('guide_6_large_balance', () => const PSGuideNew6Dialog()),
  ('guide_7', () => const PSGuideNew7Dialog()),
  ('guide_8', () => const PSGuideNew8Dialog()),
  ('guide_9', () => const PSGuideNew9Dialog()),
  ('guide_10', () => const PSGuideNew10Dialog(showToast: false)),
  ('guide_10_keyboard', () => const PSGuideNew10Dialog(showToast: false)),
  ('guide_11', () => const PSGuideNew11Dialog()),
  for (final old in [false, true])
    ('guide_12_$old', () => PSGuideNew12Dialog(is_old: old)),
  ('guide_4_second', () => const PSGuideNew4Dialog()),
  for (final old in [false, true])
    ('guide_12_denied_$old', () => PSGuideNew12Dialog(is_old: old)),
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
Set<String> filter(String input) =>
    input.isEmpty ? {} : input.split(',').toSet();

bool isQuizPage(String view) =>
    view == 'quiz' ||
    view.startsWith('quiz_level') ||
    view == 'quiz_first_question' ||
    view == 'legacy_quiz';

List<Map<String, String>> inspectText(
  RenderRepaintBoundary boundary,
  Map<String, String> info,
) {
  final findings = <Map<String, String>>[];
  final seen = <String>{};
  final viewport = Offset.zero & boundary.size;
  void visit(RenderObject node) {
    if (node is RenderOffstage && node.offstage) return;
    if (node is RenderParagraph && node.hasSize) {
      final bounds = MatrixUtils.transformRect(
        node.getTransformTo(boundary),
        Offset.zero & node.size,
      );
      final value = node.text.toPlainText().trim();
      final scale = node.textScaler.scale(1);
      if (value.runes.length >= 3 && bounds.overlaps(viewport)) {
        final issue = node.didExceedMaxLines
            ? 'max_lines'
            : scale < .72
            ? 'small_text'
            : null;
        if (issue != null && seen.add('$issue:$value')) {
          findings.add({
            ...info,
            'issue': issue,
            'text': value,
            'scale': scale.toStringAsFixed(2),
          });
        }
      }
    }
    node.visitChildren(visit);
  }

  boundary.visitChildren(visit);
  return findings;
}

Future<void> advanceView(WidgetTester tester, String view) async {
  final home = view == 'home' || view.startsWith('home_level');
  final frames = switch (view) {
    'guide_4_second' || 'legacy_home' || 'onboarding_3' => 6,
    'pig_story_false' || 'pig_story_true' => 7,
    'guide_2' || 'quiz_rank_2' => 4,
    'guide_4' || 'guide_5' || 'guide_7' => 2,
    'quiz_first_question' => 10,
    _ => isQuizPage(view) || home ? 4 : 1,
  };
  for (var i = 0; i < frames; i++) {
    await tester.pump(const Duration(milliseconds: 650));
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  var notificationsEnabled = true;
  const emojiFont = String.fromEnvironment('QA_EMOJI_FONT');
  final banks = [
    for (final source in [
      mathString,
      dailyLifeString,
      natureLifeString,
      scienceString,
      animalString,
    ])
      [
        for (final entry in jsonDecode(AESHelper.decryptString(source)) as List)
          QuestionModel.fromJson(Map<String, dynamic>.from(entry)),
      ],
  ];
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
        if (call.method == 'areNotificationsEnabled')
          return notificationsEnabled;
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
    if (emojiFont.isNotEmpty) {
      await (FontLoader('Noto Color Emoji')
            ..addFont(File(emojiFont).readAsBytes().then(ByteData.sublistView)))
          .load();
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
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetPadding);
      addTearDown(tester.view.resetViewPadding);
      addTearDown(tester.view.resetViewInsets);
      final failures = <Map<String, String>>[];
      final checked = <Map<String, String>>[];
      final textFindings = <Map<String, String>>[];
      final selectedCountries = filter(
        const String.fromEnvironment('QA_COUNTRIES'),
      );
      final selectedViews = filter(const String.fromEnvironment('QA_VIEWS'));
      final selectedSizes = filter(const String.fromEnvironment('QA_SIZES'));
      final output = Directory(
        const String.fromEnvironment('QA_OUTPUT', defaultValue: 'artifacts/qa'),
      )..createSync(recursive: true);
      for (final (size, padding) in [
        (const Size(375, 812), const FakeViewPadding(top: 24, bottom: 24)),
        (const Size(320, 568), const FakeViewPadding(top: 24, bottom: 24)),
        if (selectedSizes.contains('360x780'))
          (const Size(360, 780), const FakeViewPadding(top: 28, bottom: 46)),
        (const Size(430, 932), const FakeViewPadding(top: 47, bottom: 34)),
        (const Size(768, 1024), const FakeViewPadding(top: 24, bottom: 24)),
      ]) {
        final sizeName = '${size.width.toInt()}x${size.height.toInt()}';
        if (selectedSizes.isNotEmpty && !selectedSizes.contains(sizeName)) {
          continue;
        }
        tester.view.physicalSize = size;
        tester.view.padding = padding;
        tester.view.viewPadding = padding;
        for (final country in [
          PSLocale.fallback,
          ...PSLocale.countries.values,
        ]) {
          if (selectedCountries.isNotEmpty &&
              !selectedCountries.contains(country.country)) {
            continue;
          }
          PSLocale.current = country;
          var longest = 0;
          var bank = 0;
          var question = 0;
          for (var i = 0; i < banks.length; i++) {
            for (var j = 0; j < banks[i].length; j++) {
              final item = banks[i][j];
              final length =
                  item.localizedQuestion.runes.length +
                  item.localizedA.runes.length +
                  item.localizedB.runes.length;
              if (length > longest) {
                longest = length;
                bank = i;
                question = j;
              }
            }
          }
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
            final view = entry.$1;
            if (selectedViews.isNotEmpty && !selectedViews.contains(view)) {
              continue;
            }
            if (view == 'payout_form_pagbank' && country.country != 'BR') {
              continue;
            }
            notificationsEnabled = !view.startsWith('guide_12_denied');
            final keyboard = view.endsWith('_keyboard');
            tester.view.viewInsets = FakeViewPadding(
              bottom: keyboard ? size.height * .38 : 0,
            );
            final key = GlobalKey();
            PSLocalProvider.instance.ps_pig_level = 0;
            PSLocalProvider.instance.ps_dolas_number =
                view == 'guide_6_large_balance' ? 99.99 : 12.75;
            PSLocalProvider.instance.ps_pig_level_index = 3;
            PSLocalProvider.instance.ps_tx_ing_account =
                view == 'payout_form_pagbank' ? 1 : 0;
            PSLocalProvider.instance.ps_account_seled_index =
                PSLocalProvider.instance.ps_tx_ing_account;
            final firstQuestion = view == 'quiz_first_question';
            final quizBank = firstQuestion ? 0 : bank;
            final quizIndex = firstQuestion ? 0 : question;
            PSLocalProvider.instance.ps_quiz_model_index = quizBank;
            PSLocalProvider.instance.ps_quiz_num_index = quizIndex;
            PSLocalProvider.instance.ps_tx_task_index =
                view.startsWith('last_task_')
                ? int.parse(view.split('_').last)
                : 0;
            PSLocalProvider.instance.ps_account_id = switch (view) {
              'guide_11' => '1234562334',
              'confirm_information' || 'about_saved_payout' =>
                'alexandra.long-localized-account-2026@example.com',
              'quiz_rank_1' || 'quiz_rank_2' => 'alexandra@example.com',
              _ => '',
            };
            final capture =
                size.width == 375 ||
                (size.width == 320 &&
                    {
                      'home',
                      'quiz',
                      'wheel',
                      'cash',
                      'confirm_information',
                      'payout_form',
                      'in_app_notice',
                      'guide_4_second',
                      'guide_11',
                    }.contains(view)) ||
                selectedSizes.isNotEmpty;
            final info = {
              'country': country.country,
              'view': view,
              'size': sizeName,
              if (capture)
                'image': size.width == 375
                    ? '${country.country}_$view.png'
                    : '${country.country}_${view}_$sizeName.png',
            };
            try {
              await tester.pumpWidget(
                RepaintBoundary(
                  key: key,
                  child: host(
                    Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: const Color(0xFF292B32),
                      body: Center(child: entry.$2()),
                    ),
                  ),
                ),
              );
              await tester.runAsync(() async {
                await Future<void>.delayed(const Duration(milliseconds: 25));
              });
              await advanceView(tester, view);
              await tester.runAsync(() async {
                await Future<void>.delayed(const Duration(milliseconds: 25));
              });
              await tester.pump();
              Object? error;
              while ((error = tester.takeException()) != null)
                failures.add({...info, 'error': '$error'});
              final boundary =
                  key.currentContext!.findRenderObject()!
                      as RenderRepaintBoundary;
              textFindings.addAll(inspectText(boundary, info));
              if (isQuizPage(view)) {
                final quiz = banks[quizBank][quizIndex];
                final caption = find.text(quiz.localizedQuestion);
                if (!caption.evaluate().any((element) {
                  final render = element.renderObject;
                  if (render is! RenderBox || !render.hasSize) return false;
                  final bounds = MatrixUtils.transformRect(
                    render.getTransformTo(boundary),
                    Offset.zero & render.size,
                  );
                  return bounds.overlaps(Offset.zero & boundary.size);
                })) {
                  failures.add({...info, 'error': 'Quiz question not visible'});
                }
                final navTop = tester
                    .getTopLeft(find.byType(CustomNavBarWidget))
                    .dy;
                for (final answer in [quiz.localizedA, quiz.localizedB]) {
                  final button = find.ancestor(
                    of: find.byWidgetPredicate(
                      (widget) =>
                          widget is PSStrokeText && widget.text == answer,
                    ),
                    matching: find.byType(ParticleButton),
                  );
                  if (!button.evaluate().any((element) {
                    final render = element.renderObject;
                    if (render is! RenderBox || !render.hasSize) return false;
                    final rect = MatrixUtils.transformRect(
                      render.getTransformTo(boundary),
                      Offset.zero & render.size,
                    );
                    return rect.left >= 0 &&
                        rect.right <= size.width &&
                        rect.top >= 0 &&
                        rect.bottom <= navTop + .01;
                  })) {
                    failures.add({
                      ...info,
                      'error':
                          'Answer button not fully above the navigation bar: $answer',
                    });
                  }
                }
              }
              if (capture) {
                final img = await tester.runAsync(
                  () => boundary.toImage(pixelRatio: 1),
                );
                final bytes = await tester.runAsync(
                  () => img!.toByteData(format: ui.ImageByteFormat.png),
                );
                File(
                  '${output.path}/${info['image']}',
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
        const JsonEncoder.withIndent('  ').convert({
          'checked': checked,
          'failures': failures,
          'textFindings': textFindings,
        }),
      );
      expect(checked, isNotEmpty, reason: 'No matching layout cases');
      expect(failures, isEmpty, reason: 'See ${output.path}/results.json');
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );
}
