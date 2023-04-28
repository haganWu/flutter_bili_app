import 'package:flutter/material.dart';
import '../utils/view_util.dart';

/// 可动态改变位置的Header组件
/// 性能优化：局部刷新
class HiFlexibleHeader extends StatefulWidget {
  final String name;
  final String face;
  final ScrollController controller;

  const HiFlexibleHeader({Key? key, required this.name, required this.face, required this.controller}) : super(key: key);

  @override
  State<HiFlexibleHeader> createState() => _HiFlexibleHeaderState();
}

class _HiFlexibleHeaderState extends State<HiFlexibleHeader> {
  static const double MAX_BOTTOM = 30.0;
  static const double MIN_BOTTOM = 10.0;

  // 滚动范围
  static const double MAX_OFFSET = 80.0;
  double _dyBottom = MAX_BOTTOM;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      var offset = widget.controller.offset;
      // padding变化值0-1
      var dyOffset = (MAX_OFFSET - offset) / MAX_OFFSET;
      // 根据dyOffset计算变化的padding
      var dy = dyOffset * (MAX_BOTTOM - MIN_BOTTOM);
      //临界值保护
      if (dy > (MAX_BOTTOM - MIN_BOTTOM)) {
        dy = MAX_BOTTOM - MIN_BOTTOM;
      } else if (dy < 0) {
        dy = 0;
      }
      setState(() {
        // 实际的padding
        _dyBottom = MIN_BOTTOM + dy;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomLeft,
      padding: EdgeInsets.only(bottom: _dyBottom, left: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: cachedImage(url: widget.face, width: 44, height: 44),
          ),
          hiSpace(width: 6),
          Text(
            widget.name,
            style: const TextStyle(fontSize: 12, color: Colors.deepOrange),
          )
        ],
      ),
    );
  }
}
