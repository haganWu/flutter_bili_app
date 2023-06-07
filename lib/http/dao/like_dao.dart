import 'package:flutter_bili_app/http/request/base_request.dart';
import 'package:flutter_bili_app/http/request/cancel_like_request.dart';
import 'package:flutter_bili_app/http/request/like_request.dart';
import 'package:hi_net/hi_net.dart';
import '../../utils/LogUtil.dart';

class LikeDao {
  static like(String vid, bool isLike) async {
    BaseRequest request = isLike ? LikeRequest() : CancelLikeRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    LogUtil.L("LikeDao", result.toString());
    return result;
  }
}
