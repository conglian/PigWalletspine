import 'dart:convert';
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class PSCountry {
  final String country;
  final String language;
  final String currency;
  final String symbol;
  final int rate;
  final String topic;
  final List<String> payments;

  const PSCountry(
    this.country,
    this.language,
    this.currency,
    this.symbol,
    this.rate,
    this.topic,
    this.payments,
  );

  List<String> get topics => topic.isEmpty
      ? ['c152fcm_piggy', 'c152fcm_piggy_two']
      : ['c152pig_fcm_one_$topic', 'c152pig_fcm_two_$topic'];
}

/// 金额和奖励配置始终以美元为基准保存，只在展示边界换算。
/// 切换系统语言不会改变余额、奖励概率或提现进度，也不会重复乘汇率。
class PSLocale {
  static const fallback = PSCountry('US', 'en', 'USD', '\$', 1, '', [
    'PayPal',
    'Cash App',
  ]);
  static const countries = <String, PSCountry>{
    'ID': PSCountry('ID', 'id', 'IDR', 'Rp', 10000, 'in', [
      'GoPay',
      'OVO',
      'PayPal',
    ]),
    'PH': PSCountry('PH', 'fil', 'PHP', '₱', 100, 'ph', [
      'GCash',
      'Maya',
      'PayPal',
    ]),
    'BR': PSCountry('BR', 'pt', 'BRL', 'R\$', 10, 'br', ['Pix', 'PagBank']),
    'MX': PSCountry('MX', 'es', 'MXN', 'Mex\$', 20, 'mx', [
      'PayPal',
      'Mercado Pago',
      'Payoneer',
    ]),
    'JP': PSCountry('JP', 'ja', 'JPY', '¥', 160, 'ja', ['PayPal']),
    'AR': PSCountry('AR', 'es', 'ARS', 'Ar\$', 1500, 'ar', [
      'Mercado Pago',
      'PayPal',
      'Payoneer',
    ]),
    'RU': PSCountry('RU', 'ru', 'RUB', '₽', 80, 'ru', ['СБП', 'ЮMoney']),
    'DE': PSCountry('DE', 'de', 'EUR', '€', 1, 'de', ['PayPal']),
    'FR': PSCountry('FR', 'fr', 'EUR', '€', 1, 'fr', ['PayPal']),
  };

  static PSCountry current = fallback;
  static Map<String, dynamic> _translations = {};

  static PSCountry resolve(Locale locale) {
    final country = locale.countryCode?.toUpperCase();
    if (country != null && country.isNotEmpty) {
      return countries[country] ?? fallback;
    }
    final language = locale.languageCode.toLowerCase();
    const aliases = {
      'id': 'ID',
      'in': 'ID',
      'fil': 'PH',
      'tl': 'PH',
      'ph': 'PH',
      'pt': 'BR',
      'ja': 'JP',
      'ru': 'RU',
      'de': 'DE',
      'fr': 'FR',
    };
    return countries[aliases[language]] ?? fallback;
  }

  static Future<void> initialize(Locale locale) async {
    _translations = jsonDecode(
      await rootBundle.loadString('assets/File/ps_translations.json'),
    );
    _translations.addAll(
      jsonDecode(
            await rootBundle.loadString(
              'assets/File/ps_quiz_translations.json',
            ),
          )
          as Map<String, dynamic>,
    );
    current = resolve(locale);
  }

  static String tr(String key, [Map<String, Object?> args = const {}]) {
    return translate(key, current, args);
  }

  static String translate(
    String key,
    PSCountry country, [
    Map<String, Object?> args = const {},
  ]) {
    final values = _translations[key] as Map<String, dynamic>?;
    var result = values?[country.language] as String? ?? key;
    args.forEach(
      (key, value) => result = result.replaceAll('{$key}', '$value'),
    );
    return result;
  }

  static String money(num usd, {int? decimals, PSCountry? country}) {
    final profile = country ?? current;
    final digits =
        decimals ??
        (profile.currency == 'JPY' || profile.currency == 'IDR' ? 0 : 2);
    final format =
        NumberFormat.decimalPattern(
            '${profile.language == 'fil' ? 'en' : profile.language}_${profile.country}',
          )
          ..minimumFractionDigits = digits
          ..maximumFractionDigits = digits;
    return '${profile.symbol}${format.format(usd * profile.rate)}';
  }

  static const paymentAssets = <String, String>{
    'GCash': 'gcash',
    'PayPal': 'paypal',
    'Cash App': 'cashapp',
    'Pix': 'pix',
    'PagBank': 'pagbank',
    'GoPay': 'gopay',
    'OVO': 'ovo',
    'Maya': 'maya',
    'Mercado Pago': 'mercado',
    'Payoneer': 'payoneer',
    'СБП': 'sbp',
    'ЮMoney': 'yoomoney',
  };

  static String? paymentAsset(int index, {String variant = 'normal'}) {
    final name = paymentAssets[payment(index)];
    return name == null ? null : 'ps_payment_${name}_$variant';
  }

  static int? paymentImageIndex(String name) {
    final match = RegExp(
      r'^ps_act_(?:cash_|samil_|top_|bg_)?(\d+)(?:pt)?$',
    ).firstMatch(name);
    return match == null ? null : int.parse(match[1]!);
  }

  static String resolveImage(String name) {
    final index = paymentImageIndex(name);
    if (index == null) return name;
    final variant = name.contains('_bg_')
        ? 'card'
        : name.contains('_samil_') || name.contains('_top_')
        ? 'small'
        : name.contains('_cash_')
        ? 'badge'
        : 'normal';
    return paymentAsset(index, variant: variant) ?? 'ps_act_bg';
  }

  static int paymentIndex(int index) =>
      index >= 0 && index < current.payments.length ? index : 0;
  static String payment(int index) => current.payments[paymentIndex(index)];
}
