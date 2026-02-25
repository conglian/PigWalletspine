import 'dart:convert';

// import 'package:anythink_sdk/at_init.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';

import 'PSAdAManger.dart';

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
    _initAppMAX();
  }

  Future<void> _initAppMAX() async {
    // ump设置
    AppLovinMAX.setHasUserConsent(true);
    AppLovinMAX.setDoNotSell(false);

    AppLovinMAX.setCreativeDebuggerEnabled(false);
    AppLovinMAX.setVerboseLogging(false);
    "${decsgerew("TVdKemhuRVB0S3F4TA==")}"
            "${decsgerew("S1JMQWxWclR5UWZPMlZ4V1pXdFZ4X1N6VFdDX01nb1pMN2tUS050OXQzTV9PZ0laMjRuQlhSWHhWZDlvZ1FFcDc2MTZUV2YzQw==")}"
        .log();
    sj_max_start = DateTime.now();
    MaxConfiguration? configuration = await AppLovinMAX.initialize(
      "${decsgerew("TVdKemhuRVB0S3F4TA==")}"
      "${decsgerew("S1JMQWxWclR5UWZPMlZ4V1pXdFZ4X1N6VFdDX01nb1pMN2tUS050OXQzTV9PZ0laMjRuQlhSWHhWZDlvZ1FFcDc2MTZUV2YzQw==")}",
    );
    // AppLovinMAX.showMediationDebugger();
    //
    if (configuration != null) {
      PSAdAHelper().initRewardAdDatasource();
      // SJJoyAds().init();
      // sj_event_fire('scxji_ad_initsuc', {
      //   'ad_platform' : 'max',
      //   'ad_init_time' : DateTime.now().difference(sj_max_start).inMilliseconds
      // });
    }
    return;
  }

  // initAdjustSDk() async {
  //   const String appToken1 = 'r0fn8ph82874'; // relsease
  //   var disId = await FlutterTbaInfo.instance.getDistinctId();
  //   'disId=$disId'.log();
  //   Adjust.addGlobalCallbackParameter('customer_user_id', disId);
  //   final config = AdjustConfig(appToken1, AdjustEnvironment.production);
  //   config.logLevel = AdjustLogLevel.verbose;
  //   // 归因信息
  //   config.attributionCallback = (AdjustAttribution attributionChangedData) {
  //     print('[Adjust]: Attribution changed!');
  //     if (attributionChangedData.trackerToken != null) {
  //       print('[Adjust]: Tracker token: ${attributionChangedData.trackerToken}');
  //     }
  //     if (attributionChangedData.trackerName != null) {
  //       sj_event_fire('adjust_suc', {'adjust_user' : attributionChangedData.trackerName == 'Organic' ? 0 : 1});
  //       print('[Adjust]: Tracker name: ${attributionChangedData.trackerName}');
  //       if (attributionChangedData.trackerName != 'Organic'){
  //         sj_event_fire('organic_to_buy', {});
  //         _toHome();
  //       }
  //     }
  //     if (attributionChangedData.campaign != null) {
  //       print('[Adjust]: Campaign: ${attributionChangedData.campaign}');
  //     }
  //     if (attributionChangedData.network != null) {
  //       print('[Adjust]: Network: ${attributionChangedData.network}');
  //     }
  //     if (attributionChangedData.creative != null) {
  //       print('[Adjust]: Creative: ${attributionChangedData.creative}');
  //     }
  //     if (attributionChangedData.adgroup != null) {
  //       print('[Adjust]: Adgroup: ${attributionChangedData.adgroup}');
  //     }
  //     if (attributionChangedData.clickLabel != null) {
  //       print('[Adjust]: Click label: ${attributionChangedData.clickLabel}');
  //     }
  //     if (attributionChangedData.fbInstallReferrer != null) {
  //       print('[Adjust]: facebook install referrer: ${attributionChangedData.fbInstallReferrer}');
  //     }
  //     if (attributionChangedData.jsonResponse != null) {
  //       print('[Adjust]: JSON Response: ${attributionChangedData.jsonResponse}');
  //     }
  //   };
  //   Adjust.initSdk(config);
  //   sj_event_fire('adjust_req', {});
  // }

  // void _sjinitloadFireBase() async {
  //   final remoteConfig = FirebaseRemoteConfig.instance;
  //   await remoteConfig.setConfigSettings(
  //     RemoteConfigSettings(
  //       fetchTimeout: const Duration(seconds: 10),
  //       minimumFetchInterval: const Duration(hours: 1),
  //     ),
  //   );
  //   "app firebase init".log();
  //   "app firebase loading".log();
  //   try {
  //     await remoteConfig.fetchAndActivate();
  //
  //     // final scratchjoy_fb130 =
  //     // remoteConfig.getValue("c130scratchjoy_fb").asString();
  //     // 'c130scratchjoy_fb=$scratchjoy_fb130'.log();
  //     // // facebook_init
  //     // if (scratchjoy_fb130 != ''){
  //     //   Map<String, dynamic> jsonMap = json.decode(scratchjoy_fb130);
  //     //   SJFacebookAnalytics.init(appId: jsonMap['app_id'], clientToken: jsonMap['client_token'], appName: jsonMap['app_name']);
  //     // } else {
  //     //   SJFacebookAnalytics.init(appId: '', clientToken: '', appName: 'C130_GP');
  //     // }
  //
  //     final c130_ad_int = remoteConfig.getValue('c130_ad_int').asString();
  //     if (c130_ad_int != ''){
  //       try {
  //         Map<String, dynamic> jsonMap = json.decode(c130_ad_int);
  //         var fkEntity = RootModel.fromJson(jsonMap);
  //         SJNumberHelpers().intModel = fkEntity;
  //         "app firebase remoteconfig c130_ad_int data $jsonMap".log();
  //       } catch (error) {
  //         print("app firebase remoteconfig c130_ad_int error ${error}");
  //       }
  //     }
  //
  //     final probability_reset = remoteConfig.getValue('probability_reset').asString();
  //     if (probability_reset != ''){
  //       try {
  //         Map<String, dynamic> jsonMap = json.decode(probability_reset);
  //         var fkEntity = ProbabilityConfig.fromJson(jsonMap);
  //         SJNumberHelpers().probabilityConfigModel = fkEntity;
  //         "app firebase remoteconfig probability_reset data $jsonMap".log();
  //       } catch (error) {
  //         print("app firebase remoteconfig probability_reset error ${error}");
  //       }
  //     }
  //
  //     final winup_number = remoteConfig.getValue('winup_number').asString();
  //     if (winup_number != ''){
  //       try {
  //         Map<String, dynamic> jsonMap = json.decode(winup_number);
  //         var fkEntity = BonusConfig.fromJson(jsonMap);
  //         SJNumberHelpers().bonusConfigModel = fkEntity;
  //         "app firebase remoteconfig winup_number data $jsonMap".log();
  //       } catch (error) {
  //         print("app firebase remoteconfig winup_number error ${error}");
  //       }
  //     }
  //
  //     final c130_withdraw_task = remoteConfig.getValue('c130_withdraw_task').asString();
  //     if (c130_withdraw_task != ''){
  //       try {
  //         Map<String, dynamic> jsonMap = json.decode(c130_withdraw_task);
  //         var fkEntity = TaskRootModel.fromJson(jsonMap);
  //         SJNumberHelpers().taskModel = fkEntity;
  //         "app firebase remoteconfig c130_withdraw_task data $jsonMap".log();
  //       } catch (error) {
  //         print("app firebase remoteconfig c130_withdraw_task error ${error}");
  //       }
  //     }
  //
  //     final c130_withdraw_last_task = remoteConfig.getValue('c130_withdraw_last_task').asString();
  //     if (c130_withdraw_last_task != ''){
  //       try {
  //         Map<String, dynamic> jsonMap = json.decode(c130_withdraw_last_task);
  //         var fkEntity = TaskRootModel.fromJson(jsonMap);
  //         SJNumberHelpers().last_taskModel = fkEntity;
  //         "app firebase remoteconfig c130_withdraw_last_task data $jsonMap".log();
  //       } catch (error) {
  //         print("app firebase remoteconfig c130_withdraw_last_task error ${error}");
  //       }
  //     }
  //
  //     final scxji_ad_config = remoteConfig.getValue('scxji_ad_config').asString();
  //     if (scxji_ad_config != ''){
  //       try {
  //         Map<String, dynamic> jsonMap = json.decode(scxji_ad_config);
  //         var fkEntity = SJAdModel.fromJson(jsonMap);
  //         SJJoyAds().init(inputAd: fkEntity);
  //         "app firebase remoteconfig scxji_ad_config data $jsonMap".log();
  //       } catch (error) {
  //         SJJoyAds().init();
  //         print("app firebase remoteconfig scxji_ad_config error ${error}");
  //       }
  //     }
  //
  //   } catch (e, s) {
  //     print("RemoteConfig fetch error: $e");
  //     sj_remoteConfigTryCount += 1;
  //     if (sj_remoteConfigTryCount <= 60) {
  //       Future.delayed(Duration(seconds: 1), () {
  //         _sjinitloadFireBase();
  //       });
  //     } else {
  //       SJJoyAds().init();
  //     }
  //   }
  // }

  // 上报收入
  // sj_sendAdToSdk(MaxAd max) async {
  //   try {
  //     AdjustAdRevenue adjustAdRevenue = AdjustAdRevenue('applovin_max_sdk');
  //     adjustAdRevenue.setRevenue(max.revenue, 'USD');
  //     adjustAdRevenue.adRevenueNetwork = max.networkPlacement;
  //     adjustAdRevenue.adRevenuePlacement = max.placement;
  //     Adjust.trackAdRevenue(adjustAdRevenue);
  //     // await SJFacebookAnalytics.logPurchase(max.revenue, 'USD');
  //     "af logs:: af revenue success ${max.revenue}".log();
  //   } catch (e) {
  //     "af logs:: af revenue error $e".log();
  //   }
  // }
  // 上报收入
  // sj_sendintTopOnAdToSdk(Map extraMap) async {
  //   final revenue = extraMap["publisher_revenue"] ?? 0;
  //   final network = extraMap["network_name"];
  //   final currency = extraMap["currency"] ?? "";
  //   try {
  //     AdjustAdRevenue adjustAdRevenue = AdjustAdRevenue('topon_sdk');
  //     adjustAdRevenue.setRevenue(revenue, 'USD');
  //     adjustAdRevenue.adRevenueNetwork = network;
  //     Adjust.trackAdRevenue(adjustAdRevenue);
  //     // await SJFacebookAnalytics.logPurchase(revenue, 'USD');
  //     "af logs:: af revenue success ${revenue}".log();
  //   } catch (e) {
  //     "af logs:: af revenue error $e".log();
  //   }
  // }
}
