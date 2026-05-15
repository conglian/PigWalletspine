import 'dart:convert';
import 'dart:math';
import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_ad_revenue.dart';
import 'package:applovin_max/applovin_max.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:piggywalletspinearn/PSDialog/PSDialog.dart';
import 'package:piggywalletspinearn/PSTool/ps_LocalProvider.dart';
import 'package:piggywalletspinearn/PSTool/ps_init_sdk.dart';
import 'package:thinkup_sdk/at_interstitial.dart';
import 'package:thinkup_sdk/at_interstitial_response.dart';
import 'package:thinkup_sdk/at_listener.dart';
import 'package:thinkup_sdk/at_rewarded.dart';
import 'package:thinkup_sdk/at_rewarded_response.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import '../PSModel/PSAdModel.dart';
import '../PSPigVC/PSPigCash.dart';
import 'PSFKManger.dart';
import 'PSNumberHelpers.dart';
import 'PSTBAEventTool.dart';

Map<String, dynamic> ps_defaultAdConfig = {
  "jcyduijc": 100,
  "ewmgvdvf": 100,
  "nskdh_switch": false,
  "nskdh_int": [
    {
      "twbvgilf": "n1hb96qs9lv47j",
      "gjqlbdeg": "topon",
      "ntuoinuo": "interstitial",
      "mtnbnrsg": 3000
    }
  ],
  "nskdh_rv": [
    {
      "twbvgilf": "n1hb96qs9lusc4",
      "gjqlbdeg": "topon",
      "ntuoinuo": "reward",
      "mtnbnrsg": 3000
    }
  ]
};

class PSPigAdModel {
  String type;
  String source;

  double ecpm;
  String ad_identifer;
  int status;
  String networkName;
  String sdk;

  PSPigAdModel({
    required this.type,
    required this.source,
    required this.ecpm,
    required this.ad_identifer,
    required this.status,
    required this.networkName,
    required this.sdk,
  });

  String getTypeToServer() {
    if (type == "reward") {
      return "rv";
    } else {
      return "int";
    }
  }
}

class PSPigAds {

  static final PSPigAds _instance = PSPigAds._internal();

  factory PSPigAds() {
    return _instance;
  }

  PSPigAds._internal();

  PSAdModel? _PSPigAdModel;

  bool _pigAdDelegateCreated = false;

  String? quizAdPlaceID;

  Function(bool)? onAdClosed;
  // 保存上次播放广告时间
  DateTime? _savedTime = DateTime.now();
  // 保存上次播放到关闭广告时间
  DateTime? _savedPlayAndCloseTime;

  DateTime int_start = DateTime.now();

  DateTime read_start = DateTime.now();
  
  int _adShowed = 0;
  int _adClicked = 0;
  int adShowedToday = 0;
  double _adRevenues = 0.0;

  List<PSPigAdModel> _ads = [];
  // 测试打开，上线关闭
  final bool skipAd = true;

  Future<void> init({PSAdModel? inputAd}) async {
    _ads = [];
    "$runtimeType init ad json,remote value is $inputAd".log();
    try {
      await setAdConfigData(
        inputAdModel: inputAd ?? PSAdModel.fromJson(ps_defaultAdConfig),
      );
      _getCacheData();

      if (!_prepareRequest()) {
        return;
      }
      _requestAd();
    } catch (error) {
      "$runtimeType init ad error $error".log();
    }
  }

  void addAds(List<PSAdModellist> list) {
    for (final d in list) {
      _ads.add(
        PSPigAdModel(
          type: d.ntuoinuo,
          source: d.gjqlbdeg,
          ecpm: 0,
          ad_identifer: d.twbvgilf,
          status: 0,
          networkName: "",
          sdk: "",
        ),
      );
    }
  }

  void _getCacheData() {
    _adShowed = PSLocalProvider.instance.ps_ad_show_number;
    _adClicked =  0;
    adShowedToday =  0;
    _adRevenues = 0;
  }

  void ps_showAd(
    BuildContext context,
    String placeID, {
    required Function(bool) onCacheResponse,
    required Function(bool) adDidClosed,
    bool mustShow = false,
    bool showDialog = true,
  }) async {
    if (skipAd) {
      await setTxProgress();
      adDidClosed.call(true);
      resetHandler();
      return;
    }
    // 展示上限
    if (PSLocalProvider.instance.ps_ad_show_index > PSFKManger().fkModel.behavior.ad_daily_show){
      context.tipShow(PSPopTipsToolDialog(adStatus: .adLimit));
      onCacheResponse.call(false);
      resetHandler();
      return;
    }
    // 风控
    if (await PSFKManger().ps_checkAllStatus()){
      '风控不发起广告显示'.log();
      PSDialogTool.toast(context, 'Something went wrong, please try again later.');
      ps_event_fire('ps_fk_un', {});
      onCacheResponse.call(false);
      resetHandler();
      return;
    }

    if (someAdIsShowing()) {
      "$runtimeType ad is showing,cancel this request".log();
      return;
    }
    onAdClosed ??= adDidClosed;
    quizAdPlaceID ??= placeID;
    String adType = placeID.contains("rv") ? "rv" : "int";
    bool defaultMode = _PSPigAdModel!.nskdh_switch;
    "$runtimeType ad service request to show [$quizAdPlaceID], ad type is $adType, use mode #$defaultMode"
        .log();
    ps_event_fire('nskdh_ad_chance', {"ad_pos_id": placeID});

    if (defaultMode == false) {
      _showA(adType, onCacheResponse, context: context, showDialog: showDialog);
    } else {
      _showB(adType, onCacheResponse, context: context, showDialog: showDialog);
    }
  }

  void _showA(
    String adType,
    Function(bool) onCacheResponse, {
    BuildContext? context, bool showDialog = true,
  }) async {
    final isInt = adType == "int";
    final realType = isInt ? "interstitial" : "reward";

    final showIndex = _findShowIndex(realType, false);

    if (showIndex != -1) {
      final ad = _ads[showIndex];

      "$runtimeType prepare to show ad [A],type=$adType, id=${ad.ad_identifer}"
          .log();

      final showed = await _tryShowAd(ad, showIndex, context);
      if (showed) return;

      // show 失败兜底
      onCacheResponse(false);
      resetHandler();
      ad.status = 0;
      _requestAd(defaultIndex: [showIndex]);
      return;
    } else {
      if (context != null && showDialog == true) {
        showfaildDiolog(context);
      }
    }

    "$runtimeType prepare to show ad [A],type=$adType but no caches find!!".log();

    onCacheResponse(false);
    resetHandler();

    final notRequestingAd = _findNotRequestingAds(realType);
    if (notRequestingAd.isNotEmpty) {
      _requestAd(defaultIndex: notRequestingAd);
      return;
    }

    "$runtimeType onCacheResponse is not ready!!! error $quizAdPlaceID".log();
  }

  int _findShowIndex(String adType, bool compare) {
    int showIndex = -1;
    double bestEcpm = double.negativeInfinity;

    for (int i = 0; i < _ads.length; i++) {
      final ad = _ads[i];

      // 必须是已缓存广告
      if (ad.status != 1) continue;

      // 非 compare 模式：只选指定类型
      if (!compare && ad.type != adType) continue;

      // compare 模式下：reward 场景允许跨类型比较
      if (compare && adType != "reward" && ad.type != adType) continue;

      if (ad.ecpm > bestEcpm) {
        bestEcpm = ad.ecpm;
        showIndex = i;
      }
    }

    return showIndex;
  }

  List<int> _findNotRequestingAds(String adType) {
    final result = <int>[];
    for (int i = 0; i < _ads.length; i++) {
      if (_ads[i].status == 0 && _ads[i].type == adType) {
        result.add(i);
      }
    }
    return result;
  }

  Future<bool> _tryShowAd(
    PSPigAdModel ad,
    int index,
    BuildContext? context,
  ) async {
    if (ad.source == "max") {
      if (ad.type == "reward") {
        final ready =
            await AppLovinMAX.isRewardedAdReady(ad.ad_identifer) ?? false;
        if (!ready) return false;

        AppLovinMAX.showRewardedAd(ad.ad_identifer);
      } else {
        AppLovinMAX.showInterstitial(ad.ad_identifer);
      }
    } else {
      if (ad.type == "reward") {
        final ready = await ATRewardedManager.rewardedVideoReady(
          placementID: ad.ad_identifer,
        );
        if (!ready) return false;

        ATRewardedManager.showRewardedVideo(placementID: ad.ad_identifer);
      } else {
        ATInterstitialManager.showInterstitialAd(placementID: ad.ad_identifer);
      }
    }

    ad.status = 2;

    return true;
  }

  void _showB(
    String adType,
    Function(bool) onCacheResponse, {
    BuildContext? context,
        bool showDialog = false,
  }) async {
    final isInt = adType == "int";
    final realType = isInt ? "interstitial" : "reward";

    final showIndex = _findShowIndex(realType, true);

    if (showIndex != -1) {
      final ad = _ads[showIndex];

      "$runtimeType prepare to show ad [B],type=$adType, id=${ad.ad_identifer}"
          .log();

      final showed = await _tryShowAd(ad, showIndex, context);
      if (showed) return;

      // show 失败兜底
      onCacheResponse(false);
      resetHandler();
      ad.status = 0;
      _requestAd(defaultIndex: [showIndex]);
      return;
    } else {
      if (context != null && showDialog == true) {
        showfaildDiolog(context);
      }
    }

    "$runtimeType prepare to show ad [B],type=$adType but no caches find!!".log();

    onCacheResponse(false);
    resetHandler();

    final notRequestingAd = _findNotRequestingAds(realType);
    if (notRequestingAd.isNotEmpty) {
      _requestAd(defaultIndex: notRequestingAd);
      return;
    }

    "$runtimeType onCacheResponse is not ready!!! error $quizAdPlaceID".log();
  }

  void adImpression({required PSPigAdModel ad, required String placeID}) async {
    adRevenues(ad.ecpm);
    {
      ps_event_fire(
        "ad_impression",
        {
          "ad_pre_ecpm": ad.ecpm * 1000000,
          "ad_network": ad.networkName,
          "ad_source_client": ad.sdk,
          "ad_code_id": ad.ad_identifer,
          "ad_pos_id": placeID,
          "ad_format": ad.getTypeToServer(),
        },
      );
      ps_ad_fire({'strange' : ad.ecpm * 1000000,
                   'shiv': ad.networkName,
                   'pothole' : ad.sdk,
                   'pharmacy' : ad.ad_identifer,
                   'lenin' : placeID,
                    'buckskin' : ad.getTypeToServer()});
    }
    {
      // to sdk
      AdjustAdRevenue adjustAdRevenue = AdjustAdRevenue(ad.sdk);
      adjustAdRevenue.adRevenueNetwork = ad.networkName;
      adjustAdRevenue.setRevenue(ad.ecpm, "USD");
      adjustAdRevenue.adRevenuePlacement = placeID;
      adjustAdRevenue.adRevenueUnit = ad.ad_identifer;
      Adjust.trackAdRevenue(adjustAdRevenue);
      PSFacebookAnalytics.logPurchase(ad.ecpm, "USD");
    }

    {
      // to fb
      // SJFacebookAnalytics.logPurchase(ad.ecpm, "USD");
    }
  }

  // 显示失败弹框
  showfaildDiolog(BuildContext context) async {
    // 无网络
    bool isConnected = await NetworkUtils.isConnected();
    if (isConnected) {
      print("有网加载失败");
      context.tipShow(PSPopTipsToolDialog(adStatus: .adLoadfaild));
    } else {
      context.tipShow(PSPopTipsToolDialog(adStatus: .notWifi));
      print("设备无网络连接");
    }
  }

  void adShowed() async {
    _adShowed += 1;

    "$runtimeType ad show times $_adShowed".log();
    await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_ad_show_numberName, PSLocalProvider.instance.ps_ad_show_number + 1);
    await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_ad_all_numberName, PSLocalProvider.instance.ps_ad_all_number + 1);
    if (PSLocalProvider.instance.ps_ad_show_number % 5 == 0 && PSLocalProvider.instance.ps_ad_show_number > 0) {
      ps_event_fire(
        "cash_ad_detail",
        {
          "ad_from": PSLocalProvider.instance.ps_ad_show_number ?? "",
        },
      );
    }

    update();
  }

  void adClicked() async {
    _adClicked += 1;

    update();
  }

  int getAdShowCount() {
    return _adShowed;
  }

  void adRevenues(double revenue) {
    _adRevenues += revenue;
    update();
  }

  update() async {

  }
}

extension AdServiceExtension on PSPigAds {
  Future<void> setAdConfigData({PSAdModel? inputAdModel}) async {
    _PSPigAdModel = inputAdModel;
  }

  void _requestAd({List<int>? defaultIndex}) async {
    for (int i = 0; i < _ads.length; i++) {
      if (defaultIndex != null && !defaultIndex.contains(i)) {
        continue;
      }
      PSPigAdModel ad = _ads[i];
      int status = ad.status;
      String type = ad.type;
      String source = ad.source;
      String adID = ad.ad_identifer;

      if (status == 0) {
        if (type == "interstitial") {
          if (source == "max") {
            AppLovinMAX.loadInterstitial(adID);
          } else if (source == "topon") {
            ATInterstitialManager.loadInterstitialAd(
              placementID: adID,
              extraMap: {},
            );
          }
        } else if (type == "reward") {
          if (source == "max") {
            AppLovinMAX.loadRewardedAd(adID);
          } else {
            ATRewardedManager.loadRewardedVideo(
              placementID: adID,
              extraMap: {},
            );
          }
        }
        "$runtimeType ad requesting [start],status = $status, type is $type, source is $source, id is $adID"
            .log();
      } else if (status == 1) {
        "$runtimeType ad requesting [requesting] status = $status, type is $type, source is $source, id is $adID"
            .log();
      } else {
        "$runtimeType ad requesting [requested] status = $status, type is $type, source is $source, id is $adID"
            .log();
      }
      ps_event_fire(
        "ad_request",
        {
          "ad_code_id": adID,
          "ad_format": type,
          "ad_source_client": source,
        },
      );
    }
  }

  bool _prepareRequest() {
    if (_PSPigAdModel == null) {
      "$runtimeType request ad start,but ad model empty...".log();
      return false;
    }

    addAds(_PSPigAdModel!.nskdh_int);
    addAds(_PSPigAdModel!.nskdh_rv);
    if (_ads.isEmpty) {
      "$runtimeType request ad start,but datasource model empty...".log();
      return false;
    }

    if (!_pigAdDelegateCreated) {
      _createListener();
    }
    return true;
  }

  void _createListener() {
    _maxIntListener();
    _maxRvListener();
    _pigAdDelegateCreated = true;
  }

  void _maxIntListener() {
    AppLovinMAX.setInterstitialListener(
      InterstitialListener(
        onAdLoadedCallback: (ad) async {
          _adDidFinishLoad(maxAd: ad);
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          _adDidLoadFailed(adUnitId, error.message, 'max');
        },
        onAdDisplayedCallback: (ad) {
          _adDidDisplayed(adID: ad.adUnitId);
        },
        onAdHiddenCallback: (ad) {
          _adDidHidden(adId: ad.adUnitId);
        },
        onAdDisplayFailedCallback: (MaxAd ad, MaxError error) {
          _adDidDisplayedError(ad.adUnitId, error.message);
        },
        onAdClickedCallback: (MaxAd ad) {},
        onAdRevenuePaidCallback: (MaxAd ad) {},
      ),
    );

    ATListenerManager.interstitialEventHandler.listen((value) {
      switch (value.interstatus) {
        case InterstitialStatus.interstitialAdFailToLoadAD:
          _adDidLoadFailed(value.placementID, value.requestMessage, 'topon');
          break;
        // interstitial load finish
        case InterstitialStatus.interstitialAdDidFinishLoading:
          _adDidFinishLoad(toponInt: value);
          break;
        // interstitial play start, some AD platforms have this callback.
        case InterstitialStatus.interstitialAdDidStartPlaying:
          break;
        // interstitial play end, some AD platforms have this callback.
        case InterstitialStatus.interstitialAdDidEndPlaying:
          break;
        // interstitial play fail, some AD platforms have this callback.
        case InterstitialStatus.interstitialDidFailToPlayVideo:
          _adDidDisplayedError(value.placementID, value.requestMessage);
          break;
        // interstitial show succeed
        case InterstitialStatus.interstitialDidShowSucceed:
          _adDidDisplayed(adID: value.placementID);
          break;
        // interstitial show fail
        case InterstitialStatus.interstitialFailedToShow:
          break;
        // interstitial clicked
        case InterstitialStatus.interstitialAdDidClick:
          adClicked();
          break;
        // Deeplink
        case InterstitialStatus.interstitialAdDidDeepLink:
          break;
        // interstitial closed
        case InterstitialStatus.interstitialAdDidClose:
          _adDidHidden(adId: value.placementID);
          break;

        case InterstitialStatus.interstitialUnknown:
          break;
        case InterstitialStatus.interstitialAdDidMultipleLoaded:
        case InterstitialStatus.interstitialAdDidAdSourceBiddingAttempt:
          break;
        case InterstitialStatus.interstitialAdDidAdSourceBiddingFilled:
          break;
        case InterstitialStatus.interstitialAdDidAdSourceBiddingFail:
          break;
        case InterstitialStatus.interstitialAdDidAdSourceAttempt:
          break;
        case InterstitialStatus.interstitialAdDidAdSourceLoadFilled:
          break;
        case InterstitialStatus.interstitialAdDidAdSourceLoadFail:
          break;
      }
    });
  }

  void _maxRvListener() async {
    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
        onAdLoadedCallback: (ad) {
          _adDidFinishLoad(maxAd: ad);
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          _adDidLoadFailed(adUnitId, error.message, 'max');
        },
        onAdDisplayedCallback: (ad) {
          _adDidDisplayed(adID: ad.adUnitId);
          setTxProgress();
        },
        onAdHiddenCallback: (ad) {
          _adDidHidden(adId: ad.adUnitId);
        },
        onAdDisplayFailedCallback: (MaxAd ad, MaxError error) {
          _adDidDisplayedError(ad.adUnitId, error.message);
        },
        onAdClickedCallback: (MaxAd ad) {},
        onAdRevenuePaidCallback: (MaxAd ad) {},
        onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {},
      ),
    );

    ATListenerManager.rewardedVideoEventHandler.listen((value) {
      switch (value.rewardStatus) {
        // ad load fail
        case RewardedStatus.rewardedVideoDidFailToLoad:
          _adDidLoadFailed(value.placementID, value.requestMessage, 'topon');
          break;
        // ad load finish
        case RewardedStatus.rewardedVideoDidFinishLoading:
          _adDidFinishLoad(toponReward: value);
          break;
        // ad video start play
        case RewardedStatus.rewardedVideoDidStartPlaying:
          _adDidDisplayed(adID: value.placementID);
          setTxProgress();
          break;
        // ad video start end
        case RewardedStatus.rewardedVideoDidEndPlaying:
          break;
        // ad video fail to play
        case RewardedStatus.rewardedVideoDidFailToPlay:
          _adDidDisplayedError(value.placementID, value.requestMessage);
          break;
        // The rewarded is successful, it is recommended to issue the reward in this callback
        case RewardedStatus.rewardedVideoDidRewardSuccess:
          break;
        // ad video clicked
        case RewardedStatus.rewardedVideoDidClick:
          adClicked();
          break;
        //Deeplink
        case RewardedStatus.rewardedVideoDidDeepLink:
          break;
        case RewardedStatus.rewardedVideoDidClose:
          _adDidHidden(adId: value.placementID);
          break;
        case RewardedStatus.rewardedVideoDidAgainStartPlaying:
          break;
        // ad video again play end(only TT)
        case RewardedStatus.rewardedVideoDidAgainEndPlaying:
          break;
        // ad video again fail to play(only TT)
        case RewardedStatus.rewardedVideoDidAgainFailToPlay:
          break;
        // ad video again rewarded success(only TT)
        case RewardedStatus.rewardedVideoDidAgainRewardSuccess:
          break;
        // ad video again clicked(only TT)
        case RewardedStatus.rewardedVideoDidAgainClick:
        case RewardedStatus.rewardedVideoUnknown:
          break;
        case RewardedStatus.rewardedVideoDidMultipleLoaded:
          break;
        case RewardedStatus.rewardedVideoDidAdSourceBiddingAttempt:
          break;
        case RewardedStatus.rewardedVideoDidAdSourceBiddingFilled:
          break;
        case RewardedStatus.rewardedVideoDidAdSourceBiddingFail:
          break;
        case RewardedStatus.rewardedVideoDidAdSourceAttempt:
          break;
        case RewardedStatus.rewardedVideoDidAdSourceLoadFilled:
          break;
        case RewardedStatus.rewardedVideoDidAdSourceLoadFail:
          break;
      }
    });
  }

  void _adDidFinishLoad({
    MaxAd? maxAd,
    ATInterstitialResponse? toponInt,
    ATRewardResponse? toponReward,
  }) async {
    String adID = "";
    double revenue = 0;
    String networkName = "";
    String sdk = "";
    if (maxAd != null) {
      adID = maxAd.adUnitId;
      revenue = maxAd.revenue;
      networkName = "max";
      sdk = "applovin_max_sdk";
    }
    if (toponInt != null) {
      sdk = "topon_sdk";
      adID = toponInt.placementID;
      revenue = toponInt.extraMap["publisher_revenue"] ?? 0;
      networkName = "topon";
      String intInfo = await ATInterstitialManager.getInterstitialValidAds(
        placementID: adID,
      );
      try {
        List<dynamic> infoMap = json.decode(intInfo);
        if (infoMap.isNotEmpty) {
          Map<String, dynamic> d = infoMap.first;
          revenue = d["publisher_revenue"] ?? 0;
        }
      } catch (error) {
        "$runtimeType decode topon int info error $error".log();
      }
    }
    if (toponReward != null) {
      sdk = "topon_sdk";
      adID = toponReward.placementID;
      networkName = "topon";
      String intInfo = await ATRewardedManager.getRewardedVideoValidAds(
        placementID: adID,
      );
      try {
        List<dynamic> infoMap = json.decode(intInfo);
        if (infoMap.isNotEmpty) {
          Map<String, dynamic> d = infoMap.first;
          revenue = d["publisher_revenue"] ?? 0;
        }
      } catch (error) {
        "$runtimeType decode topon int info error $error".log();
      }
    }

    if (adID.isEmpty) {
      "$runtimeType ad did loaded but id is empty id = $adID".log();
      return;
    }

    int index = _ads.indexWhere((test) => test.ad_identifer == adID);
    if (index == -1) {
      "$runtimeType ad did loaded but cant find in ads data from id = $adID"
          .log();
      return;
    }

    _ads[index].status = 1;
    _ads[index].ecpm = revenue;
    _ads[index].networkName = networkName;
    _ads[index].sdk = sdk;
    "$runtimeType ad did load success [${_ads[index].source}] type = ${_ads[index].type} id = ${_ads[index].ad_identifer} ecpm = ${_ads[index].ecpm} network = ${_ads[index].networkName}"
        .log();
    ps_event_fire(
      "nskdh_ad_return",
       {
        "ad_code_id": _ads[index].ad_identifer,
        "ad_format": _ads[index].type == "reward" ? "rv" : "int",
        "ad_source_client": _ads[index].networkName,
        "nskdh_ad_request_time": Random().nextInt(4),
      },
    );
  }

  void _adDidLoadFailed(String adID, String reason, String type) {
    int index = _ads.indexWhere((test) => test.ad_identifer == adID);
    if (index == -1) {
      "$runtimeType ad did load failed but cant find in ads data from id = $adID"
          .log();
      return;
    }
    ps_event_fire(
      "nskdh_ad_return_fail",
      {
        "ad_code_id": quizAdPlaceID ?? "",
        "ad_format": _ads[index].getTypeToServer(),
        "ad_source_client": type,
        "reason": reason,
      },
    );
    // 延迟1s请求下一条避免出现请求频繁报错
    Future.delayed(Duration(seconds: 1),(){
      _requestAd(defaultIndex: [index]);
    });
  }

  Future<void> _adDidDisplayed({required String adID}) async {
    // if (PSLocalProvider.instance.ps_bg_music){
    //   PSAudioUtils().pauseBGM();
    // }
    _savedPlayAndCloseTime = DateTime.now();
    await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_ad_show_indexName, PSLocalProvider.instance.ps_ad_show_index + 1);
    await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_ad_all_numberName, PSLocalProvider.instance.ps_ad_all_number + 1);
    // 广告显示
    await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_ad_show_numberName, PSLocalProvider.instance.ps_ad_show_number + 1);
    int index = _ads.indexWhere((test) => test.ad_identifer == adID);
    if (index == -1) {
      "$runtimeType ad did display but cant find in ads data from id = $adID"
          .log();
      return;
    }
    _ads[index].status = 2;

    if (_ads[index].getTypeToServer() == "rv") {
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_ad_reawrd_all_numberName, PSLocalProvider.instance.ps_ad_reawrd_all_number + 1);
      // 判断两次播放间隔小于30s
      int secondsDiff = DateTime.now().difference(_savedTime!).inSeconds;
      if (secondsDiff < PSFKManger().fkModel.behavior.ad_short_show.duration && _savedTime != null){
        // 添加次数
        await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_ad_short_show_numberName, PSLocalProvider.instance.ps_ad_short_show_number + 1);
        // 大于等于次数被风控
        'PSFKManger().fkModel.behavior.ad_short_show.value=${PSFKManger().fkModel.behavior.ad_short_show.value}'.log();
        'WUUserHelpers().wu_ad_short_show_number=${PSLocalProvider.instance.ps_ad_short_show_number}'.log();
        if (PSFKManger().fkModel.behavior.ad_short_show.value <= PSLocalProvider.instance.ps_ad_short_show_number){
          ps_event_fire('risk_chance', {'risk_from' : 'ad_short_show'});
          await PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_ad_short_showName, true);
        }
      }
    }

    "$runtimeType ad did display success [${_ads[index].source}] type = ${_ads[index].type} id = ${_ads[index].ad_identifer}"
        .log();

    adShowed();
    adImpression(ad: _ads[index], placeID: quizAdPlaceID ?? "");
  }

  Future<void> setTxProgress() async {
    if (PSLocalProvider.instance.ps_tx_task_index == 2 || PSLocalProvider.instance.ps_tx_task_index == 5 || PSLocalProvider.instance.ps_tx_task_index == 8){
      await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_bubble_indexName, PSLocalProvider.instance.ps_tx_bubble_index + 1);
      Future.delayed(Duration(milliseconds: 50), () async {
        PSPigCashNotificationService.sendToQuizProgressNotification(0);
        'PSLocalProvider.instance.ps_tx_bubble_index=${PSLocalProvider.instance.ps_tx_bubble_index}'.log();
        'PSLocalProvider.instance.ps_tx_task_index=${PSLocalProvider.instance.ps_tx_task_index}'.log();
        if (PSLocalProvider.instance.ps_tx_bubble_index >= PSNumberHelpers().intModel!.tixianTask[PSLocalProvider.instance.ps_tx_task_index].data) {
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_quiz_indexName, 0);
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_wheel_indexName, 0);
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_bubble_indexName, 0);
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_task_indexName, PSLocalProvider.instance.ps_tx_task_index + 1);
          Future.delayed(Duration(milliseconds: 50), () async {
            PSPigCashNotificationService.sendToQuizProgressNotification(0);
          });
        }
      });
      // 重置任务
      Future.delayed(Duration(milliseconds: 100), () async {
        if (PSLocalProvider.instance.ps_tx_task_index + 1 >= PSNumberHelpers().intModel!.tixianTask.length){
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_quiz_indexName, 0);
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_wheel_indexName, 0);
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_bubble_indexName, 0);
          await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_tx_task_indexName, 0);
          Future.delayed(Duration(milliseconds: 50), () async {
            PSPigCashNotificationService.sendToQuizProgressNotification(0);
          });
        }
      });
    };
  }

  Future<void> _adDidHidden({required String adId}) async {
    // if (PSLocalProvider.instance.ps_bg_music){
    //   PSAudioUtils().playBGM();
    // }
    // 保存上次关闭广告时间仅限激励
    _savedTime = DateTime.now();
    int index = _ads.indexWhere((test) => test.ad_identifer == adId);
    if (index == -1) {
      "$runtimeType ad did hidden but cant find in ads data from id = $adId"
          .log();
      return;
    }
    "$runtimeType ad did hidden success id = $adId".log();
    _ads[index].status = 0;
    ps_event_fire(
      "nskdh_ad_imp_close",
      {
        "ad_pos_id": quizAdPlaceID ?? "none",
        "msg": "impsus",
        "ad_format": _ads[index].getTypeToServer(),
        "ad_code_id": _ads[index].ad_identifer,
      },
    );

    if (_ads[index].getTypeToServer() == "rv") {
      // 判断播发到关闭播放间隔小于20s
      int secondsDiff = DateTime.now().difference(_savedPlayAndCloseTime!).inSeconds;
      if (secondsDiff < PSFKManger().fkModel.behavior.ad_short_close.duration && _savedPlayAndCloseTime != null){
        // 添加次数
        await PSLocalProvider.instance.updateint(PSLocalProvider.instance.ps_ad_short_close_numberName, PSLocalProvider.instance.ps_ad_short_close_number + 1);
        // 大于等于次数被风控
        if (PSFKManger().fkModel.behavior.ad_short_close.value <= PSLocalProvider.instance.ps_ad_short_close_number){
          ps_event_fire('risk_chance', {'risk_from' : 'ad_short_close'});
          await PSLocalProvider.instance.updateBool(PSLocalProvider.instance.ps_fk_ad_short_closeName, true);
        }
      }
    }

    onAdClosed?.call(true);
    resetHandler();

    _requestAd(defaultIndex: [index]);
  }

  Future<void> _adDidDisplayedError(String adID, String errorString) async {

    int index = _ads.indexWhere((test) => test.ad_identifer == adID);

    if (index == -1) {
      "$runtimeType ad did display error but cant find in ads data from id = $adID"
          .log();
      return;
    }
    _ads[index].status = 0;
    "$runtimeType ad did display error [${_ads[index].source}] type = ${_ads[index].type} id = ${_ads[index].ad_identifer}"
        .log();

    ps_event_fire(
      "nskdh_ad_impression_fail",
      {"ad_pos_id": quizAdPlaceID ?? "", "reason": errorString},
    );

    onAdClosed?.call(false);
    resetHandler();

    _requestAd(defaultIndex: [index]);
  }

  bool findTag(List<PSAdModellist> data, String adID) {
    bool finded = false;
    for (int i = 0; i < data.length; i++) {
      if (data[i].twbvgilf == adID) {
        finded = true;
        break;
      }
    }
    return finded;
  }

  void resetHandler() {
    if (onAdClosed != null) {
      onAdClosed = null;
    }
    if (quizAdPlaceID != null) {
      quizAdPlaceID = null;
    }
  }

  bool someAdIsShowing() {
    return _ads.any((e) => e.status == 2);
  }
}

class NetworkUtils {
  /// 检查当前是否有网络连接（移动数据或Wi-Fi）
  static Future<bool> isConnected() async {
    // 获取当前网络状态
    final connectivityResult = await (Connectivity().checkConnectivity());

    // 判断是否有网络连接
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true; // 有移动数据或Wi-Fi连接
    }

    return false; // 无网络连接
  }

  /// 监听网络状态变化
  static Stream<ConnectivityResult> getNetworkChanges() {
    return Connectivity().onConnectivityChanged;
  }
}