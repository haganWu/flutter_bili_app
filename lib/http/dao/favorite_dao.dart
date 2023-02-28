import 'package:flutter_bili_app/http/core/hi_net.dart';
import 'package:flutter_bili_app/http/request/base_request.dart';
import 'package:flutter_bili_app/http/request/cancel_favorite_request.dart';
import 'package:flutter_bili_app/http/request/favorite_request.dart';

import '../../utils/LogUtil.dart';

class FavoriteDao {
  static favorite(String vid, bool isFavorite) async {
    BaseRequest request = isFavorite ? FavoriteRequest() : CancelFavoriteRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    LogUtil.L("FavoriteDao", result.toString());
    return result;
  }
}
