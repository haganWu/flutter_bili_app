import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/model/home_mo.dart';
import 'package:flutter_bili_app/utils/LogUtil.dart';
import 'package:flutter_bili_app/utils/view_util.dart';

class ExpandableContent extends StatefulWidget {
  final VideoMo videoMo;

  const ExpandableContent({Key? key, required this.videoMo}) : super(key: key);

  @override
  State<ExpandableContent> createState() => _ExpandableContentState();
}

class _ExpandableContentState extends State<ExpandableContent> with SingleTickerProviderStateMixin {
  final String tag = 'ExpandableContent';
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);
  bool _expand = false;

  // 管理动画controller
  late AnimationController _controller;

  // 生成动画高度值
  late Animation<double> _heightFactor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 200), vsync: this);
    _heightFactor = _controller.drive(_easeInTween);
    _controller.addListener(() {
      LogUtil.L(tag, '动画值:${_heightFactor.value}');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 4),
      child: Column(
        children: [_buildTitle(), const Padding(padding: EdgeInsets.only(bottom: 8)), _buildInfo(), _buildDesc()],
      ),
    );
  }

  _buildTitle() {
    return InkWell(
      onTap: _toggleExpand,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Text(widget.videoMo.title!, maxLines: 1, overflow: TextOverflow.ellipsis)),
          Padding(
            padding: const EdgeInsets.only(left: 6),
            child: Icon(
              _expand ? Icons.keyboard_arrow_up_sharp : Icons.keyboard_arrow_down_sharp,
              color: Colors.grey,
              size: 18,
            ),
          )
        ],
      ),
    );
  }

  void _toggleExpand() {
    LogUtil.L(tag, '_toggleExpand');
    setState(() {
      _expand = !_expand;
      if (_expand) {
        // 执行动画
        _controller.forward();
      } else {
        // 方向执行动画
        _controller.reverse();
      }
    });
  }

  _buildInfo() {
    var style = const TextStyle(fontSize: 12, color: Colors.grey);
    var dateStr = widget.videoMo.createTime!.length > 10 ? widget.videoMo.createTime!.substring(5, 10) : widget.videoMo.createTime;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ...smallIconText(Icons.ondemand_video, widget.videoMo.view!),
        const Padding(padding: EdgeInsets.only(left: 18)),
        ...smallIconText(Icons.list_alt, widget.videoMo.reply!),
        const Padding(padding: EdgeInsets.only(left: 18)),
        Text('$dateStr', style: style),
      ],
    );
  }

  _buildDesc() {
    var child = _expand ? Text(widget.videoMo.desc!, style: const TextStyle(fontSize: 12, color: Colors.grey)) : null;
    return AnimatedBuilder(
        animation: _controller.view,
        builder: (BuildContext context, Widget? child) {
          return Align(
            heightFactor: _heightFactor.value,
            // 从布局中上边的位置开始展开
            alignment: Alignment.topCenter,
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.only(top: 6),
              child: child,
            ),
          );
        },
        child: child);
  }
}
