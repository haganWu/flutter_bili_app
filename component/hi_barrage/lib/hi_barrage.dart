import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hi_base/LogUtil.dart';
import 'barrage_item.dart';
import 'barrage_model.dart';
import 'barrage_view_util.dart';
import 'hi_socket.dart';
import 'ibarrage.dart';

enum BarrageStatus { play, pause }

class HiBarrage extends StatefulWidget {
  final int lineCount;
  final String vid;
  final int speed;
  final double top;
  final bool autoPlay;
  final Map<String, dynamic> headers;

  const HiBarrage({Key? key, this.lineCount = 4, required this.vid, this.speed = 800, this.top = 0, this.autoPlay = false, required this.headers})
      : super(key: key);

  @override
  State<HiBarrage> createState() => HiBarrageState();
}

class HiBarrageState extends State<HiBarrage> implements IBarrage {
  late HiSocket _hiSocket;
  late double _height;
  late double _width;

  // 弹幕Widget集合
  List<BarrageItem> _barrageItemList = [];

  // 弹幕模型
  List<BarrageModel> _barrageModelList = [];

  // 第几条弹幕
  int _barrageIndex = 0;
  Random _random = Random();
  BarrageStatus _barrageStatus = BarrageStatus.play;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _hiSocket = HiSocket(widget.headers);
    _hiSocket.open(widget.vid).listen((value) {
      _handleMessage(value);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _hiSocket.close();
    _timer?.cancel();
  }

  void _handleMessage(List<BarrageModel> modelList, {bool instant = false}) {
    if (instant) {
      _barrageModelList.insertAll(0, modelList);
    } else {
      _barrageModelList.addAll(modelList);
    }
    // 收到新的弹幕后播放
    if (_barrageStatus == BarrageStatus.play) {
      play();
      return;
    }
    // 收到新的弹幕后播放
    if (widget.autoPlay && _barrageStatus != BarrageStatus.pause) {
      play();
    }
  }

  /// 播放弹幕
  @override
  void play() {
    _barrageStatus = BarrageStatus.play;
    LogUtil.L("HiBarrage", "action： Play");
    if (_timer != null && _timer!.isActive) {
      return;
    }

    _timer = Timer.periodic(Duration(milliseconds: widget.speed), (timer) {
      if (_barrageModelList.isNotEmpty) {
        var temp = _barrageModelList.removeAt(0);
        addBarrage(temp);
        LogUtil.L("HiBarrage", "temp : ${temp.content}");
      } else {
        LogUtil.L("HiBarrage", "所有弹幕发送完毕");
        _timer?.cancel();
      }
    });
  }

  void addBarrage(BarrageModel model) {
    double perRowHeight = 30;
    var line = _barrageIndex % widget.lineCount;
    _barrageIndex++;
    var top = line * perRowHeight + widget.top;
    // 为每条弹幕生成唯一的id
    String id = "${_random.nextInt(10000)}:${model.content}";
    var item = BarrageItem(id: id, top: top, child: BarrageViewUtil.barrageView(model), onComplete: _onComplete);
    _barrageItemList.add(item);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    _height = _width / 16 * 9;
    return SizedBox(
      width: _width,
      height: _height,
      child: Stack(
        children: [
          // 防止Stack的child为空
          Container(), ..._barrageItemList,
        ],
      ),
    );
  }

  @override
  void pause() {
    _barrageStatus = BarrageStatus.pause;
    _barrageModelList.clear();
    // 刷新屏幕
    setState(() {});
    LogUtil.L("HiBarrage", "pause~~");
    _timer?.cancel();
  }

  @override
  void send(String message) {
    if (message.isNotEmpty) {
      _hiSocket.send(message);
      _handleMessage([BarrageModel(content: message, vid: '-1', priority: 1, type: 1)]);
    }
  }

  void _onComplete(id) {
    LogUtil.L("HiBarrage", "Done: $id");
    _barrageItemList.removeWhere((element) => element.id == id);
  }
}
