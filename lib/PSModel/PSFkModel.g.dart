// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PSFkModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PSFkModel _$PSFkModelFromJson(Map<String, dynamic> json) => PSFkModel()
  ..ui = PSUIModel.fromJson(json['ui'] as Map<String, dynamic>)
  ..behavior = PSbehaviorModel.fromJson(
    json['behavior'] as Map<String, dynamic>,
  )
  ..device = (json['device'] as List<dynamic>).map((e) => e as String).toList();

Map<String, dynamic> _$PSFkModelToJson(PSFkModel instance) => <String, dynamic>{
  'ui': instance.ui,
  'behavior': instance.behavior,
  'device': instance.device,
};

PSUIModel _$PSUIModelFromJson(Map<String, dynamic> json) => PSUIModel()
  ..number = (json['number'] as num).toInt()
  ..behavior = (json['behavior'] as num).toInt()
  ..device = (json['device'] as num).toInt();

Map<String, dynamic> _$PSUIModelToJson(PSUIModel instance) => <String, dynamic>{
  'number': instance.number,
  'behavior': instance.behavior,
  'device': instance.device,
};

PSbehaviorModel _$PSbehaviorModelFromJson(Map<String, dynamic> json) =>
    PSbehaviorModel()
      ..ad_short_show = PSad_shortModel.fromJson(
        json['ad_short_show'] as Map<String, dynamic>,
      )
      ..ad_short_close = PSad_shortModel.fromJson(
        json['ad_short_close'] as Map<String, dynamic>,
      )
      ..wrong_deem_ad_less = (json['wrong_deem_ad_less'] as num).toInt()
      ..wrong_deem_ad_more = (json['wrong_deem_ad_more'] as num).toInt()
      ..no_install = (json['no_install'] as num).toInt()
      ..ad_daily_show = (json['ad_daily_show'] as num).toInt();

Map<String, dynamic> _$PSbehaviorModelToJson(PSbehaviorModel instance) =>
    <String, dynamic>{
      'ad_short_show': instance.ad_short_show,
      'ad_short_close': instance.ad_short_close,
      'wrong_deem_ad_less': instance.wrong_deem_ad_less,
      'wrong_deem_ad_more': instance.wrong_deem_ad_more,
      'no_install': instance.no_install,
      'ad_daily_show': instance.ad_daily_show,
    };

PSad_shortModel _$PSad_shortModelFromJson(Map<String, dynamic> json) =>
    PSad_shortModel()
      ..duration = (json['duration'] as num).toInt()
      ..value = (json['value'] as num).toInt();

Map<String, dynamic> _$PSad_shortModelToJson(PSad_shortModel instance) =>
    <String, dynamic>{'duration': instance.duration, 'value': instance.value};
