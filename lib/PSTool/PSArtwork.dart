import 'dart:ui' as ui;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'PSLocale.dart';
import 'PSNumberHelpers.dart';

/// 原图中写死的文案改为运行时文字，插画、透明度与原图分辨率保留。
/// Image 与 DecorationImage 共用此入口，国家信息参与缓存键。
class PSArtwork {
  static const labels = <String, String>{
    'ps_domand_titlle': 'Congratulations!',
    'ps_guide_top': 'Grow Your Pig, Grow Your Rewards',
    'ps_guide1_0': 'We Partner With Advertisers — You Earn The Rewards',
    'ps_guide2_0': 'Where Does The Ad Money Really Go?',
    'ps_guide3_0': 'Advertisers Pay And We Save With You',
    'ps_guide4_top': 'Advertiser Approved + Bonus Unlocked!',
    'ps_top_tips': 'Your Growth Journey Starts Now',
    'ps_top_tips_three': 'Pick Your Mood, Start Your Quiz',
    'ps_model_icon': 'Mood Quiz',
  };
  static const buttons = <String, String>{
    'ps_unlock_payout': 'Unlock Payout',
    'ps_pro_btn': 'Processing',
    'ps_inqueue_btn': 'In Queue',
    'ps_show_pig_b': 'Show Pig',
    'ps_keep_btn': 'Keep Answer, Speed Cash',
  };
  static const composites = {
    'ms_guide_center',
    'ps_100_top',
    'ps_cash_tip',
    'ps_cash_icon',
    'ps_tip_keep_title',
    'ps_tip_title_center',
    'ps_award_top_bg',
    'ps_rank_top',
    'ps_guide2_1',
    'ps_guide2_3',
    'ps_guide3_3',
    'ps_h5_btn',
    'ps_pig_home_bg',
    'ps_pig_home_bottom',
    'ps_quzi_btn_pop',
    'ps_wheel_center_bg0',
    'ps_wheel_center_bg1',
    'ps_wheel_center_bg2',
    'ps_wheel_center_iocn',
    'ps_wheel_spin_iocn',
    'ps_old_wheel_bg',
  };
  static bool handles(String name) =>
      labels.containsKey(name) ||
      buttons.containsKey(name) ||
      composites.contains(name);
  static ImageProvider provider(String name) {
    final key = name.split('/').last.replaceAll('.webp', '');
    final resolved = PSLocale.resolveImage(key);
    return handles(resolved)
        ? _PSArtworkImage(
            resolved,
            PSLocale.current,
            PSNumberHelpers().intModel?.eqRange.first ?? 100,
          )
        : AssetImage('assets/images/$resolved.webp');
  }
}

class _PSArtworkImage extends ImageProvider<_PSArtworkImage> {
  static const _signColors = {
    'paypal': Color(0xFF156CD9),
    'cashapp': Color(0xFF1C8B1A),
    'gopay': Color(0xFF1184C1),
    'ovo': Color(0xFF443998),
    'gcash': Color(0xFF002CB8),
    'maya': Color(0xFF16846A),
    'pix': Color(0xFF158CB7),
    'pagbank': Color(0xFF267C7F),
    'mercado': Color(0xFF394798),
    'payoneer': Color(0xFF7A3998),
    'sbp': Color(0xFF267C7F),
    'yoomoney': Color(0xFF6514EF),
  };

  final String name;
  final PSCountry country;
  final num threshold;
  const _PSArtworkImage(this.name, this.country, this.threshold);
  @override
  Future<_PSArtworkImage> obtainKey(ImageConfiguration configuration) =>
      SynchronousFuture(this);
  @override
  ImageStreamCompleter loadImage(
    _PSArtworkImage key,
    ImageDecoderCallback decode,
  ) => OneFrameImageStreamCompleter(key._load());
  @override
  bool operator ==(Object other) =>
      other is _PSArtworkImage &&
      other.name == name &&
      other.country == country &&
      other.threshold == threshold;
  @override
  int get hashCode => Object.hash(name, country, threshold);

  Future<ImageInfo> _load() async {
    final images = <ui.Image>[];
    Future<ui.Image> read(String asset) async {
      final bytes = await rootBundle.load('assets/images/$asset.webp');
      final codec = await ui.instantiateImageCodec(
        bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
      );
      final image = (await codec.getNextFrame()).image;
      codec.dispose();
      images.add(image);
      return image;
    }

    final original = await read(name);
    final width = original.width.toDouble(),
        height = original.height.toDouble();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    final bounds = Rect.fromLTWH(0, 0, width, height);
    String tr(String key, [Map<String, Object?> args = const {}]) =>
        PSLocale.translate(key, country, args);
    String money(num value) => PSLocale.money(value, country: country);
    void draw(ui.Image image, Rect rect) => canvas.drawImageRect(
      image,
      Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
      rect,
      Paint(),
    );
    void fill(Rect rect, Color color, {double radius = 10}) => canvas.drawRRect(
      RRect.fromRectAndRadius(rect, Radius.circular(radius)),
      Paint()..color = color,
    );
    void label(
      String text,
      Rect rect, {
      Color color = Colors.white,
      Color? stroke,
      double font = 36,
      int lines = 2,
    }) {
      TextPainter painter(double size, {Paint? foreground}) => TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontFamily: 'Black_mianfeiziti',
            fontFamilyFallback: const ['PSFallback', 'PSJapanese'],
            fontWeight: FontWeight.w900,
            fontSize: size,
            height: 1.1,
            color: foreground == null ? color : null,
            foreground: foreground,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
        maxLines: lines,
      )..layout(maxWidth: rect.width);
      var size = font;
      var paragraph = painter(size);
      while ((paragraph.didExceedMaxLines ||
              paragraph.computeLineMetrics().any(
                (line) => line.width > rect.width,
              ) ||
              paragraph.height > rect.height) &&
          size > 4) {
        paragraph.dispose();
        size -= 0.5;
        paragraph = painter(size);
      }
      final offset = Offset(
        rect.left + (rect.width - paragraph.width) / 2,
        rect.top + (rect.height - paragraph.height) / 2,
      );
      if (stroke != null) {
        final outline = painter(
          size,
          foreground: Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = size / 7
            ..strokeJoin = StrokeJoin.round
            ..color = stroke,
        );
        outline.paint(canvas, offset);
        outline.dispose();
      }
      paragraph.paint(canvas, offset);
      paragraph.dispose();
    }

    Future<void> payment(int index, Rect rect) async {
      final method =
          country.payments[index < country.payments.length ? index : 0];
      final image = await read(
        'ps_payment_${PSLocale.paymentAssets[method]}_normal',
      );
      draw(image, rect);
    }

    Future<void> paymentSign(
      int index,
      Rect rect,
      double angle, {
      double logoOffsetY = 0,
    }) async {
      final brand = index < country.payments.length
          ? PSLocale.paymentAssets[country.payments[index]]
          : null;
      final color = _signColors[brand] ?? const Color(0xFF198927);
      final inset = Rect.fromCenter(
        center: Offset.zero,
        width: rect.width,
        height: rect.height,
      );
      final shape = RRect.fromRectAndRadius(
        inset,
        Radius.circular(rect.height * 0.17),
      );
      final logo = brand == null
          ? null
          : await read('ps_payment_${brand}_normal');
      canvas.save();
      canvas.translate(rect.center.dx, rect.center.dy);
      canvas.rotate(angle);
      canvas.drawRRect(
        shape,
        Paint()
          ..shader = ui.Gradient.linear(inset.topCenter, inset.bottomCenter, [
            Color.lerp(color, Colors.white, 0.15)!,
            Color.lerp(color, Colors.black, 0.34)!,
          ]),
      );
      canvas.drawRRect(
        shape,
        Paint()
          ..color = const Color(0xFFF4FFE9)
          ..style = PaintingStyle.stroke
          ..strokeWidth = rect.height * 0.026,
      );
      if (logo == null) {
        label(country.currency, inset, font: rect.height * 0.45, lines: 1);
      } else {
        // 纯白底的透明度为 0。提亮偏浅的品牌标志，确保小图标也能看清。
        const source = Rect.fromLTRB(45, 27, 414, 150);
        final target = Rect.fromCenter(
          center: Offset(0, logoOffsetY),
          width: rect.width * 0.88,
          height: rect.width * 0.88 * source.height / source.width,
        );
        canvas.drawImageRect(
          logo,
          source,
          target,
          Paint()
            ..filterQuality = FilterQuality.medium
            ..colorFilter = const ColorFilter.matrix([
              0,
              0,
              0,
              0,
              255,
              0,
              0,
              0,
              0,
              255,
              0,
              0,
              0,
              0,
              255,
              -1.276,
              -4.292,
              -0.432,
              0,
              1530,
            ]),
        );
      }
      canvas.restore();
    }

    if (PSArtwork.labels.containsKey(name)) {
      label(
        tr(PSArtwork.labels[name]!),
        bounds.deflate(8),
        font: height * 0.44,
        stroke: name == 'ps_guide4_top'
            ? const Color(0xFFB26400)
            : const Color(0xFF352178),
        lines: 3,
      );
    } else if (PSArtwork.buttons.containsKey(name)) {
      if (name == 'ps_keep_btn' || name == 'ps_show_pig_b') {
        draw(
          await read(name == 'ps_keep_btn' ? 'ps_quzi_btn_n' : 'ps_wtd_btn'),
          bounds,
        );
      } else {
        fill(
          bounds,
          name == 'ps_pro_btn'
              ? const Color(0xFF0D7DBB)
              : name == 'ps_inqueue_btn'
              ? const Color(0xFF8433B4)
              : const Color(0xFF20A707),
          radius: height / 2,
        );
      }
      label(
        tr(PSArtwork.buttons[name]!),
        bounds.deflate(height * 0.15),
        font: height * 0.48,
      );
    } else if (name == 'ps_100_top' ||
        name == 'ps_tip_keep_title' ||
        name == 'ps_tip_title_center') {
      final text = name == 'ps_100_top'
          ? tr('{p0} Secured In Your Diamond Pig!', {'p0': money(threshold)})
          : name == 'ps_tip_keep_title'
          ? tr("Keep Answering! Today's {p0} Cash Out Feels Easy", {
              'p0': money(1000),
            })
          : tr(
              'Payout details confirmed. Quiz to release your {p0} cash out.',
              {'p0': money(threshold)},
            );
      label(
        text,
        bounds.deflate(8),
        font: height * 0.35,
        stroke: const Color(0xFF75320A),
        lines: 3,
      );
    } else if (name == 'ps_cash_tip') {
      fill(bounds.deflate(3), const Color(0xFFFFD72F), radius: height / 3);
      label(
        tr('Super Easy Cash Today!'),
        bounds.deflate(8),
        font: height * 0.42,
        stroke: const Color(0xFF803500),
      );
    } else {
      draw(original, bounds);
      if (name == 'ps_cash_icon' && country != PSLocale.fallback) {
        await paymentSign(0, const Rect.fromLTWH(6, 6, 78, 43), -0.1745);
        await paymentSign(1, const Rect.fromLTWH(43, 34, 77, 32), 0.115);
      } else if (name == 'ms_guide_center') {
        for (final item in [
          (const Rect.fromLTWH(22, 22, 180, 52), 'Your Pig'),
          (const Rect.fromLTWH(531, 0, 179, 55), 'Gold Pig'),
        ]) {
          fill(item.$1, const Color(0xFF777777), radius: 25);
          label(tr(item.$2), item.$1.deflate(5), font: 34);
        }
      } else if (name == 'ps_award_top_bg') {
        final rect = bounds.deflate(12);
        fill(rect, const Color(0xFF1A76B9));
        label(
          tr('Great! You Are The Next To Cash Out!'),
          rect.deflate(8),
          font: 42,
        );
      } else if (name == 'ps_rank_top') {
        const rect = Rect.fromLTWH(65, 22, 520, 76);
        fill(rect, const Color(0xFFFA4A42));
        label(tr('Recent Quiz Rankings'), rect.deflate(4), font: 36);
      } else if (name == 'ps_guide2_1') {
        const rect = Rect.fromLTWH(250, 55, 270, 80);
        fill(rect, Colors.white, radius: 0);
        label(
          tr('You Watched. They Earned.'),
          rect.deflate(2),
          color: const Color(0xFF505050),
          font: 30,
        );
        const button = Rect.fromLTWH(270, 180, 300, 66);
        fill(button, const Color(0xFF505050));
        label(tr('Withdraw'), button.deflate(8), font: 28);
      } else if (name == 'ps_guide2_3') {
        const card = Rect.fromLTWH(390, 170, 186, 100);
        fill(card, const Color(0xFFBFE8FF), radius: 20);
        await payment(0, const Rect.fromLTWH(405, 174, 156, 50));
        label(
          money(threshold),
          const Rect.fromLTWH(395, 224, 176, 44),
          color: Colors.black,
          font: 36,
          lines: 1,
        );
        const button = Rect.fromLTWH(365, 312, 243, 39);
        fill(button, const Color(0xFF54BA10));
        label(tr('Withdraw'), button, font: 32);
      } else if (name == 'ps_guide3_3') {
        const rect = Rect.fromLTWH(130, 300, 490, 68);
        fill(rect, const Color(0xFFFFFBE7));
        label(
          tr('Watch Ad = Real Money'),
          rect.deflate(5),
          color: const Color(0xFF341456),
          font: 38,
        );
      } else if (name == 'ps_h5_btn') {
        final rect = Rect.fromLTWH(0, height * 0.65, width, height * 0.35);
        fill(rect, const Color(0xFFA77000));
        label(tr('More Fun'), rect.deflate(1), font: 25);
      } else if (name == 'ps_quzi_btn_pop') {
        final rect = Rect.fromLTWH(5, height * 0.74, width - 10, height * 0.26);
        fill(rect, const Color(0xFF467E1A));
        label(tr('Quiz Cash'), rect.deflate(2), font: 24);
      } else if (name == 'ps_pig_home_bottom') {
        const rect = Rect.fromLTWH(159, 26, 432, 80);
        fill(rect, const Color(0xFF1188CA), radius: 18);
        label(
          tr('Top Earning Pigs (Refresh At 0:00 Every Day)'),
          rect.deflate(5),
          font: 25,
        );
      } else if (name == 'ps_pig_home_bg') {
        // 保留金库圆框，让标牌跟随原图的角度并收在圆框内。
        canvas.save();
        canvas.clipPath(
          Path()..addOval(const Rect.fromLTRB(199, 170, 550, 521)),
        );
        // 左牌的上半部位于余额栏后方，标志放在露出的下半部。
        await paymentSign(
          0,
          const Rect.fromLTWH(217, 281, 179, 108),
          -0.1745,
          logoOffsetY: 33,
        );
        await paymentSign(1, const Rect.fromLTWH(379, 357, 174, 77), 0.115);
        canvas.restore();
      } else if (name == 'ps_wheel_spin_iocn') {
        canvas.drawCircle(
          Offset(width / 2, height / 2),
          width * 0.34,
          Paint()..color = const Color(0xFFD70000),
        );
        label(
          tr('Spin'),
          Rect.fromLTWH(
            width * 0.15,
            height * 0.32,
            width * 0.7,
            height * 0.36,
          ),
          font: 50,
          color: const Color(0xFFFFE65A),
          stroke: const Color(0xFF5E2200),
        );
      } else if (name.startsWith('ps_wheel_center_')) {
        for (var i = 0; i < 8; i++) {
          canvas.save();
          canvas.translate(width / 2, height / 2);
          canvas.rotate(i * 3.141592653589793 / 4);
          final rect = Rect.fromLTWH(
            -width * 0.12,
            -height * 0.425,
            width * 0.24,
            height * 0.09,
          );
          fill(
            rect,
            i.isEven ? const Color(0xFFFFE45F) : const Color(0xFFFFFBE8),
            radius: 2,
          );
          if (i != 0 && i != 4)
            label(
              tr(
                i == 7
                    ? 'Try Again'
                    : name.endsWith('iocn')
                    ? 'Lucky Bag'
                    : 'Cash Bag',
              ),
              rect.deflate(2),
              color: const Color(0xFF7F168E),
              font: 25,
            );
          canvas.restore();
        }
      } else if (name == 'ps_old_wheel_bg') {
        final wheel = await _PSArtworkImage(
          'ps_wheel_center_bg0',
          country,
          threshold,
        )._load();
        images.add(wheel.image);
        canvas.save();
        canvas.clipRect(const Rect.fromLTWH(65, 250, 540, 204));
        draw(wheel.image, const Rect.fromLTWH(137, 260, 400, 400));
        canvas.restore();
      }
    }
    final picture = recorder.endRecording();
    final image = await picture.toImage(original.width, original.height);
    picture.dispose();
    for (final source in images) {
      source.dispose();
    }
    return ImageInfo(image: image);
  }
}
