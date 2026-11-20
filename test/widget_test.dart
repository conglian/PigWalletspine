import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piggywalletspinearn/PSTool/PSLocale.dart';
import 'package:piggywalletspinearn/PSTool/PSNumberHelpers.dart';
import 'package:piggywalletspinearn/PSTool/PSPayoutForm.dart';
import 'package:piggywalletspinearn/PSTool/PSResponsive.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import 'package:piggywalletspinearn/PSPigVC/PSPigCash.dart';
import 'package:piggywalletspinearn/PSDialog/PSDialog.dart';

Widget host(Widget child) => ChangeNotifierProvider.value(
  value: PSLocalProvider.instance,
  child: MaterialApp(
    home: child,
    debugShowCheckedModeBanner: false,
    theme: ThemeData(fontFamilyFallback: const ['PSFallback', 'PSJapanese']),
    locale: Locale(PSLocale.current.language, PSLocale.current.country),
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    supportedLocales: const [
      Locale('en'),
      Locale('id'),
      Locale('fil'),
      Locale('pt'),
      Locale('es'),
      Locale('ja'),
      Locale('ru'),
      Locale('de'),
      Locale('fr'),
    ],
    builder: (context, content) => PSResponsiveViewport(child: content!),
  ),
);
void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await PSLocale.initialize(const Locale('en', 'US'));
    await PSNumberHelpers().initNumberModel();
  });
  testWidgets(
    'cash page and confirmation fit every region on small and large screens',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      for (final size in [
        const Size(320, 568),
        const Size(375, 812),
        const Size(430, 932),
        const Size(768, 1024),
      ]) {
        tester.view.physicalSize = size;
        for (final country in [
          PSLocale.fallback,
          ...PSLocale.countries.values,
        ]) {
          PSLocale.current = country;
          await tester.pumpWidget(host(const PSPigCash()));
          await tester.pump();
          expect(
            tester.takeException(),
            isNull,
            reason: 'cash ${country.country} $size',
          );
          await tester.pumpWidget(
            host(Scaffold(body: PSConfirmInformationDialog(onApply: () {}))),
          );
          await tester.pump();
          expect(
            tester.takeException(),
            isNull,
            reason: 'confirm ${country.country} $size',
          );
          await tester.pumpWidget(const SizedBox.shrink());
        }
      }
    },
  );

  testWidgets('saved payout details stay in the same modal over the page', (
    tester,
  ) async {
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    const channel = MethodChannel('flutter_tba_info');
    messenger.setMockMethodCallHandler(channel, (_) async => 'preview');
    addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
    final provider = PSLocalProvider.instance;
    final previousAccount = provider.ps_account_id;
    addTearDown(() => provider.ps_account_id = previousAccount);
    provider.ps_account_id = 'saved@example.com';

    await tester.pumpWidget(
      host(
        Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () =>
                    context.tipShow(const PSAboutTXDialog(isConfim: true)),
                child: const Text('Withdraw test entry'),
              ),
            ),
          ),
        ),
      ),
    );
    final entry = find.text('Withdraw test entry');
    final about = find.byType(PSAboutTXDialog);
    final confirmation = find.byType(PSConfirmInformationDialog);
    final success = find.byType(PSConfimOneDialog);
    Future<void> openConfirmation() async {
      await tester.tap(entry);
      await tester.pumpAndSettle();
      final route = ModalRoute.of(tester.element(about));
      expect(route, isA<PopupRoute<dynamic>>());
      await tester.tap(find.text('Confirm Account'));
      await tester.pumpAndSettle();
      expect(confirmation, findsOneWidget);
      expect(ModalRoute.of(tester.element(confirmation)), same(route));
      expect(entry, findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
      expect(find.text('Account Name: saved@example.com'), findsOneWidget);
    }

    await openConfirmation();
    await tester.tap(find.bySemanticsLabel('Close'));
    await tester.pumpAndSettle();
    expect(about, findsNothing);
    expect(success, findsNothing);
    expect(entry, findsOneWidget);

    await openConfirmation();
    await tester.tap(find.text('Apply For Payout'));
    await tester.pumpAndSettle();
    expect(confirmation, findsNothing);
    expect(success, findsOneWidget);
    expect(entry, findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(about, findsNothing);
    expect(entry, findsOneWidget);

    provider.ps_account_id = '';
    await tester.tap(entry);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Confirm Account'));
    await tester.pumpAndSettle();
    expect(find.byType(PSInfoSubmitDialog), findsOneWidget);
    expect(confirmation, findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Philippines has three channels and whitespace cannot be submitted',
    (tester) async {
      PSLocale.current = PSLocale.countries['PH']!;
      await tester.pumpWidget(host(PSPayoutForm(onConfirmed: () {})));
      expect(find.byType(OutlinedButton), findsNWidgets(3));
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await tester.enterText(find.byType(TextField), '   ');
      await tester.pump();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await tester.enterText(find.byType(TextField), 'account');
      await tester.pump();
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNotNull,
      );
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets(
    'payout forms and text dialogs fit each country including the keyboard',
    (tester) async {
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.view.resetViewInsets);
      for (final size in [const Size(320, 568), const Size(768, 1024)]) {
        tester.view.physicalSize = size;
        for (final country in [
          PSLocale.fallback,
          ...PSLocale.countries.values,
        ]) {
          PSLocale.current = country;
          final dialogs = <Widget>[
            const PSAboutTXDialog(isConfim: false),
            const PSQuizRankOneDialog(),
            const PSTXOutDialog(seletcd_row: 0),
            const PSTXLastDialog(type: 0),
            const PSReviewFaildDialog(),
            PSPopMoreChanceDialog(),
            for (final status in AdStatus.values)
              PSPopTipsToolDialog(adStatus: status),
          ];
          for (final dialog in dialogs) {
            await tester.pumpWidget(host(Scaffold(body: dialog)));
            await tester.pump();
            expect(
              tester.takeException(),
              isNull,
              reason: '${dialog.runtimeType} ${country.country} $size',
            );
            await tester.pumpWidget(const SizedBox.shrink());
          }
          await tester.pumpWidget(
            host(PSPayoutForm(fullScreen: true, onConfirmed: () {})),
          );
          await tester.pump();
          tester.view.viewInsets = const FakeViewPadding(bottom: 240);
          await tester.pump();
          expect(
            tester.takeException(),
            isNull,
            reason: 'keyboard ${country.country} $size',
          );
          await tester.ensureVisible(find.byType(FilledButton));
          await tester.pump();
          expect(tester.takeException(), isNull);
          tester.view.resetViewInsets();
          await tester.pumpWidget(const SizedBox.shrink());
        }
      }
    },
  );

  testWidgets(
    'PagBank clears an invalid email and saves only after validation',
    (tester) async {
      PSLocale.current = PSLocale.countries['BR']!;
      var confirmed = false;
      await tester.pumpWidget(
        host(PSPayoutForm(onConfirmed: () => confirmed = true)),
      );
      await tester.tap(find.byType(OutlinedButton).at(1));
      await tester.pump();
      await tester.enterText(find.byType(TextField), 'bad@');
      await tester.pump();
      await tester.ensureVisible(find.byType(FilledButton));
      await tester.tap(find.byType(FilledButton));
      await tester.pump();
      expect(confirmed, isFalse);
      expect(
        tester.widget<TextField>(find.byType(TextField)).controller!.text,
        isEmpty,
      );
      expect(
        tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
        isNull,
      );
      await tester.enterText(find.byType(TextField), ' user@example.com ');
      await tester.pump();
      await tester.ensureVisible(find.byType(FilledButton));
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();
      expect(confirmed, isTrue);
      expect(PSLocalProvider.instance.ps_account_id, 'user@example.com');
      expect(PSLocalProvider.instance.ps_tx_ing_account, 1);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
}
