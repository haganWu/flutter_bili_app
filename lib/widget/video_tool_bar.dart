import 'package:flutter/material.dart';
import 'package:flutter_bili_app/constant/color.dart';
import 'package:flutter_bili_app/utils/view_util.dart';

import '../http/model/video_detail_mo.dart';
import '../http/model/video_model.dart';
import '../utils/format_util.dart';

/// 视频点赞分享等工具栏
class VideoToolBar extends StatelessWidget {
  final VideoDetailMo? detailMo;
  final VideoModel videoModel;
  final VoidCallback? onLike;
  final VoidCallback? onUnLike;
  final VoidCallback? onCoin;
  final VoidCallback? onFavorite;
  final VoidCallback? onShare;

  const VideoToolBar(
      {Key? key, required this.detailMo, required this.videoModel, this.onLike, this.onUnLike, this.onCoin, this.onFavorite, this.onShare})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, bottom: 8),
      margin: const EdgeInsets.only(bottom: 1),
      decoration: BoxDecoration(
        border: borderLine(context: context),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildIconText(iconData: Icons.thumb_up_alt_rounded, text: videoModel.like, onClickCallback: onLike, tint: detailMo?.isLike ?? false),
          _buildIconText(iconData: Icons.thumb_down_alt_rounded, text: "不喜欢", onClickCallback: onUnLike),
          _buildIconText(iconData: Icons.monetization_on, text: videoModel.coin, onClickCallback: onCoin),
          _buildIconText(iconData: Icons.grade_rounded, text: videoModel.favorite, onClickCallback: onFavorite, tint: detailMo?.isFavorite ?? false),
          _buildIconText(iconData: Icons.share_rounded, text: videoModel.share, onClickCallback: onShare),
        ],
      ),
    );
  }

  _buildIconText({required IconData iconData, text, VoidCallback? onClickCallback, bool tint = false}) {
    if (text is int) {
      text = countMillionFormat(text);
    }
    return InkWell(
      onTap: onClickCallback,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: tint ? primary : Colors.grey,
            size: 16,
          ),
          hiSpace(),
          Text(text, style: TextStyle(fontSize: 12, color: tint ? primary : Colors.grey))
        ],
      ),
    );
  }
}
