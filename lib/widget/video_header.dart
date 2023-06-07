import 'package:flutter/material.dart';
import 'package:hi_base/color.dart';
import 'package:hi_base/LogUtil.dart';
import 'package:hi_base/format_util.dart';
import '../http/model/video_model.dart';


class VideoHeader extends StatelessWidget {
  final Owner owner;

  const VideoHeader({Key? key, required this.owner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 2, left: 8, right: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: Image.network(owner.face!, width: 28, height: 28),
              ),
              Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    children: [
                      Text(
                        owner.name!,
                        style: const TextStyle(fontSize: 13, color: primary, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${countMillionFormat(owner.fans!)}粉丝',
                        style: const TextStyle(fontSize: 10, color: Colors.grey),
                      )
                    ],
                  ))
            ],
          ),
          MaterialButton(
              onPressed: () {
                LogUtil.L('VideoHeader', '关注 /  取消关注');
              },
              color: primary,
              height: 18,
              minWidth: 50,
              child: const Text('+关注', style: TextStyle(color: Colors.white, fontSize: 10)))
        ],
      ),
    );
  }
}
