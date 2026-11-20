// flutter test tool/render_localization_previews_test.dart --no-pub
import 'dart:io';
import 'dart:convert';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piggywalletspinearn/PSBase/PSTbaBar.dart';
import 'package:piggywalletspinearn/PSDialog/PSDialog.dart';
import 'package:piggywalletspinearn/PSDialog/PSGuideDialog.dart';
import 'package:piggywalletspinearn/PSPigVC/PSPigCash.dart';
import 'package:piggywalletspinearn/PSPigVC/PSPigHome.dart';
import 'package:piggywalletspinearn/PSTool/PSArtwork.dart';
import 'package:piggywalletspinearn/PSTool/PSLocale.dart';
import 'package:piggywalletspinearn/PSTool/PSNumberHelpers.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import '../test/widget_test.dart' show host;

Widget page({bool home = false, LayerLink? wheelIconLink}) => Scaffold(
  body: home ? const PSPigHome.preview() : const PSPigCash(),
  bottomNavigationBar: CustomNavBarWidget(
    [
      for (final item in [
        ('ps_home_icon', 'Earn'),
        ('ps_quiz_icon', 'Quiz'),
        ('ps_wheel_icon', 'Wheel'),
        ('ps_cash_icon', 'Cash'),
      ])
        PersistentBottomNavBarItem(
          icon: Image(image: PSArtwork.provider(item.$1)),
          inactiveIcon: Image(image: PSArtwork.provider(item.$1)),
          title: PSLocale.tr(item.$2),
          activeColorPrimary: Colors.transparent,
        ),
    ],
    selectedIndex: home ? 0 : 3,
    onItemSelected: (_) {},
    wheelIconLink: wheelIconLink,
  ),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await PSLocale.initialize(const Locale('en', 'US'));
    await PSNumberHelpers().initNumberModel();
    await PSLocalProvider.instance.init();
    // Stable sample rankings for country comparisons. Money is stored in base USD.
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
    PSLocalProvider.instance.ps_old_guide = true;
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
          const MethodChannel('flutter_tba_info'),
          (_) async => 'preview',
        );
    // Load the app font plus a Japanese fallback in the rendering engine used for previews.
    final font = FontLoader('Black_mianfeiziti')
      ..addFont(rootBundle.load('assets/File/Black_mianfeiziti.ttf'));
    final japaneseFont = FontLoader('PSJapanese');
    japaneseFont.addFont(rootBundle.load('assets/File/NotoSansJP.ttf'));
    await font.load();
    await japaneseFont.load();
    await (FontLoader(
      'PSFallback',
    )..addFont(rootBundle.load('assets/File/NotoSans-Regular.ttf'))).load();
    await (FontLoader(
      'MaterialIcons',
    )..addFont(rootBundle.load('fonts/MaterialIcons-Regular.otf'))).load();
  });
  testWidgets('render home, cash and dialog for all supported countries', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final output = Directory('artifacts/localization')
      ..createSync(recursive: true);
    await tester.pumpWidget(host(const SizedBox.shrink()));
    for (final country in [PSLocale.fallback, ...PSLocale.countries.values]) {
      PSLocale.current = country;
      PSLocalProvider.instance.ps_dolas_number = 12.75;
      PSLocalProvider.instance.ps_tx_ing_account = 0;
      PSLocalProvider.instance.ps_account_seled_index = 0;
      await tester.runAsync(() async {
        final context = tester.element(find.byType(MaterialApp));
        for (final asset in [
          // Production home assets, including the visible ranking avatars.
          'ps_pig_home_bg', 'ps_pig_home_bottom', 'ps_pig_user_top_bg',
          'ps_show_pig_b', 'ps_home_list_bg', 'ps_h5_btn', 'ps_b_pig_icon_0',
          'ps_0_25', 'ps_act_bg', 'ps_pao_bg', 'ps_privary_icon',
          'ps_t_center_bg', 'ps_wheel_top_bg', 'ps_dolas_2', 'ps_pig_0',
          'ps_act_top_0', 'ps_quzi_btn_pop',
          for (var i = 0; i < 6; i++) ...['ps_user_s_$i', 'ps_user_n_$i'],
          'ps_cash_bg',
          'ps_cash_top_wtd',
          'ps_cash_tip',
          'ps_pro_bg_t',
          'ps_dolas_1',
          'ps_wtd_btn',
          'ps_cash_bg_0',
          'ps_cah_green_b',
          'ps_about_bg',
          'ps_whine_close',
          'ps_home_icon',
          'ps_quiz_icon',
          'ps_wheel_icon',
          'ps_cash_icon',
          'ps_pig_tab_bg',
          'ps_tabbar_s',
          'ps_act_bg_0',
          'ps_act_cash_0',
          for (var i = 0; i < country.payments.length; i++) ...[
            PSLocale.paymentAsset(i)!,
            PSLocale.paymentAsset(i, variant: 'selected')!,
          ],
        ]) {
          await precacheImage(PSArtwork.provider(asset), context);
        }
      });
      for (final kind in ['home', 'page', 'dialog']) {
        final dialog = kind == 'dialog';
        final key = GlobalKey();
        final surface = dialog
            ? Scaffold(
                backgroundColor: const Color(0xFF292B32),
                body: const Center(
                  child: Dialog(
                    insetPadding: EdgeInsets.zero,
                    backgroundColor: Colors.transparent,
                    child: PSAboutTXDialog(isConfim: false),
                  ),
                ),
              )
            : page(home: kind == 'home');
        await tester.pumpWidget(
          host(RepaintBoundary(key: key, child: surface)),
        );
        await tester.runAsync(() async {
          await Future<void>.delayed(const Duration(milliseconds: 80));
        });
        await tester.pump(const Duration(seconds: 2));
        await tester.pump();
        expect(
          tester.takeException(),
          isNull,
          reason: '${country.country} $kind',
        );
        final boundary =
            key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
        final image = await tester.runAsync(
          () => boundary.toImage(pixelRatio: 2),
        );
        final png = await tester.runAsync(
          () => image!.toByteData(format: ui.ImageByteFormat.png),
        );
        File(
          '${output.path}/${country.country}_$kind.png',
        ).writeAsBytesSync(png!.buffer.asUint8List());
        image!.dispose();
        await tester.pumpWidget(host(const SizedBox.shrink()));
      }
    }
  });

  testWidgets('render payout confirmation and centered reward rows as modals', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPadding);
    final provider = PSLocalProvider.instance;
    final savedAccount = provider.ps_account_id;
    addTearDown(() => provider.ps_account_id = savedAccount);
    provider.ps_account_id = '12***22.@Gmail';
    provider.ps_dolas_number = 12.75;
    final output = Directory('artifacts/localization')
      ..createSync(recursive: true);

    for (final (country, name, modal) in [
      ('BR', 'BR_confirm_payment_modal', const PSAboutTXDialog(isConfim: true)),
      (
        'RU',
        'RU_reward_rows_modal',
        const PSPopAwardToolDialog(type: .quiz, isGuide: false, award: 6),
      ),
      ('JP', 'JP_tab_bottom_inset', null),
    ]) {
      PSLocale.current = PSLocale.countries[country]!;
      tester.view.padding = FakeViewPadding(bottom: modal == null ? 34 : 0);
      provider.ps_tx_ing_account = country == 'BR' ? 1 : 0;
      provider.ps_account_seled_index = provider.ps_tx_ing_account;
      final key = GlobalKey();
      late BuildContext pageContext;
      await tester.pumpWidget(
        RepaintBoundary(
          key: key,
          child: host(
            Builder(
              builder: (context) {
                pageContext = context;
                return page();
              },
            ),
          ),
        ),
      );
      if (modal != null) {
        pageContext.tipShow(modal);
        await tester.pumpAndSettle();
      }
      if (country == 'BR') {
        await tester.tap(find.text(PSLocale.tr('Confirm Account')));
        await tester.pumpAndSettle();
        expect(find.byType(PSConfirmInformationDialog), findsOneWidget);
      }
      await tester.runAsync(() async {
        await Future<void>.delayed(const Duration(milliseconds: 100));
      });
      await tester.pumpAndSettle();
      if (modal != null) expect(find.byType(BackdropFilter), findsOneWidget);
      expect(tester.takeException(), isNull);
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(key),
      );
      final image = await tester.runAsync(
        () => boundary.toImage(pixelRatio: 2),
      );
      final png = await tester.runAsync(
        () => image!.toByteData(format: ui.ImageByteFormat.png),
      );
      File(
        '${output.path}/$name.png',
      ).writeAsBytesSync(png!.buffer.asUint8List());
      image!.dispose();
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('render growth bonus cards for all supported countries', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    const channel = MethodChannel('dexterous.com/flutter/local_notifications');
    var enabled = true;
    messenger.setMockMethodCallHandler(channel, (_) async => enabled);
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    final output = Directory('artifacts/localization/growth_bonus')
      ..createSync(recursive: true);
    PSLocalProvider.instance.ps_dolas_number = 35.84;

    for (final country in [PSLocale.fallback, ...PSLocale.countries.values]) {
      PSLocale.current = country;
      for (final allowed in [true, if (country.country == 'JP') false]) {
        enabled = allowed;
        final key = GlobalKey();
        await tester.pumpWidget(
          host(
            RepaintBoundary(
              key: key,
              child: const ColoredBox(
                color: Color(0xFF292B32),
                child: PSGuideNew12Dialog(is_old: true),
              ),
            ),
          ),
        );
        await tester.runAsync(() async {
          final context = tester.element(find.byType(PSGuideNew12Dialog));
          for (final asset in [
            'ps_close_icon',
            'ps_grow_bg',
            'ps_pig_0',
            allowed ? 'ps_quzi_btn_d' : 'ps_quzi_btn_n',
          ]) {
            await precacheImage(PSArtwork.provider(asset), context);
          }
        });
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: country.country);
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(key),
        );
        final image = await tester.runAsync(
          () => boundary.toImage(pixelRatio: 2),
        );
        final png = await tester.runAsync(
          () => image!.toByteData(format: ui.ImageByteFormat.png),
        );
        final variant = allowed ? 'earn' : 'remind';
        File(
          '${output.path}/${country.country}_$variant.png',
        ).writeAsBytesSync(png!.buffer.asUint8List());
        image!.dispose();
        await tester.pumpWidget(const SizedBox.shrink());
      }
    }
  });
}
