import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/utils/format_util.dart';
import 'package:flutter_bili_app/widget/hi_navigation_bar.dart';

Widget cachedImage({required String url, double? width, double? height}) {
  return CachedNetworkImage(
    height: height,
    width: width,
    fit: BoxFit.cover,
    placeholder: (BuildContext context, String url) => Container(color: Colors.grey[200]),
    errorWidget: (BuildContext context, String url, dynamic error) => const Icon(Icons.error),
    imageUrl: url,
  );
}

///黑色线性渐变
blackLinearGradient({bool fromTop = false}) {
  return LinearGradient(
      begin: fromTop ? Alignment.topCenter : Alignment.bottomCenter,
      end: fromTop ? Alignment.bottomCenter : Alignment.topCenter,
      colors: const [Colors.black54, Colors.black45, Colors.black38, Colors.black26, Colors.black12, Colors.transparent]);
}

void changeStatusBar({Color color = Colors.white, StatusStyle statusStyle = StatusStyle.DARK_CONTENT}) {
  // 沉浸式状态栏样式 TODO插件不止空安全，已移除
  // FlutterStatusbarManager.setColor(color, animated: false);
  // FlutterStatusbarManager.setStyle(statusStyle == StatusStyle.DARK_CONTENT ? StatusBarStyle.DARK_CONTENT : StatusBarStyle.LIGHT_CONTENT);
}

smallIconText(IconData iconData, var text) {
  var style = const TextStyle(fontSize: 12, color: Colors.grey);
  if (text is int) {
    text = countMillionFormat(text);
  }
  return [
    Icon(iconData, color: Colors.grey, size: 12),
    Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text('$text', style: style),
    ),
  ];
}
