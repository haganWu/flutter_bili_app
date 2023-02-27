import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/utils/view_util.dart';
import 'package:flutter_bili_app/widget/app_bar.dart';
import 'package:flutter_bili_app/widget/video_view.dart';
import '../http/model/home_mo.dart';
import '../widget/hi_navigation_bar.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoMo? videoMo;

  const VideoDetailPage({Key? key, required this.videoMo}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

class _VideoDetailPageState extends State<VideoDetailPage> {
  @override
  void initState() {
    super.initState();
    // 设置黑色状态栏-Android
    changeStatusBar(color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Column(
            children: [
              HiNavigationBar(
                color: Colors.white,
                statusStyle: StatusStyle.LIGHT_CONTENT,
                height: Platform.isAndroid ? 0 : 36,
              ),
              _videoView(),
              Text('视频详情页， vid:${widget.videoMo?.vid}'),
              Text('视频详情页， title:${widget.videoMo?.title}')
            ],
          )),
    );
  }

  _videoView() {
    VideoMo model = widget.videoMo!;
    return VideoView(
      url: model.url!,
      cover: model.cover!,
      overlayUI: videoAppBar(),
    );
  }
}
