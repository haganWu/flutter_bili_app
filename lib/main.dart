import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bili_app/db/hi_cache.dart';
import 'package:flutter_bili_app/http/dao/login_dao.dart';
import 'package:flutter_bili_app/navigator/bottom_navigator.dart';
import 'package:flutter_bili_app/page/dark_mode_page.dart';
import 'package:flutter_bili_app/page/login_page.dart';
import 'package:flutter_bili_app/page/notice_page.dart';
import 'package:flutter_bili_app/page/registration_page.dart';
import 'package:flutter_bili_app/page/video_detail_page.dart';
import 'package:flutter_bili_app/provider/hi_provider.dart';
import 'package:flutter_bili_app/provider/theme_provider.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';
import 'package:flutter_bili_app/utils/toast.dart';
import 'package:provider/provider.dart';
import 'http/model/video_model.dart';
import 'navigator/hi_navigator.dart';

void main() {
  runZonedGuarded(() {
    runApp(const BiliApp());
  }, (error, stack) {
    LogUtil.L('Exception', error.toString());
  });
}

class BiliApp extends StatefulWidget {
  const BiliApp({Key? key}) : super(key: key);

  @override
  State<BiliApp> createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {
  final BiliRouteDelegate _routeDelegate = BiliRouteDelegate();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<HiCache>(
        future: HiCache.preInit(),
        builder: (BuildContext context, AsyncSnapshot<HiCache> snapshot) {
          // 定义router
          var widget = snapshot.connectionState == ConnectionState.done
              ? Router(routerDelegate: _routeDelegate)
              : const Scaffold(body: Center(child: CircularProgressIndicator()));
          return MultiProvider(
              providers: topProviders,
              child: Consumer<ThemeProvider>(builder: (BuildContext context, ThemeProvider themeProvider, Widget? child) {
                return MaterialApp(
                  home: widget,
                  theme: themeProvider.getTheme(),
                  darkTheme: themeProvider.getTheme(isDarkMode: true),
                  themeMode: themeProvider.getThemeMode(),
                  title: 'Flutter Bili',
                );
              }));
        });
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRouterPath> with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRouterPath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;

  // 为Navigator设置一个key，在必要的时候可通过navigatorKey.currentState来获取到NavigatorState对象
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>() {
    // 实现跳转逻辑
    HiNavigator.getInstance().registerRouteJump(RouteJumpListener(onJumpTo: (RouteStatus routeStatus, {Map? args}) {
      _routeStatus = routeStatus;
      if (routeStatus == RouteStatus.detail) {
        videoMo = args?['videoMo'];
      }
      notifyListeners();
    }));
  }

  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  VideoModel? videoMo;

  /// 返回路由堆栈信息
  @override
  Widget build(BuildContext context) {
    var index = getPageIndex(pages, routeStatus);
    List<MaterialPage> tempPages = pages;
    if (index != -1) {
      // 要打开的页面已经存在，则将改页面上面的所有页面进行出栈
      tempPages = tempPages.sublist(0, index);
    }
    var page;
    if (routeStatus == RouteStatus.home) {
      //跳转首页时将栈中其它页面进行出栈，因为首页不可回退
      pages.clear();
      page = pageWrap(const BottomNavigator());
    } else if (routeStatus == RouteStatus.darkMode) {
      page = pageWrap(const DarkModePage());
    } else if (routeStatus == RouteStatus.detail) {
      page = pageWrap(VideoDetailPage(videoMo: videoMo!));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(const RegistrationPage());
    } else if (routeStatus == RouteStatus.notice) {
      page = pageWrap(const NoticePage());
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(const LoginPage());
    }
    // 重新创建一个数组，否则pages会因为引用没有改变造成路由不会生效
    if (page != null) {
      tempPages = [...tempPages, page];
    }
    // 通知路由变化
    HiNavigator.getInstance().notify(tempPages, pages);
    // 管理路由堆栈
    pages = tempPages;
    // 修复Android物理返回键无法返回上一个页面问题
    return WillPopScope(
        onWillPop: () async => !await navigatorKey.currentState!.maybePop(),
        child: Navigator(
          key: navigatorKey,
          pages: pages,
          onPopPage: (route, result) {
            if (route.settings is MaterialPage) {
              // 登录页面未登录时做返回拦截 添加拦截处理
              if ((route.settings as MaterialPage).child is LoginPage) {
                if (!hasLogin) {
                  showErrorToast("请先登录");
                  return false;
                }
              }
            }

            // 判断是否可以返回上一页 如在首页用户点击物理返回键的时候禁止返回到欢迎页，可以在这里做处理
            if (!route.didPop(result)) {
              return false;
            }
            var tempPages = [...pages];
            // 执行返回操作
            pages.removeLast();
            // 通知路由变化
            HiNavigator.getInstance().notify(pages, tempPages);
            return true;
          },
        ));
  }

  /// 拦截路由
  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      // 当前打开的不是注册页面并且用户没有登录
      return _routeStatus = RouteStatus.login;
    } else if (videoMo != null) {
      return _routeStatus = RouteStatus.detail;
    }
    return _routeStatus;
  }

  bool get hasLogin => LoginDao.getBoardingPass().isNotEmpty;

  @override
  Future<void> setNewRoutePath(BiliRouterPath configuration) async {}
}

/// 常用于Web应用
class BiliRouterPath {
  final String location;

  BiliRouterPath.home() : location = "/";

  BiliRouterPath.detail() : location = "/detail";
}
