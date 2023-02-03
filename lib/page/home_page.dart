import 'package:flutter/material.dart';
import 'package:flutter_bili_app/constant/color.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:flutter_bili_app/page/home_tab_page.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final String tag = "HomePage";
  RouteChangeListener? listener;
  late TabController _controller;
  var tabs = ["推荐", "热门", "追播", "影视", "搞笑", "日常", "综合", "手机游戏", "短片・手记・配音"];

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: tabs.length, vsync: this);
    HiNavigator.getInstance().addListener(listener = (RouterStatusInfo current, RouterStatusInfo? pre) {
      LogUtil.L(tag, "current:${current.page}, pre:${pre?.page}");
      if (widget == current.page || current.page is HomePage) {
        // 当前首页被打开,当前打开的是本页面
        LogUtil.L(tag, "首页 -> onResume()");
      } else if (widget == pre?.page || pre?.page is HomePage) {
        // 当前打开的不是这个页面，上次打开的是这个页面
        LogUtil.L(tag, "首页 -> onPause()");
      }
    });
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: Colors.white,
              child: _tabBar(),
            ),
            // 填充底部剩余空间
            Flexible(
                child: TabBarView(
              controller: _controller,
              children: tabs.map((tab) {
                return HomeTabPage(name: tab);
              }).toList(),
            ))
          ],
        ),
      ),
    );
  }

  /// 不重新创建页面
  @override
  bool get wantKeepAlive => true;

  _tabBar() {
    return TabBar(
      controller: _controller,
      isScrollable: true,
      labelColor: Colors.black,
      indicator: const UnderlineIndicator(strokeCap: StrokeCap.round, borderSide: BorderSide(color: primary, width: 3), insets: EdgeInsets.only(left: 15, right: 15)),
      tabs: tabs.map<Tab>((tab) {
        return Tab(
          child: Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: Text(
              tab,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
  }
}
