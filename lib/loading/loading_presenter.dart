import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:init_app/config_ads.dart';
import 'package:init_app/utils/BaseView.dart';

import '../config.dart';
import '../home/HomeScreen.dart';
import '../utils/BasePresenter.dart';
import '../utils/IntentAnimation.dart';

class LoadingPresenter implements BasePresenter {
  @override
  BaseView baseView;
  BuildContext context;

  bool isLoadModsSuccess = false;

  bool isLoadMapsSuccess = false;

  bool isLoadAdsSucces = false;

  LoadingPresenter(context) : super() {
    this.context = context;
  }

  @override
  HashMap<String, StreamController<BlocEvent>> streamController;

  @override
  void addStreamController(k) {
    // TODO: implement addStreamController
  }

  @override
  addStreamControllerBroadcast(k) {
    // TODO: implement addStreamControllerBroadcast
    throw UnimplementedError();
  }

  @override
  Sink getSink(k) {
    // TODO: implement getSink
    throw UnimplementedError();
  }

  @override
  Stream getStream(k) {
    // TODO: implement getStream
    throw UnimplementedError();
  }

  @override
  void intiView(BaseView baseView) {
    // TODO: implement intiView
  }

  @override
  void onDispose() {
    // TODO: implement onDispose
  }

  void getListDataMods() {
    print("123456789");
    http.get("$rootApi/mods.json").then((value) {
//      print(value);
      if (value.body != "") {
        mods = jsonDecode(value.body)["maps"];
        isLoadModsSuccess = true;
        intentToMain();
      }
    }).catchError((err) {
      print(err);
    });
  }

  void getListDataMaps() {
    http.get("$rootApi/maps.json").then((value) {
      if (value.body != "") {
        maps = jsonDecode(value.body)["maps"];
        isLoadMapsSuccess = true;
        intentToMain();
      }
    }).catchError((err) {
      print(err);
    });
  }

  void getAds() {
    http.get(apiAds).then((value) {
      dynamic valueData = jsonDecode(value.body);
      banner_id_fan = valueData["ad_banner_fan_id"];
      banner_admob = valueData["ad_banner_id"];
      inter_admob = valueData["ad_inter_id"];
      inter_id_fan = valueData["ad_inter_fan_id"];
      isShowAdmob = valueData["isAdmob"];
      isShowBanner = valueData["is_show_banner"];
      isShowInter = valueData["is_show_inter"];
      isLoadAdsSucces = true;
      intentToMain();
    });
  }

  void intentToMain() {
    if (isLoadMapsSuccess && isLoadModsSuccess && isLoadAdsSucces) {
      IntentAnimation.intentPushReplacement(
          context: context,
          screen: HomePage(),
          option: IntentAnimationOption.RIGHT_TO_LEFT,
          duration: Duration(microseconds: 800));
    }
  }

  void createFolderIfNotExist() async {}
}
