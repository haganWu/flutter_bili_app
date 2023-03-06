import 'package:flutter/material.dart';
import 'package:flutter_bili_app/utils/format_util.dart';
import 'package:flutter_bili_app/utils/view_util.dart';

import '../http/model/home_mo.dart';
import '../http/model/video_model.dart';
import '../navigator/hi_navigator.dart';

class NoticeCard extends StatelessWidget {
  final BannerMo bannerMo;

  const NoticeCard({Key? key, required this.bannerMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        handleBannerClick(bannerMo);
      },
      child: Container(
        decoration: BoxDecoration(border: borderLine(context: context)),
        padding: const EdgeInsets.only(left: 12, top: 4, right: 12, bottom: 4),
        child: Row(
          children: [_buildIcon(), hiSpace(width: 10), _buildContents()],
        ),
      ),
    );
  }

  void handleBannerClick(BannerMo bannerMo) {
    if (bannerMo.type == 'video') {
      HiNavigator.getInstance().onJumpTo(RouteStatus.detail, args: {"videoMo": VideoModel(vid: bannerMo.url)});
    } else {
      HiNavigator.getInstance().openH5(bannerMo.url!);
    }
  }

  _buildIcon() {
    var iconData = bannerMo.type == 'video' ? Icons.ondemand_video_outlined : Icons.card_giftcard;
    return Icon(iconData, size: 26);
  }

  _buildContents() {
    return Flexible(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(bannerMo.title!, style: const TextStyle(fontSize: 16)),
            Text(dateMonthAndDay(bannerMo.createTime!)),
          ],
        ),
        hiSpace(height: 5),
        Text(bannerMo.subtitle!, maxLines: 1, overflow: TextOverflow.ellipsis)
      ],
    ));
  }
}
