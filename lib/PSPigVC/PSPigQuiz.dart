import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:piggywalletspinearn/PSDialog/PSDialog.dart';
import 'package:piggywalletspinearn/PSHome/PSHome.dart';
import 'package:piggywalletspinearn/PSTool/PSNumberHelpers.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/main.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spine_flutter/spine_widget.dart' as spine;

import '../PSBase/PSTbaBar.dart';
import '../PSGuide/PSGuideAThree.dart';
import '../PSModel/PSQuestionModel.dart';
import '../PSTool/AESHelper.dart';
import '../PSTool/PSTBAEventTool.dart';
import '../PSTool/ps_extension_help.dart';
import '../PSTool/ps_img.dart';
import '../PSTool/ps_stroke_text.dart';
import 'PSPigCash.dart';
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
  bool show_answer = false;

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

  Timer? _timer;

  final int _timeoutSeconds = 25;

  Timer? _timer2;

  final int _timeoutSeconds2 = 5;

  late spine.SpineWidgetController _controller;

  @override
  void initState() {
    super.initState();
    ps_event_fire('quiz_page', {});
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
    // 当前帧构建完成后
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PSPigQuizProgressNotificationService.sendToQuizProgressNotification(PSLocalProvider.instance.ps_quiz_all_num);
      _startTimer2();
    });

    _controller = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
  }

  /// 启动或者重置定时器
  void _startTimer2() {
    // 如果有正在运行的定时器，先取消
    _timer2?.cancel();

    // 开启新的定时器
    _timer2 = Timer(Duration(seconds: _timeoutSeconds2), () {
        setState(() {
          show_answer = true;
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
    _timer?.cancel();
    _timer2?.cancel();
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
                        if (provider.ps_pig_level == 0) {
                          return PigblancePage();
                        } else {
                          return PigblancePage2();
                        }
                      }
                  ),
                ),
                SizedBox(height: 20.h),
                Padding(
                  padding: EdgeInsets.only(left: 39),
                  child: SizedBox(
                    width: 0.width(context) - 39,
                    height: 50,
                    child: ProgressPage(),
                  ),
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
                            onTap: () async {
                              _timer?.cancel();
                              setState(() {
                                show_answer = false;
                              });
                              _startTimer2();
                              if (is_quizing) return;
                              await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_quiz_tap_indexName, PSLocalProvider.instance.ps_quiz_tap_index + 1);
                              if (current_questions[PSLocalProvider
                                  .instance
                                  .ps_quiz_num_index]
                                  .answer ==
                                  'a') {
                                ps_event_fire('answer_true_c', {});
                                setState(() {
                                  is_quizing = true;
                                  anwer_a = true;
                                  anwer_b = false;
                                });
                              } else {
                                ps_event_fire('answer_wrong_c', {});
                                setState(() {
                                  is_quizing = true;
                                  anwer_a = false;
                                  anwer_b = true;
                                });
                              }
                              Future.delayed(Duration(milliseconds: 1000), () async {
                                if (current_questions[PSLocalProvider
                                    .instance
                                    .ps_quiz_num_index]
                                    .answer ==
                                    'a') {
                                  quizAnswer();
                                  await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_quiz_all_numName, PSLocalProvider.instance.ps_quiz_all_num + 1);
                                  Future.delayed(Duration(milliseconds: 50),(){
                                    if (PSLocalProvider.instance.ps_quiz_all_num == 2 || (PSLocalProvider.instance.ps_quiz_all_num - 2) % 3 == 0){
                                      PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_wheel_numberName, PSLocalProvider.instance.ps_wheel_number + 1);
                                    }
                                    PSPigQuizProgressNotificationService.sendToQuizProgressNotification(PSLocalProvider.instance.ps_quiz_all_num);
                                  });
                                } else {
                                  next_quiz();
                                }
                                setState(() {
                                  is_quizing = false;
                                  anwer_b = false;
                                  anwer_a = false;
                                });
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
                            onTap: () async {
                              _timer?.cancel();
                              setState(() {
                                show_answer = false;
                              });
                              _startTimer2();
                              if (is_quizing) return;
                              await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_quiz_tap_indexName, PSLocalProvider.instance.ps_quiz_tap_index + 1);
                              if (current_questions[PSLocalProvider
                                  .instance
                                  .ps_quiz_num_index]
                                  .answer ==
                                  'b') {
                                ps_event_fire('answer_true_c', {});
                                setState(() {
                                  is_quizing = true;
                                  anwer_b = true;
                                  anwer_a = false;
                                });
                              } else {
                                ps_event_fire('answer_wrong_c', {});
                                setState(() {
                                  is_quizing = true;
                                  anwer_b = false;
                                  anwer_a = true;
                                });
                              }
                              Future.delayed(Duration(milliseconds: 1000), () async {
                                if (current_questions[PSLocalProvider
                                    .instance
                                    .ps_quiz_num_index]
                                    .answer ==
                                    'b') {
                                  quizAnswer();
                                  await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_quiz_all_numName, PSLocalProvider.instance.ps_quiz_all_num + 1);
                                  Future.delayed(Duration(milliseconds: 50),(){
                                    if (PSLocalProvider.instance.ps_quiz_all_num == 2 || (PSLocalProvider.instance.ps_quiz_all_num - 2) % 3 == 0){
                                      PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_wheel_numberName, PSLocalProvider.instance.ps_wheel_number + 1);
                                    }
                                    PSPigQuizProgressNotificationService.sendToQuizProgressNotification(PSLocalProvider.instance.ps_quiz_all_num);
                                  });
                                } else {
                                  next_quiz();
                                }
                                setState(() {
                                  is_quizing = false;
                                  anwer_b = false;
                                  anwer_a = false;
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
                        Positioned(
                          right: 10.w,
                          top: current_questions[PSLocalProvider.instance.ps_quiz_num_index].answer == 'b'
                              ? 330.h
                              : 250.h,
                          child: Visibility(
                            visible: show_answer, // or your condition
                            maintainState: true,       // keep the state alive
                            maintainAnimation: true,   // keep animation running
                            maintainSize: true,        // keep size even when hidden
                            child: SizedBox(
                              width: 55,
                              height: 88,
                              child: spine.SpineWidget.fromAsset(
                                'assets/spine/shouzhi/skeleton.atlas',
                                'assets/spine/shouzhi/skeleton.skel',
                                _controller,
                              ),
                            ),
                          ),
                        )
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
    if (PSLocalProvider.instance.ps_pig_level == 0) {
      int code = await context.tipShow(PSPopAwardToolDialog(type: .quiz, isGuide: false, award: PSNumberHelpers().getPrizeWithDolasNum()));
      if (code >= 0 && PSLocalProvider.instance.ps_quiz_tap_index == 3 && PSLocalProvider.instance.ps_account_id.length <= 0) {
        if (!context.mounted) return;
        context.tipShow(PSAboutTXDialog(isConfim: false));
        next_quiz();
      } else {
        // 到达80%提现确认
        if (code >= 0 && PSLocalProvider.instance.ps_dolas_number >= PSNumberHelpers().intModel!.eqRange.first * 0.8 && PSLocalProvider.instance.ps_show_80_pop == false) {
          int code =  await context.tipShow(PSAboutTXDialog(isConfim: true));
          PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_show_80_popName, true);
          if (code >= 0){
            if (code >= 0 && PSLocalProvider.instance.ps_quiz_tap_index % PSLocalProvider.instance.quiz_console == 0){
              context.showAutoDismissDialog(context: context, child: PSConfimOneDialog(isConfim: false, contentStr: getNextMessage()), duration: Duration(milliseconds: 1200));
             next_quiz();
            } else {
              next_quiz();
            }
          }
        } else {
          if (code >= 0 && PSLocalProvider.instance.ps_quiz_tap_index % PSLocalProvider.instance.quiz_console == 0){
            context.showAutoDismissDialog(context: context, child: PSConfimOneDialog(isConfim: false, contentStr: getNextMessage()), duration: Duration(milliseconds: 1200));
            next_quiz();
          } else {
            next_quiz();
          }
        }
      }
    } else {
      int code = await context.tipShowAdvanced(PSPopWheelAwaradDialog(type: .quiz, is_rv: false, award: PSNumberHelpers().getPrizeWithDomandGoldNum(), is_wheel: false));
      if (code >= 0 && PSLocalProvider.instance.ps_quiz_tap_index == 3 && PSLocalProvider.instance.ps_account_id.length <= 0) {
        if (!context.mounted) return;
        context.tipShow(PSAboutTXDialog(isConfim: false));
        next_quiz();
      } else {
        // 到达80%提现确认
        if (code >= 0 && PSLocalProvider.instance.ps_dolas_number >= PSNumberHelpers().intModel!.eqRange.first * 0.8 && PSLocalProvider.instance.ps_show_80_pop == false) {
          int code =  await context.tipShow(PSAboutTXDialog(isConfim: true));
          PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_show_80_popName, true);
          if (code >= 0){
            if (code >= 0 && PSLocalProvider.instance.ps_quiz_tap_index % PSLocalProvider.instance.quiz_console == 0){
              context.showAutoDismissDialog(context: context, child: PSConfimOneDialog(isConfim: false, contentStr: getNextMessage()), duration: Duration(milliseconds: 1200));
              next_quiz();
            } else {
              next_quiz();
            }
          }
        } else {
          if (code >= 0 && PSLocalProvider.instance.ps_quiz_tap_index % PSLocalProvider.instance.quiz_console == 0){
            context.showAutoDismissDialog(context: context, child: PSConfimOneDialog(isConfim: false, contentStr: getNextMessage()), duration: Duration(milliseconds: 1200));
            next_quiz();
          } else {
            next_quiz();
          }
        }

      }
    }

    await PSLocalProvider.instance.updateint(
      PSLocalProvider.instance.ps_quzi_rowName,
      PSLocalProvider.instance.ps_quzi_row + 1,
    );

    if (PSLocalProvider.instance.ps_quzi_row >= 3) {
      await PSLocalProvider.instance.updateint(
        PSLocalProvider.instance.ps_quzi_rowName,
        0,
      );
    }
    await setTxProgress();
  }

  Future<void> setTxProgress() async {
    if (PSLocalProvider.instance.ps_tx_task_index == 0 || PSLocalProvider.instance.ps_tx_task_index == 3 || PSLocalProvider.instance.ps_tx_task_index == 6) {
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_quiz_indexName, PSLocalProvider.instance.ps_tx_quiz_index + 1);
      Future.delayed(Duration(milliseconds: 50), () async {
        PSPigCashNotificationService.sendToQuizProgressNotification(0);
        'PSLocalProvider.instance.ps_tx_quiz_index=${PSLocalProvider.instance.ps_tx_quiz_index}'.log();
        'PSLocalProvider.instance.ps_tx_task_index=${PSLocalProvider.instance.ps_tx_task_index}'.log();
        if (PSLocalProvider.instance.ps_tx_quiz_index >= PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data) {
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_quiz_indexName, 0);
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_wheel_indexName, 0);
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_bubble_indexName, 0);
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_task_indexName, PSLocalProvider.instance.ps_tx_task_index + 1);
          Future.delayed(Duration(milliseconds: 50), () async {
            PSPigCashNotificationService.sendToQuizProgressNotification(0);
          });
        }
      });
      // 重置任务
      Future.delayed(Duration(milliseconds: 100), () async {
        if (PSLocalProvider.instance.ps_tx_task_index + 1 >= PSNumberHelpers().intModel!.tixianTask.length){
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_quiz_indexName, 0);
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_wheel_indexName, 0);
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_bubble_indexName, 0);
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_task_indexName, 0);
          Future.delayed(Duration(milliseconds: 50), () async {
            PSPigCashNotificationService.sendToQuizProgressNotification(0);
          });
        }
      });
    };
  }

  static int index = 0;

  String getNextMessage() {
    // 消息列表
    final messages = [
      "Keep Answering! Today's ${0.dolasType()}100 Cash Out Feels Easy",
      "Keep Going! ${0.dolasType()}150 Is Within Reach — One Question Away",
      "Don't Stop Now! Today's ${0.dolasType()}1000 Awaits Your Next Answer",
      "Stay in the Game — ${0.dolasType()}200 Is Heating Up with Every Question",
      "Keep Answering — Today's ${0.dolasType()}120 Is Just a Few Questions Away",
      "Almost There! ${0.dolasType()}200 Feels Closer with Every Right Answer",
    ];

    // 静态变量记录索引（函数内部保持状态）
    // 每次调用都会轮询
    // Dart 的函数内部静态变量只初始化一次
    // ignore: prefer_function_declarations_over_variables

    String message = messages[index];
    index = (index + 1) % messages.length;
    return message;
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
    if (PSLocalProvider.instance.ps_quiz_tap_index == 3 && PSLocalProvider.instance.ps_account_id.length <= 0) {
      if (!context.mounted) return;
      context.tipShow(PSAboutTXDialog(isConfim: false));
    } else {
      if (PSLocalProvider.instance.ps_quiz_tap_index == 8 || PSLocalProvider.instance.ps_quiz_tap_index == 15 || PSLocalProvider.instance.ps_quiz_tap_index == 20) {
        int code = await context.tipShow(PSQuizRankTwoDialog(quiz_num: PSLocalProvider.instance.ps_quiz_tap_index));
        if (code >= 0 && PSLocalProvider.instance.ps_quiz_tap_index % PSLocalProvider.instance.quiz_console == 0){
          context.showAutoDismissDialog(context: context, child: PSConfimOneDialog(isConfim: false, contentStr: getNextMessage()), duration: Duration(milliseconds: 1200));
        }
      } else {
        if (PSLocalProvider.instance.ps_quiz_tap_index % PSLocalProvider.instance.quiz_console == 0){
          context.showAutoDismissDialog(context: context, child: PSConfimOneDialog(isConfim: false, contentStr: getNextMessage()), duration: Duration(milliseconds: 1200));
        }
      }
    }
    if (show_answer){
      setState(() {
        show_answer = false;
      });
    }
  }
}

class ProgressPage extends StatefulWidget {
  @override
  _ProgressPageState createState() => _ProgressPageState();
}

class _ProgressPageState extends State<ProgressPage> {
  int currentProgress = 0; // Start from 20, the current position on the track

  late double currentW = (0.width(context) - 42) / 10;

  ScrollController _scrollController = ScrollController();

  late spine.SpineWidgetController _controller;

  // This function will be used to calculate the number on the wheel
  int getNumberOnWheel(int index) {
    return 2 + (index * 3); // Starting from 2 and incrementing by 3
  }

  int getProgressForWheel(int progress) {
    // 进度从 2 开始，每次增加 3
    return progress;
  }

  // Method to update the scroll position based on current progress
  void updateScrollPosition() {
    // Cap the progress at 8 if it's greater
    int cappedProgress = currentProgress;

    if (cappedProgress <= 8) {
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      int offset = getProgressForWheel(cappedProgress);
      offset -= 5;
      if (offset > 36.w){
        offset += (offset ~/ 36.w);
      }
      'offset=$offset'.log();
      'currentW=$currentW'.log();
      'currentProgress=$currentProgress'.log();
      _scrollController.animateTo(
        (offset.toDouble() * currentW),
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    // External notification example (e.g., from a service or callback)
    PSPigQuizProgressNotificationService.stream.listen((value) {
      setState(() {
        currentProgress = value;
        updateScrollPosition();
      });
    });

    _controller = spine.SpineWidgetController(onInitialized: (controller) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.animationState.setAnimationByName(0, "animation", true);
      });
    });
    'currentProgress=$currentProgress'.log();

  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Background and Progress Bar
          Stack(
            children: [
              // Background Image
              Positioned(
                top: 8,
                child: SizedBox(
                  width: screenWidth - 39, // Adjust to screen width - 39
                  height: 25,
                  child: PSImg(name: 'ps_quiz_pro_bg'),
                ),
              ),
              Positioned(
                top: 12.5,
                left: 3,
                right: 0,
                child: Container(
                  height: 11,
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10), // Adding rounded corners
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: currentProgress == 1 ? 0.07 : currentProgress <= 8 ? currentProgress * 0.1 : 0.5, // Calculate progress based on current progress, capped at 8
                    child: Container(
                      decoration: BoxDecoration(
                        color: '#E6F207'.color(),
                        borderRadius: BorderRadius.circular(10), // Rounded corners for the progress bar
                      ),
                    ),
                  ),
                ),
              ),
              // Wheels with Numbers
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ListView.builder(
                  controller: _scrollController, // Attach the scroll controller
                  scrollDirection: Axis.horizontal,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 100,
                  itemBuilder: (context, index) {
                    int wheelNumber = getNumberOnWheel(index);
                    bool isClickable = wheelNumber <= currentProgress; // Only clickable if the wheel number is <= current progress
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: GestureDetector(
                        onTap: isClickable
                            ? () {
                          ps_event_fire('quiz_wheel_c', {});
                          PigTabController.switchTo(2);
                        }
                            : null,
                        child: Stack(
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: PSDImg('ps_quiz_wheel_icon'),
                              ),
                            ),
                            Positioned(
                              left: 14,
                              bottom: 2,
                              child: PSStrokeText(
                                text: '$wheelNumber',
                                size: 16.sp,
                                color: '#FFF67B'.color(),
                                weight: FontWeight.w900,
                                skWidth: 1,
                                skColor: '#440F02'.color(),
                              ),
                            ),
                            Visibility(visible: isClickable,child: Positioned(left: 4,child: _PulsingIcon(child: PSImg(name: 'ps_shouzhi_icon', width: 40, height: 40)))),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class PSPigQuizProgressNotificationService {
  static final StreamController<int> _streamController =
  StreamController<int>.broadcast();

  static Stream<int> get stream => _streamController.stream;

  static void sendToQuizProgressNotification(int value) {
    _streamController.sink.add(value);
  }

  static void close() {
    _streamController.close();
  }
}

class _PulsingIcon extends StatefulWidget {
  final Widget child;
  const _PulsingIcon({required this.child});

  @override
  State<_PulsingIcon> createState() => _PulsingIconState();
}

class _PulsingIconState extends State<_PulsingIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true); // repeat back and forth

    _animation = Tween<double>(begin: 0.8, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}