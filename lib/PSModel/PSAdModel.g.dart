// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PSAdModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PSAdModel _$PSAdModelFromJson(Map<String, dynamic> json) => PSAdModel()
  ..jcyduijc = (json['jcyduijc'] as num).toInt()
  ..ewmgvdvf = (json['ewmgvdvf'] as num).toInt()
  ..nskdh_switch = json['nskdh_switch'] as bool
  ..nskdh_int = (json['nskdh_int'] as List<dynamic>)
      .map((e) => PSAdModellist.fromJson(e as Map<String, dynamic>))
      .toList()
  ..nskdh_rv = (json['nskdh_rv'] as List<dynamic>)
      .map((e) => PSAdModellist.fromJson(e as Map<String, dynamic>))
      .toList();

Map<String, dynamic> _$PSAdModelToJson(PSAdModel instance) => <String, dynamic>{
  'jcyduijc': instance.jcyduijc,
  'ewmgvdvf': instance.ewmgvdvf,
  'nskdh_switch': instance.nskdh_switch,
  'nskdh_int': instance.nskdh_int,
  'nskdh_rv': instance.nskdh_rv,
};

PSAdModellist _$PSAdModellistFromJson(Map<String, dynamic> json) =>
    PSAdModellist()
      ..twbvgilf = json['twbvgilf'] as String
      ..gjqlbdeg = json['gjqlbdeg'] as String
      ..ntuoinuo = json['ntuoinuo'] as String
      ..mtnbnrsg = (json['mtnbnrsg'] as num).toInt()
      ..ecpm = (json['ecpm'] as num?)?.toDouble();

Map<String, dynamic> _$PSAdModellistToJson(PSAdModellist instance) =>
    <String, dynamic>{
      'twbvgilf': instance.twbvgilf,
      'gjqlbdeg': instance.gjqlbdeg,
      'ntuoinuo': instance.ntuoinuo,
      'mtnbnrsg': instance.mtnbnrsg,
      'ecpm': instance.ecpm,
    };
