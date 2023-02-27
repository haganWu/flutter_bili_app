import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/utils/view_util.dart';
import 'package:flutter_bili_app/widget/app_bar.dart';
import 'package:flutter_bili_app/widget/video_header.dart';
import 'package:flutter_bili_app/widget/video_view.dart';
import '../http/model/home_mo.dart';
import '../widget/hi_navigation_bar.dart';
import '../widget/hi_tab.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoMo? videoMo;

  const VideoDetailPage({Key? key, required this.videoMo}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

// TickerProviderStateMixin - tabController
class _VideoDetailPageState extends State<VideoDetailPage> with TickerProviderStateMixin {
  late TabController _controller;
  List tabs = ["简介", "评论"];

  @override
  void initState() {
    super.initState();
    // 设置黑色状态栏-Android
    changeStatusBar(color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              _buildVideoView(),
              _buildTabNavigation(),
              Flexible(
                  child: TabBarView(
                controller: _controller,
                children: [
                  _buildDetailListPage(),
                  const Text(
                    "评论",
                    style: TextStyle(fontSize: 30, color: Colors.lightBlue),
                  )
                ],
              ))
            ],
          )),
    );
  }

  _buildVideoView() {
    VideoMo model = widget.videoMo!;
    return VideoView(
      url: model.url!,
      cover: model.cover!,
      overlayUI: videoAppBar(),
    );
  }

  _buildTabNavigation() {
    // 设置阴影效果
    return Material(
      elevation: 6,
      shadowColor: Colors.grey[100],
      child: Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 20),
        height: 30,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _tabBar(),
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(
                Icons.live_tv_rounded,
                color: Colors.grey,
              ),
            )
          ],
        ),
      ),
    );
  }

  _tabBar() {
    return HiTab(
        controller: _controller,
        tabs: tabs.map<Tab>((label) {
          return Tab(
            child: Padding(
              padding: const EdgeInsets.only(left: 6, right: 6),
              child: Text(
                label,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }).toList());
  }

  _buildDetailListPage() {
    return ListView(
      padding: const EdgeInsets.all(0),
      children: [...buildContents()],
    );
  }

  buildContents() {
    return [
      Container(
        child: VideoHeader(
          owner: widget.videoMo!.owner!,
        ),
      )
    ];
  }
}
