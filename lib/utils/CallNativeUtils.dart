import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CallNativeUtils {
  static var _CHANNEL;
  static MethodChannel _platform;
  static void setChannel(channel) {
    _CHANNEL = channel;
    _platform = MethodChannel(_CHANNEL);
  }

  static Future invokeMethod(
      {@required String method, dynamic aguments}) async {
    return _platform.invokeMethod(method, aguments);
  }
}
