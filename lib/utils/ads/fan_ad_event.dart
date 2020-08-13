import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:facebook_audience_network/ad/ad_native.dart';
import 'package:facebook_audience_network/ad/ad_rewarded.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:init_app/config_ads.dart';

bool isInterstitialAdLoaded = false;
bool isRewardedAdLoaded = false;
bool isRewardedVideoComplete = false;
void loadRewardedVideoAd() {
  FacebookRewardedVideoAd.loadRewardedVideoAd(
    placementId: "rewa",
    listener: (result, value) {
      print("Rewarded Ad: $result --> $value");
      if (result == RewardedVideoAdResult.LOADED) isRewardedAdLoaded = true;
      if (result == RewardedVideoAdResult.VIDEO_COMPLETE)
        isRewardedVideoComplete = true;

      /// Once a Rewarded Ad has been closed and becomes invalidated,
      /// load a fresh Ad by calling this function.
      if (result == RewardedVideoAdResult.VIDEO_CLOSED &&
          value["invalidated"] == true) {
        isRewardedAdLoaded = false;
        loadRewardedVideoAd();
      }
    },
  );
}

void showInterstitialAd(context, void callBack()) {
  FacebookInterstitialAd.loadInterstitialAd(
    placementId:
        inter_id_fan, //"IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617" YOUR_PLACEMENT_ID
    listener: (result, value) {
      print(">> FAN > Interstitial Ad: $result --> $value");
      if (result == InterstitialAdResult.LOADED) {
        FacebookInterstitialAd.showInterstitialAd();
      }
      if (result == InterstitialAdResult.ERROR) {
        Navigator.pop(context);
        callBack();
      }
      if (result == InterstitialAdResult.DISMISSED) {
        Navigator.pop(context);
        callBack();
      }
    },
  );
  // } else {
  //   callBack();
  // }
}

Widget showBannerFan(bannerSize) {
  return isShowBanner
      ? FacebookBannerAd(
          placementId: banner_id_fan, //testid

          bannerSize: bannerSize,
//          bannerSize: BannerSize.MEDIUM_RECTANGLE,
//          bannerSize: BannerSize.STANDARD,
          listener: (result, value) {
            print("Banner Ad: $result -->  $value");
          },
        )
      : Container();
}

Widget nativeBannerAd() {
  return FacebookNativeAd(
    placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964953543583512",
    adType: NativeAdType.NATIVE_BANNER_AD,
    bannerAdSize: NativeBannerAdSize.HEIGHT_50,
    width: double.infinity,
    // backgroundColor: Colors.blue,
    // titleColor: Colors.white,
    // descriptionColor: Colors.white,
    // buttonColor: Colors.deepPurple,
    // buttonTitleColor: Colors.white,
    // buttonBorderColor: Colors.white,
    listener: (result, value) {
      print("Native Banner Ad: $result --> $value");
    },
  );
}

Widget nativeAd() {
  return FacebookNativeAd(
    // placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2964952163583650",
    adType: NativeAdType.NATIVE_AD,
    width: double.infinity,
    height: 300,
    // backgroundColor: Colors.blue,
    // titleColor: Colors.white,
    // descriptionColor: Colors.white,
    // buttonColor: Colors.deepPurple,
    // buttonTitleColor: Colors.white,
    // buttonBorderColor: Colors.white,
    listener: (result, value) {
      print("Native Ad: $result --> $value");
    },
    keepExpandedWhileLoading: false,
    expandAnimationDuraion: 1000,
  );
}
