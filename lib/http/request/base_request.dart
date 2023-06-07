import '../../utils/LogUtil.dart';
import '../../utils/hi_constants.dart';
import '../dao/login_dao.dart';
import 'hi_base_request.dart';

abstract class BaseRequest extends HiBaseRequest {


  @override
  String url() {
    if (needLogin()) {
      // 等需要登录的解接口设置登录令牌
      addHeader(LoginDao.BOARDING_PASS, LoginDao.getBoardingPass());
    }

    LogUtil.L("BaseRequest", "uri:${super.url().toString()}");
    return super.url();
  }



  @override
  Map<String, dynamic> header = {
    HiConstants.courseFlagK: HiConstants.courseFlagV,
    HiConstants.authTokenK: HiConstants.authTokenV
  };


}
