import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

const psFontFallback = ['PSFallback', 'PSJapanese', 'Noto Color Emoji'];

/// 复用游戏的 375×812 设计坐标，在窄屏和短屏等比适配，大屏限制放大倍数。
/// 键盘、安全区与点击坐标同步换算，弹窗与页面共用同一套尺寸。
class PSResponsiveViewport extends StatelessWidget {
  final Widget child;
  const PSResponsiveViewport({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final scale = min(
          1.35,
          min(constraints.maxWidth / 375, constraints.maxHeight / 812),
        );
        final size = Size(375, constraints.maxHeight / scale);
        EdgeInsets scaled(EdgeInsets value) => value / scale;
        final adapted = media.copyWith(
          size: size,
          padding: scaled(media.padding),
          viewPadding: scaled(media.viewPadding),
          viewInsets: scaled(media.viewInsets),
          textScaler: TextScaler.noScaling,
        );
        ScreenUtil.configure(
          data: adapted,
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
        );
        return ColoredBox(
          color: const Color(0xFFD6ECFF),
          child: Center(
            child: SizedBox(
              width: size.width * scale,
              height: size.height * scale,
              child: FittedBox(
                fit: BoxFit.contain,
                child: SizedBox(
                  width: size.width,
                  height: size.height,
                  child: MediaQuery(data: adapted, child: child),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// 按可用宽高缩小文字，保持完整文案；多行优先换行。
class PSFitText extends StatelessWidget {
  final InlineSpan span;
  final TextAlign align;
  final int? maxLines;
  const PSFitText({
    super.key,
    required this.span,
    this.align = TextAlign.start,
    this.maxLines = 1,
  });
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaler = MediaQuery.textScalerOf(context);
        final effectiveSpan = TextSpan(
          style: DefaultTextStyle.of(
            context,
          ).style.copyWith(fontFamilyFallback: psFontFallback),
          children: [span],
        );
        var scale = 1.0;
        if (constraints.hasBoundedWidth || constraints.hasBoundedHeight) {
          bool fits(double factor) {
            final painter =
                TextPainter(
                  text: effectiveSpan,
                  locale: Localizations.maybeLocaleOf(context),
                  textAlign: align,
                  textDirection: Directionality.of(context),
                  maxLines: maxLines,
                  textScaler: TextScaler.linear(scaler.scale(1) * factor),
                )..layout(
                  maxWidth: constraints.hasBoundedWidth
                      ? constraints.maxWidth
                      : double.infinity,
                );
            final result =
                !painter.didExceedMaxLines &&
                (!constraints.hasBoundedWidth ||
                    painter.computeLineMetrics().every(
                      (line) => line.width <= constraints.maxWidth + 0.01,
                    )) &&
                (!constraints.hasBoundedHeight ||
                    painter.height <= constraints.maxHeight);
            painter.dispose();
            return result;
          }

          if (!fits(1)) {
            var low = 0.1;
            var high = 1.0;
            for (var i = 0; i < 12; i++) {
              final mid = (low + high) / 2;
              if (fits(mid)) {
                low = mid;
              } else {
                high = mid;
              }
            }
            scale = low;
          }
        }
        return Align(
          alignment: align == TextAlign.center
              ? Alignment.center
              : align == TextAlign.end || align == TextAlign.right
              ? AlignmentDirectional.centerEnd
              : AlignmentDirectional.centerStart,
          widthFactor: 1,
          heightFactor: 1,
          child: Text.rich(
            effectiveSpan,
            textAlign: align,
            maxLines: maxLines,
            textScaler: TextScaler.linear(scaler.scale(1) * scale),
          ),
        );
      },
    );
  }
}
