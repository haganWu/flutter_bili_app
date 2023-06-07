import 'package:flutter_bili_app/http/model/profile_mo.dart';
import 'package:flutter_bili_app/http/request/profile_request.dart';
import 'package:hi_net/hi_net.dart';
import '../../utils/LogUtil.dart';

class ProfileDao {
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance().fire(request);
    LogUtil.L("ProfileDao", result.toString());
    return ProfileMo.fromJson(result['data']);
  }
}
