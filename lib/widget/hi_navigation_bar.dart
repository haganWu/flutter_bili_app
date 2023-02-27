import 'package:flutter/material.dart';
import 'package:flutter_bili_app/utils/view_util.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

/// 自定义沉浸式导航栏

class HiNavigationBar extends StatefulWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget? child;

  const HiNavigationBar({Key? key, this.statusStyle = StatusStyle.DARK_CONTENT, this.color = Colors.white, this.height = 46, this.child}) : super(key: key);

  @override
  State<HiNavigationBar> createState() => _HiNavigationBarState();
}

class _HiNavigationBarState extends State<HiNavigationBar> {
  @override
  void initState() {
    super.initState();
    _statusBarInit();
  }

  @override
  Widget build(BuildContext context) {
    _statusBarInit();
    // 状态栏高度
    var top = MediaQuery.of(context).padding.top;
    if(top == 0) {
      top = 24;
    }
    return Container(
      // 屏幕宽度
      width: MediaQuery.of(context).size.width,
      height: top + widget.height,
      child: widget.child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(
        color: widget.color,
      ),
    );
  }

  void _statusBarInit() {
    // 沉浸式状态栏样式 TODO插件不止空安全，已移除
    // FlutterStatusbarManager.setColor(color, animated: false);
    // FlutterStatusbarManager.setStyle(statusStyle == StatusStyle.DARK_CONTENT ? StatusBarStyle.DARK_CONTENT : StatusBarStyle.LIGHT_CONTENT);
    changeStatusBar(color: widget.color,statusStyle: widget.statusStyle);
  }
}
