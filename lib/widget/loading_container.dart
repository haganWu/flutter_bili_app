import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingContainer extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  // 是否覆盖到原有的界面上
  final bool isCover;

  const LoadingContainer({Key? key, required this.child, required this.isLoading, this.isCover = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCover) {
      return Stack(
        children: [
          child,
          if (isLoading) _loadingView(),
        ],
      );
    } else {
      return isLoading ? _loadingView() : child;
    }
  }

  // lottie动画
  _loadingView() {
    return Center(
      child: Lottie.asset('assets/loading.json'),
    );
  }
}
