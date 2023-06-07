import 'package:dio/dio.dart';
import 'package:flutter_bili_app/http/core/hi_net_adapter.dart';
import 'package:flutter_bili_app/http/core/hi_net_error.dart';

import '../request/hi_base_request.dart';

/// 适配dio网络请求框架

class DioAdapter extends HiNetAdapter {
  @override
  Future<HiNetResponse<T>> send<T>(HiBaseRequest request) async {
    Response? response;
    Options options = Options(headers: request.header);
    DioError? error;
    try {
      if (request.httpMethod() == HttpMethod.GET) {
        response = await Dio().get(request.url(), options: options);
      } else if (request.httpMethod() == HttpMethod.POST) {
        response = await Dio()
            .post(request.url(), data: request.params, options: options);
      } else if (request.httpMethod() == HttpMethod.DELETE) {
        response = await Dio()
            .delete(request.url(), data: request.params, options: options);
      }
    } on DioError catch (e) {
      error = e;
      response = e.response;
    }
    if (error != null) {
      // 抛出HiNetError
      throw HiNetError(
          code: response?.statusCode ?? -1,
          message: error.toString(),
          data: await buildRes(response, request));//await 错误！！！！！
    }
    return buildRes(response, request);
  }

  /// 构建HiNetResponse
  Future<HiNetResponse<T>> buildRes<T>(Response? response, HiBaseRequest request) {
    return Future.value(
        HiNetResponse(
            data: response?.data,
            request: request,
            statusCode: response?.statusCode ?? -1,
            statusMessage: response?.statusMessage,
            extra: response?.extra)
    );
  }
}
