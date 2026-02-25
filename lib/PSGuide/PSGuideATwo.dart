import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:piggywalletspinearn/PSGuide/PSGuideAThree.dart';
import 'package:piggywalletspinearn/PSTool/ps_stroke_text.dart';
import 'package:piggywalletspinearn/PSTool/ps_text.dart';
import 'package:provider/provider.dart';

import '../PSHome/PSHome.dart';
import '../PSTool/ps_extension_help.dart';
import '../PSTool/ps_img.dart';

String text_fontName = 'Black_mianfeiziti';

class PSGuideTwo extends StatefulWidget {
  const PSGuideTwo({super.key});

  @override
  State<PSGuideTwo> createState() => _PSGuideTwoState();
}

class _PSGuideTwoState extends State<PSGuideTwo>
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

    // 为 Column 中每个主要元素创建弹簧动画（左移到原位）
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
                SizedBox(height: 80.h),
                _animatedItem(
                  PSImg(name: 'ps_top_tips', width: 346, height: 39),
                  0,
                ),
                SizedBox(height: 20.h),
                _animatedItem(
                  Container(
                    width: 349,
                    height: 119,
                    decoration: BoxDecoration(image: PSDImg('ps_t_center_bg')),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 16,
                          top: 18,
                          child: PSImg(
                            name: 'ps_domand_b',
                            width: 26.7,
                            height: 23.27,
                          ),
                        ),
                        Positioned(
                          left: 48,
                          top: 20,
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w900,
                                color: '#873709'.color(),
                                fontFamily: text_fontName,
                              ),
                              children: <TextSpan>[
                                TextSpan(text: 'Energy Point: '),
                                TextSpan(
                                  text: '20',
                                  style: TextStyle(color: '#006AFF'.color()),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 30,
                          top: 50,
                          child: SizedBox(
                            width: 292,
                            height: 34,
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                Container(
                                  width: 292,
                                  height: 34,
                                  decoration: BoxDecoration(
                                    image: PSDImg('ps_pro_bg_t'),
                                  ),
                                ),
                                Positioned(
                                  left: 7,
                                  child: Container(
                                    width: 278 * 0.5,
                                    height: 20,
                                    decoration: BoxDecoration(
                                      color: '#80F207'.color(),
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 150,
                          top: 56,
                          child: PSStrokeText(
                            text: '1/20',
                            size: 18,
                            color: '#FFFFFF'.color(),
                            weight: FontWeight.w900,
                            skWidth: 1,
                            skColor: '#042267'.color(),
                          ),
                        ),
                        Positioned(
                          left: 190,
                          top: 58,
                          child: PSImg(
                            name: 'ps_domand_s',
                            width: 18,
                            height: 17,
                          ),
                        ),
                        Positioned(
                          left: 20,
                          top: 40,
                          child: PSImg(name: 'ps_pig_3', width: 47, height: 47),
                        ),
                        Positioned(
                          right: 20,
                          top: 40,
                          child: PSImg(name: 'ps_pig_2', width: 47, height: 47),
                        ),
                      ],
                    ),
                  ),
                  1,
                ),
                SizedBox(height: 20.h),
                _animatedItem(
                  PSImg(name: 'ps_b_pig_icon', width: 227, height: 224),
                  2,
                ),
                _animatedItem(
                  Container(
                    width: 351,
                    height: 90,
                    decoration: BoxDecoration(image: PSDImg('ps_guide_tip_bg')),
                    child: Column(
                      children: [
                        SizedBox(height: 30),
                        SizedBox(
                          width: 303,
                          height: 34,
                          child: PSText(
                            text:
                                'Every quiz boosts your knowledge — and your Piggy’s evolution!',
                            size: 14,
                            color: '#11407A'.color(),
                            weight: FontWeight.w900,
                            maxLines: 2,
                            align: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  3,
                ),
                SizedBox(height: 40.h),
                _animatedItem(
                  ParticleButton(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => PSGuideThree()),
                      );
                    },
                    child: Container(
                      width: 260,
                      height: 59,
                      decoration: BoxDecoration(image: PSDImg('ps_green_btn')),
                      child: Center(
                        child: PSStrokeText(
                          text: 'Let’s Start',
                          size: 24,
                          color: '#FFFFFF'.color(),
                          weight: FontWeight.w900,
                          skWidth: 2,
                          skColor: '#025003'.color(),
                        ),
                      ),
                    ),
                  ),
                  4,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
