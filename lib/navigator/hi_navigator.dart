import 'package:flutter/material.dart';
import 'package:flutter_bili_app/page/home_page.dart';
import 'package:flutter_bili_app/page/login_page.dart';
import 'package:flutter_bili_app/page/registration_page.dart';
import 'package:flutter_bili_app/page/video_detail_page.dart';


typedef RouteChangeListener(RouterStatusInfo current,RouterStatusInfo? pre);

/// 创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}

/// 获取routeStatus在页面中的位置
int getPageIndex(List<MaterialPage> pages, RouteStatus routeStatus) {
  for (int i = 0; i < pages.length; i++) {
    MaterialPage page = pages[i];
    if (getStatus(page) == routeStatus) {
      return i;
    }
  }
  return -1;
}

/// 自定义路由封装，路由状态
enum RouteStatus { login, registration, home, detail, unknown }

/// 获取page对应的RouterStatus
RouteStatus getStatus(MaterialPage page) {
  if (page.child is LoginPage) {
    return RouteStatus.login;
  } else if (page.child is RegistrationPage) {
    return RouteStatus.registration;
  }
  if (page.child is HomePage) {
    return RouteStatus.home;
  }
  if (page.child is VideoDetailPage) {
    return RouteStatus.detail;
  }
  return RouteStatus.unknown;
}

/// 路由信息
class RouterStatusInfo {
  final RouteStatus routeStatus;
  final Widget page;

  RouterStatusInfo(this.routeStatus, this.page);
}

class HiNavigator extends _RouteJumpListener {
  final String tag = "HiNavigator";
  static HiNavigator? _instance;

  RouteJumpListener? _routeJumpListener;

  List<RouteChangeListener> _listenerList = [];
  RouterStatusInfo? _current;

  HiNavigator._();

  static HiNavigator getInstance() {
    return _instance ??= HiNavigator._();
  }

  ///注册路由跳转逻辑
  void registerRouteJump(RouteJumpListener routeJumpListener) {
    _routeJumpListener = routeJumpListener;
  }

  /// 添加路由改变监听
  void addListener(RouteChangeListener listener) {
    if(!_listenerList.contains(listener)){
      _listenerList.add(listener);
    }
  }
  /// 移除路由改变监听
  void removeListener(RouteChangeListener? listener) {
    if(listener != null && _listenerList.contains(listener)){
      _listenerList.remove(listener);
    }
  }

  @override
  void onJumpTo(RouteStatus routeStatus, {Map? args}) {
    _routeJumpListener?.onJumpTo!(routeStatus,args: args);
  }

  /// 通知路由页面变化
  void notify(List<MaterialPage> currentPageList,List<MaterialPage> prePageList){
    if(currentPageList == prePageList) {
      return;
    }
    var current = RouterStatusInfo(getStatus(currentPageList.last), currentPageList.last.child);
    _notify(current);
  }

  void _notify(RouterStatusInfo current) {
    _listenerList.forEach((listener) {
      listener(current,_current);
    });
    _current = current;
  }
}

/// HiNavigator继承的抽象类
abstract class _RouteJumpListener {
  void onJumpTo(RouteStatus routeStatus, {Map? args});
}

typedef OnJumpTo = void Function(RouteStatus routeStatus, {Map? args});

/// 定义路由跳转逻辑要实现的功能
class RouteJumpListener {
  OnJumpTo? onJumpTo;

  RouteJumpListener({this.onJumpTo});
}
