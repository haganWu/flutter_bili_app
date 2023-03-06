import 'package:flutter/material.dart';
import 'package:flutter_bili_app/core/hi_base_tab_state.dart';
import 'package:flutter_bili_app/http/dao/favorite_dao.dart';
import 'package:flutter_bili_app/http/model/favorite_mo.dart';
import 'package:flutter_bili_app/http/model/video_model.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:flutter_bili_app/page/video_detail_page.dart';

import '../utils/LogUtil.dart';
import '../utils/view_util.dart';
import '../widget/hi_navigation_bar.dart';
import '../widget/video_large_card.dart';

/// 收藏
class FavoritePage extends StatefulWidget {
  const FavoritePage({Key? key}) : super(key: key);

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends HiBaseTabState<FavoriteMo, VideoModel, FavoritePage> {
  late RouteChangeListener listener;

  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(listener = (RouteStatusInfo current, RouteStatusInfo? pre) {
      LogUtil.L("FavoritePage&&&&&&&&", "current:${current.page}, pre:${pre?.page}");
      if (pre?.page is VideoDetailPage && current.page is FavoritePage) {
        loadData();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [_buildNavigationBar(), Expanded(child: super.build(context))],
    );
  }

  _buildNavigationBar() {
    return NavigationBarPlus(
      child: Container(
        decoration: bottomBoxShadow(context),
        alignment: Alignment.center,
        child: const Text('收藏', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(listener);
    super.dispose();
  }

  @override
  get contentChild => ListView.builder(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        // 解决ListView数据量较少时无法滑动问题
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: dataList.length,
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) {
          return VideoLargeCard(videoModel: dataList[index]);
        },
      );

  @override
  Future<FavoriteMo> getData(int pageIndex) async {
    FavoriteMo result = await FavoriteDao.favoriteList(pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<VideoModel> parseList(FavoriteMo result) {
    return result.list!;
  }
}
