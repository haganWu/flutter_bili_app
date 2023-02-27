import 'package:flutter/material.dart';
import 'package:flutter_bili_app/utils/view_util.dart';

appBar({required String title, required String rightTitle, bool showLeftBack = true, VoidCallback? rightButtonClick}) {
  return AppBar(
    // 标题居左
    centerTitle: false,
    toolbarHeight: 36,
    titleSpacing: 0,
    leading: showLeftBack ? const BackButton() : null,
    title: Padding(
      padding: EdgeInsets.only(left: showLeftBack ? 0 : 16),
      child: Text(title, style: const TextStyle(fontSize: 18)),
    ),
    actions: [
      InkWell(
        onTap: rightButtonClick,
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          alignment: Alignment.center,
          child: Text(
            rightTitle,
            style: TextStyle(fontSize: 18, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ),
      )
    ],
  );
}

videoAppBar() {
  return Container(
    padding: const EdgeInsets.only(right: 8),
    decoration: BoxDecoration(gradient: blackLinearGradient(fromTop: true)),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const BackButton(color: Colors.white),
        Row(
          children: const [
            Icon(Icons.live_tv_rounded, color: Colors.white, size: 20),
            Padding(padding: EdgeInsets.only(left: 12), child: Icon(Icons.more_vert_rounded, color: Colors.white, size: 20))
          ],
        )
      ],
    ),
  );
}
