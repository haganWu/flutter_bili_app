import 'package:flutter_bili_app/http/model/favorite_mo.dart';
import 'package:flutter_bili_app/http/request/base_request.dart';
import 'package:flutter_bili_app/http/request/cancel_favorite_request.dart';
import 'package:flutter_bili_app/http/request/favorite_request.dart';
import 'package:hi_net/hi_net.dart';
import '../../utils/LogUtil.dart';
import '../request/favorite_list_request.dart';


class FavoriteDao {
  static favorite(String vid, bool isFavorite) async {
    BaseRequest request = isFavorite ? FavoriteRequest() : CancelFavoriteRequest();
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    LogUtil.L("FavoriteDao", result.toString());
    return result;
  }

  static favoriteList({int pageIndex = 1, int pageSize = 10}) async {
    FavoriteListRequest request = FavoriteListRequest();
    // 查询 参数
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    LogUtil.L("FavoriteDao-List", result.toString());
    return FavoriteMo.fromJson(result['data']);
  }
}
