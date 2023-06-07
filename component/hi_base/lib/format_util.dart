import 'package:intl/intl.dart';

/// 数字转万
String countMillionFormat(int count) {
  String result = "";
  if (count > 9999) {
    // 保留两位小数
    result = "${(count / 10000).toStringAsFixed(2)}万";
  } else {
    result = count.toString();
  }
  return result;
}

/// 将描述转成【分：秒】格式
String timeDurationFormat(int seconds) {
  String result = "";
  int m = (seconds / 60).truncate();
  int s = seconds - m * 60;
  if (s < 10) {
    result = '$m:0$s';
  } else {
    result = '$m:$s';
  }
  return result;
}

///日期格式化，2022-06-11 20:06:43 -> 06-11
String dateMonthAndDay(String dateStr) {
  DateTime now = DateTime.now();
  DateFormat formatter = DateFormat('MM-dd');
  String formatted = formatter.format(now);
  return formatted;
}