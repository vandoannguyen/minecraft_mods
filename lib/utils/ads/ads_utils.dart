import 'dart:math';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:init_app/config_ads.dart';

import 'admob_ad_event.dart';
import 'fan_ad_event.dart';

enum AdsBannerSize { BANNER, MEDIUM, LARGE }

class AdsUtils {
  void clickADs(context, percent, callBack) {
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

  Widget banner(context, AdsBannerSize bannerSize) {
    if (isShowBanner) {
      if (isShowAdmob) {
        return showBannerAdmob(
            context,
            bannerSize == AdsBannerSize.BANNER
                ? AdmobBannerSize.BANNER
                : bannerSize == AdsBannerSize.MEDIUM
                    ? AdmobBannerSize.MEDIUM_RECTANGLE
                    : AdmobBannerSize.LARGE_BANNER);
      } else {
        return showBannerFan(bannerSize == AdsBannerSize.BANNER
            ? BannerSize.STANDARD
            : bannerSize == AdsBannerSize.MEDIUM
                ? BannerSize.MEDIUM_RECTANGLE
                : BannerSize.LARGE);
      }
    } else {
      return Container();
    }

    //          bannerSize: BannerSize.LARGE,
//          bannerSize: BannerSize.MEDIUM_RECTANGLE,
//          bannerSize: BannerSize.STANDARD,
  }
}
