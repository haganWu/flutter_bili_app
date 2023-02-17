import 'package:flutter/material.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';

import '../http/model/home_mo.dart';

class VideoCard extends StatelessWidget {
  final String tag = 'VideoCard';
  final VideoMo? videoMo;

  const VideoCard({Key? key, this.videoMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          LogUtil.L(tag, "url:${videoMo?.url}");
        },
        child: Image.network(videoMo?.cover! ?? '',fit:BoxFit.fill,),
      ),
    );
  }
}
