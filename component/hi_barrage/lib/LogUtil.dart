import 'package:flutter/foundation.dart';

class LogUtil {
  static L(String tag, String message) {
    if (kDebugMode) {
      print("$tag -- $message");
    }
  }
}
