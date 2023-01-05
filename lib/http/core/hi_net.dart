import 'package:flutter_bili_app/http/request/base_request.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';

class HiNet {
  final String tag = "HiNet";
  HiNet._();
  // 单例
  static HiNet? _install;

  static HiNet getInstance() {
    return _install ??= HiNet._();
  }

  Future fire(BaseRequest request) async{
    var response = await send(request);
    var result = response['data'];
    LogUtil.L(tag, "result: $result");
    return result;
  }

  Future<dynamic> send<T>(BaseRequest request) async{
    LogUtil.L(tag, "url: ${request.url()}");
    LogUtil.L(tag, "method: ${request.httpMethod()}");
    request.addHeader("token","123");
    LogUtil.L(tag, "header: ${request.header}");
    return Future.value({"statusCode":200,"data":{"code":0,"message":'success'}});
  }
}
