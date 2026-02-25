import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:piggywalletspinearn/PSTool/ps_stroke_text.dart';
import 'package:piggywalletspinearn/PSTool/ps_text.dart';
import 'package:provider/provider.dart';

import '../PSHome/PSHome.dart';
import '../PSTool/ps_extension_help.dart';
import '../PSTool/ps_img.dart';
import 'PSGuideATwo.dart';

class PSGuideOne extends StatefulWidget {
  const PSGuideOne({super.key});

  @override
  State<PSGuideOne> createState() => _PSGuideOneState();
}

class _PSGuideOneState extends State<PSGuideOne>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1200),
    );

    // Column 中有 5 个主要元素，给每个创建动画
    _animations = List.generate(5, (index) {
      double start = index * 0.1; // 每个元素延迟出现
      double end = start + 0.5;
      if (end > 1) end = 1;
      return Tween<double>(begin: -200.0, end: 0.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, end, curve: Curves.elasticOut),
        ),
      );
    });

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _animatedItem(Widget child, int index) {
    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, _) {
        return Transform.translate(
          offset: Offset(_animations[index].value, 0),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 0.width(context),
            height: 0.height(context),
            decoration: BoxDecoration(image: PSDImg('ps_guide_bg')),
            child: Column(
              children: [
                SizedBox(height: 228.h),
                _animatedItem(
                  PSImg(name: 'ms_guide_center', width: 355, height: 130),
                  0,
                ),
                SizedBox(height: 60.h),
                _animatedItem(
                  Container(
                    width: 351,
                    height: 151,
                    decoration: BoxDecoration(image: PSDImg('ps_guide_tip_bg')),
                    child: Column(
                      children: [
                        SizedBox(height: 40),
                        PSText(
                          text: 'Answer fun quizzes to collect diamonds.',
                          size: 14,
                          color: '#11407A'.color(),
                          weight: FontWeight.w900,
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 303,
                          height: 34,
                          child: PSText(
                            text:
                                'Every diamond helps your Piggy level up — all the way to the Gold Pig!',
                            size: 14,
                            color: '#962929'.color(),
                            weight: FontWeight.w900,
                            maxLines: 2,
                            align: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  1,
                ),
                SizedBox(height: 40.h),
                _animatedItem(
                  ParticleButton(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => PSGuideTwo()),
                      );
                    },
                    child: Container(
                      width: 260,
                      height: 59,
                      decoration: BoxDecoration(image: PSDImg('ps_green_btn')),
                      child: Center(
                        child: PSStrokeText(
                          text: 'Got It',
                          size: 24,
                          color: '#FFFFFF'.color(),
                          weight: FontWeight.w900,
                          skWidth: 2,
                          skColor: '#025003'.color(),
                        ),
                      ),
                    ),
                  ),
                  2,
                ),
                // 如果 Column 内还有其他需要动画的元素，可继续添加 _animatedItem
              ],
            ),
          ),
          Positioned(
            left: 24.w,
            top: 100.h,
            child: PSImg(name: 'ps_guide_top', width: 325, height: 97),
          ),
        ],
      ),
    );
  }
}
