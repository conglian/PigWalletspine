import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:piggywalletspinearn/PSDialog/PSGuideDialog.dart';
import 'package:piggywalletspinearn/PSHome/PSHome.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../PSBase/PSTbaBar.dart';

class PSGuideManager {
  static const String _stepKey = "guide_step";
  static const String _finishedKey = "guide_finished";
  static const String _versionKey = "guide_version";

  static const int totalSteps = 14;
  static const int currentVersion = 1;


  /// 获取当前状态
  static Future<GuideState> getState() async {
    final prefs = await SharedPreferences.getInstance();

    final savedVersion = prefs.getInt(_versionKey) ?? 0;

    // 👉 如果版本变了，重置引导
    if (savedVersion != currentVersion) {
      await reset();
      await prefs.setInt(_versionKey, currentVersion);
    }

    final step = prefs.getInt(_stepKey) ?? 0;
    final finished = prefs.getBool(_finishedKey) ?? false;

    return GuideState(
      currentStep: step,
      finished: finished,
    );
  }

  // 外部调用显示引导
  static Future<void> showStep(BuildContext contexts) async {
    final state = await getState();
    int step = state.currentStep;
    switch (step) {
      case 0:
        Navigator.pushReplacement(
          contexts,
          MaterialPageRoute(
            builder: (_) => PSGuideNew1Dialog(),
          ),
        );
        break;
      case 1:
        Navigator.pushReplacement(
          contexts,
          MaterialPageRoute(
            builder: (_) => PSGuideNew2Dialog(),
          ),
        );
        break;
      case 2:
        Navigator.pushReplacement(
          contexts,
          MaterialPageRoute(
            builder: (_) => PSGuideNew3Dialog(),
          ),
        );
        break;
      case 3:
        Navigator.pushReplacement(
          contexts,
          MaterialPageRoute(
            builder: (_) => PigBottomExample(key: homeKey),
          ),
        );
        Future.delayed(Duration(seconds: 1),(){
          Navigator.pushReplacement(
            homeKey.currentContext!,
            MaterialPageRoute(
              builder: (_) => PSGuideNew4Dialog(),
            ),
          );
        });
        break;
      case 4:
        if (homeKey.currentContext == null){
          // 冷启动需要多处理一步
          Navigator.pushReplacement(
            contexts,
            MaterialPageRoute(
              builder: (_) => PigBottomExample(key: homeKey),
            ),
          );
          Future.delayed(Duration(seconds: 1),(){
            homeKey.currentContext!.tipShow2(PSGuideNew5Dialog());
          });
        } else {
          contexts.tipShow(PSGuideNew5Dialog());
        }
        break;
      case 5:
        if (homeKey.currentContext == null){
          // 冷启动需要多处理一步
          Navigator.pushReplacement(
            contexts,
            MaterialPageRoute(
              builder: (_) => PigBottomExample(key: homeKey),
            ),
          );
          Future.delayed(Duration(seconds: 1),(){
            homeKey.currentContext!.tipShow(PSGuideNew6Dialog());
          });
        } else {
          contexts.tipShow(PSGuideNew6Dialog());
        }
        break;
      case 6:
        if (homeKey.currentContext == null){
          // 冷启动需要多处理一步
          Navigator.pushReplacement(
            contexts,
            MaterialPageRoute(
              builder: (_) => PigBottomExample(key: homeKey),
            ),
          );
          Future.delayed(Duration(seconds: 1),(){
            homeKey.currentContext!.tipShow(PSGuideNew7Dialog());
          });
        } else {
          contexts.tipShow(PSGuideNew7Dialog());
        }
        break;
      case 7:
        if (homeKey.currentContext == null){
          // 冷启动需要多处理一步
          Navigator.pushReplacement(
            contexts,
            MaterialPageRoute(
              builder: (_) => PigBottomExample(key: homeKey),
            ),
          );
          Future.delayed(Duration(seconds: 1),(){
            homeKey.currentContext!.tipShow(PSGuideNew8Dialog());
          });
        } else {
          contexts.tipShow(PSGuideNew8Dialog());
        }
        break;
      case 8:
        if (homeKey.currentContext == null){
          // 冷启动需要多处理一步
          Navigator.pushReplacement(
            contexts,
            MaterialPageRoute(
              builder: (_) => PigBottomExample(key: homeKey),
            ),
          );
          Future.delayed(Duration(seconds: 1),(){
            homeKey.currentContext!.tipShow(PSGuideNew9Dialog());
          });
        } else {
          contexts.tipShow(PSGuideNew9Dialog());
        }
        break;
      case 9:
        if (homeKey.currentContext == null){
          // 冷启动需要多处理一步
          Navigator.pushReplacement(
            contexts,
            MaterialPageRoute(
              builder: (_) => PigBottomExample(key: homeKey),
            ),
          );
          Future.delayed(Duration(seconds: 1),(){
            Navigator.push(homeKey.currentContext!,
                MaterialPageRoute(
                  builder: (_) => PSGuideNew10Dialog(showToast: false),
                )
            );
          });
        } else {
          Navigator.push(contexts,
            MaterialPageRoute(
              builder: (_) => PSGuideNew10Dialog(showToast: false),
            )
          );
        }
        break;
      case 10:
        if (homeKey.currentContext == null){
          // 冷启动需要多处理一步
          Navigator.pushReplacement(
            contexts,
            MaterialPageRoute(
              builder: (_) => PigBottomExample(key: homeKey),
            ),
          );
          Future.delayed(Duration(seconds: 1),(){
            homeKey.currentContext!.tipShow(PSGuideNew11Dialog());
          });
        } else {
          contexts.tipShow(PSGuideNew11Dialog());
        }
        break;
      case 11:
        if (homeKey.currentContext == null){
          // 冷启动需要多处理一步
          Navigator.pushReplacement(
            contexts,
            MaterialPageRoute(
              builder: (_) => PigBottomExample(key: homeKey),
            ),
          );
          Future.delayed(Duration(seconds: 1),(){
            homeKey.currentContext!.tipShow(PSGuideNew12Dialog(is_old: false));
          });
        } else {
          contexts.tipShow(PSGuideNew12Dialog(is_old: false));
        }
        break;
      case 12:
        if (homeKey.currentContext == null){
          // 冷启动需要多处理一步
          Navigator.pushReplacement(
            contexts,
            MaterialPageRoute(
              builder: (_) => PigBottomExample(key: homeKey),
            ),
          );
          Future.delayed(Duration(seconds: 1),(){
            homeKey.currentContext!.tipShow2(PSGuideNew13Dialog());
          });
        } else {
          contexts.tipShow2(PSGuideNew13Dialog());
        }
        break;
      default:
        return;
    }
  }

  /// 下一步
  static Future<void> nextStep(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    int step = prefs.getInt(_stepKey) ?? 0;

    step++;

    if (step >= totalSteps) {
      await finishGuide();
    } else {
      await prefs.setInt(_stepKey, step);
    }
    await showStep(context);
  }

  /// 完成引导
  static Future<void> finishGuide() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_finishedKey, true);
    await prefs.remove(_stepKey);
  }

  /// 跳过
  static Future<void> skip() async {
    await finishGuide();
  }

  /// 重置（调试用）
  static Future<void> reset() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_stepKey);
    await prefs.remove(_finishedKey);
  }
}


class GuideState {
  final int currentStep;
  final bool finished;

  GuideState({
    required this.currentStep,
    required this.finished,
  });
}