import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:init_app/utils/ads/ads_utils.dart';
import 'package:toast/toast.dart';

import '../config.dart';
import '../utils/BasePresenter.dart';
import '../utils/CallNativeUtils.dart';

class ModsDetailPresenter extends BasePresenter {
  static final String FILE = "FILE";
  var sub;
  static final String DOWNLOAD_EVENT = "DOWNLOAD_EVENT";

  void checkFileContain(data) async {
    getSink(FILE).add(new BlocLoading());
    for (int i = 0; i < data.length; i++) {
      String name = data[i]['url'];
      if (await CallNativeUtils.invokeMethod(
          method: "checkFileExit", aguments: {"path": name})) {
        data[i]["downloaded"] = true;
      } else {
        data[i]["downloaded"] = false;
      }
    }
    getSink("FILE").add(new BlocLoaded(data));
  }

  void downloadOrInstall(context, dynamic data, index, String id) async {
    if (await CallNativeUtils.invokeMethod(method: "checkMinecraft")) {
      AdsUtils().clickADs(context, 50, () {
        if (data[index]["downloaded"]) {
          String folderOut = "";
          String title = data[index]["title"];
          String url = data[index]["url"];
          if (url.contains("mcworld")) {
            CallNativeUtils.invokeMethod(
                method: "installMod",
                aguments: {"name": url, "folder": "minecraftWorlds"});
          }
          if (url.contains("mctemplate")) {
            CallNativeUtils.invokeMethod(
                method: "installMod",
                aguments: {"name": url, "folder": "world_templates"});
          }
          if (url.contains("mcaddon")) {
            CallNativeUtils.invokeMethod(
                method: "installMod",
                aguments: {"name": url, "folder": "addon"});
          }
          if (url.contains("mcpack")) {
            if (title.toLowerCase().contains("behavior")) {
              CallNativeUtils.invokeMethod(
                  method: "installMod",
                  aguments: {"name": url, "folder": "behavior_packs"});
            } else if (title.toLowerCase().contains("resource")) {
              CallNativeUtils.invokeMethod(
                  method: "installMod",
                  aguments: {"name": url, "folder": "resource_packs"});
            } else if (title.toLowerCase().contains("texture")) {
              CallNativeUtils.invokeMethod(
                  method: "installMod",
                  aguments: {"name": url, "folder": "resource_packs"});
            }
          }
        } else {
          CallNativeUtils.invokeMethod(method: "download", aguments: {
            "url": "${rootApi}/ftp/addons/$id/${data[index]["url"]}",
            "fileName": data[index]["url"]
          });
        }
      });
    } else {
      Toast.show("Minecraft is not install", context, duration: 2);
    }
  }

  onDispose() {
    super.onDispose();
    sub.cancel();
  }

  ModsDetailPresenter() {
    addStreamController("FILE");
    addStreamController(DOWNLOAD_EVENT);
    EventChannel eventChannel = new EventChannel("download");
    sub = eventChannel.receiveBroadcastStream().listen((event) {
      event = jsonDecode(event);
      if (event["name"] == "progress") {
        getSink(DOWNLOAD_EVENT).add(new BlocLoaded("${event["value"]}"));
      } else {
        baseView.updateUI("");
        getSink(DOWNLOAD_EVENT).add(new BlocLoading());
      }
    });
  }
}
