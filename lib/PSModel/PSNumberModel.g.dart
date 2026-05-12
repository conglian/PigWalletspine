// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PSNumberModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppConfig _$AppConfigFromJson(Map<String, dynamic> json) => AppConfig(
  eqRange:
      (json['eq_range'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
  newAdConsole: (json['new_ad_console'] as num?)?.toInt() ?? 0,
  queueNumber:
      (json['queue_number'] as List<dynamic>?)
          ?.map((e) => QueueNumber.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  tixianTask:
      (json['tixian_task'] as List<dynamic>?)
          ?.map((e) => TixianTask.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  intadPoint:
      (json['intad_point'] as List<dynamic>?)
          ?.map((e) => IntAdPoint.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  wheelRange:
      (json['wheel_range'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
  firstAdPrize: (json['first_ad_prize'] as num?)?.toDouble() ?? 0,
  growPoint:
      (json['grow_point'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
  moneyPrize:
      (json['money_prize'] as List<dynamic>?)
          ?.map((e) => MoneyPrize.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  diamondPrize:
      (json['diamond_prize'] as List<dynamic>?)
          ?.map((e) => MoneyPrize.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
  goldPrize:
      (json['gold_prize'] as List<dynamic>?)
          ?.map((e) => MoneyPrize.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [],
);

Map<String, dynamic> _$AppConfigToJson(AppConfig instance) => <String, dynamic>{
  'eq_range': instance.eqRange,
  'new_ad_console': instance.newAdConsole,
  'queue_number': instance.queueNumber.map((e) => e.toJson()).toList(),
  'tixian_task': instance.tixianTask.map((e) => e.toJson()).toList(),
  'intad_point': instance.intadPoint.map((e) => e.toJson()).toList(),
  'wheel_range': instance.wheelRange,
  'first_ad_prize': instance.firstAdPrize,
  'grow_point': instance.growPoint,
  'money_prize': instance.moneyPrize.map((e) => e.toJson()).toList(),
  'diamond_prize': instance.diamondPrize.map((e) => e.toJson()).toList(),
  'gold_prize': instance.goldPrize.map((e) => e.toJson()).toList(),
};

QueueNumber _$QueueNumberFromJson(Map<String, dynamic> json) => QueueNumber(
  intAll: (json['int_all'] as num?)?.toInt() ?? 0,
  intAllDelete:
      (json['int_all_delete'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
  intCurrent: (json['int_current'] as num?)?.toInt() ?? 0,
  intCurrentDelete:
      (json['int_current_delete'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList() ??
      [],
);

Map<String, dynamic> _$QueueNumberToJson(QueueNumber instance) =>
    <String, dynamic>{
      'int_all': instance.intAll,
      'int_all_delete': instance.intAllDelete,
      'int_current': instance.intCurrent,
      'int_current_delete': instance.intCurrentDelete,
    };

TixianTask _$TixianTaskFromJson(Map<String, dynamic> json) => TixianTask(
  title: json['title'] as String? ?? '',
  data: (json['data'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$TixianTaskToJson(TixianTask instance) =>
    <String, dynamic>{'title': instance.title, 'data': instance.data};

IntAdPoint _$IntAdPointFromJson(Map<String, dynamic> json) => IntAdPoint(
  firstNumber: (json['first_number'] as num?)?.toInt() ?? 0,
  point: (json['point'] as num?)?.toInt() ?? 0,
  endNumber: (json['end_number'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$IntAdPointToJson(IntAdPoint instance) =>
    <String, dynamic>{
      'first_number': instance.firstNumber,
      'point': instance.point,
      'end_number': instance.endNumber,
    };

MoneyPrize _$MoneyPrizeFromJson(Map<String, dynamic> json) => MoneyPrize(
  firstNumber: (json['first_number'] as num?)?.toInt() ?? 0,
  type: (json['type'] as num?)?.toInt() ?? 0,
  prize:
      (json['prize'] as List<dynamic>?)
          ?.map((e) => (e as num).toDouble())
          .toList() ??
      [],
  endNumber: (json['end_number'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$MoneyPrizeToJson(MoneyPrize instance) =>
    <String, dynamic>{
      'first_number': instance.firstNumber,
      'type': instance.type,
      'prize': instance.prize,
      'end_number': instance.endNumber,
    };
