import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bili_app/widget/hi_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'package:hi_base/color.dart';
import '../navigator/hi_navigator.dart';
import '../page/profile_page.dart';
import '../page/video_detail_page.dart';
import '../provider/theme_provider.dart';


/// 分割线
borderLine({required BuildContext context, bool bottom = true, bool top = false}) {
  var themeProvider = context.watch<ThemeProvider>();
  Color? lineColor = themeProvider.isDark() ? Colors.grey : Colors.grey[200];
  BorderSide borderSide = BorderSide(width: 0.5, color: lineColor!);
  return Border(
    bottom: bottom ? borderSide : BorderSide.none,
    top: top ? borderSide : BorderSide.none,
  );
}

///底部阴影
BoxDecoration? bottomBoxShadow(BuildContext context) {
  var themeProvider = context.watch<ThemeProvider>();
  if (themeProvider.isDark()) {
    return null;
  }
  return BoxDecoration(color: Colors.white, boxShadow: [
    BoxShadow(
        color: Colors.grey[100]!,
        offset: const Offset(0, 5), //xy轴偏移
        blurRadius: 5.0, //阴影模糊程度
        spreadRadius: 1 //阴影扩散程度
    )
  ]);
}

///修改状态栏
void changeStatusBar({Color color = Colors.white, StatusStyle statusStyle = StatusStyle.DARK_CONTENT, BuildContext? context}) {
  if (context != null) {
    //fix Tried to listen to a value exposed with provider, from outside of the widget tree.
    var themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    if (themeProvider.isDark()) {
      statusStyle = StatusStyle.LIGHT_CONTENT;
      color = HiColor.dark_bg;
    }
  }
  var page = HiNavigator.getInstance().getCurrent()?.page;
  //fix Android切换 profile页面状态栏变白问题
  if (page is ProfilePage) {
    color = Colors.transparent;
  } else if (page is VideoDetailPage) {
    color = Colors.black;
    statusStyle = StatusStyle.LIGHT_CONTENT;
  }
  //沉浸式状态栏样式
  var brightness;
  if (Platform.isIOS) {
    brightness = statusStyle == StatusStyle.LIGHT_CONTENT ? Brightness.dark : Brightness.light;
  } else {
    brightness = statusStyle == StatusStyle.LIGHT_CONTENT ? Brightness.light : Brightness.dark;
  }
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
    statusBarColor: Colors.transparent,
    statusBarBrightness: brightness,
    statusBarIconBrightness: brightness,
  ));
}
