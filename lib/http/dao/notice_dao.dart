import 'package:flutter_bili_app/http/core/hi_net.dart';
import 'package:flutter_bili_app/http/model/notice_mo.dart';
import 'package:flutter_bili_app/http/request/notice_request.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';

class NoticeDao {
  static noticeList({int pageIndex = 1, int pageSize = 10}) async {
    NoticeRequest request = NoticeRequest();
    request.add('pageIndex', pageIndex).add('pageSize', pageSize);
    var result = await HiNet.getInstance().fire(request);
    LogUtil.L("NoticeDao", result.toString());
    return NoticeMo.fromJson(result['data']);
  }
}
