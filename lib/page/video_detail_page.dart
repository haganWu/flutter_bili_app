
import 'package:flutter/material.dart';

import '../http/model/home_mo.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoMo? videoMo;
  const VideoDetailPage({Key? key, required this.videoMo}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text("视频详情页 -> ${widget.videoMo?.vid}"),
      ),
    );
  }
}
