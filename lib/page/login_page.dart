import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/dao/login_dao.dart';
import 'package:flutter_bili_app/utils/toast.dart';
import 'package:flutter_bili_app/widget/app_bar.dart';
import 'package:flutter_bili_app/widget/login_button.dart';

import '../utils/LogUtil.dart';
import '../widget/login_effect.dart';
import '../widget/login_input.dart';
/// 登录页面
class LoginPage extends StatefulWidget {
  final VoidCallback? onJumpToRegistration;
  const LoginPage({Key? key, this.onJumpToRegistration}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final String tag = "_LoginPageState";
  bool protect = false;
  bool buttonEnable = false;
  String userName = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("登录", "注册", widget.onJumpToRegistration),
      body: ListView(
        children: [
          LoginEffect(protect:protect),
          LoginInput(
            title: "用户名",
            hint: "请输入用户名",
            lineStretch: true,
            onValueChanged: (text){
              userName = text;
              checkButtonEnable();
            },
          ),
          LoginInput(
            title: "密码",
            hint: "请输入密码",
            lineStretch: true,
            focusChanged: (focus){
              setState((){
                protect = focus;
              });

            },
            obscureText: true,
            onValueChanged: (text){
              password = text;
              checkButtonEnable();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: LoginButton(title: "登录",enable: buttonEnable,onPress: send),
          )
        ],
      ),
    );
  }

  void checkButtonEnable() {
    bool enable;
    if(userName.isNotEmpty && password.isNotEmpty ){
      enable = true;
    } else {
      enable = false;
    }
    setState((){
      buttonEnable = enable;
    });
  }

  void send() async {
    var result = await LoginDao.login(userName, password);
    LogUtil.L(tag, result.toString());
    if(result["code"] == 0) {
      // TODO 跳转到首页
      showToast("Login Success");
    } else {
      showErrorToast(result["msg"]);
    }
  }

}
