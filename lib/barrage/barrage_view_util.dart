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
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(15)
        ),
        child: Text(model.content!, style: const TextStyle(color: Colors.deepOrangeAccent)),
      ),
    );
  }
}
