import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/utils/format_util.dart';
import 'package:flutter_bili_app/widget/hi_navigation_bar.dart';

Widget cachedImage({required String url, double? width, double? height}) {
  return CachedNetworkImage(
    width: width,
    height: height,
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

smallIconText({required IconData iconData, required dynamic text, double iconSize = 12, double fontSize = 12, Color color = Colors.grey}) {
  var style = TextStyle(fontSize: fontSize, color: color);
  if (text is int) {
    text = countMillionFormat(text);
  }
  return [
    Icon(iconData, color: Colors.grey, size: iconSize),
    Padding(
      padding: const EdgeInsets.only(left: 2),
      child: Text('$text', style: style),
    ),
  ];
}

/// 分割线
borderLine({required BuildContext context, bool bottom = true, bool top = false}) {
  BorderSide borderSide = const BorderSide(width: 0.5, color: Color(0xFFEEEEEE));
  return Border(
    bottom: bottom ? borderSide : BorderSide.none,
    top: top ? borderSide : BorderSide.none,
  );
}

/// 间距
SizedBox hiSpace({double width = 1, double height = 1}) {
  return SizedBox(
    width: width,
    height: height,
  );
}

/// 底部阴影
BoxDecoration bottomBoxShadow() {
  return const BoxDecoration(color: Colors.white, boxShadow: [
    BoxShadow(color: Color(0xFFF5F5F5), offset: Offset(0, 5), blurRadius: 5.0, spreadRadius: 1),
  ]);
}
