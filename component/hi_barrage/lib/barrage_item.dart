import 'package:flutter/material.dart';

import 'barrage_transition.dart';

class BarrageItem extends StatelessWidget {
  final String id;
  final double top;
  final Widget child;
  final ValueChanged onComplete;
  final Duration duration;

  BarrageItem(
      {Key? key,
      required this.id,
      required this.top,
      required this.child,
      required this.onComplete,
      this.duration = const Duration(milliseconds: 9000)})
      : super(key: key);

  // fix 动画状态错乱
  final _key = GlobalKey<BarrageTransitionState>();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        top: top,
        child: BarrageTransition(
          key: _key,
          duration: duration,
          onComplete: (v) {
            onComplete(id);
          },
          child: child,
        ));
  }
}
