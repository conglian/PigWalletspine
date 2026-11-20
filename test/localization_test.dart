import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:piggywalletspinearn/PSTool/PSLocale.dart';
import 'package:piggywalletspinearn/PSTool/PSPayoutValidation.dart';
import 'package:piggywalletspinearn/PSTool/AESHelper.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:piggywalletspinearn/PSModel/PSQuestionModel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUp(() async => PSLocale.initialize(const Locale('en', 'US')));

  test('document regions, rates, currencies, payment counts and topics', () {
    final expected = {
      'ID': [10000, 'Rp', 3, 'in'],
      'PH': [100, '₱', 3, 'ph'],
      'BR': [10, 'R\$', 2, 'br'],
      'MX': [20, 'Mex\$', 3, 'mx'],
      'JP': [160, '¥', 1, 'ja'],
      'AR': [1500, 'Ar\$', 3, 'ar'],
      'RU': [80, '₽', 2, 'ru'],
      'DE': [1, '€', 1, 'de'],
      'FR': [1, '€', 1, 'fr'],
    };
    for (final item in expected.entries) {
      final profile = PSLocale.resolve(Locale('en', item.key));
      expect([
        profile.rate,
        profile.symbol,
        profile.payments.length,
        profile.topic,
      ], item.value);
      expect(profile.topics, [
        'c152pig_fcm_one_${item.value[3]}',
        'c152pig_fcm_two_${item.value[3]}',
      ]);
    }
    expect(PSLocale.resolve(const Locale('pt', 'PT')), PSLocale.fallback);
    expect(PSLocale.resolve(const Locale('es', 'ES')), PSLocale.fallback);
    expect(PSLocale.resolve(const Locale('zh', 'CN')), PSLocale.fallback);
    for (final code in ['fil', 'tl', 'ph']) {
      expect(PSLocale.resolve(Locale(code)).country, 'PH');
    }
    expect(PSLocale.resolve(const Locale('in')).country, 'ID');
  });

  test('conversion is display-only, signed, repeatable and localized', () {
    const usd = 12.75;
    PSLocale.current = PSLocale.countries['BR']!;
    expect(PSLocale.money(usd), 'R\$127,50');
    expect(PSLocale.money(-usd), 'R\$-127,50');
    PSLocale.current = PSLocale.countries['ID']!;
    expect(PSLocale.money(usd), 'Rp127.500');
    PSLocale.current = PSLocale.countries['JP']!;
    expect(PSLocale.money(usd), '¥2,040');
    PSLocale.current = PSLocale.fallback;
    expect(PSLocale.money(usd), '\$12.75');
    expect(usd, 12.75);
  });

  test('all translated messages retain every named placeholder', () {
    final catalog =
        jsonDecode(File('assets/File/ps_translations.json').readAsStringSync())
            as Map;
    final placeholder = RegExp(r'\{p\d+\}');
    for (final entry in catalog.entries) {
      final required = placeholder
          .allMatches(entry.key)
          .map((m) => m[0])
          .toSet();
      for (final language in [
        'id',
        'fil',
        'pt',
        'es',
        'ja',
        'ru',
        'de',
        'fr',
      ]) {
        final translated = (entry.value as Map)[language] as String;
        expect(translated.trim(), isNotEmpty, reason: '${entry.key}:$language');
        expect(
          placeholder.allMatches(translated).map((m) => m[0]).toSet(),
          required,
          reason: '${entry.key}:$language',
        );
      }
    }
  });

  test(
    'PIX and PagBank formats; other methods require trimmed nonempty only',
    () {
      for (final method in [
        'GCash',
        'Maya',
        'PayPal',
        'GoPay',
        'OVO',
        'Mercado Pago',
        'Payoneer',
        'СБП',
        'ЮMoney',
      ]) {
        expect(PSPayoutValidation.validate(method, '  '), isNotNull);
        expect(PSPayoutValidation.validate(method, ' some-account '), isNull);
      }
      expect(PSPayoutValidation.validate('PagBank', 'a@example.com'), isNull);
      expect(PSPayoutValidation.validate('PagBank', 'bad@'), isNotNull);
      String? pix(
        String account,
        String type, {
        String cpf = '99999999999',
        String name = 'Jason',
      }) => PSPayoutValidation.validate(
        'Pix',
        account,
        cpf: cpf,
        name: name,
        type: type,
      );
      expect(pix('a@example.com', 'Email'), isNull);
      expect(
        pix('a@example.com', 'Email', cpf: '123'),
        'Enter 11-digit CPF number',
      );
      expect(
        pix('a@example.com', 'Email', name: 'a@b'),
        'Enter the correct name',
      );
      expect(pix('+5511912345678', 'Phone'), isNull);
      expect(pix('+5596992047139', 'Phone'), isNull);
      expect(pix('+55119123456789', 'Phone'), isNotNull);
      expect(pix('55119123456789', 'Phone'), isNotNull);
      expect(pix('+55123', 'Phone'), isNotNull);
      expect(pix('99999999999', 'CPF'), isNull);
      expect(pix('123e4567-e89b-12d3-a456-426655440000', 'EVP'), isNull);
      expect(pix('x' * 36, 'EVP'), isNotNull);
    },
  );

  test('all converted payment artwork exists at original resolution', () {
    final manifest =
        jsonDecode(File('tool/payment_assets.json').readAsStringSync()) as List;
    expect(manifest.length, 60);
    for (final item in manifest) {
      expect(
        File('assets/images/${item['asset']}').lengthSync(),
        greaterThan(0),
      );
    }
    for (final country in PSLocale.countries.values) {
      PSLocale.current = country;
      for (var i = 0; i < country.payments.length; i++) {
        for (final variant in [
          'normal',
          'selected',
          'card',
          'badge',
          'small',
        ]) {
          expect(
            File(
              'assets/images/${PSLocale.paymentAsset(i, variant: variant)}.webp',
            ).existsSync(),
            isTrue,
          );
        }
      }
    }
  });
  test(
    'all 158 question prompts and choices have eight language translations',
    () {
      final source = File('lib/main.dart').readAsStringSync();
      final catalog =
          jsonDecode(
                File(
                  'assets/File/ps_quiz_translations.json',
                ).readAsStringSync(),
              )
              as Map;
      var count = 0;
      for (final match in RegExp(
        r"String (\w+String) =\s*'([^']+)';",
      ).allMatches(source)) {
        final questions =
            jsonDecode(AESHelper.decryptString(match[2]!)) as List;
        count += questions.length;
        for (final question in questions) {
          expect(
            QuestionModel.fromJson(Map<String, dynamic>.from(question)).answer,
            anyOf('a', 'b'),
          );
          for (final field in ['question', 'a', 'b']) {
            final key = question[field] as String;
            if (RegExp(r'^[0-9]+$|^(Ag|Au|O|H|He)$').hasMatch(key)) continue;
            expect(catalog.containsKey(key), isTrue, reason: key);
            for (final country in PSLocale.countries.values) {
              PSLocale.current = country;
              expect(catalog[key][country.language], isNotEmpty);
              expect(PSLocale.tr(key), catalog[key][country.language]);
            }
          }
        }
      }
      expect(count, 158);
    },
  );

  test(
    'country changes clear incompatible payment indices without converting stored balances',
    () async {
      SharedPreferences.setMockInitialValues({
        'ps_payout_country': 'BR',
        'ps_tx_ing_account': 1,
        'ps_account_seled_index': 1,
        'ps_account_id': 'old@example.com',
        'ps_dolas_number': 12.75,
      });
      PSLocale.current = PSLocale.countries['JP']!;
      await PSLocalProvider.instance.syncPayoutCountry();
      expect(PSLocalProvider.instance.ps_account_id, isEmpty);
      expect(PSLocalProvider.instance.ps_tx_ing_account, 0);
      expect(PSLocalProvider.instance.ps_account_seled_index, 0);
      expect(PSLocalProvider.instance.ps_dolas_number, 12.75);
    },
  );
}
