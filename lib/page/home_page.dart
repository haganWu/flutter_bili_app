import 'package:flutter/material.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';

import '../http/model/video_model.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String tag = "_HomePageState";
  RouteChangeListener? listener;

  @override
  void initState() {
    super.initState();
    HiNavigator.getInstance().addListener(listener = (RouterStatusInfo current, RouterStatusInfo? pre){
      if(widget == current.page || current.page is HomePage){
        // 当前首页被打开,当前打开的是本页面
        LogUtil.L(tag, "首页 -> onResume()");
      }else if(widget == pre?.page || pre?.page is HomePage) {
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
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: Column(
          children: [
            Text("首页"),
            MaterialButton(
              onPressed: (){
                HiNavigator.getInstance().onJumpTo(RouteStatus.detail,args: {'videoModel':VideoModel(666888)});
              },
              child: Text("详情"),

            )
          ],
        ),
      ),
    );
  }
}
