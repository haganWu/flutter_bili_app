import 'package:flutter/material.dart';

import '../constant/color.dart';

/// 自定义输入框Widget
class LoginInput extends StatefulWidget {
  final String title;
  final String hint;
  final ValueChanged<String>? onValueChanged;
  final ValueChanged<bool>? focusChanged;

  // 分割线 默认false使用短线
  final bool lineStretch;

  // 是否是密码框 false默认不是密码类型
  final bool obscureText;
  final TextInputType keyboardType;

  const LoginInput({Key? key,
    this.title = "",
    this.hint = "",
    this.onValueChanged,
    this.focusChanged,
    this.lineStretch = false,
    this.obscureText = false,
    this.keyboardType = TextInputType.text})
      : super(key: key);

  @override
  State<LoginInput> createState() => _LoginInputState();
}

class _LoginInputState extends State<LoginInput> {
  final _focusNode = FocusNode();
  final String tag = "_LoginInputState";

  @override
  void initState() {
    super.initState();
    // 是否获取光标的监听
    _focusNode.addListener(() {
      if (widget.focusChanged != null) {
        widget.focusChanged!(_focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 16),
              width: 100,
              child: Text(widget.title, style: const TextStyle(fontSize: 16)),
            ),
            _input(),
          ],
        ),
        Padding(
          padding: EdgeInsets.only(left: widget.lineStretch?16:0,right: widget.lineStretch?16:0),
          child: const Divider(height: 1,thickness: 0.5,)
        )
      ],
    );
  }

  _input() {
    return Expanded(
      flex: 1,
      child: TextField(
        focusNode: _focusNode,
        onChanged: widget.onValueChanged,
        obscureText: widget.obscureText,
        keyboardType: widget.keyboardType,
        autofocus: false,//!widget.obscureText,
        cursorColor: primary,
        style: const TextStyle(fontSize: 16,color: Colors.black, fontWeight: FontWeight.w300),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 12, right: 12),
          border: InputBorder.none,
          hintText: widget.hint,
          hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
        ),
      ),
    );
  }
}
