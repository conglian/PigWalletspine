import 'dart:developer';
import 'dart:math';
import 'package:applovin_max/applovin_max.dart';
import 'package:flutter/cupertino.dart';
import 'package:piggywalletspinearn/PSTool/ps_extension_help.dart';
import '../PSDialog/PSDialog.dart';

class PSAdAHelper {
  static final PSAdAHelper _instance = PSAdAHelper._internal();

  factory PSAdAHelper() {
    return _instance;
  }

  PSAdAHelper._internal();

  String rewardOne = 'e66df9383308e49c';

  String? placeId;

  void Function(bool)? finishIntAd;

  void resetBlock() {
    finishIntAd = null;
  }

  void load() {
    if (rewardOne.length == 0) {
      "pigwalletspinearn Reward no data".log();
      return;
    }

    AppLovinMAX.setRewardedAdListener(
      RewardedAdListener(
        onAdLoadedCallback: (ad) {
          _saveCurrentAds(ad.adUnitId);
        },
        onAdLoadFailedCallback: (adUnitId, error) {
          _reLoadad(adUnitId, error.message);
        },
        onAdDisplayedCallback: (ad) async {
          // if (SJLocalProvider.instance.sj_bg_music) {
          //   SJAudioUtils().pauseBGM();
          // }
          "pigwalletspinearn Reward did display ${ad.adUnitId}".log();
        },
        onAdDisplayFailedCallback: (ad, error) {
          "pigwalletspinearn Reward did faild to display ${error.message}"
              .log();
          if (this.finishIntAd != null) {
            this.finishIntAd!(false);
          }
        },
        onAdClickedCallback: (ad) {
          "pigwalletspinearn Reward did click ${ad.adUnitId}".log();
        },
        onAdHiddenCallback: (ad) {
          // if (SJLocalProvider.instance.sj_bg_music) {
          //   SJAudioUtils().pauseBGM();
          // }
          "pigwalletspinearn Reward did hide - ${ad.adUnitId}".log();
          if (this.finishIntAd != null) {
            this.finishIntAd!(true);
          }
          load();
        },
        onAdRevenuePaidCallback: (ad) {
          "pigwalletspinearn Reward did pay ${ad.revenue} - ${ad.adUnitId}"
              .log();
          "pigwalletspinearn Int did pay finally ${ad.revenue} - ${ad.adUnitId}"
              .log();
        },
        onAdReceivedRewardCallback: (MaxAd ad, MaxReward reward) {},
      ),
    );

    if (rewardOne.length != 0) {
      "pigwalletspinearn Reward Start Load Root ${rewardOne}".log();
      AppLovinMAX.loadRewardedAd(rewardOne);
    }
  }

  void _reLoadad(String identifer, String message) {
    load();
  }

  void _saveCurrentAds(String identifer) {}

  Future<void> show(
    BuildContext content,
    void Function(bool) hasCache,
    void Function(bool)? finished,
  ) async {
    if (finished != null) {
      finishIntAd = finished;
    }

    bool isReady = (await AppLovinMAX.isRewardedAdReady(rewardOne))!;

    if (isReady) {
      AppLovinMAX.showRewardedAd(rewardOne);
      "pigwalletspinearn Reward request to show pos_id: success root ${rewardOne}"
          .log();
      hasCache(true);
      return;
    }

    "pigwalletspinearn Reward request to show no cache!}".log();
    PSDialogTool.toast(content, 'Ad Loading Failed, Please Try Again Later~');
    load();
    hasCache(false);
  }
}

extension AdRewardHelperExtension on PSAdAHelper {
  initRewardAdDatasource() {
    load();
  }
}
