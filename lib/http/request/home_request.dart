import 'package:flutter_bili_app/http/request/base_request.dart';

class HomeRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    throw HttpMethod.GET;
  }

  @override
  bool needLogin() {
    throw true;
  }

  @override
  String path() {
    return "/uapi/fa/home/";
  }
}
