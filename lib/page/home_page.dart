import 'package:flutter/material.dart';
import 'package:flutter_bili_app/constant/color.dart';
import 'package:flutter_bili_app/core/hi_state.dart';
import 'package:flutter_bili_app/http/core/hi_net_error.dart';
import 'package:flutter_bili_app/http/dao/home_dao.dart';
import 'package:flutter_bili_app/http/model/home_mo.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:flutter_bili_app/page/home_tab_page.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';
import 'package:flutter_bili_app/utils/toast.dart';
import 'package:flutter_bili_app/widget/hi_navigation_bar.dart';
import 'package:flutter_bili_app/widget/loading_container.dart';
import 'package:underline_indicator/underline_indicator.dart';

class HomePage extends StatefulWidget {
  final ValueChanged<int>? onJumpTo;

  const HomePage({Key? key, this.onJumpTo}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends HiState<HomePage> with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  final String tag = "HomePage";
  RouteChangeListener? listener;
  late TabController _controller;
  List<CategoryMo> categoryList = [];
  List<BannerMo> bannerList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: categoryList.length, vsync: this);
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
    loadData();
  }

  @override
  void dispose() {
    HiNavigator.getInstance().removeListener(listener);
    _controller.dispose();
    super.dispose();
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
              HiNavigationBar(height: 44, child: _appBar(), color: Colors.white, statusStyle: StatusStyle.DARK_CONTENT),
              Container(
                color: Colors.white,
                child: _tabBar(),
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
    return TabBar(
      controller: _controller,
      isScrollable: true,
      labelColor: Colors.black,
      indicator: const UnderlineIndicator(strokeCap: StrokeCap.round, borderSide: BorderSide(color: primary, width: 3), insets: EdgeInsets.only(left: 15, right: 15)),
      tabs: categoryList.map<Tab>((tab) {
        return Tab(
          child: Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: Text(
              tab.name!,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        );
      }).toList(),
    );
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
