import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/core/hi_net_error.dart';
import 'package:flutter_bili_app/http/dao/video_detail_dao.dart';
import 'package:flutter_bili_app/utils/view_util.dart';
import 'package:flutter_bili_app/widget/app_bar.dart';
import 'package:flutter_bili_app/widget/expandable_content.dart';
import 'package:flutter_bili_app/widget/video_header.dart';
import 'package:flutter_bili_app/widget/video_tool_bar.dart';
import 'package:flutter_bili_app/widget/video_view.dart';
import '../http/model/video_model.dart';
import '../utils/LogUtil.dart';
import '../utils/toast.dart';
import '../widget/hi_navigation_bar.dart';
import '../widget/hi_tab.dart';
import 'package:flutter_bili_app/http/model/video_detail_mo.dart';

class VideoDetailPage extends StatefulWidget {
  final VideoModel videoMo;

  const VideoDetailPage({Key? key, required this.videoMo}) : super(key: key);

  @override
  State<VideoDetailPage> createState() => _VideoDetailPageState();
}

// TickerProviderStateMixin - tabController
class _VideoDetailPageState extends State<VideoDetailPage> with TickerProviderStateMixin {
  late TabController _controller;
  List tabs = ["简介", "评论"];
  final String tag = "VideoDetailPage";
  VideoDetailMo? videoDetailMo;
  late VideoModel videoModel;

  @override
  void initState() {
    super.initState();
    // 设置黑色状态栏-Android
    changeStatusBar(color: Colors.black, statusStyle: StatusStyle.LIGHT_CONTENT);
    _controller = TabController(length: tabs.length, vsync: this);
    videoModel = widget.videoMo;
    loadDetailData();
  }

  void loadDetailData() async {
    try {
      VideoDetailMo result = await VideoDetailDao.get(vid: videoModel.vid!);
      LogUtil.L(tag, result.toJson().toString());
      setState(() {
        videoDetailMo = result;
        videoModel = result.videoInfo!;
      });
    } on NeedAuth catch (e) {
      LogUtil.L(tag, e.toString());
      showErrorToast(e.message);
    } on HiNetError catch (e) {
      LogUtil.L(tag, e.toString());
      showErrorToast(e.message);
      setState(() {});
    }
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
          child: videoModel.url != null
              ? Column(
                  children: [
                    HiNavigationBar(
                      color: Colors.white,
                      statusStyle: StatusStyle.LIGHT_CONTENT,
                      height: Platform.isAndroid ? 0 : 28,
                      top: 30,
                    ),
                    _buildVideoView(),
                    _buildTabNavigation(),
                    Flexible(
                        child: TabBarView(
                      controller: _controller,
                      children: [_buildDetailListPage(), const Text(" 开发中...", style: TextStyle(fontSize: 18, color: Colors.lightBlue))],
                    ))
                  ],
                )
              : Container()),
    );
  }

  _buildVideoView() {
    VideoModel model = videoModel;
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
        height: 36,
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
      children: [
        ...buildContents(),
        Container(
          height: 500,
          alignment: Alignment.topLeft,
          decoration: const BoxDecoration(color: Colors.white),
          child: Text(videoDetailMo != null ? videoDetailMo!.videoInfo!.desc! : "..."),
        )
      ],
    );
  }

  buildContents() {
    return [
      VideoHeader(
        owner: videoModel.owner!,
      ),
      ExpandableContent(videoMo: videoModel),
      VideoToolBar(
        detailMo: videoDetailMo,
        videoModel: videoModel,
        onLike: _onLike,
        onUnLike: _onUnLike,
        onCoin: _onCoin,
        onFavorite: _onFavorite,
        onShare: _onShare,
      )
    ];
  }

  void _onLike() {}

  void _onUnLike() {}

  void _onCoin() {}

  void _onFavorite() {}

  void _onShare() {}
}
