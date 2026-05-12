import 'package:json_annotation/json_annotation.dart';

part 'PSNumberModel.g.dart';

@JsonSerializable(explicitToJson: true)
class AppConfig {
  @JsonKey(name: 'eq_range', defaultValue: [])
  final List<int> eqRange;

  @JsonKey(name: 'new_ad_console', defaultValue: 0)
  final int newAdConsole;

  @JsonKey(name: 'queue_number', defaultValue: [])
  final List<QueueNumber> queueNumber;

  @JsonKey(name: 'tixian_task', defaultValue: [])
  final List<TixianTask> tixianTask;

  @JsonKey(name: 'intad_point', defaultValue: [])
  final List<IntAdPoint> intadPoint;

  @JsonKey(name: 'wheel_range', defaultValue: [])
  final List<int> wheelRange;

  @JsonKey(name: 'first_ad_prize', defaultValue: 0)
  final double firstAdPrize;

  @JsonKey(name: 'grow_point', defaultValue: [])
  final List<int> growPoint;

  @JsonKey(name: 'money_prize', defaultValue: [])
  final List<MoneyPrize> moneyPrize;

  @JsonKey(name: 'diamond_prize', defaultValue: [])
  final List<MoneyPrize> diamondPrize;

  @JsonKey(name: 'gold_prize', defaultValue: [])
  final List<MoneyPrize> goldPrize;

  AppConfig({
    required this.eqRange,
    required this.newAdConsole,
    required this.queueNumber,
    required this.tixianTask,
    required this.intadPoint,
    required this.wheelRange,
    required this.firstAdPrize,
    required this.growPoint,
    required this.moneyPrize,
    required this.diamondPrize,
    required this.goldPrize,
  });

  factory AppConfig.fromJson(Map<String, dynamic> json) => _$AppConfigFromJson(json);
  Map<String, dynamic> toJson() => _$AppConfigToJson(this);
}

@JsonSerializable()
class QueueNumber {
  @JsonKey(name: 'int_all', defaultValue: 0)
  final int intAll;

  @JsonKey(name: 'int_all_delete', defaultValue: [])
  final List<int> intAllDelete;

  @JsonKey(name: 'int_current', defaultValue: 0)
  final int intCurrent;

  @JsonKey(name: 'int_current_delete', defaultValue: [])
  final List<int> intCurrentDelete;

  QueueNumber({
    required this.intAll,
    required this.intAllDelete,
    required this.intCurrent,
    required this.intCurrentDelete,
  });

  factory QueueNumber.fromJson(Map<String, dynamic> json) => _$QueueNumberFromJson(json);
  Map<String, dynamic> toJson() => _$QueueNumberToJson(this);
}

@JsonSerializable()
class TixianTask {
  @JsonKey(name: 'title', defaultValue: '')
  final String title;

  @JsonKey(name: 'data', defaultValue: 0)
  final int data;

  TixianTask({required this.title, required this.data});

  factory TixianTask.fromJson(Map<String, dynamic> json) => _$TixianTaskFromJson(json);
  Map<String, dynamic> toJson() => _$TixianTaskToJson(this);
}

@JsonSerializable()
class IntAdPoint {
  @JsonKey(name: 'first_number', defaultValue: 0)
  final int firstNumber;

  @JsonKey(name: 'point', defaultValue: 0)
  final int point;

  @JsonKey(name: 'end_number', defaultValue: 0)
  final int endNumber;

  IntAdPoint({required this.firstNumber, required this.point, required this.endNumber});

  factory IntAdPoint.fromJson(Map<String, dynamic> json) => _$IntAdPointFromJson(json);
  Map<String, dynamic> toJson() => _$IntAdPointToJson(this);
}

@JsonSerializable()
class MoneyPrize {
  @JsonKey(name: 'first_number', defaultValue: 0)
  final int firstNumber;

  @JsonKey(name: 'type', defaultValue: 0)
  final int type;

  @JsonKey(name: 'prize', defaultValue: [])
  final List<double> prize;

  @JsonKey(name: 'end_number', defaultValue: 0)
  final int endNumber;

  MoneyPrize({
    required this.firstNumber,
    required this.type,
    required this.prize,
    required this.endNumber,
  });

  factory MoneyPrize.fromJson(Map<String, dynamic> json) => _$MoneyPrizeFromJson(json);
  Map<String, dynamic> toJson() => _$MoneyPrizeToJson(this);
}