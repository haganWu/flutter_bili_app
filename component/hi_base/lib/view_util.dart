import 'package:flutter/material.dart';
import 'package:hi_base/format_util.dart';
import 'package:cached_network_image/cached_network_image.dart';

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

/// 间距
SizedBox hiSpace({double width = 1, double height = 1}) {
  return SizedBox(
    width: width,
    height: height,
  );
}

