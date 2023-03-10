import 'package:flutter/material.dart';
import 'package:underline_indicator/underline_indicator.dart';
import '../constant/color.dart';

/// 顶部Tab组件
class HiTab extends StatelessWidget {
  final List<Widget> tabs;
  final TabController controller;
  final double fontSize;
  final double borderWith;
  final double insets;
  final Color unselectedLabelColor;

  const HiTab(
      {Key? key,
      required this.tabs,
      required this.controller,
      this.fontSize = 16,
      this.borderWith = 2,
      this.insets = 12,
      this.unselectedLabelColor = Colors.black54})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TabBar(
      controller: controller,
      isScrollable: true,
      labelColor: primary,
      unselectedLabelColor: unselectedLabelColor,
      labelStyle: TextStyle(fontSize: fontSize),
      indicator: UnderlineIndicator(
          strokeCap: StrokeCap.square,
          borderSide: BorderSide(color: primary, width: borderWith),
          insets: EdgeInsets.only(left: insets, right: insets)),
      tabs: tabs,
    );
  }
}
