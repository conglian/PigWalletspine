import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piggywalletspinearn/PSBase/PSTbaBar.dart';
import 'package:piggywalletspinearn/PSDialog/PSGuideManager.dart';
import 'package:piggywalletspinearn/PSHome/PSHome.dart';
import 'package:piggywalletspinearn/PSTool/PSNumberHelpers.dart';
import 'package:piggywalletspinearn/PSTool/PSTBAEventTool.dart';
import 'package:piggywalletspinearn/PSTool/ps_GradientNumber.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_ad_manger.dart';
import 'package:spine_flutter/spine_widget.dart' as spine;
import '../PSTool/ps_extension_help.dart';
import '../PSTool/ps_img.dart';
import '../PSTool/ps_stroke_text.dart';
import '../PSTool/ps_text.dart';
import 'PSDialog.dart';

class PSGuideNew1Dialog extends StatefulWidget {
  const PSGuideNew1Dialog({super.key});

  @override
  State<PSGuideNew1Dialog> createState() => PSGuideNew1DialogState();
}

class PSGuideNew1DialogState extends State<PSGuideNew1Dialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late spine.SpineWidgetController _controller1;
  @override
  void initState() {
    super.initState();
    ps_event_fire('new_guide_one', {});
    // 初始化 AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );

    // 使用 Tween 来控制从 0 到 1 的进度
    _animation = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    // 启动动画
    _controller.forward();

    _controller1 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 0.width(context),
        height: 0.height(context),
        decoration: BoxDecoration(
            image: PSDImg('ps_guide_bgs')
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PSImg(name: 'ps_guide1_0', width: 362, height: 97),
            SizedBox(height: 28),
            Container(
              width: 349,
              height: 119,
              decoration: BoxDecoration(image: PSDImg('ps_t_center_bg')),
              child: Stack(
                children: [
                  Positioned(
                    left: 32,
                    top: 0,
                    child: Container(
                      width: 141,
                      height: 32,
                      decoration: BoxDecoration(image: PSDImg('ps_act_bg')),
                      child: Center(
                        child: PSImg(
                          name: 'ps_act_0',
                          width: 128,
                          height: 20,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 32,
                    top: 29,
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.w900,
                          color: '#873709'.color(),
                          fontFamily: 'Black_mianfeiziti',
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Growing Balance: '),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                      left: 174,
                      top: 27,
                    child: PSGradientNumberRoller(
                    value: PSNumberHelpers().intModel!.eqRange.first,
                    duration: 1500,
                    fontSize: 16.0,
                    gradientColors: ['#0BA408'.color(), '#0BA408'.color()],
                    borderColor: Colors.transparent,
                    borderWidth: 0.0,
                    decimalPlaces: 2,
                  ),),
                  Positioned(
                    left: 30,
                    top: 56,
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
                            child: AnimatedBuilder(
                              animation: _controller,
                              builder: (context, child) {
                                return Container(
                                  width: 278 * _animation.value, // 动态调整宽度
                                  height: 20,
                                  decoration: BoxDecoration(
                                    color: '#80F207'.color(),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    right: 20,
                    bottom: 30,
                    child: PSImg(name: 'ps_dolas_b', width: 39, height: 29),
                  ),
                  Positioned(
                    right: 26,
                    bottom: 30,
                    child: PSStrokeText(
                      text: '${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first}',
                      size: 12,
                      color: '#FFE711'.color(),
                      weight: FontWeight.w900,
                      skWidth: 1,
                      skColor: '#042267'.color(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 347.w,
              height: 340,
              child: Stack(
                children: [
                  Positioned(
                      left: (0.width(context) - 156) * 0.48,
                      child: SizedBox(width: 156, height: 160, child: spine.SpineWidget.fromAsset('assets/spine/yindao-pig/skeleton.atlas', 'assets/spine/yindao-pig/skeleton.skel', _controller1),)),
                  Positioned(
                      left: (0.width(context) - 327) * 0.45,
                      top: 120,
                      child: PSImg(name: 'ps_guide1_1', width: 327, height: 198)),
                  Positioned(
                      left: (0.width(context) - 100) * 0.52,
                      top: 150,
                      child: PSText(
                        text: 'Piggy Payout',
                        size: 14,
                        color: '#FCF9E5'.color(),
                        weight: FontWeight.w900,
                      )),
                  Positioned(
                      left: 20,
                      bottom: 10,
                      child: PSText(
                        text: 'Advertisers',
                        size: 14,
                        color: '#FCF9E5'.color(),
                        weight: FontWeight.w900,
                      )),
                  Positioned(
                      right: 4,
                      bottom: 10,
                      child: PSText(
                        text: 'Your Wallet',
                        size: 14,
                        color: '#FCF9E5'.color(),
                        weight: FontWeight.w900,
                      )),
                ],
              ),
            ),
            SizedBox(height: 20.h),
            InkWell(
              onTap: () {
                ps_event_fire('new_guide_one_c', {});
                PSGuideManager.nextStep(context);
              },
              child: Container(
                width: 272,
                height: 71,
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
          ],
        ),
      ),
    );
  }
}

class PSGuideNew2Dialog extends StatefulWidget {
  const PSGuideNew2Dialog({super.key});

  @override
  State<PSGuideNew2Dialog> createState() => PSGuideNew2DialogState();
}

class PSGuideNew2DialogState extends State<PSGuideNew2Dialog>
    with TickerProviderStateMixin {
  /// ps_guide2_0淡入
  late AnimationController _fade0Ctrl;

  /// ps_guide2_1淡入+缩放
  late AnimationController _fade1Ctrl;
  late Animation<double> _fade1Anim;
  late Animation<double> _scale1Anim;

  /// ps_guide2_2滑动
  late AnimationController _slideCtrl;
  late Animation<double> _slideAnim;

  /// ps_guide2_2呼吸动画
  late AnimationController _breathCtrl;
  late Animation<double> _breathAnim;

  /// ps_guide2_3淡入+缩放 & 按钮显示
  late AnimationController _fade3Ctrl;
  late Animation<double> _fade3Anim;
  late Animation<double> _scale3Anim;

  @override
  void initState() {
    super.initState();
    ps_event_fire('new_guide_two', {});

    // 初始化控制器
    _fade0Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _fade1Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _breathCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fade3Ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final screenWidth = MediaQuery.of(context).size.width;

    // ps_guide2_1淡入 + 缩放
    _fade1Anim = CurvedAnimation(
      parent: _fade1Ctrl,
      curve: Curves.easeIn,
    );
    _scale1Anim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _fade1Ctrl, curve: Curves.elasticOut),
    );

    // 滑动动画：从屏幕右边到中心
    _slideAnim = Tween<double>(
      begin: screenWidth,
      end: (screenWidth - 320) * 0.5,
    ).animate(CurvedAnimation(
      parent: _slideCtrl,
      curve: Curves.easeOut,
    ));

    // 呼吸动画：缩放
    _breathAnim = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _breathCtrl, curve: Curves.easeInOut),
    );

    // ps_guide2_3淡入 + 缩放
    _fade3Anim = CurvedAnimation(parent: _fade3Ctrl, curve: Curves.easeIn);
    _scale3Anim = Tween<double>(begin: 0.5, end: 1.02).animate(
      CurvedAnimation(parent: _fade3Ctrl, curve: Curves.elasticOut),
    );

    // 启动动画序列
    _startAnim();
  }

  void _startAnim() async {
    // 0：ps_guide2_0淡入
    _fade0Ctrl.forward();

    await Future.delayed(const Duration(milliseconds: 500));

    // 1：ps_guide2_1淡入 + 缩放
    _fade1Ctrl.forward();

    await Future.delayed(const Duration(milliseconds: 500));

    // 2：ps_guide2_2滑动
    _slideCtrl.forward();

    await Future.delayed(const Duration(milliseconds: 500));

    // 3：ps_guide2_3淡入 + 缩放 & 按钮显示，同时ps_guide2_2开始呼吸动画
    _fade3Ctrl.forward();
    _breathCtrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fade0Ctrl.dispose();
    _fade1Ctrl.dispose();
    _slideCtrl.dispose();
    _breathCtrl.dispose();
    _fade3Ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 0.width(context),
        height: 0.height(context),
        decoration: BoxDecoration(
          image: PSDImg('ps_guide_bgs'),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /// --- ps_guide2_0淡入 ---
            FadeTransition(
              opacity: _fade0Ctrl,
              child: PSImg(name: 'ps_guide2_0', width: 319, height: 97),
            ),

            SizedBox(
              width: 0.width(context),
              height: 476.h,
              child: Stack(
                children: [
                  /// --- ps_guide2_1淡入 + 缩放 ---
                  AnimatedBuilder(
                    animation: _fade1Ctrl,
                    builder: (context, child) {
                      return Positioned(
                        left: (0.width(context) - 330) * 0.5,
                        child: Opacity(
                          opacity: _fade1Anim.value,
                          child: Transform.scale(
                            scale: _scale1Anim.value,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: PSImg(
                      name: 'ps_guide2_1',
                      width: 330,
                      height: 140,
                    ),
                  ),

                  /// --- ps_guide2_2滑动 + 呼吸 ---
                  AnimatedBuilder(
                    animation: Listenable.merge([_slideCtrl, _breathCtrl]),
                    builder: (context, child) {
                      return Positioned(
                        left: _slideAnim.value,
                        top: 140,
                        child: Transform.scale(
                          scale: _breathAnim.value,
                          child: child!,
                        ),
                      );
                    },
                    child: PSImg(
                      name: 'ps_guide2_2',
                      width: 320,
                      height: 134,
                    ),
                  ),

                  /// --- ps_guide2_3淡入 + 缩放 ---
                  AnimatedBuilder(
                    animation: _fade3Ctrl,
                    builder: (context, child) {
                      return Positioned(
                        left: (0.width(context) - 336) * 0.5,
                        top: 240,
                        child: Opacity(
                          opacity: _fade3Anim.value,
                          child: Transform.scale(
                            scale: _scale3Anim.value,
                            child: child,
                          ),
                        ),
                      );
                    },
                    child: PSImg(
                      name: 'ps_guide2_3',
                      width: 336,
                      height: 206,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 10.h),

            /// --- 底部按钮淡入 ---
            FadeTransition(
              opacity: _fade3Ctrl,
              child: InkWell(
                onTap: () {
                  ps_event_fire('new_guide_two_c', {});
                  PSGuideManager.nextStep(context);
                },
                child: Container(
                  width: 272,
                  height: 71,
                  decoration: BoxDecoration(
                    image: PSDImg('ps_green_btn'),
                  ),
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
            ),
          ],
        ),
      ),
    );
  }
}
class PSGuideNew3Dialog extends StatefulWidget {
  const PSGuideNew3Dialog({super.key});

  @override
  State<PSGuideNew3Dialog> createState() => PSGuideNew3DialogState();
}

class PSGuideNew3DialogState extends State<PSGuideNew3Dialog> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;
  late double screenWidth = 0.width(context); // 用于保存屏幕宽度
  late spine.SpineWidgetController _controller1;
  @override
  void initState() {
    super.initState();
    ps_event_fire('new_guide_three', {});

    _controller1 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    // 初始化动画控制器，设置为无限循环
    _controller = AnimationController(
      duration: Duration(seconds: 3), // 动画持续时间
      vsync: this,
    )..repeat(reverse: false); // 让动画循环播放，不反向

    // 设置Tween来控制图片的位置，范围从 -1 到 1，表示从左到右
    _animation = Tween<Offset>(
      begin: Offset(-1.0, 0.0), // 从屏幕外的左边开始
      end: Offset(0.0, 0.0), // 到达屏幕右边
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear, // 让动画平滑
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 0.width(context),
        height: 0.height(context),
        decoration: BoxDecoration(
          image: PSDImg('ps_guide_bgs'),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PSImg(name: 'ps_guide3_0', width: 319, height: 97),
            Container(
              width: 361,
              height: 159,
              decoration: BoxDecoration(
                image: PSDImg('ps_guide3_2'), // 这里是你丢失的 ps_guide3_2
              ),
              child: Stack(
                children: [
                  // 使用 AnimatedBuilder 实现无限滚动
                  Positioned(
                    top: 24,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        final dx = (_controller.value * 570) % 570; // 570 为图片宽度
                        return Stack(
                          children: [
                            Transform.translate(
                              offset: Offset(-dx, 0),
                              child: PSImg(name: 'ps_guide3_1', width: 570, height: 106),
                            ),
                            Transform.translate(
                              offset: Offset(-dx + 570, 0),
                              child: PSImg(name: 'ps_guide3_1', width: 570, height: 106),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 375, height: 245, child: spine.SpineWidget.fromAsset('assets/spine/yindao-money/skeleton.atlas', 'assets/spine/yindao-money/skeleton.skel', _controller1)),
            SizedBox(height: 10.h),
            InkWell(
              onTap: () {
                ps_event_fire('new_guide_three_c', {});
                PSGuideManager.nextStep(context);
              },
              child: Container(
                width: 272,
                height: 71,
                decoration: BoxDecoration(
                  image: PSDImg('ps_green_btn'),
                ),
                child: Center(
                  child: PSStrokeText(
                    text: 'Let‘s Start Earning',
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
    );
  }
}

class PSGuideNew4Dialog extends StatefulWidget {
  const PSGuideNew4Dialog({super.key});

  @override
  State<PSGuideNew4Dialog> createState() => PSGuideNew4DialogState();
}

class PSGuideNew4DialogState extends State<PSGuideNew4Dialog> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _firstTextAnimation;
  late Animation<int> _secondTextAnimation;
  late Timer _textSwitchTimer;

  bool showButton = false;
  bool showFirstText = true;
  bool showPsGuide4_3 = false;

  final firstText = 'Hey, I’m Jason. Just last week, I cashed out ${0.dolasType()}100\nFrom this App.';
  final secondText = 'You wanna know how I did it? 👉 Let me show you. It’s easy — we earn money by watching ads.';

  @override
  void initState() {
    super.initState();
    ps_event_fire('new_home_guide', {});

    // 初始化动画控制器
    _controller = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );

    // 第一段文本动画
    _firstTextAnimation = IntTween(begin: 0, end: firstText.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 第二段文本动画
    _secondTextAnimation = IntTween(begin: 0, end: secondText.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 启动第一段文字的动画
    _controller.forward();

    // 延迟5秒后切换到第二段文字的动画
    _textSwitchTimer = Timer(Duration(seconds: 2), () {
      setState(() {
        showButton = true;     // 显示底部按钮
        showPsGuide4_3 = true; // 显示 ps_guide4_3
        showFirstText = false; // 显示第二段文本
        _controller.reset();   // 重置动画
        _controller.forward(); // 启动第二段文本的动画
      });
    });

    // 延迟9秒后显示按钮和图片
    Timer(Duration(seconds: 3), () {
      setState(() {
      });
    });
  }

  String cleanInvalidUtf16Characters(String text) {
    // 转换为 UTF-8 字符串，然后再转换回字符串
    try {
      List<int> bytes = utf8.encode(text);
      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      print('Error cleaning invalid UTF-16 characters: $e');
      return text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _textSwitchTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox(
        width: double.infinity,  // 容器宽度填充整个屏幕
        height: double.infinity, // 容器高度填充整个屏幕
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 380,
              child: Stack(
                children: [
                  Positioned(
                    left: (0.width(context) - 211) * 0.5,
                    child: Container(
                      width: 211,
                      height: 208,
                      decoration: BoxDecoration(
                          image: PSDImg('ps_b_pig_icon_0')
                      ),
                      child: Column(
                        children: [
                          Spacer(),
                          Container(
                            width: 141,
                            height: 34,
                            decoration: BoxDecoration(
                                image: PSDImg('ps_act_bg')
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                PSImg(name: 'ps_dolas_2', width: 26, height: 21),
                                SizedBox(width: 5,),
                                PSText(text: '${0.dolasType()}${PSLocalProvider.instance.ps_dolas_number}', size: 20, color: '#8B0002'.color(), weight: FontWeight.w900)
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: (0.width(context) - 335) * 0.5,
                    top: 240,
                    child: Container(
                      width: 335,
                      height: 139,
                      decoration: BoxDecoration(
                          image: PSDImg('ps_guide4_2')
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 38, left: 20, right: 12),
                        child: SizedBox(
                          width: 261,
                          height: 76,
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              String textToShow = showFirstText
                                  ? cleanInvalidUtf16Characters(firstText.substring(0, _firstTextAnimation.value))
                                  : cleanInvalidUtf16Characters(secondText.substring(0, _secondTextAnimation.value));

                              return Text(
                                textToShow,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w900,
                                    color: '#733A1B'.color(), // 默认颜色
                                    fontFamily: 'Black_mianfeiziti'
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(left: 40, top: 200, child: PSImg(name: 'ps_guide4_1', width: 68, height: 68)),
                  Positioned(left: 54, top: 174, child: PSImg(name: 'ps_guide4_0', width: 41, height: 35)),
                ],
              ),
            ),
            SizedBox(height: 12.h),
            // 确保 ps_guide4_3 和按钮的占位不变
            Visibility(
              visible: showPsGuide4_3,
              maintainSize: true,
              maintainState: true, // Ensure state is maintained
              maintainAnimation: true, // Maintain animation as well
              child: Row(
                children: [
                  SizedBox(width: 227.w),
                  PSImg(name: 'ps_guide4_3', width: 37, height: 46),
                ],
              ),
            ),
            SizedBox(height: 10.h),
            // 控制按钮的显示与隐藏
            Visibility(
              visible: showButton,
              maintainSize: true,
              maintainState: true, // Ensure state is maintained
              maintainAnimation: true, // Maintain animation as well
              child: InkWell(
                onTap: () {
                  ps_event_fire('new_home_guide_c', {});
                  Navigator.pop(context, 0);
                  PSGuideManager.nextStep(context);
                },
                child: Container(
                  width: 272,
                  height: 71,
                  decoration: BoxDecoration(
                    image: PSDImg('ps_quzi_btn_n'),
                  ),
                  child: Center(
                    child: PSStrokeText(
                      text: 'Try It Now',
                      size: 24,
                      color: '#FFFFFF'.color(),
                      weight: FontWeight.w900,
                      skWidth: 2,
                      skColor: '#025003'.color(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PSGuideNew5Dialog extends StatefulWidget {
  const PSGuideNew5Dialog({super.key});

  @override
  State<PSGuideNew5Dialog> createState() => PSGuideNew5DialogState();
}

class PSGuideNew5DialogState extends State<PSGuideNew5Dialog> with TickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<int> _textAnimation;
  bool showAppleBubble = true; // 控制显示ps_apple_bubble

  final firstText = 'Fed it more apples, and boom — it evolved into a Gold Pig.That’s when the payout unlocked.';

  late spine.SpineWidgetController _controller1;

  @override
  void initState() {
    super.initState();

    ps_event_fire('new_apple_guide', {});

    // 初始化动画控制器
    _controller = AnimationController(
      duration: Duration(seconds: 1), // 动画时长
      vsync: this,
    );

    // 文本逐渐显示的动画
    _textAnimation = IntTween(begin: 0, end: firstText.length).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 启动文本动画
    _controller.forward();

    // 在动画结束后，显示ps_apple_bubble
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
      }
    });

    _controller1 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
  }

  String cleanInvalidUtf16Characters(String text) {
    try {
      List<int> bytes = utf8.encode(text);
      return utf8.decode(bytes, allowMalformed: true);
    } catch (e) {
      print('Error cleaning invalid UTF-16 characters: $e');
      return text;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,  // 容器宽度填充整个屏幕
        height: double.infinity, // 容器高度填充整个屏幕
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: double.infinity,
              height: 480,
              child: Stack(
                children: [
                  Positioned(
                    left: (0.width(context) - 335) * 0.5,
                    top: 140.h,
                    child: Container(
                      width: 335,
                      height: 139,
                      decoration: BoxDecoration(
                          image: PSDImg('ps_guide4_2')
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(top: 38, left: 20, right: 12),
                        child: SizedBox(
                          width: 261,
                          height: 76,
                          child: AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              // 获取当前显示的文字
                              String textToShow = cleanInvalidUtf16Characters(
                                  firstText.substring(0, _textAnimation.value)
                              );

                              return Text(
                                textToShow,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.w900,
                                    color: '#733A1B'.color(), // 默认颜色
                                    fontFamily: 'Black_mianfeiziti'
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(left: 40, top: 100.h, child: PSImg(name: 'ps_guide4_1', width: 68, height: 68)),
                  Positioned(left: 54, top: 72.h, child: PSImg(name: 'ps_guide4_0', width: 41, height: 35)),
                  // 显示 ps_apple_bubble 图标，直到文字动画结束
                  if (showAppleBubble)
                    Positioned(
                      top: 0,
                      right: 42.w,
                      child: InkWell(
                        onTap: () async {
                          ps_event_fire('new_apple_guide_c', {});
                          //
                          if (PSLocalProvider.instance.new_ad_console == 1) {
                             // ad
                             PSPigAds().ps_showAd(context, 'asd_rv', onCacheResponse: (onCacheResponse){
                               Navigator.pop(context,0);
                               PSGuideManager.nextStep(context);
                             }, adDidClosed: (adDidClosed) async {
                               double award = PSNumberHelpers().getPrizeWithDolasNum();
                               await PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_dolas_numberName, award);
                               if (!context.mounted) return;
                               int code = await context.tipShow2(PSPoGetAwardDog(award: award),bc: Colors.transparent);
                               if (code >= 0){
                                 Navigator.pop(context,0);
                                 PSGuideManager.nextStep(context);
                               }
                             });
                          } else {
                            Navigator.pop(context,0);
                            double award = PSNumberHelpers().getPrizeWithDolasNum();
                            await PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_dolas_numberName, award);
                            if (!context.mounted) return;
                            int code = await context.tipShow2(PSPoGetAwardDog(award: award),bc: Colors.transparent);
                            if (code >= 0){
                              PSGuideManager.nextStep(context);
                            }
                          }
                        },
                        child: Container(
                          width: 62,
                          height: 62,
                          decoration: BoxDecoration(
                              image: PSDImg('ps_apple_bubble')
                          ),
                          child: Stack(
                            children: [
                              Positioned(right: 0, child: PSImg(name: 'ps_ad_icon', width: 25, height: 28)),
                            ],
                          ),
                        ),
                      ),
                    ),
                  if (showAppleBubble)
                    Positioned(
                      top: 30,
                      right: 30.w,
                      child: ParticleButton(
                        onTap: () async {
                          ps_event_fire('new_apple_guide_c', {});
                          //
                          if (PSLocalProvider.instance.new_ad_console == 1) {
                            // ad
                            PSPigAds().ps_showAd(context, 'asd_rv', onCacheResponse: (onCacheResponse){
                              Navigator.pop(context,0);
                              PSGuideManager.nextStep(context);
                            }, adDidClosed: (adDidClosed) async {
                              double award = PSNumberHelpers().getPrizeWithDolasNum();
                              await PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_dolas_numberName, award);
                              if (!context.mounted) return;
                              int code = await context.tipShow2(PSPoGetAwardDog(award: award),bc: Colors.transparent);
                              if (code >= 0){
                                Navigator.pop(context,0);
                                PSGuideManager.nextStep(context);
                              }
                            });
                          } else {
                            Navigator.pop(context,0);
                            double award = PSNumberHelpers().getPrizeWithDolasNum();
                            await PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_dolas_numberName, award);
                            if (!context.mounted) return;
                            int code = await context.tipShow2(PSPoGetAwardDog(award: award),bc: Colors.transparent);
                            if (code >= 0){
                              PSGuideManager.nextStep(context);
                            }
                          }

                        },
                        child: SizedBox(
                        width: 55,
                        height: 88,
                        child: spine.SpineWidget.fromAsset(
                          'assets/spine/shouzhi/skeleton.atlas',
                          'assets/spine/shouzhi/skeleton.skel',
                          _controller1,
                         )
                        ),
                      ),)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PSGuideNew6Dialog extends StatefulWidget {
  const PSGuideNew6Dialog({super.key});

  @override
  State<PSGuideNew6Dialog> createState() => PSGuideNew6DialogState();
}

class PSGuideNew6DialogState extends State<PSGuideNew6Dialog> with TickerProviderStateMixin {

  late spine.SpineWidgetController _controller1;

  @override
  void initState() {
    super.initState();

    _controller1 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

    Future.delayed(Duration(milliseconds: 1800),(){
      Navigator.pop(context, 0);
      PSGuideManager.nextStep(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,  // 容器宽度填充整个屏幕
        height: double.infinity, // 容器高度填充整个屏幕
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              left: (0.width(context) - 211) * 0.5,
              top: 140.h,
              child: Container(
                width: 211,
                height: 208,
                decoration: BoxDecoration(
                    image: PSDImg('ps_b_pig_icon_0')
                ),
                child: Column(
                  children: [
                    Spacer(),
                    Padding(padding: EdgeInsetsGeometry.only(left: 50),child: PSImg(name: 'ps_0_${PSLocalProvider.instance.ps_dolas_number > 25 ? 50 : 25}', width: 78.02, height: 67.21)),
                    SizedBox(height: 16),
                    Container(
                      width: 141,
                      height: 34,
                      decoration: BoxDecoration(
                          image: PSDImg('ps_act_bg')
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          PSImg(name: 'ps_dolas_2', width: 26, height: 21),
                          SizedBox(width: 5,),
                          PSGradientNumberRoller(
                            value: PSLocalProvider.instance.ps_dolas_number,
                            duration: 1800,
                            fontSize: 20.0,
                            gradientColors: ['#8B0002'.color(), '#8B0002'.color()],
                            borderColor: Colors.transparent,
                            borderWidth: 0.0,
                            decimalPlaces: 2,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 180.h),
                InkWell(
                  onTap: (){
                  },
                  child: SizedBox(
                    child: SizedBox(
                        width: 0.width(context),
                        height: 500,
                        child: Stack(
                          children: [
                            spine.SpineWidget.fromAsset(
                              'assets/spine/yindao3/skeleton.atlas',
                              'assets/spine/yindao3/skeleton.skel',
                              _controller1,
                            ),
                            Column(
                              children: [
                                Spacer(),
                                Row(
                                  mainAxisAlignment: .center,
                                  children: [
                                    PSImg(name: 'ps_act_0${isBrazilianPortuguese(context) == true ? 'pt' : ''}', width: 120, height: 32),
                                    SizedBox(width: 10.w),
                                    PSText(text: '+${0.dolasType()}${PSLocalProvider.instance.ps_dolas_number}', size: 24, color: '#8B0002'.color(), weight: FontWeight.w900)
                                  ],
                                ),
                                SizedBox(height: 196)
                              ],
                            ),
                          ],
                        )
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  bool isBrazilianPortuguese(BuildContext context) {
    // 获取当前语言环境
    Locale currentLocale = Localizations.localeOf(context);

    // 判断是否是巴西葡萄牙语
    return currentLocale.languageCode == 'pt' || currentLocale.countryCode == 'BR';
  }
}


class PSGuideNew7Dialog extends StatefulWidget {
  const PSGuideNew7Dialog({super.key});

  @override
  State<PSGuideNew7Dialog> createState() => PSGuideNew7DialogState();
}

class PSGuideNew7DialogState extends State<PSGuideNew7Dialog> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    ps_event_fire('new_first_prize_pop', {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,  // 容器宽度填充整个屏幕
        height: double.infinity, // 容器高度填充整个屏幕
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 211,
              height: 208,
              decoration: BoxDecoration(
                  image: PSDImg('ps_b_pig_icon_0')
              ),
              child: Column(
                children: [
                  Spacer(),
                  Padding(padding: EdgeInsetsGeometry.only(left: 50),child: PSImg(name: 'ps_0_25', width: 78.02, height: 67.21)),
                  SizedBox(height: 16),
                  Container(
                    width: 141,
                    height: 34,
                    decoration: BoxDecoration(
                        image: PSDImg('ps_act_bg')
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PSImg(name: 'ps_dolas_2', width: 26, height: 21),
                        SizedBox(width: 5,),
                        PSText(text: '${0.dolasType()}${PSLocalProvider.instance.ps_dolas_number}', size: 20, color: '#8B0002'.color(), weight: FontWeight.w900)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.h),
            Container(
              width: 325,
              height: 300,
              decoration: BoxDecoration(
                  image: PSDImg('ps_guide7_0')
              ),
              child: Column(
                children: [
                  SizedBox(height: 24),
                  PSText(text: '💰 Your First commission has arrived!', size: 16, color: '#620F0F'.color(), weight: FontWeight.w900),
                  PSImg(name: 'ps_guide7_1', width: 86, height: 78),
                  PSStrokeText(text: 'Deposit amount：${0.dolasType()}${PSLocalProvider.instance.ps_dolas_number}', size: 24, color: '#FFE11C'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#1D0808'.color()),
                  SizedBox(height: 12),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w900,
                        color: '#2A1B1B'.color(),
                        fontFamily: 'Black_mianfeiziti',
                      ),
                      children: <TextSpan>[
                        TextSpan(text: 'An advertiser just paid you.\n'),
                        TextSpan(text: 'Just'),
                        TextSpan(
                          text: ' ${0.dolasType()}${0.to2Double(PSNumberHelpers().intModel!.eqRange.first - PSLocalProvider.instance.ps_dolas_number)} ',
                          style: TextStyle(color: '#199E24'.color()),
                        ),
                        TextSpan(text: 'more to cash out!'),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  ParticleButton(
                    onTap: () {
                      Navigator.pop(context, 0);
                      ps_event_fire('new_first_prize_pop_c', {});
                      PSGuideManager.nextStep(context);
                    },
                    child: Container(
                      width: 272,
                      height: 71,
                      decoration: BoxDecoration(
                        image: PSDImg('ps_quzi_btn_d'),
                      ),
                      child: Center(
                        child: PSStrokeText(
                          text: 'Keep Earning',
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
            )
          ],
        ),
      ),
    );
  }
}

class PSGuideNew8Dialog extends StatefulWidget {
  const PSGuideNew8Dialog({super.key});

  @override
  State<PSGuideNew8Dialog> createState() => PSGuideNew8DialogState();
}

class PSGuideNew8DialogState extends State<PSGuideNew8Dialog> with TickerProviderStateMixin {
  bool is_quizing = false;
  bool anwer_a = false;
  bool anwer_b = false;
  bool show_c = false;
  int row = 0;
  int dui_row = 0;
  List<String> ques = ['Who gives you money here?', 'When can you withdraw your cash?', 'What’s the fastest way to fill your PiggyBoost?'];
  List<String> answerA = ['Advertisers', 'When you get a Golden Pig', 'Watch more ads'];
  List<String> answerB = ['Other players', 'Any time', 'Wait without playing'];
  late spine.SpineWidgetController _controller1;
  @override
  void initState() {
    super.initState();
    ps_event_fire('new_quiz_guide', {});

    _controller1 = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: 0.width(context),  // 容器宽度填充整个屏幕
        height: 0.height(context), // 容器高度填充整个屏幕
        color: Colors.transparent,
        child: Column(
          children: [
            SizedBox(height: 44.h),
            SizedBox(
          width: double.infinity,
          height: 200,
          child: Stack(
            children: [
              Positioned(
                left: (0.width(context) - 335) * 0.5,
                bottom: 0.h,
                child: Container(
                  width: 335,
                  height: 139,
                  decoration: BoxDecoration(
                      image: PSDImg('ps_guide4_2')
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 38, left: 20, right: 12),
                    child: SizedBox(
                      width: 261,
                      height: 76,
                      child: Text(
                        "Answer And Unlock!\nAdvertisers want to confirm you're Real.\n🎁 Pass their quiz = Unlock withdrawal Access!\n👉 Start now – only 3 Easy Questions!",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w900,
                            color: '#733A1B'.color(), // 默认颜色
                            fontFamily: 'Black_mianfeiziti'
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(left: 40, top: 26.h, child: PSImg(name: 'ps_guide4_1', width: 68, height: 68)),
              Positioned(left: 54, top: 0.h, child: PSImg(name: 'ps_guide4_0', width: 41, height: 35)),
            ],
             )
            ),
            SizedBox(height: 22.h),
            Container(
              width: 323.w,
              height: 427.h,
              decoration: BoxDecoration(
                image: PSDImg('ps_quiz_bg')
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: -22.w,
                    top: 12.h,
                    width: 0.width(context),
                    child: PSStrokeText(
                      text: 'Right Answer Wins Cash',
                      size: 18,
                      color: '#F8FFAD'.color(),
                      weight: FontWeight.w900,
                      skWidth: 1,
                      skColor: '#026724'.color(),
                    ),
                  ),
                  Positioned(
                    left: (343.w - 300.w) * 0.5,
                    top: 94.h,
                    child: SizedBox(
                      width: 288.w,
                      height: 120.h,
                      child: Center(
                        child: PSStrokeText(
                          text:
                          ques[row],
                          size: 24.sp,
                          color: '#FCFFE5'.color(),
                          weight: FontWeight.w900,
                          skWidth: 2,
                          skColor: '#03441B'.color(),
                          align: TextAlign.center,
                          maxLines: 5,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: (343.w - 280.w) * 0.5,
                    top: 240.h,
                    child: ParticleButton(
                      onTap: () {
                        if (is_quizing) return;
                        ps_event_fire('new_quiz_guide_c', {});
                          setState(() {
                            is_quizing = true;
                            anwer_a = true;
                          });
                        Future.delayed(Duration(milliseconds: 1000), () async {
                         var code = await context.tipShow(PSPopAwardToolDialog(type: .quiz, isGuide: true, award: PSNumberHelpers().intModel!.firstAdPrize));
                         if (code >= 0) {
                           dui_row += 1;
                           // answerA.removeAt(row);
                           // answerB.removeAt(row);
                           // ques.removeAt(row);
                           if (dui_row ==3) {
                             Navigator.pop(context, 0);
                             PSGuideManager.nextStep(context);
                           }
                           setState(() {
                             is_quizing = false;
                             anwer_b = false;
                             anwer_a = false;
                           });
                         }
                        });
                      },
                      child: Container(
                        width: 260.w,
                        height: 58.78.h,
                        decoration: BoxDecoration(
                          image: PSDImg(
                            is_quizing
                                ? anwer_a
                                ? 'ps_quzi_btn_d'
                                : 'ps_quzi_btn_c'
                                : 'ps_quzi_btn_n',
                          ),
                        ),
                        child: Center(
                          child: PSStrokeText(
                            text: answerA[row],
                            size: 18,
                            color: '#FFFFFF'.color(),
                            weight: FontWeight.w900,
                            skWidth: 2,
                            skColor: '#711A00'.color(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: (343.w - 280.w) * 0.5,
                    top: 320.h,
                    child: ParticleButton(
                      onTap: () {
                        if (is_quizing) return;
                        ps_event_fire('new_quiz_guide_c', {});
                        row += 1;
                        if (row + 1 >= ques.length){
                          row = 0;
                        }
                        setState(() {
                          is_quizing = true;
                          anwer_b = false;
                          anwer_a = true;
                          show_c = true;
                        });
                        Future.delayed(Duration(milliseconds: 1000), () {
                          setState(() {
                            is_quizing = false;
                            anwer_b = false;
                            anwer_a = false;
                            show_c = false;
                          });
                        });
                      },
                      child: Container(
                        width: 260.w,
                        height: 58.78.h,
                        decoration: BoxDecoration(
                          image: PSDImg(
                            is_quizing
                                ? anwer_b
                                ? 'ps_quzi_btn_d'
                                : 'ps_quzi_btn_c'
                                : 'ps_quzi_btn_n',
                          ),
                        ),
                        child: Center(
                          child: PSStrokeText(
                            text: answerB[row],
                            size: 18,
                            color: '#FFFFFF'.color(),
                            weight: FontWeight.w900,
                            skWidth: 2,
                            skColor: '#711A00'.color(),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 34.w,
                    bottom: 172.h,
                    child: Visibility(
                      visible: is_quizing,
                      child: PSImg(
                        name:
                        anwer_a ==
                            true
                            ? 'ps_quzi_status_s'
                            : 'ps_quzi_status_n',
                        width: 39,
                        height: 39,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 34.w,
                    bottom: 92.h,
                    child: Visibility(
                      visible: show_c,
                      child: PSImg(
                        name:
                        anwer_b ==
                            true
                            ? 'ps_quzi_status_s'
                            : 'ps_quzi_status_n',
                        width: 39,
                        height: 39,
                      ),
                    ),
                  ),
                  Positioned(right: 4.w,bottom: 74.h,child: SizedBox(
                    width: 58,
                    height: 89,
                    child: spine.SpineWidget.fromAsset(
                      'assets/spine/shouzhi/skeleton.atlas',
                      'assets/spine/shouzhi/skeleton.skel',
                      _controller1,
                    ),
                  ),)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PSGuideNew9Dialog extends StatefulWidget {
  const PSGuideNew9Dialog({super.key});

  @override
  State<PSGuideNew9Dialog> createState() => PSGuideNew9DialogState();
}

class PSGuideNew9DialogState extends State<PSGuideNew9Dialog> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    ps_event_fire('new_confirm_account_pop', {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: double.infinity,  // 容器宽度填充整个屏幕
        height: double.infinity, // 容器高度填充整个屏幕
        color: Colors.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 345.w,
              height: 466.h,
              decoration: BoxDecoration(
                  image: PSDImg('ps_tx_info_bg')
              ),
              child: Column(
                children: [
                  SizedBox(height: 17.h),
                  PSText(text: 'Congratulation!', size: 24, color: '#134475'.color(), weight: FontWeight.w900),
                  SizedBox(height: 14.h),
                  Container(
                    width: 273.w,
                    height: 37.h,
                    decoration: BoxDecoration(
                      color: '#F54E00'.color(),
                      borderRadius: BorderRadius.circular(19.h)
                    ),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w900,
                            color: '#FFFFFF'.color(),
                            fontFamily: 'Black_mianfeiziti',
                          ),
                          children: <TextSpan>[
                            TextSpan(text: '28,783 ',
                            style: TextStyle(color: '#FFE313'.color())),
                            TextSpan(text: 'Users Have Successfully\nWithdrawn Cash This Week'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 13.h),
                  PSImg(name: 'ps_guide9_0', width: 109, height: 109),
                  PSText(text: 'You’re Ready To Cash Out!', size: 16, color: '#F54E00'.color(), weight: FontWeight.w900),
                  SizedBox(height: 8.h),
                  SizedBox(
                    width: 0.width(context),
                    height: 122,
                    child: Row(
                      children: [
                        SizedBox(width: 38),
                        PSImg(name: 'ps_dui_iconsss', width: 27, height: 108),
                        SizedBox(width: 12),
                        Column(
                          children: [
                            SizedBox(height: 10),
                            SizedBox(width: 241, height: 19,child: PSText(text: 'Quiz passed', size: 15, color: '#24313F'.color(), weight: FontWeight.w900)),
                            SizedBox(height: 22),
                            SizedBox(width: 250, height: 19,child: PSText(text: 'Now confirm your payout info.', size: 15, color: '#A5A5A5'.color(), weight: FontWeight.w900)),
                            SizedBox(height: 14),
                            SizedBox(width: 250, height: 38,child: PSText(text: 'Fill Your Piggy Bank, Cash Out Instantly', size: 15, color: '#A5A5A5'.color(), weight: FontWeight.w900, maxLines: 2)),
                          ],
                        ) 
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  ParticleButton(
                    onTap: () {
                      Navigator.pop(context, 0);
                      ps_event_fire('new_confirm_account_pop_c', {});
                      PSGuideManager.nextStep(context);
                    },
                    child: Container(
                      width: 301,
                      height: 50,
                      decoration: BoxDecoration(
                        color: '#0E79C6'.color(),
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: Center(
                        child: PSStrokeText(
                          text: 'Confirm Now',
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
            SizedBox(height: 16.h),
            ParticleButton(child: SizedBox(width: 40,height: 40,child: Center(child: PSImg(name: 'ps_whine_close', width: 18, height: 18 , fit: BoxFit.fill,))), onTap: (){
              Navigator.pop(context, 0);
              PSGuideManager.nextStep(context);
            })
          ]
         )
      ),
    );
  }
}


class PSGuideNew10Dialog extends StatefulWidget {
  final bool showToast;
  const PSGuideNew10Dialog({super.key, required this.showToast});

  @override
  State<PSGuideNew10Dialog> createState() => PSGuideNew10DialogState();
}

class PSGuideNew10DialogState extends State<PSGuideNew10Dialog> with TickerProviderStateMixin {

  int seletcd_row = 0;

  int email_row = 0;

  List<String> emails = ['Email', 'Phone', 'CPF', 'EVP'];

  final TextEditingController _controller = TextEditingController();

  final TextEditingController _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    ps_event_fire('input_account_page', {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          width: double.infinity,  // 容器宽度填充整个屏幕
          height: double.infinity, // 容器高度填充整个屏幕
          decoration: BoxDecoration(
            image: PSDImg('ps_tx_infos_bg')
          ),
          child: SingleChildScrollView(
            child: Column(
                children: [
                  SizedBox(height: 60.h),
                  Row(
                    children: [
                      SizedBox(width: 12,),
                      ParticleButton(child: SizedBox(width: 40, height:40, child: Center(child: PSImg(name: 'ps_back_white_icon', width: 12, height: 19))), onTap: (){
                        // Navigator.pop(context, 0);
                        PSDialogTool.toast(context, 'Please Input Your Account ID');
                      }),
                      SizedBox(width: 12),
                      PSText(text: 'Confirm Payment Information', size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w900)
                    ],
                  ),
                  SizedBox(height: 50.h),
                  Row(
                    children: [
                      SizedBox(width: 28.w),
                      PSText(text: 'Payment Method:', size: 16, color: '#3B5688'.color(), weight: FontWeight.w900),
                    ],
                  ),
                  SizedBox(height: 15.w),
                  Row(
                    children: [
                      SizedBox(width: 28.w),
                      ParticleButton(child: Container(width: 153.w, height: 58.h, decoration: BoxDecoration(
                        image: PSDImg(isBrazilianPortuguese(context) == true ? 'ps_act_0pt' : 'ps_act_0'),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          width: 2,
                          color: seletcd_row == 0 ? '#0077B3'.color() : Colors.transparent
                        )
                      )), onTap: (){
                          setState(() {
                            seletcd_row = 0;
                            PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_ing_accountName, 0);
                          });
                      }),
                      Spacer(),
                      ParticleButton(child: Container(width: 153.w, height: 58.h, decoration: BoxDecoration(
                          image: PSDImg(isBrazilianPortuguese(context) == true ? 'ps_act_1pt' : 'ps_act_1'),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                              width: 2,
                              color: seletcd_row == 1 ? '#0077B3'.color() : Colors.transparent
                          )
                      )), onTap: (){
                        setState(() {
                          seletcd_row = 1;
                          PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_ing_accountName, 1);
                        });
                      }),
                      SizedBox(width: 28.w),
                    ],
                  ),
                  if (isBrazilianPortuguese(context) == false)
                    SizedBox(height: 38.h),
                  if (isBrazilianPortuguese(context) == false)
                    Row(
                    children: [
                      SizedBox(width: 28.w),
                      PSText(text: 'Email/Phone number:', size: 16, color: '#3B5688'.color(), weight: FontWeight.w900),
                    ],
                  ),
                  if (isBrazilianPortuguese(context) == false)
                    SizedBox(height: 14.h),
                  if (isBrazilianPortuguese(context) == true)
                    SizedBox(height: 20.h),
                  Container(
                    width: 319.w,
                    height: 50.h,
                    decoration: BoxDecoration(
                      color: '#F0F8FA'.color(),
                      borderRadius: BorderRadius.circular(8.h),
                      border: Border.all(
                        color: '#ACC4C8'.color(),  // 边框颜色
                        width: 1,            // 边框宽度
                      ),
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: isBrazilianPortuguese(context) == false ? 'Please Input Your Account ID' : 'Name', // 占位符文案
                        hintStyle: TextStyle(
                            color: Color(0xFF949DA2), // 占位符文案颜色
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold
                        ),
                        border: InputBorder.none, // 移除默认边框
                      ),
                      style: TextStyle(
                        color: Color(0xFF000000), // 输入文字颜色
                        fontSize: 14.0,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (isBrazilianPortuguese(context) == true)
                    SizedBox(height: 28.h),
                  if (isBrazilianPortuguese(context) == true)
                    Row(
                      children: [
                        SizedBox(width: 28.w),
                        PSText(text: 'Account Type:', size: 16, color: '#3B5688'.color(), weight: FontWeight.w900),
                      ],
                    ),
                  if (isBrazilianPortuguese(context) == true)
                    SizedBox(height: 14.h),
                  if (isBrazilianPortuguese(context) == true)
                    Row(
                      mainAxisAlignment: .center,
                      children: [
                        SizedBox(width: 28.w),
                        ParticleButton(child: Container(
                            width: 75.w,
                            height: 37.h,
                            decoration: BoxDecoration(
                              color: email_row == 0 ? '#117EE3'.color() : '#A2A2A2'.color(),
                              borderRadius: BorderRadius.circular(8.h)
                            ),
                           child: Center(
                               child: PSText(text: emails[0], size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                            ),
                         ), onTap: (){
                          setState(() {
                            email_row = 0;
                          });
                        }),
                        SizedBox(width: 6.w),
                        ParticleButton(child: Container(
                          width: 75.w,
                          height: 37.h,
                          decoration: BoxDecoration(
                              color: email_row == 1 ? '#117EE3'.color() : '#A2A2A2'.color(),
                              borderRadius: BorderRadius.circular(8.h)
                          ),
                          child: Center(
                            child: PSText(text: emails[1], size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                          ),
                        ), onTap: (){
                          setState(() {
                            email_row = 1;
                          });
                        }),
                        SizedBox(width: 6.w),
                        ParticleButton(child: Container(
                          width: 75.w,
                          height: 37.h,
                          decoration: BoxDecoration(
                              color: email_row == 2 ? '#117EE3'.color() : '#A2A2A2'.color(),
                              borderRadius: BorderRadius.circular(8.h)
                          ),
                          child: Center(
                            child: PSText(text: emails[2], size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                          ),
                        ), onTap: (){
                          setState(() {
                            email_row = 2;
                          });
                        }),
                        SizedBox(width: 6.w),
                        ParticleButton(child: Container(
                          width: 75.w,
                          height: 37.h,
                          decoration: BoxDecoration(
                              color: email_row == 3 ? '#117EE3'.color() : '#A2A2A2'.color(),
                              borderRadius: BorderRadius.circular(8.h)
                          ),
                          child: Center(
                            child: PSText(text: emails[3], size: 14, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                          ),
                        ), onTap: (){
                          setState(() {
                            email_row = 3;
                          });
                        }),
                        SizedBox(width: 28.w)
                      ],
                    ),
                  if (isBrazilianPortuguese(context) == true)
                    SizedBox(height: 28.h),
                  if (isBrazilianPortuguese(context) == true)
                    Row(
                      children: [
                        SizedBox(width: 28.w),
                        PSText(text: 'Email/Phone number:', size: 16, color: '#3B5688'.color(), weight: FontWeight.w900),
                      ],
                    ),
                  if (isBrazilianPortuguese(context) == true)
                    SizedBox(height: 14.h),
                  if (isBrazilianPortuguese(context) == true)
                    Container(
                      width: 319.w,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: '#F0F8FA'.color(),
                        borderRadius: BorderRadius.circular(8.h),
                        border: Border.all(
                          color: '#ACC4C8'.color(),  // 边框颜色
                          width: 1,            // 边框宽度
                        ),
                      ),
                      child: TextField(
                        controller: _controller2,
                        decoration: InputDecoration(
                          hintText: 'Please Input Your Account ID', // 占位符文案
                          hintStyle: TextStyle(
                              color: Color(0xFF949DA2), // 占位符文案颜色
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                          border: InputBorder.none, // 移除默认边框
                        ),
                        style: TextStyle(
                          color: Color(0xFF000000), // 输入文字颜色
                          fontSize: 14.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  if (isBrazilianPortuguese(context) == true)
                    SizedBox(height: 36.h),
                  if (isBrazilianPortuguese(context) == false)
                    SizedBox(height: 194.h),
                  Row(
                    children: [
                      SizedBox(width: 49.w),
                      PSImg(name: 'ps_Sectiy_icon', width: 29, height: 29),
                      SizedBox(width: 8.w),
                      PSText(text: 'We’ll only use this for sending your withdrawal', size: 10, color: '#566D7E'.color(), weight: FontWeight.w900)
                    ],
                  ),
                  SizedBox(height: 35.h),
                  ParticleButton(child: Container(
                    width: 319.w,
                    height: 55.h,
                    decoration: BoxDecoration(
                      color: '#0E79C6'.color(),
                      borderRadius: BorderRadius.circular(28.h)
                    ),
                    child: Center(
                      child: PSText(text: 'Confrim', size: 20, color: '#FFFFFF'.color(), weight: FontWeight.w900),
                    ),
                  ), onTap: (){
                    ps_event_fire('input_account_page_c', {});
                    if (isBrazilianPortuguese(context) == true) {
                      if (_controller.text.length <= 0){
                        PSDialogTool.toast(context, 'Please Input Your Name');
                      } else if (_controller2.text.length <= 0){
                        PSDialogTool.toast(context, 'Please Input Your Account ID');
                      } else {
                        Navigator.pop(context, 1);
                        if (widget.showToast){
                          context.tipShow(PSConfimOneDialog(isConfim: true, contentStr: 'Payout details confirmed.\nQuiz to release your ${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first} cash out.',));
                        } else {
                          PSLocalProvider.instance.updateString(PSLocalProvider.instance.ps_account_idName, _controller2.text);
                          Future.delayed(Duration(milliseconds: 100), () async {
                            PSGuideManager.nextStep(homeKey.currentContext!);
                          }); 
                        }
                      }
                    } else {
                      if (_controller.text.length <= 0){
                        PSDialogTool.toast(context, isBrazilianPortuguese(context) == false ? 'Please Input Your Account ID' : 'Please Input Your Name');
                      } else {
                        PSLocalProvider.instance.updateString(PSLocalProvider.instance.ps_account_idName, _controller.text);
                        Navigator.pop(context, 1);
                        if (widget.showToast){
                          context.tipShow(PSConfimOneDialog(isConfim: true, contentStr: 'Payout details confirmed.\nQuiz to release your ${0.dolasType()}${PSNumberHelpers().intModel!.eqRange.first} cash out.',));
                        } else {
                          Future.delayed(Duration(milliseconds: 100), () async {
                            PSGuideManager.nextStep(homeKey.currentContext!);
                          }); 
                        }
                      }

                    }
                  }),
                ]
            ),
          )
      ),
    );
  }

  bool isBrazilianPortuguese(BuildContext context) {
    // 获取当前语言环境
    Locale currentLocale = Localizations.localeOf(context);

    // 判断是否是巴西葡萄牙语
    return currentLocale.languageCode == 'pt' || currentLocale.countryCode == 'BR';
  }
}

class PSGuideNew11Dialog extends StatefulWidget {
  const PSGuideNew11Dialog({super.key});

  @override
  State<PSGuideNew11Dialog> createState() => PSGuideNew11DialogState();
}

class PSGuideNew11DialogState extends State<PSGuideNew11Dialog> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    ps_event_fire('account_suc_pop', {});

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
          width: double.infinity,  // 容器宽度填充整个屏幕
          height: double.infinity, // 容器高度填充整个屏幕
          color: Colors.transparent,
          child: Stack(
            children: [
              Positioned(
                left: (0.width(context) - 277.w) * 0.5,
                top: (0.height(context) - 357.h) * 0.5,
                child: Column(
                    children: [
                      Container(
                        width: 277.w,
                        height: 357.h,
                        decoration: BoxDecoration(
                            image: PSDImg('ps_tx_info_bg')
                        ),
                        child: Column(
                          children: [
                            SizedBox(height: 56.h),
                            PSText(text: 'Official Notice', size: 16, color: '#134475'.color(), weight: FontWeight.w900),
                            SizedBox(height: 18.h),
                            SizedBox(
                              width: 227,
                              height: 76,
                              child: RichText(
                                textAlign: TextAlign.left,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w900,
                                    color: '#576479'.color(),
                                    fontFamily: 'Black_mianfeiziti',
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(text: 'Dear User ${PSLocalProvider.instance.ps_account_id}：\n',
                                        style: TextStyle(color: '#134475'.color(), fontSize: 14.0)),
                                    TextSpan(text: 'Your payment information has\nbeen confirmed successfully,\nYou are a new user, it will be\nsuper easy to withdraw cash today！'),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 18.h),
                            Container(
                              width: 239,
                              height: 84,
                              decoration: BoxDecoration(
                                image: PSDImg('ps_notice_center_bg')
                              ),
                              child: Column(
                                children: [
                                  SizedBox(height: 12),
                                  RichText(
                                    textAlign: TextAlign.left,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w900,
                                        color: '#122C5B'.color(),
                                        fontFamily: 'Black_mianfeiziti',
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(text: 'Only '),
                                        TextSpan(text: '${0.dolasType()}${0.to2Double(PSNumberHelpers().intModel!.eqRange.first - PSLocalProvider.instance.ps_dolas_number)} ',
                                            style: TextStyle(color: '#199D28'.color(), fontSize: 14.0)),
                                        TextSpan(text: 'Left To Withdraw'),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 11),
                                  PSText(text: 'Want to stack up more cash?\nKeep earning now!', size: 12, color: '#E34C06'.color(), weight: FontWeight.w900, maxLines: 2, align: .center)
                                ],
                              ),
                            ),
                            SizedBox(height: 15.h),
                            ParticleButton(
                              onTap: () {
                                Navigator.pop(context, 0);
                                ps_event_fire('account_suc_pop_c', {});
                                PSGuideManager.nextStep(context);
                              },
                              child: Container(
                                width: 239.w,
                                height: 50.h,
                                decoration: BoxDecoration(
                                    color: '#0E79C6'.color(),
                                    borderRadius: BorderRadius.circular(25)
                                ),
                                child: Center(
                                  child: PSStrokeText(
                                    text: 'Confrim',
                                    size: 20,
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

                    ]
                ),
              ),
              Positioned(left: (0.width(context) - 87) * 0.5,top: 184.h,child: PSImg(name: 'ps_notice_big_icon', width: 87, height: 87,))
            ],
          ) 
      ),
    );
  }
}

class PSGuideNew12Dialog extends StatefulWidget {
  final bool is_old;
  const PSGuideNew12Dialog({super.key, required this.is_old});

  @override
  State<PSGuideNew12Dialog> createState() => PSGuideNew12DialogState();
}

class PSGuideNew12DialogState extends State<PSGuideNew12Dialog> with TickerProviderStateMixin {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  bool open_notice = true;

  @override
  void initState() {
    super.initState();
    updatenoticeStatus();
    ps_event_fire('grow_bonus_pop', {'pop_from' : widget.is_old ? 'old' : 'new'});
  }

  Future<void> updatenoticeStatus() async {
    var nfPermission = await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
    if(nfPermission??false){
      open_notice = true;
    }else{
      open_notice = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: .center,
        children: [
          Row(
            children: [
              Spacer(),
              ParticleButton(child: PSImg(name: 'ps_close_icon', width: 48, height: 48), onTap: (){
                ps_event_fire('grow_bonus_pop_c', {'pop_from' : widget.is_old ? 'old' : 'new'});
                Navigator.pop(context, 0);
                PSGuideManager.nextStep(context);
              }),
              SizedBox(width: 27.w)
            ],
          ),
          SizedBox(height: 20.h),
          Container(
            width: 335,
            height: 478,
            decoration: BoxDecoration(
              image: PSDImg('ps_grow_bg')
            ),
            child: Column(
              children: [
                SizedBox(height: 28),
                PSStrokeText(text: 'Grow Bonus Activated!', size: 24, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#1051A4'.color()),
                SizedBox(height: 42),
                PSImg(name: 'ps_pig_0', width: 111, height: 109,),
                SizedBox(height: 14),
                PSText(text: "You've saved ${0.dolasType()}${0.to2Double(PSLocalProvider.instance.ps_dolas_number)} Today", size: 18, color: '#EA8100'.color(), weight: FontWeight.w900),
                SizedBox(height: 25),
                PSText(text: '💡 Come back tomorrow to feed\nyour piggy again and\nget a +${PSLocalProvider.instance.add_olduser_point}% cash boost!', size: 16, color: '#134475'.color(), weight: FontWeight.w900, maxLines: 3, align: .center),
                SizedBox(height: 60),
                if (open_notice == true)
                 ParticleButton(
                  onTap: () async {
                    ps_event_fire('grow_bonus_pop_c', {'pop_from' : widget.is_old ? 'old' : 'new'});
                    if (widget.is_old == true) {
                      // 加钱
                      if (PSLocalProvider.instance.ps_pig_level == 0){
                        double award = 0.to2Double(PSLocalProvider.instance.ps_dolas_number * PSLocalProvider.instance.add_olduser_point);
                        PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_dolas_numberName, PSLocalProvider.instance.ps_dolas_number + award);
                        if (!context.mounted) return;
                        int code = await context.tipShow2(PSPoGetAwardDog(award: award),bc: Colors.transparent);
                        if (code >= 0){
                          Navigator.pop(context, 0);
                        }
                      } else {
                        double award = 0.to2Double(PSLocalProvider.instance.ps_pig_level_index * PSLocalProvider.instance.add_olduser_point);
                        PSLocalProvider.instance.updatedouble(PSLocalProvider.instance.ps_pig_level_indexName, PSLocalProvider.instance.ps_pig_level_index + award);
                        if (!context.mounted) return;
                        int code = await context.tipShow2(PSPoGetAwardDog(award: award),bc: Colors.transparent);
                        if (code >= 0){
                          Navigator.pop(context, 0);
                        }
                      }
                    } else {
                      Navigator.pop(context, 0);
                      PSGuideManager.nextStep(context);
                    }
                  },
                  child: Container(
                    width: 260.w,
                    height: 70.h,
                    decoration: BoxDecoration(
                        image: PSDImg('ps_quzi_btn_d')
                    ),
                    child: Center(
                      child: PSStrokeText(
                        text: 'Go Earn',
                        size: 24,
                        color: '#FFFFFF'.color(),
                        weight: FontWeight.w900,
                        skWidth: 2,
                        skColor: '#025003'.color(),
                      ),
                    ),
                  ),
                 ),
                if (open_notice == false)
                  ParticleButton(
                    onTap: () async {
                      ps_event_fire('grow_bonus_pop_c', {'pop_from' : widget.is_old ? 'old' : 'new'});
                      Navigator.pop(context, 0);
                      int code = await context.tipShow(PSPopTipsToolDialog(adStatus: .noticeOpen));
                      if (code >= 0){
                        PSGuideManager.nextStep(context);
                      }
                    },
                    child: Container(
                      width: 260.w,
                      height: 70.h,
                      decoration: BoxDecoration(
                          image: PSDImg('ps_quzi_btn_n')
                      ),
                      child: Center(
                        child: PSStrokeText(
                          text: 'Reminder Me',
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
      )
    );
  }
}


class PSGuideNew13Dialog extends StatefulWidget {
  const PSGuideNew13Dialog({super.key});

  @override
  State<PSGuideNew13Dialog> createState() => PSGuideNew13DialogState();
}

class PSGuideNew13DialogState extends State<PSGuideNew13Dialog> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: ParticleButton(
          onTap: (){
            Navigator.pop(context, 0);
            PigTabController.switchTo(2);
          },
          child: Stack(
            children: [
              Positioned(
                left: (0.width(context) - 335) * 0.5,
                bottom: 129.h,
                child: Container(
                  width: 335,
                  height: 139,
                  decoration: BoxDecoration(
                      image: PSDImg('ps_guide4_2')
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top: 38, left: 20, right: 12),
                    child: SizedBox(
                      width: 291,
                      height: 76,
                      child: RichText(
                        textAlign: TextAlign.left,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w900,
                            color: '#733A1B'.color(),
                            fontFamily: 'Black_mianfeiziti',
                          ),
                          children: <TextSpan>[
                            TextSpan(text: 'Want Higher Earnings?Spin the wheel to unlock up to '),
                            TextSpan(text: '${0.dolasType()}50 ',
                                style: TextStyle(color: '#0A8A33'.color(), fontSize: 16.0)),
                            TextSpan(text: 'interest bonus in your savings.More bonus, faster withdrawals!'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(left: 40, bottom: 238.h, child: PSImg(name: 'ps_guide4_1', width: 68, height: 68)),
              Positioned(left: 54, bottom: 298.h, child: PSImg(name: 'ps_guide4_0', width: 41, height: 35)),
              Positioned(right: 121.w, bottom: 80.h, child: PSImg(name: 'ps_guide4_3', width: 37, height: 46)),
              Positioned(right: 115.w, bottom: 16.h, child: PSImg(name: 'ps_wheel_icon', width: 49, height: 49)),
            ],
          ),
        )
    );
  }
}