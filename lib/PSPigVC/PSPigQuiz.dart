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
import 'package:shared_preferences/shared_preferences.dart';

import '../PSBase/PSTbaBar.dart';
import '../PSGuide/PSGuideAThree.dart';
import '../PSModel/PSQuestionModel.dart';
import '../PSTool/AESHelper.dart';
import '../PSTool/ps_extension_help.dart';
import '../PSTool/ps_img.dart';
import '../PSTool/ps_stroke_text.dart';
import 'PSPigHome.dart';

class PSPigQuiz extends StatefulWidget {
  const PSPigQuiz({super.key});

  @override
  State<PSPigQuiz> createState() => _PSPigQuiztate();
}

class _PSPigQuiztate extends State<PSPigQuiz> with TickerProviderStateMixin {
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
                  child: PigblancePage(),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: 0.width(context),
                  height: 50,
                  child: ProgressPage(),
                ),
                SizedBox(height: 20.h),
                // 底部 Container 自动动画
                SlideTransition(
                  position: _bottomContainerOffset,
                  child: Container(
                    width: 343.w,
                    height: 441.h,
                    decoration: BoxDecoration(image: PSDImg('ps_quiz_bg')),
                    child: Stack(
                      children: [
                        Positioned(
                          left: -16.w,
                          top: 12.h,
                          width: 0.width(context),
                          child: PSStrokeText(
                            text: 'Right answer wins cash',
                            size: 18,
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

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int currentProgress = 1; // Start from 1 (This controls the current position on the track)

  // Increase progress by 1 each time
  void incrementProgress() {
    if (currentProgress < 100) {
      setState(() {
        currentProgress++;
      });
    }
  }

  // This function will be used to calculate the number on the wheel
  int getNumberOnWheel(int index) {
    return 2 + (index * 3); // Starting from 2 and incrementing by 3
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Background and Progress Bar
          Stack(
            children: [
              // Background Image
              Container(
                width: double.infinity,
                height: 25,
                child: PSImg(name: 'ps_quiz_pro_bg'),
              ),
              // Progress Bar
              Positioned(
                top: 25,
                left: 0,
                right: 0,
                child: Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: currentProgress / 100,
                    child: Container(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Wheels with Numbers
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 100,
              itemBuilder: (context, index) {
                int wheelNumber = getNumberOnWheel(index);
                bool isClickable = index < currentProgress;

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: GestureDetector(
                    onTap: isClickable
                        ? () {
                      print('Wheel $wheelNumber clicked!');
                    }
                        : null,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // The wheel image with the number
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage('assets/your_wheel_image.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$wheelNumber',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          // Button to increment progress
          ElevatedButton(
            onPressed: incrementProgress,
            child: Text('Increase Progress +1'),
          ),
        ],
      ),
    );
  }
}