import 'package:flutter/material.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:hi_base/LogUtil.dart';
import 'package:hi_base/format_util.dart';
import 'package:provider/provider.dart';
import '../http/model/video_model.dart';
import '../provider/theme_provider.dart';
import 'package:hi_base/view_util.dart';

class VideoCard extends StatelessWidget {
  final String tag = 'VideoCard';
  final VideoModel videoMo;

  const VideoCard({Key? key, required this.videoMo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeProvider = context.watch<ThemeProvider>();
    Color textColor = themeProvider.isDark() ? Colors.white70 : Colors.black87;
    return InkWell(
      onTap: () {
        LogUtil.L(tag, "url:${videoMo.url}");
        HiNavigator.getInstance().onJumpTo(RouteStatus.detail, args: {"videoMo": videoMo});
      },
      child: SizedBox(
        height: 200,
        child: Card(
          // 取消卡片边const 距
          margin: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _itemImage(MediaQuery.of(context).size),
                _infoText(textColor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _itemImage(Size size) {
    return Stack(
      children: [
        cachedImage(
          height: 120,
          width: (size.width / 2 - 20),
          url: videoMo.cover ?? "",
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.only(left: 6, right: 6, bottom: 2, top: 4),
              decoration: const BoxDecoration(
                  // 渐变
                  gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black54, Colors.transparent])),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // 垂直居中
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _iconText(iconData: Icons.ondemand_video, count: videoMo.view!),
                  _iconText(iconData: Icons.favorite_border, count: videoMo.favorite!),
                  _iconText(count: videoMo.duration!),
                ],
              ),
            ))
      ],
    );
  }

  _iconText({IconData? iconData, required int count}) {
    String views = "";
    if (iconData != null) {
      views = countMillionFormat(count);
    } else {
      views = timeDurationFormat(videoMo.duration!);
    }
    return Row(
      // 垂直居中
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (iconData != null) Icon(iconData, color: Colors.white, size: 12),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            views,
            style: const TextStyle(fontSize: 10, color: Colors.white),
          ),
        )
      ],
    );
  }

  _infoText(Color textColor) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.only(left: 6, right: 6, bottom: 4, top: 4),
      child: Column(
        // 左边对齐
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // 文字最多2行，多的用..显式
        children: [
          Text(
            videoMo.title!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: textColor),
          ),
          _owner(textColor)
        ],
      ),
    ));
  }

  _owner(Color textColor) {
    var owner = videoMo.owner;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: cachedImage(
                url: owner?.face ?? "",
                width: 24,
                height: 24,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                owner?.name ?? "",
                style: TextStyle(fontSize: 12, color: textColor),
              ),
            )
          ],
        ),
        const Icon(Icons.more_vert_sharp, size: 15, color: Colors.grey)
      ],
    );
  }
}
