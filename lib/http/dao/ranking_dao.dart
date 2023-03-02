import 'package:flutter_bili_app/http/request/ranking_request.dart';

import '../../utils/LogUtil.dart';
import '../core/hi_net.dart';
import '../model/ranking_mo.dart';

class RankingDao {
  static get({required String sort, int pageIndex = 1, int pageSize = 10}) async {
    RankingRequest request = RankingRequest();
    // 查询 参数
    request.add("sort", sort).add("pageIndex", pageIndex).add("pageSize", pageSize);
    var result = await HiNet.getInstance().fire(request);
    LogUtil.L("RankingDao", result.toString());
    return RankingMo.fromJson(result['data']);
  }
}