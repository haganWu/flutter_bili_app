import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bili_app/constant/color.dart';
import 'package:flutter_bili_app/db/hi_cache.dart';
import 'package:flutter_bili_app/http/core/hi_net.dart';
import 'package:flutter_bili_app/http/dao/login_dao.dart';
import 'package:flutter_bili_app/http/request/notice_request.dart';
import 'package:flutter_bili_app/page/registration_page.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: white,
      ),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      home: const RegistrationPage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String resultTip = "result ---";

  @override
  void initState() {
    HiCache.preInit();
    super.initState();
  }

  void _incrementCounter() async {
    // test();
    // test1();
    // test2();
    testInterface();

    // TestRequest request = TestRequest();
    // request.add("aa", "aaaa").add("bb", "bbbbbb").add("requestPrams", "dddd");
    // try {
    //   var result = await HiNet.getInstance().fire(request);
    //   setState(() {
    //     resultTip = result.toString();
    //   });
    //   LogUtil.L("requestResult:", result.toString());
    // } on NeedAuth catch (e) {
    //   LogUtil.L("requestResult:", e.toString());
    //   setState(() {
    //     resultTip = e.toString();
    //   });
    // } on NeedLogin catch (e) {
    //   LogUtil.L("requestResult:", e.toString());
    //   setState(() {
    //     resultTip = e.toString();
    //   });
    // } on HiNetError catch (e) {
    //   LogUtil.L("requestResult:", e.toString());
    //   setState(() {
    //     resultTip = e.toString();
    //   });
    // }
  }

  void testInterface() async {
    var result = await LoginDao.login("", "");
    // var result = LoginDao.registration("", "","","");
    LogUtil.L("mainTestLogin", result.toString());
    if(result["code"] == 0 && result["data"] != null){
      // 登录成功之后
      testInterface1();
    }
  }
  void testInterface1() async {
  NoticeRequest noticeRequest = NoticeRequest();
  noticeRequest.add("pageIndex", 1);
  noticeRequest.add("pageSize", 10);
  var result = await HiNet.getInstance().fire(noticeRequest);
  LogUtil.L("mainTestNotice", result.toString());
  }

  void test2(){
    HiCache.getInstall().setString("test", "天王盖地虎");
    LogUtil.L("preferences", HiCache.getInstall().get<String>("test")??"");
  }

  void test1(){
    // var ownerMap = {
    //   "name": "伊零Onezero",
    //   "face":
    //   "http://i2.hdslb.com/bfs/face/1c57a17a7b077ccd19dba58a981a673799b85aef.jpg",
    //   "fans": 0
    // };
    // // map 转 model
    // Owner owner = Owner.fromJson(ownerMap);
    // LogUtil.L("test1 map->model:", owner.toString());



  }

  void test() {
    const jsonString =
        "{ \"name\": \"flutter\", \"url\": \"https://coding.imooc.com/class/487.html\" }";
    // json转map
    Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    LogUtil.L("testJson name:", jsonMap["name"]);
    LogUtil.L("testJson url:", jsonMap["url"]);

    // map转json
    String json = jsonEncode(jsonMap);
    LogUtil.L("testJson json:", json);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              resultTip,
              style: Theme.of(context).textTheme.bodyText2,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.get_app),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

}
