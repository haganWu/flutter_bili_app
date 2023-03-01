import 'package:flutter/material.dart';
import 'package:flutter_bili_app/core/hi_state.dart';
import 'package:flutter_bili_app/http/core/hi_net_error.dart';
import 'package:flutter_bili_app/http/dao/home_dao.dart';
import 'package:flutter_bili_app/http/model/home_mo.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:flutter_bili_app/page/home_tab_page.dart';
import 'package:flutter_bili_app/page/profile_page.dart';
import 'package:flutter_bili_app/page/video_detail_page.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';
import 'package:flutter_bili_app/utils/toast.dart';
import 'package:flutter_bili_app/utils/view_util.dart';
import 'package:flutter_bili_app/widget/hi_navigation_bar.dart';
import 'package:flutter_bili_app/widget/hi_tab.dart';
import 'package:flutter_bili_app/widget/loading_container.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;

  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin, WidgetsBindingObserver {
  final String tag = "HomePage";
  RouteChangeListener? listener;
  late TabController _controller;
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  bool _isLoading = true;
  late Widget _currentPage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _controller = TabController(length: categoryList.length, vsync: this);
    HiNavigator.getInstance().addListener(listener = (RouterStatusInfo current, RouterStatusInfo? pre) {
      _currentPage = current.page;
      LogUtil.L(tag, "current:${current.page}, pre:${pre?.page}");
      if (widget == current.page || current.page is HomePage) {
        // 当前首页被打开,当前打开的是本页面
        LogUtil.L(tag, "首页 -> onResume()");
      } else if (widget == pre?.page || pre?.page is HomePage) {
        // 当前打开的不是这个页面，上次打开的是这个页面
        LogUtil.L(tag, "首页 -> onPause()");
      }
      // 当页面返回到首页恢复首页的状态栏样式
      if (pre?.page is VideoDetailPage && current.page is! ProfilePage) {
        var statusStyle = StatusStyle.DARK_CONTENT;
        changeStatusBar(color: Colors.white, statusStyle: statusStyle);
      }
    });

    loadData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    HiNavigator.getInstance().removeListener(listener);
    _controller.dispose();
    super.dispose();
  }

  // 监听应用生命周期方法
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    LogUtil.L(tag, 'didChangeAppLifecycleState --- state:$state');
    switch (state) {
      // 非激活 即将暂停
      case AppLifecycleState.inactive:
        LogUtil.L(tag, '生命周期方法 -  非激活 即将暂停');
        break;
      // 暂停
      case AppLifecycleState.paused:
        LogUtil.L(tag, '生命周期方法 -  已暂停');
        break;
      // 重新激活
      case AppLifecycleState.resumed:
        LogUtil.L(tag, '生命周期方法 -  重新激活');
        if (_currentPage is! VideoDetailPage) {
          changeStatusBar(color: Colors.white, statusStyle: StatusStyle.DARK_CONTENT);
        }
        break;
      // APP结束
      case AppLifecycleState.detached:
        LogUtil.L(tag, '生命周期方法 -  App结束');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: SafeArea(
        child: LoadingContainer(
          isLoading: _isLoading,
          isCover: true,
          child: Column(
            children: [
              HiNavigationBar(height: 36, top: 16, child: _appBar(), color: Colors.white, statusStyle: StatusStyle.DARK_CONTENT),
              Container(
                child: _tabBar(),
                decoration:bottomBoxShadow(),
              ),
              // 填充底部剩余空间
              Flexible(
                  child: TabBarView(
                controller: _controller,
                children: categoryList.map((tab) {
                  return HomeTabPage(
                    categoryName: tab.name!,
                    bannerList: tab.name! == "推荐" ? bannerList : null,
                  );
                }).toList(),
              ))
            ],
          ),
        ),
      ),
    );
  }

  /// 不重新创建页面
  @override
  bool get wantKeepAlive => true;

  _tabBar() {
    return HiTab(
        controller: _controller,
        fontSize: 16,
        borderWith: 3,
        tabs: categoryList.map<Tab>((tab) {
          return Tab(
            height: 36,
            child: Padding(
              padding: const EdgeInsets.only(left: 6, right: 6),
              child: Text(
                tab.name!,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          );
        }).toList());
  }

  void loadData() async {
    try {
      HomeMo result = await HomeDao.get(categoryName: "推荐");
      if (result.categoryList != null) {
        _controller = TabController(length: result.categoryList!.length, vsync: this);
        setState(() {
          categoryList = result.categoryList!;
          _isLoading = false;
        });
      }
      if (result.bannerList != null) {
        setState(() {
          bannerList = result.bannerList!;
          _isLoading = false;
        });
      }
    } on NeedAuth catch (e) {
      LogUtil.L(tag, e.toString());
      showErrorToast(e.message);
      setState(() {
        _isLoading = false;
      });
    } on HiNetError catch (e) {
      LogUtil.L(tag, e.toString());
      showErrorToast(e.message);
      setState(() {
        _isLoading = false;
      });
    }
  }

  _appBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              if (widget.onJumpTo != null) {
                widget.onJumpTo!(3);
              }
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: const Image(
                height: 36,
                width: 36,
                image: AssetImage('images/avatar.png'),
              ),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.only(left: 10),
                height: 32,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(color: Colors.grey[100]),
                child: const Icon(Icons.search, color: Colors.grey),
              ),
            ),
          )),
          const Icon(Icons.explore_outlined, color: Colors.grey),
          const Padding(
            padding: EdgeInsets.only(left: 12),
            child: Icon(
              Icons.mail_outline,
              color: Colors.grey,
            ),
          )
        ],
      ),
    );
  }
}
