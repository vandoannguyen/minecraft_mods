import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:init_app/mods/mod_screen.dart';
import 'package:init_app/utils/BaseView.dart';
import 'package:init_app/utils/ads/ads_utils.dart';

import '../utils/IntentAnimation.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> implements BaseView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              "assets/images/back_groundhome.png",
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              child: Column(
                children: [
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () => pressMods(context),
                          child: Container(
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/btn_guns.png",
                                  width: 100,
                                  height: 100,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Mods",
                                  style: buttonTextStyle(),
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => pressMaps(context),
                          child: Container(
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/btn_map.png",
                                  width: 100,
                                  height: 100,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Maps",
                                  style: buttonTextStyle(),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  Container(
                    child: adsBanner(),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void updateUI(dynamic) {
    // TODO: implement updateUI
  }

  buttonTextStyle() {
    return TextStyle(color: Colors.white, fontSize: 18);
  }

  void pressMaps(ctx) {
    AdsUtils().clickADs(ctx, 80, () {
      IntentAnimation.intentNomal(
          context: context,
          screen: ModScreen(keyCheck: "Maps"),
          option: IntentAnimationOption.RIGHT_TO_LEFT,
          duration: Duration(milliseconds: 800));
    });
  }

  void pressMods(ctx) {
    AdsUtils().clickADs(ctx, 80, () {
      IntentAnimation.intentNomal(
          context: context,
          screen: ModScreen(),
          option: IntentAnimationOption.RIGHT_TO_LEFT,
          duration: Duration(milliseconds: 800));
    });
  }

  adsBanner() {
    return AdsUtils().banner(context, AdsBannerSize.LARGE);
  }
}
