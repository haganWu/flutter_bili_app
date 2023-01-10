import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/dao/login_dao.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';
import 'package:flutter_bili_app/utils/toast.dart';
import 'package:flutter_bili_app/widget/app_bar.dart';
import 'package:flutter_bili_app/widget/login_effect.dart';
import 'package:flutter_bili_app/widget/login_input.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widget/login_button.dart';

class RegistrationPage extends StatefulWidget {
  final VoidCallback? onJumpToLogin;
  const RegistrationPage({Key? key, this.onJumpToLogin}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final String tag = "_RegistrationPageState";
  bool protect = false;
  bool buttonEnable = false;
  String userName = "";
  String password = "";
  String repeatPassword = "";
  String imoocId = "";
  String orderId = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("注册", "登录", widget.onJumpToLogin),
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
          LoginInput(
            title: "确认密码",
            hint: "请再次输入密码",
            lineStretch: true,
            focusChanged: (focus){
              setState((){
                protect = focus;
              });

            },
            obscureText: true,
            onValueChanged: (text){
              repeatPassword = text;
              checkButtonEnable();
            },
          ),
          LoginInput(
            title: "慕课ID",
            hint: "请输入慕课网用户ID",
            lineStretch: true,
            keyboardType: TextInputType.number,
            onValueChanged: (text){
              imoocId = text;
              checkButtonEnable();
            },
          ),
          LoginInput(
            title: "订单号",
            hint: "请输入订单号后四位",
            lineStretch: false,
            keyboardType: TextInputType.number,
            onValueChanged: (text){
              orderId = text;
              checkButtonEnable();
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
            child: LoginButton(title: "注册",enable: buttonEnable,onPress: (){
              if(checkParams()){
                send();
              }
            }),
          )
        ],
      ),
    );
  }

  void checkButtonEnable() {
    bool enable;
    if(userName.isNotEmpty && password.isNotEmpty && repeatPassword.isNotEmpty && imoocId.isNotEmpty && orderId.isNotEmpty){
      enable = true;
    } else {
      enable = false;
    }
    setState((){
      buttonEnable = enable;
    });
  }

  void send() async {
    var result = await LoginDao.registration(userName, password, imoocId, orderId);
    LogUtil.L(tag, result.toString());
    if(result["code"] == 0) {
      if(widget.onJumpToLogin != null) {
        widget.onJumpToLogin!();
      }
    } else {
      Fluttertoast.showToast(msg: result["msg"], toastLength: Toast.LENGTH_LONG);
    }
  }

  bool checkParams() {
    if(password != repeatPassword){
      showWarnToast("两次输入的密码不一致");
      return false;
    }
    if(orderId.length != 4){
      showWarnToast("请输入订单号的后四位");
      return false;
    }
    return true;
  }


}
