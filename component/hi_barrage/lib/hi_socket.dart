import 'package:flutter/material.dart';
import 'package:hi_base/LogUtil.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'barrage_model.dart';


/// 与后端webSocket通信
class HiSocket implements ISocket {
  Map<String, dynamic> headers;
  static const _URL = "wss://api.devio.org/uapi/fa/barrage/";
  WebSocketChannel? _channel;
  ValueChanged<List<BarrageModel>>? _callBack;
  final int _intervalSeconds = 50;


  HiSocket(this.headers);

  @override
  ISocket open(String vid) {
    _channel = IOWebSocketChannel.connect(_URL + vid, headers: headers, pingInterval: Duration(seconds: _intervalSeconds));
    _channel?.stream.handleError((error) {
      LogUtil.L("HiSocket", "链接发生错误:$error");
    }).listen((message) {
      _handleMessage(message);
    });
    return this;
  }

  /// 处理服务端数据返回
  void _handleMessage(message) {
    LogUtil.L("HiSocket", "received:$message");
    var result = BarrageModel.fromJsonString(message);
    if(_callBack != null){
      _callBack!(result);
    }
  }

  @override
  ISocket send(String message) {
    _channel?.sink.add(message);
    return this;
  }

  @override
  void close() {
    if(_channel != null){
      _channel?.sink.close();
    }
  }

  @override
  ISocket listen(ValueChanged<List<BarrageModel>> callBack) {
    _callBack = callBack;
    return this;
  }
}



abstract class ISocket {
  /// 和服务器建立链接
  ISocket open(String vid);

  /// 发送弹幕
  ISocket send(String message);

  ///关闭链接
  void close();

  /// 接收弹幕
  ISocket listen(ValueChanged<List<BarrageModel>> callBack);
}
