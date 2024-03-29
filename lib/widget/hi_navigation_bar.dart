import 'package:flutter/material.dart';
import 'package:flutter_bili_app/provider/theme_provider.dart';
import 'package:hi_base/LogUtil.dart';
import 'package:provider/provider.dart';
import 'package:hi_base/color.dart';
import '../utils/view_util.dart';

enum StatusStyle { LIGHT_CONTENT, DARK_CONTENT }

///可自定义样式的沉浸式导航栏
class NavigationBarPlus extends StatefulWidget {
  final StatusStyle statusStyle;
  final Color color;
  final double height;
  final Widget? child;

  const NavigationBarPlus({Key? key, this.statusStyle = StatusStyle.DARK_CONTENT, this.color = Colors.white, this.height = 32, this.child})
      : super(key: key);

  @override
  State<NavigationBarPlus> createState() => _NavigationBarState();
}

class _NavigationBarState extends State<NavigationBarPlus> {
  late StatusStyle _statusStyle;
  late Color _color;

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    if (themeProvider.isDark()) {
      _color = HiColor.dark_bg;
      _statusStyle = StatusStyle.LIGHT_CONTENT;
    } else {
      _color = widget.color;
      _statusStyle = widget.statusStyle;
    }
    _statusBarInit();
    //状态栏高度
    var top = MediaQuery.of(context).padding.top;
    LogUtil.L('HiNavigationBar', '状态栏高度 top:${top}');
    return Container(
      width: MediaQuery.of(context).size.width,
      height: top + widget.height,
      child: widget.child,
      padding: EdgeInsets.only(top: top),
      decoration: BoxDecoration(color: _color),
    );
  }

  void _statusBarInit() {
    //沉浸式状态栏
    changeStatusBar(color: _color, statusStyle: _statusStyle);
  }
}
