import 'package:flutter/material.dart';
import 'package:flutter_bili_app/constant/color.dart';
import 'package:flutter_bili_app/db/hi_cache.dart';
import 'package:flutter_bili_app/http/dao/login_dao.dart';
import 'package:flutter_bili_app/http/model/video_model.dart';
import 'package:flutter_bili_app/page/home_page.dart';
import 'package:flutter_bili_app/page/login_page.dart';
import 'package:flutter_bili_app/page/registration_page.dart';
import 'package:flutter_bili_app/page/video_detail_page.dart';

import 'navigator/hi_navigator.dart';

void main() {
  runApp(const BiliApp());
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
              : const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
          return MaterialApp(
            home: widget,
            theme: ThemeData(primarySwatch: white),
          );
        });
  }
}

class BiliRouteDelegate extends RouterDelegate<BiliRouterPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRouterPath> {
  final GlobalKey<NavigatorState> navigatorKey;
  // 为Navigator设置一个key，在必要的时候可通过navigatorKey.currentState来获取到NavigatorState对象
  BiliRouteDelegate() : navigatorKey = GlobalKey<NavigatorState>();
  RouteStatus _routeStatus = RouteStatus.home;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;

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
      // 跳转到首页时需要将栈中的其他页面进行出栈，因为首页不能进行后退
      pages.clear();
      page = pageWrap(HomePage(onJumpToDetail: (videoModel) {
        this.videoModel = videoModel;
        // 相当于setState
        notifyListeners();
      }));
    } else if (routeStatus == RouteStatus.detail) {
       page = pageWrap(VideoDetailPage(videoModel: videoModel));
    } else if (routeStatus == RouteStatus.registration) {
      page = pageWrap(RegistrationPage(onJumpToLogin: () {
        _routeStatus = RouteStatus.login;
        notifyListeners();
      }));
    } else if (routeStatus == RouteStatus.login) {
      page = pageWrap(const LoginPage());
    }
    // 重新创建一个数组，否则pages会因为引用没有改变造成路由不会生效
    if(page != null) {
      tempPages = [...tempPages, page];
    }
    // 管理路由堆栈
    pages = tempPages;

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        // 判断是否可以返回上一页 如在首页用户点击物理返回键的时候禁止返回到欢迎页，可以在这里做处理
        if (!route.didPop(result)) {
          return false;
        }
        return true;
      },
    );
  }

  /// 拦截路由
  RouteStatus get routeStatus {
    if (_routeStatus != RouteStatus.registration && !hasLogin) {
      // 当前打开的不是注册页面并且用户没有登录
      return _routeStatus = RouteStatus.login;
    } else if (videoModel != null) {
      return _routeStatus = RouteStatus.detail;
    }
    return _routeStatus;
  }

  bool get hasLogin => LoginDao.getBoardingPass().isNotEmpty;

  @override
  Future<void> setNewRoutePath(BiliRouterPath configuration) async {
  }
}

/// 常用于Web应用
class BiliRouterPath {
  final String location;

  BiliRouterPath.home() : location = "/";

  BiliRouterPath.detail() : location = "/detail";
}
