import 'package:flutter_bili_app/http/core/dio_adapter.dart';
import 'package:flutter_bili_app/http/core/hi_net_adapter.dart';
import 'package:flutter_bili_app/http/core/hi_net_error.dart';
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
    HiNetResponse? response;
    dynamic error;
    try{
      response = await send(request);
    } on HiNetError catch(e){
      error = e;
      response = e.data;
    } catch(e) {
      error = e;
      LogUtil.L(tag, e.toString());
    }
    if(response == null){
      LogUtil.L(tag, error.toString());
    }
    var result = response?.data;
    LogUtil.L(tag, "result: $result");

    int? status = response?.statusCode??-1;
    switch(status){
      case 200:
        return result;
      case 401:
        throw NeedLogin();
      case 403:
        throw NeedAuth(message: result.toString(), data: result);
      default:
        throw HiNetError(code: status, message: result?.toString()??"",data: result??"");
    }

  }

  Future<dynamic> send<T>(BaseRequest request) async{
    LogUtil.L(tag, "url: ${request.url()}");
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }
}
