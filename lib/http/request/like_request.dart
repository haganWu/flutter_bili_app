import 'base_request.dart';
import 'package:hi_net/request/hi_base_request.dart';


class LikeRequest extends BaseRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.POST;
  }

  @override
  bool needLogin() {
    return true;
  }

  @override
  String path() {
    return '/uapi/fa/like/';
  }
}
