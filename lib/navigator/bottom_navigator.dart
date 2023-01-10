import 'package:flutter/material.dart';
import 'package:flutter_bili_app/constant/color.dart';
import 'package:flutter_bili_app/page/favorite_page.dart';
import 'package:flutter_bili_app/page/home_page.dart';
import 'package:flutter_bili_app/page/profile_page.dart';
import 'package:flutter_bili_app/page/ranking_page.dart';

/// 底部导航
class BottomNavigator extends StatefulWidget {
  const BottomNavigator({Key? key}) : super(key: key);

  @override
  State<BottomNavigator> createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
  var _defaultColor = Colors.grey;
  var _activeColor = primary;
  int _currentIndex = 0;
  final PageController _controller = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _controller,
        children: [HomePage(), RankingPage(), FavoritePage(), ProfilePage()],
      ),
    );
  }
}
