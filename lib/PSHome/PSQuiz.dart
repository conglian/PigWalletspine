import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:piggywalletspinearn/PSDialog/PSDialog.dart';
import 'package:piggywalletspinearn/PSHome/PSHome.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/main.dart';
import 'package:provider/provider.dart';

import '../PSGuide/PSGuideAThree.dart';
import '../PSModel/PSQuestionModel.dart';
import '../PSTool/AESHelper.dart';
import '../PSTool/ps_extension_help.dart';
import '../PSTool/ps_img.dart';
import '../PSTool/ps_stroke_text.dart';

class PSQuiz extends StatefulWidget {
  const PSQuiz({super.key});

  @override
  State<PSQuiz> createState() => _PSQuizState();
}

class _PSQuizState extends State<PSQuiz> with TickerProviderStateMixin {
  bool is_quizing = false;
  bool anwer_a = false;
  bool anwer_b = false;

  late AnimationController _topContainerController;
  late Animation<Offset> _topContainerOffset;
  late AnimationController _bottomContainerController;
  late Animation<Offset> _bottomContainerOffset;

  List<QuestionModel> daily_questions = [];
  List<QuestionModel> nature_questions = [];
  List<QuestionModel> science_questions = [];
  List<QuestionModel> math_questions = [];
  List<QuestionModel> animal_questions = [];
  List<QuestionModel> current_questions = [];

  @override
  void initState() {
    super.initState();

    // 顶部 Container 动画
    _topContainerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _topContainerOffset =
        Tween<Offset>(begin: const Offset(-1.5, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _topContainerController,
            curve: Curves.elasticOut,
          ),
        );

    // 底部 Container 动画
    _bottomContainerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _bottomContainerOffset =
        Tween<Offset>(begin: const Offset(-1.5, 0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _bottomContainerController,
            curve: Curves.elasticOut,
          ),
        );

    // 页面进入自动播放动画
    _topContainerController.forward().then((_) {
      _bottomContainerController.forward();
    });
    loadQuizModel();
    PSPigQuizUpdateNotificationService.stream.listen((value) async {
      // 当前帧构建完成后
      WidgetsBinding.instance.addPostFrameCallback((_) {
        getCurrentModel();
      });
    });
  }

  // 解析本地model
  void loadQuizModel() {
    final daily_decrypted = AESHelper.decryptString(dailyLifeString);
    daily_questions = questionListFromJson(jsonDecode(daily_decrypted));
    '${daily_questions.first.question}'.log();

    final nature_decrypted = AESHelper.decryptString(natureLifeString);
    nature_questions = questionListFromJson(jsonDecode(nature_decrypted));
    '${nature_questions.first.question}'.log();

    final science_decrypted = AESHelper.decryptString(scienceString);
    science_questions = questionListFromJson(jsonDecode(science_decrypted));
    '${science_questions.first.question}'.log();

    final math_decrypted = AESHelper.decryptString(mathString);
    math_questions = questionListFromJson(jsonDecode(math_decrypted));
    '${math_questions.first.question}'.log();

    final animal_decrypted = AESHelper.decryptString(animalString);
    animal_questions = questionListFromJson(jsonDecode(animal_decrypted));
    '${animal_questions.first.question}'.log();

    getCurrentModel();
  }

  List<QuestionModel> questionListFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => QuestionModel.fromJson(json)).toList();
  }

  @override
  void dispose() {
    _topContainerController.dispose();
    _bottomContainerController.dispose();
    super.dispose();
  }

  // 获取当前主题
  void getCurrentModel() {
    if (PSLocalProvider.instance.ps_quiz_model_index == 0) {
      current_questions = math_questions;
    } else if (PSLocalProvider.instance.ps_quiz_model_index == 1) {
      current_questions = daily_questions;
    } else if (PSLocalProvider.instance.ps_quiz_model_index == 2) {
      current_questions = nature_questions;
    } else if (PSLocalProvider.instance.ps_quiz_model_index == 3) {
      current_questions = science_questions;
    } else if (PSLocalProvider.instance.ps_quiz_model_index == 4) {
      current_questions = animal_questions;
    }
    setState(() {});
  }

  // 下一题
  Future<void> next_quiz() async {
    if (PSLocalProvider.instance.ps_quiz_num_index + 1 >=
        current_questions.length) {
      await PSLocalProvider.instance.updateint(
        PSLocalProvider.instance.ps_quiz_num_indexName,
        0,
      );
      // 最后一题切换 下一个主题
      if (PSLocalProvider.instance.ps_quiz_model_index >= 4) {
        await PSLocalProvider.instance.updateint(
          PSLocalProvider.instance.ps_quiz_model_indexName,
          0,
        );
      } else {
        await PSLocalProvider.instance.updateint(
          PSLocalProvider.instance.ps_quiz_model_indexName,
          PSLocalProvider.instance.ps_quiz_model_index + 1,
        );
      }
      getCurrentModel();
    } else {
      await PSLocalProvider.instance.updateint(
        PSLocalProvider.instance.ps_quiz_num_indexName,
        PSLocalProvider.instance.ps_quiz_num_index + 1,
      );
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 0.width(context),
            height: 0.height(context),
            decoration: BoxDecoration(image: PSDImg('ps_quzi_bg')),
            child: Column(
              children: [
                SizedBox(height: 44.h),

                // 顶部 Container 自动动画
                SlideTransition(
                  position: _topContainerOffset,
                  child: Consumer<PSLocalProvider>(
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
                                      style: TextStyle(
                                        color: '#006AFF'.color(),
                                      ),
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
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
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
                ),

                SizedBox(height: 88.h),

                // 底部 Container 自动动画
                SlideTransition(
                  position: _bottomContainerOffset,
                  child: Container(
                    width: 343.w,
                    height: 441.h,
                    decoration: BoxDecoration(image: PSDImg('ps_quzis_bg')),
                    child: Stack(
                      children: [
                        Positioned(
                          left: 108.w,
                          top: 12.h,
                          child: PSStrokeText(
                            text: 'Quiz Cash',
                            size: 32,
                            color: '#F8FFAD'.color(),
                            weight: FontWeight.w900,
                            skWidth: 1,
                            skColor: '#026724'.color(),
                          ),
                        ),
                        Positioned(
                          left: (343.w - 288.w) * 0.5,
                          top: 94.h,
                          child: SizedBox(
                            width: 288.w,
                            height: 120.h,
                            child: Center(
                              child: PSStrokeText(
                                text:
                                    current_questions[PSLocalProvider
                                            .instance
                                            .ps_quiz_num_index]
                                        .question,
                                size: 24,
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
                          left: (343.w - 260.w) * 0.5,
                          top: 240.h,
                          child: ParticleButton(
                            onTap: () {
                              if (is_quizing) return;
                              if (current_questions[PSLocalProvider
                                          .instance
                                          .ps_quiz_num_index]
                                      .answer ==
                                  'a') {
                                setState(() {
                                  is_quizing = true;
                                  anwer_a = true;
                                  anwer_b = false;
                                });
                              } else {
                                setState(() {
                                  is_quizing = true;
                                  anwer_a = false;
                                  anwer_b = true;
                                });
                              }
                              Future.delayed(Duration(milliseconds: 1000), () {
                                if (current_questions[PSLocalProvider
                                            .instance
                                            .ps_quiz_num_index]
                                        .answer ==
                                    'a') {
                                  quizAnswer();
                                }
                                setState(() {
                                  is_quizing = false;
                                  anwer_b = false;
                                  anwer_a = false;
                                });
                                next_quiz();
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
                                  text:
                                      current_questions[PSLocalProvider
                                              .instance
                                              .ps_quiz_num_index]
                                          .a,
                                  size: 24,
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
                          left: (343.w - 260.w) * 0.5,
                          top: 320.h,
                          child: ParticleButton(
                            onTap: () {
                              if (is_quizing) return;
                              if (current_questions[PSLocalProvider
                                          .instance
                                          .ps_quiz_num_index]
                                      .answer ==
                                  'b') {
                                setState(() {
                                  is_quizing = true;
                                  anwer_b = true;
                                  anwer_a = false;
                                });
                              } else {
                                setState(() {
                                  is_quizing = true;
                                  anwer_b = false;
                                  anwer_a = true;
                                });
                              }
                              Future.delayed(Duration(milliseconds: 1000), () {
                                if (current_questions[PSLocalProvider
                                            .instance
                                            .ps_quiz_num_index]
                                        .answer ==
                                    'b') {
                                  quizAnswer();
                                }
                                setState(() {
                                  is_quizing = false;
                                  anwer_b = false;
                                  anwer_a = false;
                                });
                                next_quiz();
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
                                  text:
                                      current_questions[PSLocalProvider
                                              .instance
                                              .ps_quiz_num_index]
                                          .b,
                                  size: 24,
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
                                  current_questions[PSLocalProvider
                                              .instance
                                              .ps_quiz_num_index]
                                          .answer ==
                                      'a'
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
                            visible: is_quizing,
                            child: PSImg(
                              name:
                                  current_questions[PSLocalProvider
                                              .instance
                                              .ps_quiz_num_index]
                                          .answer ==
                                      'b'
                                  ? 'ps_quzi_status_s'
                                  : 'ps_quzi_status_n',
                              width: 39,
                              height: 39,
                            ),
                          ),
                        ),
                      ],
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

  // 答对展示后续逻辑
  Future<void> quizAnswer() async {
    context.tipShowAdvanced(PSPopDomandAwardADialog());
    await PSLocalProvider.instance.updateint(
      PSLocalProvider.instance.ps_quzi_rowName,
      PSLocalProvider.instance.ps_quzi_row + 1,
    );
    await PSLocalProvider.instance.updateint(
      PSLocalProvider.instance.ps_pig_level_indexName,
      PSLocalProvider.instance.ps_pig_level_index + 1,
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
    }
    if (PSLocalProvider.instance.ps_pig_level == 1 && PSLocalProvider.instance.ps_pig_level_index >= 10){
      await PSLocalProvider.instance.updateint(
        PSLocalProvider.instance.ps_pig_level_indexName,
        10,
      );
    }
    if (PSLocalProvider.instance.ps_quzi_row >= 3) {
      await PSLocalProvider.instance.updateint(
        PSLocalProvider.instance.ps_quzi_rowName,
        0,
      );
      await PSLocalProvider.instance.updateint(
        PSLocalProvider.instance.ps_wheel_numberName,
        PSLocalProvider.instance.ps_wheel_number + 1,
      );
    }
  }
}
