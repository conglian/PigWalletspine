import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';


void ps_session_fire() async {
  var baseBody = await PSRequestHelpers().baseBody();
  baseBody["chinook"] = {};
  PSRequestHelpers().post(baseBody, 2);
}

void ps_ad_fire(Map<String, dynamic> body) async {
  var baseBody = await PSRequestHelpers().baseBody();
  baseBody["braid"] = body;
  PSRequestHelpers().post(baseBody, 3);
}

void ps_event_fire(String name, Map<String, dynamic> body) async {
  var baseBodys = await PSRequestHelpers().baseBody();
  baseBodys["infima"] = name;
  baseBodys['hermetic'] = body;
  PSRequestHelpers().post(baseBodys, 0);
}

void ps_install_fire() async {
  var baseBody = await PSRequestHelpers().baseBody();
  var map = await FlutterTbaInfo.instance.getReferrerMap();
  baseBody["material"] = map['build'];
  baseBody["erode"] = map['referrer_url'];
  baseBody["lea"] = map['install_version'];
  baseBody["wile"] = map['user_agent'];
  baseBody["freight"] = 'strewn';
  baseBody["grovel"] = map['referrer_click_timestamp_seconds'];
  baseBody["doberman"] = map['install_begin_timestamp_seconds'];
  baseBody["defy"] = map['referrer_click_timestamp_server_seconds'];
  baseBody["chair"] = map['install_begin_timestamp_server_seconds'];
  baseBody["espouse"] = map['install_first_seconds'];
  baseBody["ojibwa"] = map['last_update_seconds'];
  baseBody["infima"] = 'handsome';
  PSRequestHelpers().post(baseBody, 1);
}

class PSRequestHelpers {
  static final PSRequestHelpers _instance = PSRequestHelpers._internal();

  factory PSRequestHelpers() {
    return _instance;
  }

  PSRequestHelpers._internal();

  static String cloak_Url =
      "https://actress.piggywalletspinfunpro.com/rueful/gloomy";

  static String tba_event_Url =
      "https://test-appian.piggywalletspinfunpro.com/sextet/tiresome/youth";

  // static String tba_event_Url =
  //     "https://appian.piggywalletspinfunpro.com/thrust/herschel/kochab";

  final Map<String, String> normalHeader = {
    'Content-Type': 'application/json',
  };

  Map<String, String> eventHeader = {
    'Content-Type': 'application/json',
  };

  Future<dynamic> getCloak() async {
    var url = Uri.parse("${cloak_Url}?cab=${await FlutterTbaInfo.instance.getBundleId()}&afghan=sarasota&merry=${await FlutterTbaInfo.instance.getAppVersion()}&archaic=${DateTime.now().millisecondsSinceEpoch}");
    "scratch play land config request ${url}".log();
    try {
      var response = await http.get(
        url,
        headers: normalHeader,
      );
      return _handleResponse(response);
    } catch (e) {
      "upload event [cloak] faild error $e".log();
    }
  }

  Future<dynamic> post(dynamic data, int type) async {
    var eventName = "";
    if (type == 0) {
      eventName = "event";
    } else if (type == 1) {
      eventName = "install";
    } else if (type == 2) {
      eventName = "session";
    } else {
      eventName = "ad";
    }
    var url = Uri.parse(
        "${tba_event_Url}");
    "upload event [${eventName}] url ${url} \n ${data}".log();
    try {
      var response = await http.post(
        url,
        headers: eventHeader,
        body: jsonEncode(data),
      );
      print("upload event [${eventName}] success ${response.body}");
      // "upload event [${eventName}] success ${response.body}".log();
      return _handleResponse(response);
    } catch (e) {
      "upload event [${eventName}] faild error $e".log();
      // throw Exception('Failed to perform POST request: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    } else {
      throw Exception('Request failed with status: ${response.statusCode}');
    }
  }

  void _refreshHeader() async {
    eventHeader = {
      'Content-Type': 'application/json',
    };
  }

  void init() {
    _refreshHeader();
  }


}
// request parmerters
extension RequestHelpersExtension on PSRequestHelpers {
  Future<String> getConfigQueryString() async {
    var queryBody = {
      "walter": await FlutterTbaInfo.instance.getBundleId(),
      "rancid": 'perky',
      "advise": await FlutterTbaInfo.instance.getAppVersion(),
    };
    'queryBody=$queryBody'.log();
    return Uri(queryParameters: queryBody).query;
  }

  Future<Map<String, dynamic>> baseBody() async {
    Map<String, dynamic> baseBody = {};

    Map<String, dynamic> sheppard = {
      "walter": await FlutterTbaInfo.instance.getBundleId(),
      'advise' : await FlutterTbaInfo.instance.getAppVersion(),
      "sora": await FlutterTbaInfo.instance.getLogId(),
      "digamma": await FlutterTbaInfo.instance.getDeviceModel(),
    };
    baseBody['sheppard'] = sheppard;

    Map<String, dynamic> smutty = {
      "rancid": 'perky',
      'barr' : await FlutterTbaInfo.instance.getDistinctId(),
      'plaguey' : await FlutterTbaInfo.instance.getBrand(),
      "moliere": await FlutterTbaInfo.instance.getOperator(),
      'operant' : await FlutterTbaInfo.instance.getAndroidId(),
    };
    baseBody['smutty'] = smutty;

    Map<String, dynamic> chromium = {
      'basso' : DateTime.now().millisecondsSinceEpoch,
      'glamour' : await FlutterTbaInfo.instance.getManufacturer(),
      'pyle' : await FlutterTbaInfo.instance.getOsVersion(),
      "complain": await FlutterTbaInfo.instance.getNetworkType(),
      'dyadic' : await FlutterTbaInfo.instance.getSystemLanguage(),
      "symphony": await FlutterTbaInfo.instance.getGaid(),
      'prickle' : await FlutterTbaInfo.instance.getOsCountry(),
    };
    baseBody['chromium'] = chromium;
    return baseBody;
  }

}