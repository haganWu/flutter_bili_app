import 'package:flutter_bili_app/db/hi_cache.dart';
import 'package:flutter_bili_app/http/core/hi_net.dart';
import 'package:flutter_bili_app/http/request/base_request.dart';
import 'package:flutter_bili_app/http/request/login_request.dart';
import 'package:flutter_bili_app/http/request/registration_request.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';

class LoginDao {
  static const BOARDING_PASS = "boarding-pass";

  /// 登录接口
  static login(String userName, String password) {
    return _send(userName: userName, password: password);
  }

  /// 注册接口
  static registration(String userName, String password, String imoocId, String orderId) {
    return _send(userName: userName, password: password, imoocId: imoocId, orderId: orderId);
  }

  static _send(
      {required String userName, required String password, String? imoocId, String? orderId}) async {
    BaseRequest request;
    if (imoocId != null && orderId != null) {
      request = RegistrationRequest();
      request.add("imoocId", imoocId).add("orderId", orderId).add("courseFlag", "fa");
    } else {
      request = LoginRequest();
    }
    request.add("userName", userName).add("password", password);

    var result = await HiNet.getInstance().fire(request);
    LogUtil.L('loginDao', result.toString());
    if(result["code"] == 0 && result["data"] != null){
      // 保存登录令牌
      HiCache.getInstall().setString(BOARDING_PASS, result["data"]);
    }
    return result;
  }

  static String getBoardingPass(){
    return HiCache.getInstall().get(BOARDING_PASS)??"";
  }
}