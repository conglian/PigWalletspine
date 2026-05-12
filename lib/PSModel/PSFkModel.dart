import 'package:json_annotation/json_annotation.dart';

part 'PSFkModel.g.dart';

@JsonSerializable()
class PSFkModel {
  late PSUIModel ui = PSUIModel();
  late PSbehaviorModel behavior = PSbehaviorModel();
  late List<String> device = [];
  PSFkModel();

  // 工厂构造函数，用于反序列化
  factory PSFkModel.fromJson(Map<String, dynamic> json) => _$PSFkModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$PSFkModelToJson(this);
}

@JsonSerializable()
class PSUIModel {
  late int number = 0;
  late int behavior = 0;
  late int device = 0;
  PSUIModel();

  // 工厂构造函数，用于反序列化
  factory PSUIModel.fromJson(Map<String, dynamic> json) => _$PSUIModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$PSUIModelToJson(this);
}

@JsonSerializable()
class PSbehaviorModel {
  late PSad_shortModel ad_short_show = PSad_shortModel();
  late PSad_shortModel ad_short_close = PSad_shortModel();
  late int wrong_deem_ad_less = 0;
  late int wrong_deem_ad_more = 0;
  late int no_install = 0;
  late int ad_daily_show = 0;
  PSbehaviorModel();

  // 工厂构造函数，用于反序列化
  factory PSbehaviorModel.fromJson(Map<String, dynamic> json) => _$PSbehaviorModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$PSbehaviorModelToJson(this);
}

@JsonSerializable()
class PSad_shortModel {
  late int duration = 0;
  late int value = 0;

  PSad_shortModel();

  // 工厂构造函数，用于反序列化
  factory PSad_shortModel.fromJson(Map<String, dynamic> json) => _$PSad_shortModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$PSad_shortModelToJson(this);
}