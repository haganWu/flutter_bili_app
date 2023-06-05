import 'package:flutter/material.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_bili_app/main.dart' as app;

void main() {
  // 集成测试初始化
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test Login Jump', (WidgetTester tester) async {
    // 构建应用
    app.main();

    // 捕获一帧
    await tester.pumpAndSettle();
    // 通过key查找注册按钮
    var registrationBtn = find.byKey(const Key('registration'));
    // 触发按钮的点击事件
    await tester.tap(registrationBtn);
    // 捕获一帧
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 3));

    // 判断是否跳转到了注册页
    expect(HiNavigator.getInstance().getCurrent()?.routeStatus, RouteStatus.registration);

    //获取返回按钮，触发返回上一页
    var backBtn = find.byType(BackButton);
    await tester.tap(backBtn);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 3));

    // 判断是否返回到登陆页
    expect(HiNavigator.getInstance().getCurrent()?.routeStatus, RouteStatus.login);


  });

  // 命令行
  //  flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart
}