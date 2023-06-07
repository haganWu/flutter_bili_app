
enum HttpMethod { GET, POST, DELETE }

/// 基础请求

abstract class HiBaseRequest {
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
    return uri.toString();
  }

  bool needLogin();

  // 查询参数
  Map<String, String> params = {};

  //添加参数
  HiBaseRequest add(String k, Object v) {
    params[k] = v.toString();
    return this;
  }

  Map<String, dynamic> header = {
  };

  // 添加header
  HiBaseRequest addHeader(String k, Object v) {
    header[k] = v.toString();
    return this;
  }
}
