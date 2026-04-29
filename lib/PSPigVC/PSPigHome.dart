import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_WebKitView.dart';
import 'package:piggywalletspinearn/PSTool/ps_text.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import 'package:piggywalletspinearn/PSTool/ps_img.dart';
import 'package:piggywalletspinearn/PSTool/ps_stroke_text.dart';
import 'package:provider/provider.dart';
import '../PSBase/PSTbaBar.dart';
import '../PSDialog/PSDialog.dart';
import '../PSGuide/PSGuideAThree.dart';
import '../PSTool/PSAdAManger.dart';
import '../PSTool/PSMarqueeText.dart';

final GlobalKey<_PSPigHomeState> homePigKey = GlobalKey<_PSPigHomeState>();

class PSPigHome extends StatefulWidget {
  const PSPigHome({super.key});

  @override
  State<PSPigHome> createState() => _PSPigHomeState();
}

class _PSPigHomeState extends State<PSPigHome> with TickerProviderStateMixin {
  late AnimationController _controller;

  // 六个按钮单独动画控制器
  late List<AnimationController> _buttonControllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _scaleAnimations;

  final int itemCount = 97;
  List<String> names = [
    'Everyday Trivia',
    'Chill Time Quiz',
    'Brain Teasers',
    'Warm-Up Quiz',
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _controller.forward();

    // 初始化 6 个按钮的动画
    _buttonControllers = List.generate(6, (index) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
    });

    _fadeAnimations = _buttonControllers
        .map(
          (ctrl) => Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.easeIn)),
    )
        .toList();

    _scaleAnimations = _buttonControllers
        .map(
          (ctrl) => Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(parent: ctrl, curve: Curves.elasticOut)),
    )
        .toList();

    // 依次延迟 200ms 播放动画
    for (int i = 0; i < _buttonControllers.length; i++) {
      Timer(Duration(milliseconds: 300 * i), () {
        if (mounted) _buttonControllers[i].forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var ctrl in _buttonControllers) {
      ctrl.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 原来的背景、列表、顶部进度条等保持不变
          Container(
            width: 0.width(context),
            height: 0.height(context),
            decoration: BoxDecoration(image: PSDImg('ps_pig_home_bg')),
            child: Stack(
              children: [
                Positioned(bottom: 0,child: PSImg(name: 'ps_pig_home_bottom', width: 0.width(context), height: 338.h)),
                Column(
                  children: [
                    SizedBox(height: 44.h),
                    PigblancePage(),
                    SizedBox(height:288.h),
                    // ListView 列表
                    SizedBox(
                      width: 0.width(context),
                      height: 277.h,
                      child: CustomScrollView(
                        slivers: [
                          // Sliver for the header (TableViewHeaderView)
                          SliverToBoxAdapter(
                            child: Container(
                              width: 364,
                              height: 184,
                              decoration: BoxDecoration(
                                image: PSDImg('ps_pig_user_top_bg')
                              ),
                              child: Stack(
                                children: [
                                  Positioned(right: 14,top: 24,child: PSImg(name: 'ps_pig_2', width: 33, height: 33)),
                                  Positioned(left: 14,top: 24,child: PSImg(name: 'ps_pig_2', width: 33, height: 33)),
                                  Positioned(right: 124,top: 12,child: PSImg(name: 'ps_pig_2', width: 33, height: 33)),
                                  Positioned(left: 48,top: 64,child: PSImg(name: 'ps_user_icon_0', width: 31, height: 31)),
                                  Positioned(right: 48,top: 64,child: PSImg(name: 'ps_user_icon_1', width: 31, height: 31)),
                                  Positioned(left: 154,top: 48,child: PSImg(name: 'ps_user_icon_0', width: 49, height: 49)),
                                  Positioned(left: 24,top: 98,child: PSStrokeText(text: '**User **48 (Texas)', size: 8, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#2C4862'.color())),
                                  Positioned(right: 24,top: 98,child: PSStrokeText(text: '**User **48 (Texas)', size: 8, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#2C4862'.color())),
                                  Positioned(left: 138,top: 98,child: PSStrokeText(text: '**User **48 (Texas)', size: 8, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 1, skColor: '#2C4862'.color())),
                                  Positioned(left: 24,top: 108,child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Black_mianfeiziti',
                                        color: '#264564'.color(),
                                      ),
                                      children: [
                                        TextSpan(text: 'Total earning：'),
                                        TextSpan(
                                          text: '\$10',
                                          style: TextStyle(color: '#FFFFFF'.color(), fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),),
                                  Positioned(right: 24,top: 108,child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Black_mianfeiziti',
                                        color: '#264564'.color(),
                                      ),
                                      children: [
                                        TextSpan(text: 'Total earning：'),
                                        TextSpan(
                                          text: '\$10',
                                          style: TextStyle(color: '#FFFFFF'.color(), fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),),
                                  Positioned(left: 138,top: 108,child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Black_mianfeiziti',
                                        color: '#264564'.color(),
                                      ),
                                      children: [
                                        TextSpan(text: 'Total earning：'),
                                        TextSpan(
                                          text: '\$10',
                                          style: TextStyle(color: '#FFFFFF'.color(), fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),),
                                  Positioned(left: 24,top: 120,child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Black_mianfeiziti',
                                        color: '#264564'.color(),
                                      ),
                                      children: [
                                        TextSpan(text: 'Ads watched：'),
                                        TextSpan(
                                          text: '50',
                                          style: TextStyle(color: '#FFFFFF'.color(), fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),),
                                  Positioned(right: 24,top: 120,child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Black_mianfeiziti',
                                        color: '#264564'.color(),
                                      ),
                                      children: [
                                        TextSpan(text: 'Ads watched：'),
                                        TextSpan(
                                          text: '50',
                                          style: TextStyle(color: '#FFFFFF'.color(), fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),),
                                  Positioned(left: 140,top: 120,child: RichText(
                                    textAlign: TextAlign.center,
                                    text: TextSpan(
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.w500,
                                        fontFamily: 'Black_mianfeiziti',
                                        color: '#264564'.color(),
                                      ),
                                      children: [
                                        TextSpan(text: 'Ads watched：'),
                                        TextSpan(
                                          text: '50',
                                          style: TextStyle(color: '#FFFFFF'.color(), fontSize: 9),
                                        ),
                                      ],
                                    ),
                                  ),),
                                  Positioned(left: 28,top: 136,child: Container(
                                    width: 71,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      image: PSDImg('ps_show_pig_b')
                                    ),
                                  ),),
                                  Positioned(right: 28,top: 136,child: Container(
                                    width: 71,
                                    height: 22,
                                    decoration: BoxDecoration(
                                        image: PSDImg('ps_show_pig_b')
                                    ),
                                  ),),
                                  Positioned(left: 144,top: 136,child: Container(
                                    width: 71,
                                    height: 22,
                                    decoration: BoxDecoration(
                                        image: PSDImg('ps_show_pig_b')
                                    ),
                                  ),),
                                ],
                              ),
                            ),
                          ),
                          // SliverList for the ListView with animation
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                                  (context, index) {
                                return SlideTransition(
                                  position: Tween<Offset>(
                                    begin: const Offset(-1.2, 0),
                                    end: Offset.zero,
                                  ).animate(
                                    CurvedAnimation(
                                      parent: _controller,
                                      curve: Interval(
                                        index * 0.15,
                                        (index * 0.15 + 0.6).clamp(0.0, 1.0),
                                        curve: Curves.easeOutBack,
                                      ),
                                    ),
                                  ),
                                  child: Container(
                                    height: 73,
                                    margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      image: PSDImg('ps_home_list_bg'),
                                    ),
                                    child: GestureDetector(
                                      onTap: () {
                                       context.tipShow(PSdolls100Dialog());
                                      },
                                      child: Stack(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(width: 18,),
                                              PSStrokeText(text: "${4 + index}", size: 16, color: '#FFFFFF'.color(), weight: FontWeight.w900, skWidth: 2, skColor: '#4B030E'.color()),
                                              SizedBox(width: 12),
                                              PSImg(name: 'ps_user_icon_0', width: 49, height: 49),
                                              SizedBox(
                                                width: 120,
                                                height: 66,
                                                child: Column(
                                                  children: [
                                                    SizedBox(height: 12),
                                                    PSText(text: '**User **48 (Texas)', size: 12, color: '#0C3D8C'.color(), weight: FontWeight.w900),
                                                    SizedBox(height: 6),
                                                    RichText(
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: 'Black_mianfeiziti',
                                                          color: '#873709'.color(),
                                                        ),
                                                        children: [
                                                          TextSpan(text: 'Total earning：'),
                                                          TextSpan(
                                                            text: '\$10',
                                                            style: TextStyle(color: '#0B7C1C'.color(), fontSize: 10),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    RichText(
                                                      textAlign: TextAlign.center,
                                                      text: TextSpan(
                                                        style: TextStyle(
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w500,
                                                          fontFamily: 'Black_mianfeiziti',
                                                          color: '#873709'.color(),
                                                        ),
                                                        children: [
                                                          TextSpan(text: 'Ads watched：'),
                                                          TextSpan(
                                                            text: '60',
                                                            style: TextStyle(color: '#7212CC'.color(), fontSize: 10),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Spacer(),
                                              Container(
                                                width: 74,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                  image: PSDImg('ps_show_pig_b')
                                                ),
                                              ),
                                              SizedBox(width: 28)
                                            ],
                                          ),
                                          Positioned(right: 16,top: 4,child: PSImg(name: 'ps_pig_2', width: 33, height: 33)),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              childCount: itemCount,
                            ),
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              ],
            ),
          ),
          /// =================== 6 个按钮渐显 + 缩放 ===================
          Consumer<PSLocalProvider>(
            builder: (context, provider, child) {
              return Positioned(
                left: (0.width(context) - 211) * 0.5,
                top: 148.h,
                child: PSImg(name: provider.ps_pig_level <= 1 ? 'ps_b_pig_icon_${provider.ps_pig_level}' : 'ps_b_pig_icon_2', width: 211, height: 208),
              );
            },
          ),
          Positioned(top: 330.h, left: (0.width(context) - 141) * 0.53,child: Container(
            width: 141,
            height: 34,
            decoration: BoxDecoration(
              image: PSDImg('ps_act_bg')

            ),
            child: Row(
              mainAxisAlignment: .center,
              children: [
                PSImg(name: 'ps_dolas_2', width: 26, height: 21),
                SizedBox(width: 5,),
                PSText(text: '\$158.00', size: 20, color: '#8B0002'.color(), weight: FontWeight.w900)
              ],
            ),
          )),
          Positioned(top: 368.h,left: (0.width(context) - 328.w) * 0.5,child: Container(
            width: 328.w, height:30.h,
            decoration: BoxDecoration(
                image: PSDImg('ps_pao_bg')
            ),
            child: Center(
              child: PSMarqueeText()
            ),
          )),
          Positioned(
            right: 50.w,
            top: 160.h,
            width: 60.44,
            height: 60.2,
            child: FadeTransition(
              opacity: _fadeAnimations[0],
              child: ScaleTransition(
                scale: _scaleAnimations[0],
                child: ParticleButton(
                  onTap: () {
                    PSAdAHelper().show(
                      context,
                          (hasCache) {
                        if (!hasCache){
                          PSAdAHelper().resetBlock();
                        }
                      },
                          (finished) async {
                        // X2
                        await PSLocalProvider.instance.updateint(
                          PSLocalProvider.instance.ps_pig_level_indexName,
                          PSLocalProvider.instance.ps_pig_level_index + 2,
                        );
                        if (PSLocalProvider.instance.ps_pig_level == 0 && PSLocalProvider.instance.ps_pig_level_index >= 20){
                          await PSLocalProvider.instance.updateint(
                            PSLocalProvider.instance.ps_pig_level_indexName,
                            0,
                          );
                          await PSLocalProvider.instance.updateint(
                            PSLocalProvider.instance.ps_pig_levelName,
                            1,
                          );
                        } else if (PSLocalProvider.instance.ps_pig_level == 1 && PSLocalProvider.instance.ps_pig_level_index >= 10){
                          await PSLocalProvider.instance.updateint(
                            PSLocalProvider.instance.ps_pig_level_indexName,
                            10,
                          );
                          await PSLocalProvider.instance.updateint(
                            PSLocalProvider.instance.ps_pig_levelName,
                            2,
                          );
                        }
                        PSAdAHelper().resetBlock();
                      },
                    );
                  },
                  child: Stack(
                    children: [
                      PSBouncyImage(
                        imagePath: 'ps_apple_bubble',
                        width: 60.44,
                        height: 60.2,
                        enableAnimation: true,
                      ),
                      Positioned(
                        top: -8,
                        right: -4,
                        child: PSBouncyImage(
                          imagePath: 'ps_ad_icon',
                          width: 37,
                          height: 40,
                          enableAnimation: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 50.w,
            top: 160.h,
            child: FadeTransition(
              opacity: _fadeAnimations[1],
              child: ScaleTransition(
                scale: _scaleAnimations[1],
                child: ParticleButton(
                  onTap: () {
                    context.tipShowAdvanced(PSPopDomandAwardADialog());
                  },
                  child: Stack(
                    children: [
                      Consumer<PSLocalProvider>(
                        builder: (context, provider, child) {
                          return PSBouncyImage(
                            imagePath: provider.ps_pig_level == 0 ? 'ps_domand_bubble' : 'ps_zhuan_bubble',
                            width: 60.44,
                            height: 60.2,
                            enableAnimation: true,
                          );
                        },
                      ),
                      Positioned(
                        left: 20,
                        bottom: 0,
                        child: PSStrokeText(
                          text: 'X2',
                          size: 20,
                          color: '#FFFDE1'.color(),
                          weight: FontWeight.w900,
                          skWidth: 2,
                          skColor: '#5F2605'.color(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 12.w,
            top: 220.h,
            child: FadeTransition(
              opacity: _fadeAnimations[2],
              child: ScaleTransition(
                scale: _scaleAnimations[2],
                child: ParticleButton(
                  onTap: () {
                    context.tipShowAdvanced(PSPopDomandAwardADialog());
                  },
                  child: Stack(
                    children: [
                      Consumer<PSLocalProvider>(
                        builder: (context, provider, child) {
                          return PSBouncyImage(
                            imagePath: provider.ps_pig_level == 0 ? 'ps_domand_bubble' : 'ps_zhuan_bubble',
                            width: 60.44,
                            height: 60.2,
                            enableAnimation: true,
                          );
                        },
                      ),
                      Positioned(
                        left: 20,
                        bottom: 0,
                        child: PSStrokeText(
                          text: 'X2',
                          size: 20,
                          color: '#FFFDE1'.color(),
                          weight: FontWeight.w900,
                          skWidth: 2,
                          skColor: '#5F2605'.color(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 12.w,
            top: 220.h,
            child: FadeTransition(
              opacity: _fadeAnimations[3],
              child: ScaleTransition(
                scale: _scaleAnimations[3],
                child: ParticleButton(
                  onTap: () {
                    context.tipShowAdvanced(PSPopDomandAwardADialog());
                  },
                  child: Stack(
                    children: [
                      Consumer<PSLocalProvider>(
                        builder: (context, provider, child) {
                          return PSBouncyImage(
                            imagePath: provider.ps_pig_level == 0 ? 'ps_domand_bubble' : 'ps_zhuan_bubble',
                            width: 60.44,
                            height: 60.2,
                            enableAnimation: true,
                          );
                        },
                      ),
                      Positioned(
                        left: 20,
                        bottom: 0,
                        child: PSStrokeText(
                          text: 'X2',
                          size: 20,
                          color: '#FFFDE1'.color(),
                          weight: FontWeight.w900,
                          skWidth: 2,
                          skColor: '#5F2605'.color(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 40.w,
            top: 290.h,
            child: FadeTransition(
              opacity: _fadeAnimations[4],
              child: ScaleTransition(
                scale: _scaleAnimations[4],
                child: ParticleButton(
                  onTap: () {
                    PigTabController.switchTo(1);
                  },
                  child: PSBouncyImage(
                    imagePath: 'ps_quiz_bubble',
                    width: 60.44,
                    height: 60.2,
                    enableAnimation: true,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 40.w,
            top: 290.h,
            child: FadeTransition(
              opacity: _fadeAnimations[5],
              child: ScaleTransition(
                scale: _scaleAnimations[5],
                child: ParticleButton(
                  onTap: () {
                    PigTabController.switchTo(2);
                  },
                  child: PSBouncyImage(
                    imagePath: 'ps_wheel_bubble',
                    width: 60.44,
                    height: 60.2,
                    enableAnimation: true,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0.w,
            top: 380.h,
            width: 50,
            height: 50,
            child: ParticleButton(
              child: Center(
                child: PSImg(name: 'ps_privary_icon', width: 20, height: 20),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (builder) {
                      return PSWebkitview(
                        url: "https://sites.google.com/view/piggywallet-pp/home",
                        title: 'Privacy Policy',
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
class PigblancePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<PSLocalProvider>(
      builder: (context, provider, child) {
        return Container(
          width: 349,
          height: 119,
          decoration: BoxDecoration(
            image: PSDImg('ps_t_center_bg'),
          ),
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
                right: 32,
                top: 17,
                child: Container(
                  width: 118,
                  height: 29,
                  decoration: BoxDecoration(image: PSDImg('ps_wtd_btn')),
                  child: InkWell(
                    onTap: () {
                      PigTabController.switchTo(3);
                    },
                    child: Center(
                      child: PSStrokeText(
                        text: 'Withdraw',
                        size: 12,
                        color: '#FFFFFF'.color(),
                        weight: FontWeight.w900,
                        skWidth: 1,
                        skColor: '#025003'.color(),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 28,
                left: 32,
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Black_mianfeiziti',
                      color: '#873709'.color(),
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'Growing Balance: '),
                      TextSpan(
                        text: '\$100', // Static or dynamic value based on the provider data
                        style: TextStyle(color: '#0BA408'.color(), fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 21.5,
                left: 32,
                child: Stack(
                  children: [
                    // 👇 First Layer: Stroke
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Black_mianfeiziti',
                          foreground: Paint()
                            ..style = PaintingStyle.stroke
                            ..strokeWidth = 1
                            ..color = '#042267'.color(),
                        ),
                        children: [
                          TextSpan(text: 'Only '),
                          TextSpan(text: '\$0.9'), // Static or dynamic based on provider
                          TextSpan(text: ' Left To Withdraw '),
                          TextSpan(text: '\$100'), // Static or dynamic based on provider
                        ],
                      ),
                    ),
                    // 👇 Second Layer: Normal Fill
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Black_mianfeiziti',
                          color: '#FFFFFF'.color(),
                        ),
                        children: [
                          TextSpan(text: 'Only '),
                          TextSpan(
                            text: '\$0.9', // Static or dynamic based on provider
                            style: TextStyle(color: '#FFE711'.color(), fontSize: 12),
                          ),
                          TextSpan(text: ' Left To Withdraw '),
                          TextSpan(
                            text: '\$100', // Static or dynamic based on provider
                            style: TextStyle(color: '#FFE711'.color(), fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 30,
                top: 52,
                child: SizedBox(
                  width: 292,
                  height: 30,
                  child: Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        width: 292,
                        height: 30,
                        decoration: BoxDecoration(image: PSDImg('ps_pro_bg_t')),
                      ),
                      Positioned(
                        left: 7,
                        child: Container(
                          width: 278 * (provider.ps_dolas_number / 100), // Use provider data
                          height: 18,
                          decoration: BoxDecoration(
                            color: '#39B101'.color(),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 38,
                child: Container(
                  width: 39,
                  height: 29,
                  decoration: BoxDecoration(image: PSDImg('ps_dolas_1')),
                  child: Column(
                    children: [
                      Spacer(),
                      PSStrokeText(
                        text: '\$100', // Static or dynamic value based on provider data
                        size: 12,
                        color: '#FFE711'.color(),
                        weight: FontWeight.w900,
                        skWidth: 1,
                        skColor: '#04226'.color(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
