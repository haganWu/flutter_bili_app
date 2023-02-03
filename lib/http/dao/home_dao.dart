import 'package:flutter_bili_app/http/core/hi_net.dart';
import 'package:flutter_bili_app/http/model/home_mo.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';

import '../request/home_request.dart';

// https://api.devio.org/uapi/fa/home/推荐?pageIndex=1&pageSize=10
class HomeDao {
  static get({required String categoryName, int pageIndex = 1, int pageSize = 10}) async {
    HomeRequest request = HomeRequest();
    // path 参数
    request.pathParams = categoryName;
    // 查询 参数
    request.add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    LogUtil.L("homeDao", result);
    return HomeMo.fromJson(result['data']);
  }
}
