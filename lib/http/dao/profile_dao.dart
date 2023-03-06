import 'package:flutter_bili_app/http/core/hi_net.dart';
import 'package:flutter_bili_app/http/model/profile_mo.dart';
import 'package:flutter_bili_app/http/request/profile_request.dart';
import '../../utils/LogUtil.dart';

class ProfileDao {
  static get() async {
    ProfileRequest request = ProfileRequest();
    var result = await HiNet.getInstance().fire(request);
    LogUtil.L("ProfileDao", result.toString());
    return ProfileMo.fromJson(result['data']);
  }
}
