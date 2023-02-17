import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
