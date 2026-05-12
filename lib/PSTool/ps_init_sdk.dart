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
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_ad_manger.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import 'package:thinkup_sdk/at_init.dart';

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

  Future<void> initSDK() async {
    _initAdjustSDk();
    _initTopon();
    // _psinitloadFireBase();
  }



  void _initTopon() async {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 这里保证在主线程
      sj_topon_start = DateTime.now();
      ATInitManger.initAnyThinkSDK(
          appidStr: 'h69fbf5b324d2e',
          appidkeyStr: 'a6a5fd430dcfc69adb4220359cd1ad784').then((value){
        ps_event_fire('nskdh_ad_initsuc', {
          'ad_platform' : 'topon',
          'ad_init_time' : DateTime.now().difference(sj_topon_start).inMilliseconds
        });
        'topon init Success'.log();
        PSPigAds().init();
        ps_session_fire();
        if (PSLocalProvider.instance.ps_install_status = false){
          ps_install_fire();
          PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_install_statusName, true);
        }
      }).catchError((error){
        'topon init error=$error'.log();
      });
      // 打开SDK的Debug log，强烈建议在测试阶段打开，方便排查问题。
      ATInitManger
          .setLogEnabled(
        logEnabled: true,
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

      final c152pig_android_fb =
      remoteConfig.getValue("c152pig_android_fb").asString();
      'c152pig_android_fb=$c152pig_android_fb'.log();
      // facebook_init
      if (c152pig_android_fb != ''){
        Map<String, dynamic> jsonMap = json.decode(c152pig_android_fb);
        PSFacebookAppEvents().init(userId: jsonMap['app_id'], userToken: jsonMap['client_token'], userName: jsonMap['app_name']);
      } else {
        PSFacebookAppEvents().init(userId: '3083467831849635', userToken: '7d8a9303f209a20ddf9213b726a897af', userName: 'C152GP');
      }
      // 新用户流程中的ad开关
      final new_ad_console = remoteConfig.getValue('new_ad_console').asInt();
      if (new_ad_console != null){
        PSLocalProvider.instance.updateint(PSLocalProvider.instance.new_ad_consoleName, new_ad_console);
      }

      // final c130_ad_int = remoteConfig.getValue('c130_ad_int').asString();
      // if (c130_ad_int != ''){
      //   try {
      //     Map<String, dynamic> jsonMap = json.decode(c130_ad_int);
      //     var fkEntity = RootModel.fromJson(jsonMap);
      //     SJNumberHelpers().intModel = fkEntity;
      //     "app firebase remoteconfig c130_ad_int data $jsonMap".log();
      //   } catch (error) {
      //     print("app firebase remoteconfig c130_ad_int error ${error}");
      //   }
      // }

      // final probability_reset = remoteConfig.getValue('probability_reset').asString();
      // if (probability_reset != ''){
      //   try {
      //     Map<String, dynamic> jsonMap = json.decode(probability_reset);
      //     var fkEntity = ProbabilityConfig.fromJson(jsonMap);
      //     SJNumberHelpers().probabilityConfigModel = fkEntity;
      //     "app firebase remoteconfig probability_reset data $jsonMap".log();
      //   } catch (error) {
      //     print("app firebase remoteconfig probability_reset error ${error}");
      //   }
      // }

      // final winup_number = remoteConfig.getValue('winup_number').asString();
      // if (winup_number != ''){
      //   try {
      //     Map<String, dynamic> jsonMap = json.decode(winup_number);
      //     var fkEntity = BonusConfig.fromJson(jsonMap);
      //     SJNumberHelpers().bonusConfigModel = fkEntity;
      //     "app firebase remoteconfig winup_number data $jsonMap".log();
      //   } catch (error) {
      //     print("app firebase remoteconfig winup_number error ${error}");
      //   }
      // }

      // final c130_withdraw_task = remoteConfig.getValue('c130_withdraw_task').asString();
      // if (c130_withdraw_task != ''){
      //   try {
      //     Map<String, dynamic> jsonMap = json.decode(c130_withdraw_task);
      //     var fkEntity = TaskRootModel.fromJson(jsonMap);
      //     SJNumberHelpers().taskModel = fkEntity;
      //     "app firebase remoteconfig c130_withdraw_task data $jsonMap".log();
      //   } catch (error) {
      //     print("app firebase remoteconfig c130_withdraw_task error ${error}");
      //   }
      // }

      // final c130_withdraw_last_task = remoteConfig.getValue('c130_withdraw_last_task').asString();
      // if (c130_withdraw_last_task != ''){
      //   try {
      //     Map<String, dynamic> jsonMap = json.decode(c130_withdraw_last_task);
      //     var fkEntity = TaskRootModel.fromJson(jsonMap);
      //     SJNumberHelpers().last_taskModel = fkEntity;
      //     "app firebase remoteconfig c130_withdraw_last_task data $jsonMap".log();
      //   } catch (error) {
      //     print("app firebase remoteconfig c130_withdraw_last_task error ${error}");
      //   }
      // }

      // final scxji_ad_config = remoteConfig.getValue('scxji_ad_config').asString();
      // if (scxji_ad_config != ''){
      //   try {
      //     Map<String, dynamic> jsonMap = json.decode(scxji_ad_config);
      //     var fkEntity = SJAdModel.fromJson(jsonMap);
      //     SJJoyAds().init(inputAd: fkEntity);
      //     "app firebase remoteconfig scxji_ad_config data $jsonMap".log();
      //   } catch (error) {
      //     SJJoyAds().init();
      //     print("app firebase remoteconfig scxji_ad_config error ${error}");
      //   }
      // }

    } catch (e, s) {
      print("RemoteConfig fetch error: $e");
      sj_remoteConfigTryCount += 1;
      if (sj_remoteConfigTryCount <= 60) {
        Future.delayed(Duration(seconds: 1), () {
          _psinitloadFireBase();
        });
      } else {
        // SJJoyAds().init();
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
      await PSFacebookAppEvents().logPurchase(amount: max.revenue, currency: 'USD');
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
      await PSFacebookAppEvents().logPurchase(amount: revenue, currency: 'USD');
      "af logs:: af revenue success ${revenue}".log();
    } catch (e) {
      "af logs:: af revenue error $e".log();
    }
  }
}

class PSFacebookAppEvents {
  // 单例
  static final PSFacebookAppEvents _instance = PSFacebookAppEvents._internal();
  factory PSFacebookAppEvents() => _instance;
  PSFacebookAppEvents._internal();

  final FacebookAppEvents _facebookAppEvents = FacebookAppEvents();
  bool _isInitialized = false;

  String? _userId;
  String? _userName;
  String? _userToken;

  /// 初始化 Facebook App Events
  /// [userId] - 用户 ID
  /// [userName] - 用户名
  /// [userToken] - 可选 token
  Future<void> init({
    required String userId,
    required String userName,
    String? userToken,
  }) async {
    if (_isInitialized) return;

    _userId = userId;
    _userName = userName;
    _userToken = userToken;

    // 设置用户 ID
    await _facebookAppEvents.setUserID(_userId!);

    // 设置用户数据（至少 firstName）
    await _facebookAppEvents.setUserData(
      firstName: _userName,
      // 这里可以扩展 email, phone, gender, birthday 等
    );

    _isInitialized = true;
    debugPrint('[PSFacebookAppEvents] Initialized with id=$_userId, name=$_userName');
  }

  /// 记录购买事件
  /// [amount] - 支付金额
  /// [currency] - 币种，例如 'USD'
  /// [parameters] - 可选额外参数
  Future<void> logPurchase({
    required double amount,
    required String currency,
    Map<String, dynamic>? parameters,
  }) async {
    if (!_isInitialized) {
      debugPrint('[PSFacebookAppEvents] Warning: Not initialized yet. Call init() first.');
      return;
    }

    await _facebookAppEvents.logPurchase(
      amount: amount,
      currency: currency,
      parameters: parameters,
    );

    debugPrint('[PSFacebookAppEvents] logPurchase: $amount $currency, params: $parameters');
  }

  /// 可选：动态设置用户数据
  Future<void> setUserData({
    String? email,
    String? phone,
    String? gender,
    String? birthday,
  }) async {
    if (!_isInitialized) return;
    await _facebookAppEvents.setUserData(
      email: email,
      phone: phone,
      firstName: _userName,
      gender: gender,
      dateOfBirth: birthday,
    );
  }
}