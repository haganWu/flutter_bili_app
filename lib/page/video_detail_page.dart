import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/barrage/barrage_input.dart';
import 'package:flutter_bili_app/barrage/hi_barrage.dart';
import 'package:flutter_bili_app/http/core/hi_net_error.dart';
import 'package:flutter_bili_app/http/dao/favorite_dao.dart';
import 'package:flutter_bili_app/http/dao/like_dao.dart';
import 'package:flutter_bili_app/http/dao/video_detail_dao.dart';
import 'package:flutter_bili_app/utils/view_util.dart';
import 'package:flutter_bili_app/widget/app_bar.dart';
import 'package:flutter_bili_app/widget/expandable_content.dart';
import 'package:flutter_bili_app/widget/video_header.dart';
import 'package:flutter_bili_app/widget/video_tool_bar.dart';
import 'package:flutter_bili_app/widget/video_view.dart';
import 'package:flutter_overlay/flutter_overlay.dart';
import '../http/model/video_model.dart';
import '../utils/LogUtil.dart';
import '../utils/event_bus_util.dart';
import '../utils/toast.dart';
import '../widget/hi_navigation_bar.dart';
import '../widget/hi_tab.dart';
import 'package:flutter_bili_app/http/model/video_detail_mo.dart';

import '../widget/video_large_card.dart';

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
  List<VideoModel> videoList = [];
  final _barrageKey = GlobalKey<HiBarrageState>();
  bool _inputIsShowing = false;

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
        videoList = result.videoList!;
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
                    NavigationBarPlus(
                      color: Colors.black,
                      statusStyle: StatusStyle.LIGHT_CONTENT,
                      height: Platform.isAndroid ? 0 : 32,
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
      barrageUI: HiBarrage(
        key: _barrageKey,
        vid: model.vid!,
        autoPlay: true,
      ),
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
            _buildBarrageBtn(),
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
        ...buildRelevancyVideoList(),
      ],
    );
  }

  buildRelevancyVideoList() {
    return videoList.map((videoMo) => VideoLargeCard(videoModel: videoMo)).toList();
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

  void _onLike() async {
    try {
      var result = await LikeDao.like(videoModel.vid!, !videoDetailMo!.isLike!);
      LogUtil.L(tag, result.toString());
      if (result['code'] == 0) {
        videoDetailMo!.isLike = !videoDetailMo!.isLike!;
      }
      if (videoDetailMo!.isLike!) {
        videoModel.like += 1;
      } else {
        videoModel.like -= 1;
        if (videoModel.like < 0) {
          videoModel.like = 0;
        }
      }
      setState(() {
        videoModel = videoModel;
        videoDetailMo = videoDetailMo;
      });
      showToast(result['msg']);
    } on NeedAuth catch (e) {
      LogUtil.L(tag, e.toString());
      showErrorToast(e.message);
    } on HiNetError catch (e) {
      LogUtil.L(tag, e.toString());
      showErrorToast(e.message);
    }
  }

  void _onUnLike() {}

  void _onCoin() {}

  void _onFavorite() async {
    try {
      var result = await FavoriteDao.favorite(videoModel.vid!, !videoDetailMo!.isFavorite!);
      LogUtil.L(tag, result.toString());
      if (result['code'] == 0) {
        videoDetailMo!.isFavorite = !videoDetailMo!.isFavorite!;
        if (videoDetailMo!.isFavorite!) {
          videoModel.favorite += 1;
        } else {
          videoModel.favorite -= 1;
          if (videoModel.favorite < 0) {
            videoModel.favorite = 0;
          }
        }
        setState(() {
          videoModel = videoModel;
          videoDetailMo = videoDetailMo;
        });
        showToast(result['msg']);
        // 发送通知，收藏页面更新数据
        EventBusUtils.getInstance()?.fire("onReloadFavoriteData");
      }
    } on NeedAuth catch (e) {
      LogUtil.L(tag, e.toString());
      showErrorToast(e.message);
    } on HiNetError catch (e) {
      LogUtil.L(tag, e.toString());
      showErrorToast(e.message);
    }
  }

  void _onShare() {}

  _buildBarrageBtn() {
    return InkWell(
      onTap: () {
        HiOverlay.show(context, child: BarrageInput(onTabClose: () {
          setState(() {
            _inputIsShowing = false;
          });
        })).then((value) {
          LogUtil.L("VideoDetailPage", "输入框返回内容： $value");
          _barrageKey.currentState?.send(value ?? "");
        });
      },
      child: const Padding(
        padding: EdgeInsets.only(right: 20),
        child: Icon(
          Icons.live_tv_rounded,
          color: Colors.grey,
        ),
      ),
    );
  }
}
