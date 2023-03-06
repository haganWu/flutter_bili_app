import 'package:flutter/material.dart';
import 'package:flutter_bili_app/page/ranking_tab_page.dart';

import '../utils/view_util.dart';
import '../widget/hi_tab.dart';

/// 排行榜
class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> with TickerProviderStateMixin {
  final String tag = "RankingPage";
  late TabController _controller;
  final List tabs = [
    {"key": "like", "name": "最热"},
    {"key": "pubdate", "name": "最新"},
    {"key": "favorite", "name": "收藏"},
  ];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildTabBarView(),
            _buildTabContentView(),
          ],
        ),
      ),
    );
  }

  _buildTabBarView() {
    return Container(
      alignment: Alignment.center,
      child: _tabBar(),
      decoration: bottomBoxShadow(context),
    );
  }

  _tabBar() {
    return HiTab(
        controller: _controller,
        tabs: tabs.map<Tab>((tab) {
          return Tab(
            height: 36,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, right: 16),
              child: Text(
                tab['name'],
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }).toList());
  }

  _buildTabContentView() {
    // Flexible 填充底部剩余空间
    return Flexible(
      child: TabBarView(
        controller: _controller,
        children: tabs.map((tab) {
          return RankingTabPage(tabName: tab['key']);
        }).toList(),
      ),
    );
  }
}
