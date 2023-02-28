import 'package:flutter/material.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

import '../http/model/home_mo.dart';
import '../http/model/video_model.dart';

class HiBanner extends StatelessWidget {
  final String tag = "HiBanner";
  final List<BannerMo> bannerList;
  final double bannerHeight;
  final EdgeInsetsGeometry? padding;

  const HiBanner({Key? key, required this.bannerList, this.bannerHeight = 160, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: bannerHeight,
      child: _banner(),
    );
  }

  _banner() {
    var right = 10 + (padding?.horizontal ?? 0) / 2;
    return Swiper(
      itemCount: bannerList.length,
      autoplay: true,
      itemBuilder: (BuildContext context, int index) {
        return _image(bannerList[index]);
      },
      // 自定义指示器
      pagination: SwiperPagination(
        alignment: Alignment.bottomRight,
        margin: EdgeInsets.only(right: right, bottom: 6),
        builder: const DotSwiperPaginationBuilder(color: Colors.white60, size: 6, activeSize: 6),
      ),
    );
  }

  _image(BannerMo bannerMo) {
    return InkWell(
      onTap: () {
        _handleClick(bannerMo);
      },
      child: Container(
        padding: padding,
        //圆角
        child: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          child: Image.network(
            bannerMo.cover!,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }

  void _handleClick(BannerMo bannerMo) {
    if (bannerMo.type == "video") {
      HiNavigator.getInstance().onJumpTo(RouteStatus.detail, args: {'videoMo': VideoModel(vid: bannerMo.url)});
    } else {
      LogUtil.L(tag, 'type: ${bannerMo.type!}, url:${bannerMo.url}');
    }
  }
}
