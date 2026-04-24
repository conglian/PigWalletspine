import 'package:shared_preferences/shared_preferences.dart';

class PSGuideManager {
  static const String _stepKey = "guide_step";
  static const String _finishedKey = "guide_finished";
  static const String _versionKey = "guide_version";

  static const int totalSteps = 14;

  /// 👉 每次改引导流程就+1
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
  static Future<void> showStep() async {
    final state = await getState();
    int step = state.currentStep;
    switch (step) {
      case 0:
        break;
      case 1:
        break;
      case 2:
        break;
      case 3:
        break;
      case 4:
        break;
      case 5:
        break;
      case 6:
        break;
      case 7:
        break;
      case 8:
        break;
      case 9:
        break;
      case 10:
        break;
      case 11:
        break;
      case 12:
        break;
      case 13:
        break;
      default:
        return;
    }
  }

  /// 下一步
  static Future<void> nextStep() async {
    final prefs = await SharedPreferences.getInstance();
    int step = prefs.getInt(_stepKey) ?? 0;

    step++;

    if (step >= totalSteps) {
      await finishGuide();
    } else {
      await prefs.setInt(_stepKey, step);
    }
    await showStep();
  }

  /// 设置步骤（恢复用）
  static Future<void> setStep(int step) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_stepKey, step);
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