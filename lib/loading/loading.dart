import 'package:flutter/material.dart';
import 'package:init_app/loading/loading_presenter.dart';

import '../config.dart';
import '../utils/BaseView.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> implements BaseView {
  LoadingPresenter _presenter;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _presenter = new LoadingPresenter(context);
    _presenter.intiView(this);
    _presenter.getListDataMods();
    _presenter.getListDataMaps();
    _presenter.getAds();
    _presenter.createFolderIfNotExist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: Image.asset(
              imageBackgroundLoading,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Container(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Image.asset(
                        imageLoading,
                        width: 30,
                        height: 30,
                      ),
                      Text(
                        "loading...",
                        style: TextStyle(color: Color(0xFFFFFFFF)),
                      ),
                    ],
                  )))
        ],
      ),
    );
  }

  @override
  void updateUI(dynamic) {
    // TODO: implement updateUI
  }
}
