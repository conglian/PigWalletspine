import 'dart:async';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:piggywalletspinearn/PSHome/PSHome.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_stroke_text.dart';
import 'package:piggywalletspinearn/PSTool/ps_text.dart';
import 'package:provider/provider.dart';

import '../PSBase/PSTbaBar.dart';
import '../PSTool/ps_extension_help.dart';
import '../PSTool/ps_img.dart';

String text_fontName = 'Black_mianfeiziti';

class PSGuideThree extends StatefulWidget {
  const PSGuideThree({super.key});

  @override
  State<PSGuideThree> createState() => _PSGuideThreeState();
}

class _PSGuideThreeState extends State<PSGuideThree>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  final int itemCount = 4;

  int itemSeletecd = 0;

  List<String> names = ['Calm', 'Chill', 'Focused', 'Warm UP'];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Animation<Offset> _buildAnimation(int index) {
    // 每个 item 延迟 0.15
    final double start = index * 0.15;
    final double end = start + 0.6;

    return Tween<Offset>(
      begin: const Offset(-1.2, 0), // 从左侧外面进来
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          start,
          end.clamp(0.0, 1.0),
          curve: Curves.easeOutBack, // 自然回弹效果
        ),
      ),
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
                Row(
                  children: [
                    const SizedBox(width: 20),
                    PSImg(name: 'ps_top_tips_three', width: 271, height: 107),
                  ],
                ),
                SizedBox(height: 20.h),

                /// 🔥 动画 List
                SizedBox(
                  width: 0.width(context),
                  height: 350,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: itemCount,
                    separatorBuilder: (_, __) => SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      return SlideTransition(
                        position: _buildAnimation(index),
                        child: Container(
                          height: 75,
                          margin: EdgeInsets.symmetric(horizontal: 24),
                          decoration: BoxDecoration(
                            image: PSDImg('ps_three_icon_bg'),
                          ),
                          child: ParticleButton(
                            onTap: () async {
                              setState(() {
                                itemSeletecd = index;
                              });
                              await PSLocalProvider.instance.updateint(
                                PSLocalProvider.instance.ps_quiz_num_indexName,
                                0,
                              );
                              if (index == 0) {
                                await PSLocalProvider.instance.updateint(
                                  PSLocalProvider
                                      .instance
                                      .ps_quiz_model_indexName,
                                  1,
                                );
                              } else if (index == 1) {
                                await PSLocalProvider.instance.updateint(
                                  PSLocalProvider
                                      .instance
                                      .ps_quiz_model_indexName,
                                  2,
                                );
                              } else if (index == 2) {
                                await PSLocalProvider.instance.updateint(
                                  PSLocalProvider
                                      .instance
                                      .ps_quiz_model_indexName,
                                  3,
                                );
                              } else if (index == 3) {
                                await PSLocalProvider.instance.updateint(
                                  PSLocalProvider
                                      .instance
                                      .ps_quiz_model_indexName,
                                  0,
                                );
                              }
                            },
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 23,
                                  top: 9,
                                  child: PSImg(
                                    name: 'ps_three_icon_$index',
                                    width: 50,
                                    height: 50,
                                  ),
                                ),
                                Positioned(
                                  left: 88,
                                  top: 20,
                                  child: PSText(
                                    text: names[index],
                                    size: 24,
                                    color: '#A14D20'.color(),
                                    weight: FontWeight.w900,
                                  ),
                                ),
                                Positioned(
                                  right: 23,
                                  top: 16,
                                  child: PSImg(
                                    name:
                                        'ps_three_icon_${itemSeletecd == index ? 's' : 'n'}',
                                    width: 37,
                                    height: 37,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 40),
                InkWell(
                  onTap: () async {
                    await PSLocalProvider.instance.updateBool(
                      PSLocalProvider.instance.ps_newA_guideName,
                      true,
                    );
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => PigBottomExample(key: homeKey),
                      ),
                    );
                    Future.delayed(Duration(milliseconds: 100), () {
                      PigTabController.switchTo(1);
                    });
                  },
                  child: Container(
                    width: 260,
                    height: 59,
                    decoration: BoxDecoration(image: PSDImg('ps_green_btn')),
                    child: Center(
                      child: PSStrokeText(
                        text: 'Continue',
                        size: 24,
                        color: '#FFFFFF'.color(),
                        weight: FontWeight.w900,
                        skWidth: 2,
                        skColor: '#025003'.color(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
