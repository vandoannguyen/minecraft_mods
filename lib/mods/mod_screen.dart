import 'package:flutter/material.dart';
import 'package:init_app/mode_detail/mode_detail.dart';
import 'package:init_app/utils/ads/ads_utils.dart';

import '../config.dart';
import '../utils/BaseView.dart';
import '../utils/IntentAnimation.dart';

class ModScreen extends StatefulWidget {
  var keyCheck = "Mods";

  ModScreen({this.keyCheck = "Mods"});

  @override
  _ModScreenState createState() => _ModScreenState();
}

class _ModScreenState extends State<ModScreen> implements BaseView {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(widget.keyCheck),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => selectedIndex(index),
                  child: ItemMod(index),
                ),
                itemCount: isMods() ? mods.length : maps.length,
              ),
            ),
            AdsUtils().banner(context, AdsBannerSize.LARGE)
          ],
        ),
      ),
    );
  }

  Widget ItemMod(index) {
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      margin: EdgeInsets.all(5),
      child: Container(
        child: Column(
          children: [
            FadeInImage.assetNetwork(
              placeholder: imageLoading,
              image: isMods()
                  ? "${rootApi}/ftp/addons/${mods[index]["id"]}/${mods[index]["images"][0]["url"]}"
                  : "${rootApi}/ftp/addons/${maps[index]["id"]}/${maps[index]["images"][0]["url"]}",
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                isMods()
                    ? "${mods[index]["title"]}"
                    : "${maps[index]["title"]}",
              ),
            )
          ],
        ),
      ),
    );
  }

  isMods() {
    return widget.keyCheck == "Mods";
  }

  void selectedIndex(int index) {
    AdsUtils().clickADs(context, 70, () {
      IntentAnimation.intentNomal(
          context: context,
          screen: ModsDetail(
            keyCheck: widget.keyCheck,
            data: isMods() ? mods[index] : maps[index],
          ),
          option: IntentAnimationOption.RIGHT_TO_LEFT,
          duration: Duration(milliseconds: 800));
    });
  }

  @override
  void updateUI(dynamic) {
    // TODO: implement updateUI
  }
}
