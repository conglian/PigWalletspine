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

final GlobalKey<_PSHomeState> homeKey = GlobalKey<_PSHomeState>();

class PSHome extends StatefulWidget {
  const PSHome({super.key});

  @override
  State<PSHome> createState() => _PSHomeState();
}

class _PSHomeState extends State<PSHome> with TickerProviderStateMixin {
  late AnimationController _controller;

  // 六个按钮单独动画控制器
  late List<AnimationController> _buttonControllers;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<double>> _scaleAnimations;

  final int itemCount = 4;
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
            height: 0.height(context) - 81,
            decoration: BoxDecoration(image: PSDImg('ps_home_bg')),
            child: Column(
              children: [
                SizedBox(height: 44.h),
                Consumer<PSLocalProvider>(
                  builder: (context, provider, child) {
                    return // 中心进度条区域
                    Container(
                      width: 349,
                      height: 119,
                      decoration: BoxDecoration(
                        image: PSDImg('ps_t_center_bg'),
                      ),
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
                                  const TextSpan(text: 'Energy Point: '),
                                  TextSpan(
                                    text: provider.ps_pig_level == 0
                                        ? '20'
                                        : '10',
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
                                      width:
                                          278 *
                                          (provider.ps_pig_level_index /
                                              (provider.ps_pig_level == 0
                                                  ? 20
                                                  : 10)),
                                      height: 20,
                                      decoration: BoxDecoration(
                                        color: '#80F207'.color(),
                                        borderRadius: BorderRadius.circular(10),
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
                              text:
                                  '${provider.ps_pig_level_index}/${provider.ps_pig_level == 0 ? '20' : '10'}',
                              size: 18,
                              color: '#FFFFFF'.color(),
                              weight: FontWeight.w900,
                              skWidth: 1,
                              skColor: '#042267'.color(),
                            ),
                          ),
                          Positioned(
                            left: 200,
                            top: provider.ps_pig_level == 0 ? 58 : 62,
                            child: PSImg(
                              name: provider.ps_pig_level == 0 ? 'ps_domand_s' : 'ps_zhuan_smail',
                              width: provider.ps_pig_level == 0 ? 18 : 13,
                              height: provider.ps_pig_level == 0 ? 17 : 11,
                            ),
                          ),
                          Positioned(
                            left: 20,
                            top: 40,
                            child: PSImg(
                              name: provider.ps_pig_level == 0
                                  ? 'ps_pig_1'
                                  : 'ps_pig_3',
                              width: 47,
                              height: 47,
                            ),
                          ),
                          Positioned(
                            right: 20,
                            top: 40,
                            child: PSImg(
                              name: provider.ps_pig_level == 0
                                  ? 'ps_pig_3'
                                  : 'ps_pig_2',
                              width: 47,
                              height: 47,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 194.h),
                Container(
                  width: 0.width(context),
                  height: 80,
                  decoration: BoxDecoration(image: PSDImg('ps_home_center_bg')),
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: PSImg(
                        name: 'ps_model_icon',
                        width: 128,
                        height: 28,
                      ),
                    ),
                  ),
                ),
                // ListView 列表
                SizedBox(
                  width: 0.width(context),
                  height: 290.h,
                  child: ListView.separated(
                    padding: EdgeInsets.zero,
                    itemCount: itemCount,
                    separatorBuilder: (_, __) => SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      return SlideTransition(
                        position:
                            Tween<Offset>(
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
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            image: PSDImg('ps_home_list_bg'),
                          ),
                          child: ParticleButton(
                            onTap: () async {
                              if (index == 0) {
                                await PSLocalProvider.instance.updateint(
                                  PSLocalProvider
                                      .instance
                                      .ps_quiz_num_indexName,
                                  0,
                                );
                                await PSLocalProvider.instance.updateint(
                                  PSLocalProvider
                                      .instance
                                      .ps_quiz_model_indexName,
                                  1,
                                );
                                PSPigQuizUpdateNotificationService.sendToDomandNumberNotification(
                                  0,
                                );
                                PigTabController.switchTo(1);
                              } else if (index == 1) {
                                await PSLocalProvider.instance.updateint(
                                  PSLocalProvider
                                      .instance
                                      .ps_quiz_num_indexName,
                                  0,
                                );
                                await PSLocalProvider.instance.updateint(
                                  PSLocalProvider
                                      .instance
                                      .ps_quiz_model_indexName,
                                  2,
                                );
                                PSPigQuizUpdateNotificationService.sendToDomandNumberNotification(
                                  0,
                                );
                                PigTabController.switchTo(1);
                              } else if (index == 2) {
                                await PSLocalProvider.instance.updateint(
                                  PSLocalProvider
                                      .instance
                                      .ps_quiz_num_indexName,
                                  0,
                                );
                                await PSLocalProvider.instance.updateint(
                                  PSLocalProvider
                                      .instance
                                      .ps_quiz_model_indexName,
                                  3,
                                );
                                PSPigQuizUpdateNotificationService.sendToDomandNumberNotification(
                                  0,
                                );
                                PigTabController.switchTo(1);
                              } else if (index == 3) {
                                await PSLocalProvider.instance.updateint(
                                  PSLocalProvider
                                      .instance
                                      .ps_quiz_num_indexName,
                                  0,
                                );
                                await PSLocalProvider.instance.updateint(
                                  PSLocalProvider
                                      .instance
                                      .ps_quiz_model_indexName,
                                  0,
                                );
                                PSPigQuizUpdateNotificationService.sendToDomandNumberNotification(
                                  0,
                                );
                                PigTabController.switchTo(1);
                              }
                            },
                            child: Stack(
                              children: [
                                Positioned(
                                  left: 24,
                                  top: 9,
                                  child: PSImg(
                                    name: 'ps_home_list_$index',
                                    width: 45,
                                    height: 51,
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                Positioned(
                                  left: 88,
                                  top: 24,
                                  child: PSText(
                                    text: names[index],
                                    size: 20,
                                    color: '#873709'.color(),
                                    weight: FontWeight.w900,
                                  ),
                                ),
                                Positioned(
                                  right: 33,
                                  top: 24,
                                  child: PSImg(
                                    name: 'ps_quiz_arrow',
                                    width: 31,
                                    height: 25,
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
              ],
            ),
          ),

          /// =================== 6 个按钮渐显 + 缩放 ===================
          Positioned(
            left: (0.width(context) - 227) * 0.5,
            top: 148.h,
            child: PSImg(name: 'ps_b_pig_icon', width: 227, height: 224),
          ),
          Positioned(
            right: 24.w,
            top: 160.h,
            width: 68.44,
            height: 69.2,
            child: FadeTransition(
              opacity: _fadeAnimations[0],
              child: ScaleTransition(
                scale: _scaleAnimations[0],
                child: ParticleButton(
                  onTap: () {
                    PSAdAHelper().show(
                      context,
                      (hasCache) {
                        PSAdAHelper().resetBlock();
                      },
                      (finished) {
                        PSAdAHelper().resetBlock();
                        // X2
                      },
                    );
                  },
                  child: Stack(
                    children: [
                      PSBouncyImage(
                        imagePath: 'ps_apple_bubble',
                        width: 68.44,
                        height: 69.2,
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
            left: 24.w,
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
                      PSBouncyImage(
                        imagePath: 'ps_domand_bubble',
                        width: 68.44,
                        height: 69.2,
                        enableAnimation: true,
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
            top: 240.h,
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
                      PSBouncyImage(
                        imagePath: 'ps_domand_bubble',
                        width: 68.44,
                        height: 69.2,
                        enableAnimation: true,
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
            top: 240.h,
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
                      PSBouncyImage(
                        imagePath: 'ps_domand_bubble',
                        width: 68.44,
                        height: 69.2,
                        enableAnimation: true,
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
            top: 310.h,
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
                    width: 68.44,
                    height: 69.2,
                    enableAnimation: true,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 40.w,
            top: 310.h,
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
                    width: 68.44,
                    height: 69.2,
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
                        url: "https://simulatedcardscrajoycc.com/privacy/",
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

class PSPigQuizUpdateNotificationService {
  static final StreamController<int> _streamController =
      StreamController<int>.broadcast();

  static Stream<int> get stream => _streamController.stream;

  static void sendToDomandNumberNotification(int value) {
    _streamController.sink.add(value);
  }

  static void close() {
    _streamController.close();
  }
}
