import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:init_app/config_ads.dart';

import 'dialog.dart';
import 'fan_ad_event.dart';

AdmobInterstitial interstitialAd;
AdmobBannerSize bannerSize;

void clickADsMust(context, percent, callBack) {
  var rng = new Random();
  if (rng.nextInt(100) <= percent && isShowInter) {
    if (isShowAdmob) {
      clickAdmob(context, () {
        callBack();
      });
    } else {
      showInterstitialAd(context, () {
        callBack();
      });
    }
  } else {
    callBack();
  }
}

void clickAdmob(context, void callBack()) {
  onLoading(context);
  interstitialAd = AdmobInterstitial(
    adUnitId: inter_admob,
    listener: (AdmobAdEvent event, Map<String, dynamic> args) {
      handleEventAdmob(event, args, 'Interstitial', () {
        Navigator.pop(context);
        callBack();
      });
    },
  )..load();
}

void handleEventAdmob(AdmobAdEvent event, Map<String, dynamic> args,
    String adType, Function callBack) async {
  switch (event) {
    case AdmobAdEvent.loaded:
      interstitialAd.show();
      break;
    case AdmobAdEvent.opened:
      break;
    case AdmobAdEvent.closed:
      callBack();
      break;
    case AdmobAdEvent.failedToLoad:
      callBack();
      break;
    case AdmobAdEvent.rewarded:
      break;
    default:
  }
}

void handleEventBanner(
    AdmobAdEvent event, Map<String, dynamic> args, String adType) async {
  switch (event) {
    case AdmobAdEvent.loaded:
      break;
    case AdmobAdEvent.opened:
      break;
    case AdmobAdEvent.closed:
      break;
    case AdmobAdEvent.failedToLoad:
      break;
    case AdmobAdEvent.rewarded:
      break;
    default:
  }
}

Widget showBannerAdmob(context, bannerSize) {
  return isShowBanner
      ? Container(
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.bottomCenter,
          child: AdmobBanner(
            adUnitId: banner_admob,
            adSize: bannerSize,
            listener: (AdmobAdEvent event, Map<String, dynamic> args) {
              handleEventBanner(event, args, 'Banner');
            },
          ),
        )
      : Container();
}
