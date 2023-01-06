import 'package:flutter_bili_app/utils/LogUtil.dart';

enum HttpMethod { GET, POST, DELETE }

/// 基础请求

abstract class BaseRequest {
  var pathParams;
  var useHttps = true;

  // 域名
  String authority() {
    return "api.devio.org";
  }

  // 请求方式
  HttpMethod httpMethod();

  // 请求短路径
  String path();

  String url() {
    Uri uri;
    var pathStr = path();
    // 拼接path参数
    if (pathParams != null) {
      if (path().endsWith("/")) {
        pathStr = "${path()}$pathParams";
      } else {
        pathStr = "${path()}/$pathParams";
      }
    }
    // http 和 Https 切换
    if (useHttps) {
      uri = Uri.https(authority(), pathStr, params);
    } else {
      uri = Uri.http(authority(), pathStr, params);
    }
    LogUtil.L("BaseRequest", "uri:${uri.toString()}");
    return uri.toString();
  }

  bool needLog();

  // 查询参数
  Map<String, String> params = {};

  //添加参数
  BaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = {
    "course-flag": "fa",
    "auth-token": "ZmEtMjAyMS0wNC0xMiAyMToyMjoyMC1mYQ==fa"
  };

  // 添加header
  BaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
