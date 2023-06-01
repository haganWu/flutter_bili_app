import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../constant/color.dart';
import '../db/hi_cache.dart';
import '../utils/hi_constants.dart';

/// 扩展
extension ThemeModeExtension on ThemeMode {
  String get value => <String>['System', 'Light', 'Dark'][index];
}

class ThemeProvider extends ChangeNotifier {
  ThemeMode? _themeMode;
  var _platformBrightness = SchedulerBinding.instance?.window.platformBrightness;

  ///系统Dark Mode发生变化
  void darModeChange() {
    if (_platformBrightness !=
        SchedulerBinding.instance?.window.platformBrightness) {
      _platformBrightness = SchedulerBinding.instance?.window.platformBrightness;
      notifyListeners();
    }
  }

  ///判断是否是Dark Mode
  bool isDark() {
    if (_themeMode == ThemeMode.system) {
      //获取系统的Dark Mode
      return SchedulerBinding.instance?.window.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  ///获取主题模式
  ThemeMode getThemeMode() {
    String? theme = HiCache.getInstance().get(HiConstants.theme);
    switch (theme) {
      case 'Dark':
        _themeMode = ThemeMode.dark;
        break;
      case 'System':
        _themeMode = ThemeMode.system;
        break;
      default:
        _themeMode = ThemeMode.light;
        break;
    }
    return _themeMode = ThemeMode.dark;
  }

  ///设置主题
  void setTheme(ThemeMode themeMode) {
    HiCache.getInstance().setString(HiConstants.theme, themeMode.value);
    notifyListeners();
  }

  ///获取主题
  ThemeData getTheme({bool isDarkMode = false}) {
    var themeData = ThemeData(
        // 亮度
        brightness: isDarkMode ? Brightness.dark : Brightness.light,
        // 错误状态颜色
        errorColor: isDarkMode ? HiColor.dark_red : HiColor.red,
        // 主题主色调
        primaryColor: isDarkMode ? HiColor.dark_bg : white,
        // 文字强调色
        accentColor: isDarkMode ? primary[50] : white,
        //Tab指示器的颜色
        indicatorColor: isDarkMode ? primary[50] : white,
        //页面背景色
        scaffoldBackgroundColor: isDarkMode ? HiColor.dark_bg : white);
    return themeData;
  }
}
