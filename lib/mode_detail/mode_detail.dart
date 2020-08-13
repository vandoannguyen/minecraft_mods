import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:init_app/mode_detail/mod_detail_presenter.dart';
import 'package:init_app/utils/ads/ads_utils.dart';

import '../config.dart';
import '../utils/BasePresenter.dart';
import '../utils/BaseView.dart';

class ModsDetail extends StatefulWidget {
  dynamic data;
  String keyCheck;

  ModsDetail({this.keyCheck, this.data});

  @override
  _ModsDetailState createState() => _ModsDetailState();
}

class _ModsDetailState extends State<ModsDetail> implements BaseView {
  ModsDetailPresenter _presenter;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _presenter = ModsDetailPresenter();
    _presenter.intiView(this);
    _presenter.checkFileContain(widget.data["downloads"]);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _presenter.onDispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: Text("${widget.keyCheck} detail"),
        ),
        body: Stack(children: [
          Container(
            child: Column(
              children: [
                Container(
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    child: CarouselSlider.builder(
                        itemCount: widget.data["images"].length,
                        itemBuilder: (ctx, index) => ItemSlider(index),
                        options: CarouselOptions(
                          autoPlay: true,
                          reverse: false,
                          initialPage: 0,
                          autoPlayCurve: Curves.fastOutSlowIn,
                          aspectRatio: 16 / 9,
                          viewportFraction: 0.65,
                          enlargeCenterPage: true,
                        )),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            widget.data["title"],
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            width: double.infinity,
                            child: StreamBuilder(
                              stream: _presenter
                                  .getStream(ModsDetailPresenter.FILE),
                              builder: (ctx, snap) => snap.data is BlocLoading
                                  ? Container(
                                      child: Image.asset(
                                        imageLoading,
                                        width: 40,
                                        height: 40,
                                      ),
                                    )
                                  : snap.data is BlocLoaded
                                      ? ListView.builder(
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemBuilder: (ctx, index) =>
                                              ItemDownloads(
                                                  snap.data.value, index),
                                          itemCount: snap.data.value.length,
                                        )
                                      : Container(),
                            ),
                          ),
                          Text(
                            widget.data["text"],
                            style: TextStyle(
                                color: Colors.black54,
                                fontFamily: "minecraftBool"),
                          )
                        ],
                      )),
                ),
                AdsUtils().banner(context, AdsBannerSize.LARGE)
              ],
            ),
          ),
          StreamBuilder(
            stream: _presenter.getStream(ModsDetailPresenter.DOWNLOAD_EVENT),
            builder: (ctx, snap) => snap.data is BlocLoaded
                ? Container(
                    alignment: Alignment.center,
                    color: Colors.black38,
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            new CircularProgressIndicator(),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text("downloading..."),
                                  Text(snap.data.value)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
          )
        ]));
  }

  ItemSlider(int index) {
    return Card(
      borderOnForeground: true,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8))),
      margin: EdgeInsets.only(top: 10, bottom: 10, right: 0, left: 0),
      clipBehavior: Clip.antiAlias,
      elevation: 4,
      child: Container(
        child: FadeInImage.assetNetwork(
            fit: BoxFit.fill,
            placeholder: imageLoading,
            image:
                "${rootApi}/ftp/addons/${widget.data["id"]}/${widget.data["images"][index]["url"]}"),
      ),
    );
  }

  ItemDownloads(dynamic data, index) {
    return Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data[index]["title"],
              style: TextStyle(fontSize: 11),
            ),
            Container(
              alignment: Alignment.center,
              child: FlatButton(
                padding: EdgeInsets.all(5),
                onPressed: () {
                  _presenter.downloadOrInstall(
                      context, data, index, widget.data["id"]);
                },
                child: data[index]["downloaded"] != null &&
                        data[index]["downloaded"]
                    ? Container(
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Install",
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Download",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: Text(
                data[index]["url"],
                style: TextStyle(fontSize: 10, color: Colors.black54),
              ),
            )
          ],
        ));
  }

  @override
  void updateUI(dynamic) {
    _presenter.checkFileContain(widget.data["downloads"]);
  }
}
