import 'package:flutter_bili_app/http/request/video_detail_request.dart';
import 'package:hi_net/hi_net.dart';
import '../../utils/LogUtil.dart';
import '../model/video_detail_mo.dart';

class VideoDetailDao {
  static get({required String vid}) async {
    VideoDetailRequest request = VideoDetailRequest();
    // path 参数
    request.pathParams = vid;
    var result = await HiNet.getInstance().fire(request);
    LogUtil.L("VideoDetailDao", result.toString());
    return VideoDetailMo.fromJson(result['data']);
  }
}
