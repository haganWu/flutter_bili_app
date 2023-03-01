import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/model/video_model.dart';
import 'package:flutter_bili_app/navigator/hi_navigator.dart';
import 'package:flutter_bili_app/utils/format_util.dart';
import 'package:flutter_bili_app/utils/view_util.dart';

/// 关联视频，视频列表卡片
class VideoLargeCard extends StatelessWidget {
  final VideoModel videoModel;

  const VideoLargeCard({Key? key, required this.videoModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HiNavigator.getInstance().onJumpTo(RouteStatus.detail, args: {"videoMo": videoModel});
      },
      child: Container(
        padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
        child: Row(
          children: [
            _itemImage(context),
            _buildContent(),
          ],
        ),
      ),
    );
  }

  _itemImage(BuildContext context) {
    double height = 90;
    return ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Stack(
          children: [
            cachedImage(url: videoModel.cover!, width: height * 16 / 9, height: height),
            Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  padding: const EdgeInsets.only(left: 2, top: 1, right: 2, bottom: 1),
                  decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(2)),
                  child: Text(
                    timeDurationFormat(videoModel.duration!),
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ))
          ],
        ));
  }

  _buildContent() {
    return Expanded(
        child: Container(
      margin: const EdgeInsets.only(left: 4),
      height: 90,
      padding: const EdgeInsets.only(top: 2, bottom: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            videoModel.title!,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
          Column(

            children: [
              Row(
                children: [...smallIconText(iconData: Icons.person, text: videoModel.owner!.name!, fontSize: 12, iconSize: 14)],
              ),
              hiSpace(height: 4),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Row(
                    children: [
                      ...smallIconText(iconData: Icons.ondemand_video, text: videoModel.view!, fontSize: 12, iconSize: 14),
                      hiSpace(width: 6),
                      ...smallIconText(iconData: Icons.list_alt, text: videoModel.reply!, fontSize: 12, iconSize: 14),
                    ],
                  )),
                  const Icon(
                    Icons.more_vert_sharp,
                    color: Colors.grey,
                    size: 12,
                  )
                ],
              ),
            ],
          )
        ],
      ),
    ));
  }
}
