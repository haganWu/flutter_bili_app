import 'package:flutter/material.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';

import '../http/model/video_model.dart';

class HomePage extends StatefulWidget {

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
