import 'dart:convert';

// import 'package:anythink_sdk/at_init.dart';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_ad_revenue.dart';
import 'package:adjust_sdk/adjust_attribution.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:facebook_app_events/facebook_app_events.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_tba_info/flutter_tba_info.dart';
import 'package:piggywalletspinearn/PSTool/PSFKManger.dart';
import 'package:piggywalletspinearn/PSTool/PSNumberHelpers.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_ad_manger.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import 'package:thinkup_sdk/at_init.dart';

import '../PSModel/PSAdModel.dart';
import '../PSModel/PSFkModel.dart';
import '../PSModel/PSNumberModel.dart';
import 'PSAdAManger.dart';
import 'PSTBAEventTool.dart';

String decsgerew(String st) => utf8.decode(base64Decode(st));

class PSSDKHelpers {
  static final PSSDKHelpers _instance = PSSDKHelpers._internal();

  factory PSSDKHelpers() {
    return _instance;
  }

  PSSDKHelpers._internal();

  DateTime sj_max_start = DateTime.now();

  DateTime sj_topon_start = DateTime.now();

  int sj_remoteConfigTryCount = 0;

  bool is_ad_suc = false;

  Future<void> initSDK() async {
    _initAdjustSDk();
    _initTopon();
    _psinitloadFireBase();
  }



  void _initTopon() async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 这里保证在主线程
      sj_topon_start = DateTime.now();
      ATInitManger.initAnyThinkSDK(
          appidStr: 'h69fbf5b324d2e',
          appidkeyStr: 'a6a5fd430dcfc69adb4220359cd1ad784').then((value){
        ps_event_fire('nskdh_ad_initsuc', {
          'ad_source_client' : 'topon',
          'ad_init_time' : DateTime.now().difference(sj_topon_start).inMilliseconds
        });
        'topon init Success'.log();
        PSPigAds().init();
        ps_session_fire();
        if (PSLocalProvider.instance.ps_install_status == false){
          ps_install_fire();
          PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_install_statusName, true);
        }
      }).catchError((error){
        'topon init error=$error'.log();
      });
      // 打开SDK的Debug log，强烈建议在测试阶段打开，方便排查问题。
      ATInitManger
          .setLogEnabled(
        logEnabled: false,
      );
    });
  }

  _initAdjustSDk() async {
    const String appToken1 = 't84ar6u7tse8'; // relsease
    var disId = await FlutterTbaInfo.instance.getDistinctId();
    'disId=$disId'.log();
    Adjust.addGlobalCallbackParameter('customer_user_id', disId);
    final config = AdjustConfig(appToken1, AdjustEnvironment.production);
    config.logLevel = AdjustLogLevel.verbose;
    // 归因信息
    config.attributionCallback = (AdjustAttribution attributionChangedData) {
      print('[Adjust]: Attribution changed!');
      if (attributionChangedData.trackerToken != null) {
        print('[Adjust]: Tracker token: ${attributionChangedData.trackerToken}');
      }
      if (attributionChangedData.trackerName != null) {
        ps_event_fire('adjust_suc', {'adjust_user' : attributionChangedData.trackerName == 'Organic' ? 0 : 1});
        print('[Adjust]: Tracker name: ${attributionChangedData.trackerName}');
        if (attributionChangedData.trackerName != 'Organic'){
          ps_event_fire('organic_to_buy', {});
          // _toHome();
        }
      }
      if (attributionChangedData.campaign != null) {
        print('[Adjust]: Campaign: ${attributionChangedData.campaign}');
      }
      if (attributionChangedData.network != null) {
        print('[Adjust]: Network: ${attributionChangedData.network}');
      }
      if (attributionChangedData.creative != null) {
        print('[Adjust]: Creative: ${attributionChangedData.creative}');
      }
      if (attributionChangedData.adgroup != null) {
        print('[Adjust]: Adgroup: ${attributionChangedData.adgroup}');
      }
      if (attributionChangedData.clickLabel != null) {
        print('[Adjust]: Click label: ${attributionChangedData.clickLabel}');
      }
      if (attributionChangedData.fbInstallReferrer != null) {
        print('[Adjust]: facebook install referrer: ${attributionChangedData.fbInstallReferrer}');
      }
      if (attributionChangedData.jsonResponse != null) {
        print('[Adjust]: JSON Response: ${attributionChangedData.jsonResponse}');
      }
    };
    Adjust.initSdk(config);
    ps_event_fire('adjust_req', {});
  }

  void _psinitloadFireBase() async {
    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    "app firebase init".log();
    "app firebase loading".log();
    try {
       await remoteConfig.fetchAndActivate();

      final gp152_pig_number = remoteConfig.getValue('gp152_pig_number').asString();
      if (gp152_pig_number != ''){
        try {
          Map<String, dynamic> jsonMap = json.decode(gp152_pig_number);
          var intModel = AppConfig.fromJson(jsonMap);
          PSNumberHelpers().intModel = intModel;
          "app firebase remoteconfig gp152_pig_number data $jsonMap".log();
        } catch (error) {
          print("app firebase remoteconfig gp152_pig_number error ${error}");
        }
      }

      final nskdh_ad_config = remoteConfig.getValue('nskdh_ad_config').asString();
      if (nskdh_ad_config != ''){
        try {
          Map<String, dynamic> jsonMap = json.decode(nskdh_ad_config);
          if (is_ad_suc == false){
            is_ad_suc = true;
            PSPigAds().init(inputAd: PSAdModel.fromJson(jsonMap));
            "app firebase remoteconfig nskdh_ad_config data $jsonMap".log();
          }
        } catch (error) {
          print("app firebase remoteconfig nskdh_ad_config error ${error}");
        }
      }
       'c152pig_android_fb=默认'.log();
       PSFacebookAnalytics.init(appId: '3083467831849635', clientToken: '7d8a9303f209a20ddf9213b726a897af', appName: 'C152GP');

      final c152pig_android_fb =
      remoteConfig.getValue("c152pig_android_fb").asString();
      // facebook_init
      if (c152pig_android_fb != ''){
        "app firebase remoteconfig c152pig_android_fb data $c152pig_android_fb".log();
        Map<String, dynamic> jsonMap = json.decode(c152pig_android_fb);
        PSFacebookAnalytics.init(appId: jsonMap['app_id'], clientToken: jsonMap['client_token'], appName: jsonMap['app_name']);
      } else {
        'c152pig_android_fb=默认'.log();
        PSFacebookAnalytics.init(appId: '3083467831849635', clientToken: '7d8a9303f209a20ddf9213b726a897af', appName: 'C152GP');
      }

      // 新用户流程中的ad开关
      // 给默认值，确保不存在 Key 时不会报错
      await remoteConfig.setDefaults(<String, dynamic>{
        'new_ad_console': 0, // 默认值
      });
      int new_ad_console = remoteConfig.getValue('new_ad_console').asInt();
      if (new_ad_console != null){
        "app firebase remoteconfig new_ad_console data $new_ad_console".log();
        PSLocalProvider.instance.updateint(PSLocalProvider.instance.new_ad_consoleName, new_ad_console);
      }


      final gp152_control = remoteConfig.getValue('gp152_control').asString();
      if (gp152_control != ''){
        try {
          Map<String, dynamic> jsonMap = json.decode(gp152_control);
          var fkModel = PSFkModel.fromJson(jsonMap);
          PSFKManger().fkModel = fkModel;
          "app firebase remoteconfig gp152_control data $jsonMap".log();
        } catch (error) {
          print("app firebase remoteconfig gp152_control error ${error}");
        }
      }

      // 新用户流程中的ad开关
      // 给默认值，确保不存在 Key 时不会报错
      await remoteConfig.setDefaults(<String, dynamic>{
        'quiz_console': 5, // 默认值
      });
      int quiz_console = remoteConfig.getValue('quiz_console').asInt();
      if (quiz_console != null){
        PSLocalProvider.instance.updateint(PSLocalProvider.instance.quiz_consoleName, quiz_console);
        "app firebase remoteconfig new_ad_console data $quiz_console".log();
      }

    } catch (e, s) {
      print("RemoteConfig fetch error: $e");
      sj_remoteConfigTryCount += 1;
      if (sj_remoteConfigTryCount <= 60) {
        Future.delayed(Duration(seconds: 1), () {
          _psinitloadFireBase();
        });
      } else {
        // PSPigAds().init();
      }
    }
  }

  // 上报收入
  ps_sendAdToSdk(MaxAd max) async {
    try {
      AdjustAdRevenue adjustAdRevenue = AdjustAdRevenue('applovin_max_sdk');
      adjustAdRevenue.setRevenue(max.revenue, 'USD');
      adjustAdRevenue.adRevenueNetwork = max.networkPlacement;
      adjustAdRevenue.adRevenuePlacement = max.placement;
      Adjust.trackAdRevenue(adjustAdRevenue);
      await PSFacebookAnalytics.logPurchase( max.revenue, 'USD');
      "af logs:: af revenue success ${max.revenue}".log();
    } catch (e) {
      "af logs:: af revenue error $e".log();
    }
  }
  // 上报收入
  sj_sendintTopOnAdToSdk(Map extraMap) async {
    final revenue = extraMap["publisher_revenue"] ?? 0;
    final network = extraMap["network_name"];
    final currency = extraMap["currency"] ?? "";
    try {
      AdjustAdRevenue adjustAdRevenue = AdjustAdRevenue('topon_sdk');
      adjustAdRevenue.setRevenue(revenue, 'USD');
      adjustAdRevenue.adRevenueNetwork = network;
      Adjust.trackAdRevenue(adjustAdRevenue);
      await PSFacebookAnalytics.logPurchase(revenue, 'USD');
      "af logs:: af revenue success ${revenue}".log();
    } catch (e) {
      "af logs:: af revenue error $e".log();
    }
  }
}
class PSFacebookAnalytics {
  static final _channel = MethodChannel("com.example.piggywalletspinearn/facebook");

  /// 初始化 Facebook SDK（动态传入 appId、clientToken、appName）
  static Future<void> init({
    required String appId,
    required String clientToken,
    required String appName,
  }) async {
    'initFacebook1'.log();
    await _channel.invokeMethod("initFacebook", {
      "app_id": appId,
      "client_token": clientToken,
      "app_name": appName,
    });
    'initFacebook2'.log();
  }

  /// 购买打点（无参数）
  static Future<void> logPurchase(double amount, String currency) async {
    await _channel.invokeMethod("logPurchase", {
      "amount": amount,
      "currency": currency,
    });
  }
}