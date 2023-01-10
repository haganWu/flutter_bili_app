
import 'package:flutter/material.dart';

appBar(String title,String rightTitle, VoidCallback? rightButtonClick) {
  return AppBar(
    // 标题居左
    centerTitle: false,
    titleSpacing: 0,
    leading: const BackButton(),
    title: Text(title, style: const TextStyle(fontSize: 18)),
    actions: [
      InkWell(
        onTap: rightButtonClick,
        child: Container(
          padding: const EdgeInsets.only(left: 16, right: 16),
          alignment: Alignment.center,
          child: Text(rightTitle, style: TextStyle(fontSize: 18, color: Colors.grey[500]),textAlign: TextAlign.center,),
        ),
      )
    ],
  );
}

