import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/dao/ranking_dao.dart';
import 'package:flutter_bili_app/http/model/ranking_mo.dart';
import 'package:flutter_bili_app/http/model/video_model.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';

import '../core/hi_base_tab_state.dart';
import '../widget/video_large_card.dart';

class RankingTabPage extends StatefulWidget {
  final String tabName;

  const RankingTabPage({Key? key, required this.tabName}) : super(key: key);

  @override
  State<RankingTabPage> createState() => _RankingTabPageState();
}

class _RankingTabPageState extends HiBaseTabState<RankingMo, VideoModel, RankingTabPage> {
  @override
  void initState() {
    super.initState();
    LogUtil.L('RankingTabPage', 'tabName:${widget.tabName}');
  }

  @override
  get contentChild => ListView.builder(
        // 解决ListView数据量较少时无法滑动问题
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: dataList.length,
        controller: scrollController,
        itemBuilder: (BuildContext context, int index) {
          return VideoLargeCard(videoModel: dataList[index]);
        },
      );

  @override
  Future<RankingMo> getData(int pageIndex) async {
    RankingMo result = await RankingDao.get(sort: widget.tabName, pageIndex: pageIndex, pageSize: 10);
    LogUtil.L("RankingTabPage", result.toJson().toString());
    return result;
  }

  @override
  List<VideoModel> parseList(RankingMo result) {
    return result.list!;
  }
}
