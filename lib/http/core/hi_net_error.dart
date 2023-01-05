/// 网络异常统一格式类
class HiNetError implements Exception{

  final int code;
  final String message;
  final dynamic data;

  HiNetError({required this.code,required this.message, this.data});

  @override
  String toString() {
    return 'HiNetError{code: $code, message: $message, data: $data}';
  }
}

/// 需要的登录的异常
class NeedLogin extends HiNetError {
  NeedLogin({int code = 401, String message = "请先登录"})
      :super(code: code, message: message);
}
/// 需要授权的异常
class NeedAuth extends HiNetError{
  NeedAuth({int code = 403, required String message,required dynamic data})
      :super(code: code,message: message,data: data);

}