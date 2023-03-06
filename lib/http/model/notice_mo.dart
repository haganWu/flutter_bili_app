import 'home_mo.dart';

class NoticeMo {
  late int total;
  late List<BannerMo> list;


  NoticeMo.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    if (json['list'] != null) {
      list = List<BannerMo>.empty(growable: true);
      json['list'].forEach((v) {
        list.add(BannerMo.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['list'] = list.map((v) => v.toJson()).toList();
    return data;
  }
}

