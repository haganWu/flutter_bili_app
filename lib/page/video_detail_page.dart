
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/model/video_model.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel? videoModel;
  const VideoDetailPage({Key? key, required this.videoModel}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Text("视频详情页 -> ${widget.videoModel?.vId}"),
      ),
    );
  }
}