import 'base_request.dart';
import 'hi_base_request.dart';

class NoticeRequest extends BaseRequest{
  @override
  HttpMethod httpMethod() {
    return HttpMethod.GET;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return "/uapi/notice";
  }

}