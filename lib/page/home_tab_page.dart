import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/constant/color.dart';
import 'package:flutter_bili_app/core/hi_state.dart';
import 'package:flutter_bili_app/http/core/hi_net_error.dart';
import 'package:flutter_bili_app/http/model/home_mo.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';
import 'package:flutter_bili_app/widget/hi_banner.dart';
import 'package:flutter_bili_app/widget/video_card.dart';
import 'package:flutter_nested/flutter_nested.dart';

import '../http/dao/home_dao.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;

  const HomeTabPage({Key? key, required this.categoryName, this.bannerList}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends HiState<HomeTabPage> with AutomaticKeepAliveClientMixin {
  final String tag = "_HomeTabPageState";
  List<VideoMo> videoList = [];
  int pageIndex = 1;
  bool loading = false;
  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      var dis = scrollController.position.maxScrollExtent - scrollController.position.pixels;
      // LogUtil.L(tag, "dis:$dis");
      // 当距离底部不足300 && 不在加载中 && 列表高度满一屏时 时加载更多
      if (dis < 300 && !loading && scrollController.position.maxScrollExtent != 0) {
        LogUtil.L(tag, "加载更多 _loadData");
        _loadData(loadMore: true);
      }
    });
    _loadData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 出去ListView上边距
    return RefreshIndicator(
      onRefresh: _loadData,
      color: primary,
      child: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: HiNestedScrollView(
              controller: scrollController,
              itemCount: videoList.length,
              padding: const EdgeInsets.only(top: 8, left: 10, right: 10),
              headers: [
                if (widget.bannerList != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: _banner(widget.bannerList!),
                  )
              ],
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.82),
              itemBuilder: (BuildContext context, int index) {
                return VideoCard(videoMo: videoList[index]);
              })),
    );
  }

  _banner(List<BannerMo> bannerList) {
    return HiBanner(bannerList: bannerList);
  }

  Future<void> _loadData({loadMore = false}) async {
    if (loading) {
      LogUtil.L(tag, "上次加载未完成...");
      return;
    }
    loading = true;
    if (!loadMore) {
      pageIndex = 1;
    }
    var currentIndex = pageIndex + (loadMore ? 1 : 0);
    LogUtil.L(tag, "currentIndex:$currentIndex");
    try {
      HomeMo result = await HomeDao.get(categoryName: widget.categoryName, pageIndex: pageIndex, pageSize: 10);
      setState(() {
        if (loadMore) {
          videoList = [...videoList, ...?result.videoList];
          if (result.videoList != null && result.videoList!.isNotEmpty) {
            pageIndex++;
          }
        } else {
          videoList = result.videoList!;
        }
      });
      Future.delayed(const Duration(milliseconds: 1000), () {
        loading = false;
      });
    } on NeedAuth catch (e) {
      loading = false;
      LogUtil.L(tag, e.toString());
    } on HiNetError catch (e) {
      loading = false;
      LogUtil.L(tag, e.toString());
    }
  }

  @override
  bool get wantKeepAlive => true;
}
