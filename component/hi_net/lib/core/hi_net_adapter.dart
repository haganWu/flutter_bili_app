import 'dart:convert';
import '../request/hi_base_request.dart';


///网络请求抽象列
abstract class HiNetAdapter {
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request);
}

/// 统一网络层返回格式
class HiNetResponse<T>{
  T data;
  HiBaseRequest? request;
  int statusCode;
  String? statusMessage;
  dynamic extra;


  HiNetResponse(
  {required this.data, this.request,required this.statusCode, this.statusMessage, this.extra});

  @override
  String toString() {
    if(data is Map){
      return json.encode(data);
    }
    return data.toString();
  }
}
