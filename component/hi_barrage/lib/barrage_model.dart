//barrage_model.dart
import 'dart:convert';

import 'package:hi_base/LogUtil.dart';

class BarrageModel {
  String? content;
  String? vid;
  int? priority;
  int? type;

  BarrageModel({this.content, this.vid, this.priority, this.type});

  BarrageModel.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    vid = json['vid'];
    priority = json['priority'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['content'] = content;
    data['vid'] = vid;
    data['priority'] = priority;
    data['type'] = type;
    return data;
  }

  static List<BarrageModel> fromJsonString(json) {
    List<BarrageModel> list = [];
    if (json is! String || !json.startsWith('[')) {
      LogUtil.L('BarrageModel', 'json is not invalid');
      return [];
    }

    var jsonArray = jsonDecode(json);
    jsonArray.forEach((v) {
      list.add(BarrageModel.fromJson(v));
    });
    return list;
  }
}
