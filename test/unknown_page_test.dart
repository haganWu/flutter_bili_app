import 'package:flutter/material.dart';
import 'package:flutter_bili_app/page/unknown_page.dart';
import 'package:flutter_test/flutter_test.dart';

/// Widget 测试

void main() {
  testWidgets('测试UnKnownPage', (WidgetTester widgetTester) async {
    var app = const MaterialApp(home: UnKnownPage());
    await widgetTester.pumpWidget(app);
    // 从UnKnownPage页面找404的Text
    expect((find.text('404')), findsOneWidget);
  });
}