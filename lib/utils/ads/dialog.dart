import 'package:flutter/material.dart';

void onLoading(context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
          decoration: new BoxDecoration(color: Colors.white),
          child: new Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                  padding: EdgeInsets.only(right: 15.0),
                  child: new CircularProgressIndicator()),
              new Text("Loading..."),
            ],
          ),
        ),
      );
    },
  );
}

void closeDialog(context) {
  Navigator.pop(context);
}
