import 'package:flutter/material.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';
import 'package:flutter_bili_app/widget/app_bar.dart';
import 'package:flutter_bili_app/widget/login_effect.dart';
import 'package:flutter_bili_app/widget/login_input.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final String tag = "_RegistrationPageState";
  bool protect = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar("登录", "注册", () {
        // 右边按钮点击
      }),
      body: Container(
        // 使用ListView适配小屏幕手机自适应键盘弹出防止遮挡
        child: ListView(
          children: [
            LoginEffect(protect:protect),
            LoginInput(
              title: "用户名",
              hint: "请输入用户名",
              lineStretch: true,
              onValueChanged: (text){
                LogUtil.L(tag, "onValueChanged text -> $text");
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
                LogUtil.L(tag, "onValueChanged text -> $text");
              },
            ),
          ],
        ),
      ),
    );
  }


}
