import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/view_util.dart';

/// 弹幕输入界面
class BarrageInput extends StatelessWidget {
  final VoidCallback onTabClose;

  const BarrageInput({Key? key, required this.onTabClose}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 输入框
    TextEditingController editingController = TextEditingController();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // 空白区域点击关闭弹框
          Expanded(
              child: GestureDetector(
                onTap: () {
                  onTabClose();
                  Navigator.of(context).pop();
                },
                child: Container(
                  color: Colors.transparent,
                ),
              )),
          SafeArea(
              child: Container(
                color: Colors.white,
                child: Row(
                  children: [
                    hiSpace(width: 15),
                    _buildInput(context, editingController),
                    _buildSendBtn(context, editingController),
                  ],
                ),
              ))
        ],
      ),
    );
  }

  /// 输入框
  _buildInput(BuildContext context, TextEditingController editingController) {
    return Expanded(
        child: Container(
          decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          // 输入框
          child: TextField(
            decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.only(left: 12, right: 12, top: 6, bottom: 6),
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 13, color: Colors.grey),
                hintText: "说点什么吧"),
            autofocus: true,
            controller: editingController,
            onSubmitted: (value) {
              _send(context, value);
            },
            cursorColor: primary,
          ),
        ));
  }

  /// 发送按钮
  _buildSendBtn(BuildContext context, TextEditingController editingController) {
    return InkWell(
      onTap: () {
        _send(context, editingController.text.trim());
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: const Icon(
          Icons.send_rounded,
          color: Colors.grey,
        ),
      ),
    );
  }

  /// 发送弹幕
  void _send(BuildContext context, String text) {
    if (text.isNotEmpty) {
      // 发送消息时关闭弹窗
      onTabClose();
      Navigator.pop(context, text);
    }
  }
}
