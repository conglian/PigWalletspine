import 'package:json_annotation/json_annotation.dart';

part 'PSAdModel.g.dart';

@JsonSerializable()
class PSAdModel {
  late int jcyduijc = 0;
  late int ewmgvdvf = 0;
  late bool nskdh_switch = false;
  late List<PSAdModellist> nskdh_int = [];
  late List<PSAdModellist> nskdh_rv = [];
  PSAdModel();

  // 工厂构造函数，用于反序列化
  factory PSAdModel.fromJson(Map<String, dynamic> json) => _$PSAdModelFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$PSAdModelToJson(this);
}

@JsonSerializable()
class PSAdModellist {
  // id
  late String twbvgilf = "";
  // type
  late String gjqlbdeg = "";
  // ad_type
  late String ntuoinuo = "";
  //
  late int mtnbnrsg = 0;
  //
  late double? ecpm = 0;

  PSAdModellist();

  // 工厂构造函数，用于反序列化
  factory PSAdModellist.fromJson(Map<String, dynamic> json) => _$PSAdModellistFromJson(json);

  // 序列化方法
  Map<String, dynamic> toJson() => _$PSAdModellistToJson(this);
}