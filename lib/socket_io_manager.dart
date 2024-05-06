import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketIoManager {
  static final SocketIoManager _instance = SocketIoManager._internal();

  factory SocketIoManager() {
    return _instance;
  }

  SocketIoManager._internal();

  late IO.Socket socket;

  void initSocket() {
    socket = IO.io('https://serverd-rvou.onrender.com', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('Connected');
    });

    socket.on('chat message', (data) {
      print('Received message: $data');
      // Handle received message here
    });

    socket.onDisconnect((_) {
      print('Disconnected');
    });

    socket.connect();
  }

  void sendMessage(String message) {
    socket.emit('chat message', message);
  }
}
