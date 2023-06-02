import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';

/// 异常处理
class HiDefend {
  run(Widget app) {

    // Flutter框架异常捕获
    FlutterError.onError = (FlutterErrorDetails details) async {
      // 线上环境， 走接口上报
      if(kReleaseMode) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      } else {
        // 开发环境， 日志输出
        FlutterError.dumpErrorToConsole(details);
      }
    };

    // 非Flutter框架异常捕获
    runZonedGuarded(() {
      runApp(app);
    }, (error, stack) => _reportError(error, stack));
  }

  // 上报异常
  _reportError(Object error, StackTrace stack) {
    if (kDebugMode) {
      LogUtil.L('Exception', error.toString());
    }else{
      // 异常接口上报
      // pub.dev  -> 插件 bugly
    }
  }
}
