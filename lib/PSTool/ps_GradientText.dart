import 'PSLocale.dart';
import 'PSResponsive.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PSGradientText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Gradient gradient;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final TextOverflow? overflow;
  final bool softWrap;
  final int? maxLines;
  final double? textScaleFactor;

  const PSGradientText(
    this.text, {
    Key? key,
    required this.fontSize,
    required this.gradient,
    this.textAlign,
    this.textDirection,
    this.overflow,
    this.softWrap = true,
    this.maxLines,
    this.textScaleFactor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: PSFitText(
        span: TextSpan(text: PSLocale.tr(text), style: TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: fontSize * (textScaleFactor ?? 1),
          fontFamily: 'Black_mianfeiziti', fontFamilyFallback: const ['PSFallback', 'PSJapanese'],
          color: Colors.white,
        )),
        align: textAlign ?? TextAlign.start,
        maxLines: maxLines,
      ),
    );
  }
}

class PSGradientStrokeText extends StatelessWidget {
  final String text;
  final List<Color> gradientColors;
  final Color strokeColor;
  final double strokeWidth;
  final int fontSize;
  final double width;
  final double height;

  const PSGradientStrokeText({
    super.key,
    required this.text,
    required this.gradientColors,
    required this.width,
    required this.height,
    this.strokeColor = Colors.black,
    this.strokeWidth = 2.0,
    required this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    final localized = PSLocale.tr(text);
    final style = TextStyle(fontSize: fontSize.toDouble(), fontWeight: FontWeight.bold,
        fontFamily: 'Black_mianfeiziti', fontFamilyFallback: const ['PSFallback', 'PSJapanese'], height: 1.15);
    return SizedBox(width: width, height: height, child: Stack(alignment: Alignment.center, children: [
      PSFitText(span: TextSpan(text: localized, style: style.copyWith(foreground: Paint()
        ..style = PaintingStyle.stroke ..strokeWidth = strokeWidth ..color = strokeColor)), align: TextAlign.center),
      ShaderMask(blendMode: BlendMode.srcIn,
        shaderCallback: (bounds) => LinearGradient(colors: gradientColors).createShader(bounds),
        child: PSFitText(span: TextSpan(text: localized, style: style.copyWith(color: Colors.white)), align: TextAlign.center)),
    ]));
  }
}
