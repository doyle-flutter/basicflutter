import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;


class SocketProvider with ChangeNotifier{
  IO.Socket socket;

  String chatTxt;
  void _init(){
    this.socket = IO.io('http://192.168.0.2:3000/', <String, dynamic>{'transports': ['websocket']});
    socket.on('connect', (_) {
      socket.emit('open', "FlutterSocketTest");
    });
    socket.on('welcome', (data) => print(data));

    notifyListeners();
  }

  SocketProvider(){
    _init();
  }
}