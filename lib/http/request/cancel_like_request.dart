import 'package:flutter_bili_app/http/request/base_request.dart';

import 'like_request.dart';

class CancelLikeRequest extends LikeRequest {
  @override
  HttpMethod httpMethod() {
    return HttpMethod.DELETE;
  }
}
