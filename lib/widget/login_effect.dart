import 'package:flutter/material.dart';

/// 登录动效
class LoginEffect extends StatefulWidget {
  final bool protect;
  const LoginEffect({Key? key, this.protect = false}) : super(key: key);

  @override
  State<LoginEffect> createState() => _LoginEffectState();
}

class _LoginEffectState extends State<LoginEffect> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        border: const Border(bottom: BorderSide(color: Color(0xFFE0E0E0)))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _image(true),
          const Image(
              height: 100,
              width: 90,
              image: AssetImage('images/logo.png')
          ),
          _image(false),
        ],
      ),
    );
  }

  _image(bool isLeft) {
    var imageRes = isLeft ? (widget.protect ? 'images/head_left_protect.png' : 'images/head_left.png') :
                             widget.protect ? 'images/head_right_protect.png' : 'images/head_right.png';
    return Image(
      height: 90,
      image: AssetImage(imageRes)
    );
  }
}
