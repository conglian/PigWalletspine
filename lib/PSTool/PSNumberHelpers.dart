import 'dart:convert';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../PSModel/PSNumberModel.dart';

class PSNumberHelpers {
  static final PSNumberHelpers _instance = PSNumberHelpers._internal();

  factory PSNumberHelpers() {
    return _instance;
  }

  PSNumberHelpers._internal();

  AppConfig? intModel;

  Future<void> initNumberModel() async {
    await _psloadintDataFromLocate();
    await _psloadtaskDataFromLocate();
    await _psloadprobabilityDataFromLocate();
    await _psloadwinup_numberDataFromLocate();
    await _psloadlsattaskDataFromLocate();
  }

  Future<void> _psloadintDataFromLocate() async {
    String jsonString = await rootBundle.loadString("gp152_pig_number".jsons());
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    intModel = AppConfig.fromJson(jsonMap);
    "PigWallets int jsonMap = ${jsonMap}".log();
    "PigWallets int model = ${intModel?.eqRange}".log();
  }

  Future<void> _psloadtaskDataFromLocate() async {
    // String jsonString = await rootBundle.loadString("c130_withdraw_task".jsons());
    // Map<String, dynamic> jsonMap = json.decode(jsonString);
    // taskModel = TaskRootModel.fromJson(jsonMap);
    // "PigWallets task json = ${taskModel}".log();
  }

  Future<void> _psloadlsattaskDataFromLocate() async {
    // String jsonString = await rootBundle.loadString("c130_withdraw_last_task".jsons());
    // Map<String, dynamic> jsonMap = json.decode(jsonString);
    // last_taskModel = TaskRootModel.fromJson(jsonMap);
    // "PigWallets task json = ${last_taskModel}".log();
  }

  Future<void> _psloadprobabilityDataFromLocate() async {
    // String jsonString = await rootBundle.loadString("probability_reset".jsons());
    // Map<String, dynamic> jsonMap = json.decode(jsonString);
    // probabilityConfigModel = ProbabilityConfig.fromJson(jsonMap);
    // "PigWallets probabilityConfig json = ${probabilityConfigModel}".log();
  }

  Future<void> _psloadwinup_numberDataFromLocate() async {
    // String jsonString = await rootBundle.loadString("winup_number".jsons());
    // Map<String, dynamic> jsonMap = json.decode(jsonString);
    // bonusConfigModel = BonusConfig.fromJson(jsonMap);
    // "PigWallets winup_number json = ${bonusConfigModel}".log();
  }

  // 插屏概率获取
  bool checkProbability() {
    // 找到 value 所在的区间
    int range = 0;
    for (var item in intModel!.intadPoint) {
      if (PSLocalProvider.instance.ps_dolas_old_number >= item.firstNumber && PSLocalProvider.instance.ps_dolas_old_number <= item.endNumber) {
        range = item.point;
        break;
      }
    }
    'range=$range'.log();
    if (PSLocalProvider.instance.ps_dolas_old_number >= intModel!.eqRange.first){
      return true;
    }

    if (range <= 0.0) {
      return false;
    }

    double point = range.toDouble() ?? 0.0;

    // 随机概率判断
    double rand = Random().nextDouble(); // 0.0 ~ 1.0
    return rand <= point;
  }

  /// 获取气泡奖励值
  double getPrizeWithDolasNum() {
    for (var item in intModel!.moneyPrize) {
      int start = item.firstNumber;
      int end = item.endNumber;

      if (PSLocalProvider.instance.ps_dolas_number >= start && PSLocalProvider.instance.ps_dolas_number < end) {
        double min = item.prize.first;
        double max = item.prize.last;
        'XXXXXXX${0.to2Double(_randomBetween(min, max))}'.log();
        return 0.to2Double(_randomBetween(min, max));
      }
    }

    /// 如果超出所有区间，返回最后一段
    var last = intModel!.moneyPrize.last;
    'YYYYYYY${0.to2Double(_randomBetween(last.prize.first, last.prize.last))}'.log();
    return 0.to2Double(_randomBetween(
      last.prize.first,
      last.prize.last,
    ));
  }

  /// 获取金额范围奖励值
  List<double> getPrizeWithDolasNSize(double ps_dolas) {
    for (var item in intModel!.moneyPrize) {
      int start = item.firstNumber;
      int end = item.endNumber;

      if (ps_dolas >= start && ps_dolas < end) {
        return item.prize;
      }
    }

    /// 如果超出所有区间，返回最后一段
    var last = intModel!.moneyPrize.last;
    return last.prize;
  }

  /// 获取钻石或者金砖奖励值
  double getPrizeWithDomandGoldNum() {
    List<MoneyPrize> model = PSLocalProvider.instance.ps_pig_level == 1 ? intModel!.diamondPrize : intModel!.goldPrize;
    for (var item in model) {
      int start = item.firstNumber;
      int end = item.endNumber;

      if (PSLocalProvider.instance.ps_Level_inedx >= start && PSLocalProvider.instance.ps_Level_inedx < end) {
        double min = item.prize.first;
        double max = item.prize.last;
        return 0.to2Double(_randomBetween(min, max));
      }
    }

    /// 如果超出所有区间，返回最后一段
    var last = model.last;
    return 0.to2Double(_randomBetween(
      last.prize.first,
      last.prize.last,
    ));
  }


  /// 生成[min, max]之间随机整数（兼容 double）
  double _randomBetween(double min, double max) {
    if (min > max) {
      throw ArgumentError('min should be less than or equal to max');
    }

    final r = Random();
    // Generate a double between 0.0 and 1.0, then scale to range
    double value = min + r.nextDouble() * (max - min);
    // Round to 2 decimal places
    return double.parse(value.toStringAsFixed(2));
  }



}