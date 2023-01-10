import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/constant/color.dart';

class LoginButton extends StatelessWidget {
  final String title;
  final bool enable;
  final VoidCallback onPress;
  const LoginButton({Key? key, required this.title, this.enable = false, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 填充屏幕宽度
    return FractionallySizedBox(
      widthFactor: 1,
      child: MaterialButton(
        // 设置圆角
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        height: 44,
        onPressed: enable ? onPress : null,
        disabledColor: primary[50],
        color: primary,
        child: Text(title, style: const TextStyle(fontSize: 16,color: Colors.white)),
      ),
    );
  }
}
