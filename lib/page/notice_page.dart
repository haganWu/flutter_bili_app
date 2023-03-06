import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/dao/notice_dao.dart';
import 'package:flutter_bili_app/http/model/notice_mo.dart';
import 'package:flutter_bili_app/widget/notice_card.dart';

import '../core/hi_base_tab_state.dart';
import '../http/model/home_mo.dart';

class NoticePage extends StatefulWidget {
  const NoticePage({Key? key}) : super(key: key);

  @override
  State<NoticePage> createState() => _NoticePageState();
}

class _NoticePageState extends HiBaseTabState<NoticeMo, BannerMo, NoticePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [_buildNavigationBar(), Expanded(child: super.build(context))],
    ));
  }

  _buildNavigationBar() {
    return AppBar(
      toolbarHeight: 40,
      title: const Text('通知', style: TextStyle(color: Colors.white)),
      // backgroundColor: Colors.white,
      // iconTheme: const IconThemeData(color: Colors.black)
    );
  }

  @override
  get contentChild => ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 10),
      itemCount: dataList.length,
      controller: scrollController,
      itemBuilder: (BuildContext context, int index) => NoticeCard(bannerMo: dataList[index]));

  @override
  Future<NoticeMo> getData(int pageIndex) async {
    NoticeMo result = await NoticeDao.noticeList(pageIndex: pageIndex, pageSize: 10);
    return result;
  }

  @override
  List<BannerMo> parseList(NoticeMo result) {
    return result.list;
  }
}
