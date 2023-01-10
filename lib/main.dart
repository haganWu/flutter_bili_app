import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/model/video_model.dart';
import 'package:flutter_bili_app/page/home_page.dart';
import 'package:flutter_bili_app/page/video_detail_page.dart';

void main() {
  runApp(const BiliApp());
}

class BiliApp extends StatefulWidget {
  const BiliApp({Key? key}) : super(key: key);

  @override
  State<BiliApp> createState() => _BiliAppState();
}

class _BiliAppState extends State<BiliApp> {

  final BiliRouterDelegate _routerDelegate = BiliRouterDelegate();

  @override
  Widget build(BuildContext context) {
    // 定义router
    var widget = Router(routerDelegate: _routerDelegate);
    return MaterialApp(
      home: widget,
    );
  }
}


class BiliRouterDelegate extends RouterDelegate<BiliRouterPath>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<BiliRouterPath> {
  @override
  final GlobalKey<NavigatorState> navigatorKey;
  List<MaterialPage> pages = [];
  VideoModel? videoModel;
  late BiliRouterPath path;

  // 为Navigator设置一个key，在必要的时候可通过navigatorKey.currentState来获取到NavigatorState对象
  BiliRouterDelegate() : navigatorKey = GlobalKey<NavigatorState>();

  /// 返回路由堆栈信息
  @override
  Widget build(BuildContext context) {

    // 构建路由堆栈
    pages = [
      pageWrap(HomePage(onJumpToDetail: (videoModel){
        this.videoModel = videoModel;
        // 相当于setState
        notifyListeners();
      })),
      if(videoModel != null) pageWrap(VideoDetailPage(videoModel: videoModel))
    ];

    return Navigator(
      key: navigatorKey,
      pages: pages,
      onPopPage: (route, result) {
        // 判断是否可以返回上一页 如在首页用户点击物理返回键的时候禁止返回到欢迎页，可以在这里做处理
        if(!route.didPop(result)){
          return false;
        }
        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(BiliRouterPath configuration) async {
    path = configuration;
  }
}

/// 常用于Web应用
class BiliRouterPath {
  final String location;

  BiliRouterPath.home() : location = "/";

  BiliRouterPath.detail() : location = "/detail";
}

/// 创建页面
pageWrap(Widget child) {
  return MaterialPage(key: ValueKey(child.hashCode), child: child);
}
