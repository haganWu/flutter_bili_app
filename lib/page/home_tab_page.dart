import 'package:flutter/material.dart';
import 'package:flutter_bili_app/core/hi_base_tab_state.dart';
import 'package:flutter_bili_app/http/model/home_mo.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';
import 'package:flutter_bili_app/widget/hi_banner.dart';
import 'package:flutter_bili_app/widget/video_card.dart';
import 'package:flutter_nested/flutter_nested.dart';

import '../http/dao/home_dao.dart';
import '../http/model/video_model.dart';

class HomeTabPage extends StatefulWidget {
  final String categoryName;
  final List<BannerMo>? bannerList;

  const HomeTabPage({Key? key, required this.categoryName, this.bannerList}) : super(key: key);

  @override
  State<HomeTabPage> createState() => _HomeTabPageState();
}

class _HomeTabPageState extends HiBaseTabState<HomeMo, VideoModel, HomeTabPage> {
  @override
  void initState() {
    super.initState();
    LogUtil.L(tag, "categoryName:${widget.categoryName}");
    LogUtil.L(tag, "bannerList:${widget.bannerList}");
  }

  _banner(List<BannerMo> bannerList) {
    return HiBanner(bannerList: bannerList, padding: const EdgeInsets.only(left: 5, right: 5));
  }

  @override
  bool get wantKeepAlive => true;

  @override
  get contentChild => HiNestedScrollView(
      // physics: AlwaysScrollableScrollPhysics(), 解决只有一条数据是无法上下拉刷新
      controller: scrollController,
      itemCount: dataList.length,
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
        return VideoCard(videoMo: dataList[index]);
      });

  @override
  Future<HomeMo> getData(int pageIndex) async {
    HomeMo result = await HomeDao.get(categoryName: widget.categoryName, pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(HomeMo result) {
    return result.videoList!;
  }
}
