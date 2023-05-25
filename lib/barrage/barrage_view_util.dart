import 'package:flutter/material.dart';
import 'package:flutter_bili_app/http/model/barrage_model.dart';

class BarrageViewUtil {
  static barrageView(BarrageModel model) {
    switch (model.type) {
      case 1:
        return _barrageType1(model);
    }
    return Text(model.content!, style: const TextStyle(color: Colors.white));
  }

  static _barrageType1(BarrageModel model) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.orange),
          borderRadius: BorderRadius.circular(4)
        ),
        padding: const EdgeInsets.only(left: 6, right: 6, top: 2, bottom: 2),
        child: Text(model.content!, style: const TextStyle(color: Colors.deepOrangeAccent)),
      ),
    );
  }
}
