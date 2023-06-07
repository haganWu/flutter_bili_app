import 'package:hi_net/request/hi_base_request.dart';
import 'core/dio_adapter.dart';
import 'core/hi_net_adapter.dart';
import 'core/hi_net_error.dart';

class HiNet {
  final String tag = "HiNet";
  HiNet._();
  // 单例
  static HiNet? _install;

  static HiNet getInstance() {
    return _install ??= HiNet._();
  }

  Future fire(HiBaseRequest request) async{
    HiNetResponse? response;
    dynamic error;
    try{
      response = await send(request);
    } on HiNetError catch(e){
      error = e;
      response = e.data;
    } catch(e) {
      error = e;
      print("$tag -- ${e.toString()}");
    }
    if(response == null){
      print("$tag -- ${error.toString()}");
    }
    var result = response?.data;
    print("$tag -- result: $result");

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

  Future<dynamic> send<T>(HiBaseRequest request) async{
    print("$tag -- url: ${request.url()}");
    HiNetAdapter adapter = DioAdapter();
    return adapter.send(request);
  }
}
