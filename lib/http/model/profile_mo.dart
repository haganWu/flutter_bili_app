import 'home_mo.dart';

class ProfileMo {
  String? name;
  String? face;
  int? fans;
  int? favorite;
  int? like;
  int? coin;
  int? browsing;
  List<BannerMo>? bannerList;
  List<Course>? courseList;
  List<Benefit>? benefitList;

  ProfileMo(
      {this.name,
        this.face,
        this.fans,
        this.favorite,
        this.like,
        this.coin,
        this.browsing,
        this.bannerList,
        this.courseList,
        this.benefitList});

  ProfileMo.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    face = json['face'];
    fans = json['fans'];
    favorite = json['favorite'];
    like = json['like'];
    coin = json['coin'];
    browsing = json['browsing'];
    if (json['bannerList'] != null) {
      bannerList = <BannerMo>[];
      json['bannerList'].forEach((v) {
        bannerList!.add(BannerMo.fromJson(v));
      });
    }
    if (json['courseList'] != null) {
      courseList = <Course>[];
      json['courseList'].forEach((v) {
        courseList!.add(Course.fromJson(v));
      });
    }
    if (json['benefitList'] != null) {
      benefitList = <Benefit>[];
      json['benefitList'].forEach((v) {
        benefitList!.add(Benefit.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['face'] = face;
    data['fans'] = fans;
    data['favorite'] = favorite;
    data['like'] = like;
    data['coin'] = coin;
    data['browsing'] = browsing;
    if (bannerList != null) {
      data['bannerList'] = bannerList!.map((v) => v.toJson()).toList();
    }
    if (courseList != null) {
      data['courseList'] = courseList!.map((v) => v.toJson()).toList();
    }
    if (benefitList != null) {
      data['benefitList'] = benefitList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}


class Course {
  String? name;
  String? cover;
  String? url;
  int? group;

  Course({this.name, this.cover, this.url, this.group});

  Course.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    cover = json['cover'];
    url = json['url'];
    group = json['group'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['cover'] = cover;
    data['url'] = url;
    data['group'] = group;
    return data;
  }
}

class Benefit {
  String? name;
  String? url;

  Benefit({this.name, this.url});

  Benefit.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['url'] = url;
    return data;
  }
}
