import 'package:flutter/material.dart';
import 'package:flutter_bili_app/widget/video_view.dart';

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
      body: Column(
        children: [
          Text('视频详情页， vid:${widget.videoMo?.vid}'),
          Text('视频详情页， title:${widget.videoMo?.title}'),
          _videoView()
        ],
      ),
    );
  }

  _videoView() {
    VideoMo model = widget.videoMo!;
    return  VideoView(url: model.url!,cover: model.cover!);
  }
}
