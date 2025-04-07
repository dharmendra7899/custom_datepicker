import 'dart:async';

import 'package:custom_datepicker/network/api_client.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketServiceImp implements SocketService {
  final String _url;
  late IO.Socket _socket;
  StreamController<dynamic>? _controller;
  SocketServiceImp({required String url}) : _url = url;

  @override
  Future<void> connect() async {
    final options = IO.OptionBuilder()
        .setTransports(['websocket'])
        .enableForceNew()
        .enableReconnection()
        .build();

    _socket = IO.io(_url, options);

    _socket.onConnect((val) {
      debugPrint('Connected to socket server $val');
    });

    _socket.onDisconnect((val) {
      debugPrint('Disconnected from socket server $val');
    });

    _socket.onConnectError((error) {
      debugPrint('Socket connect error: $error');
    });

    _socket.onError((error) {
      debugPrint('Socket error: $error');
    });

    if (_controller == null || _controller!.isClosed) {
      _controller = StreamController<dynamic>.broadcast();
    }

    _socket.onAny((event, data) {
      debugPrint('Event :: $event  data:: $data');
      if (_controller != null && !_controller!.isClosed) {
        _controller!.add({'event': event, 'data': data});
      } else {
        debugPrint('Warning: Tried to add to a closed controller');
      }
    });
  }

  @override
  void emit(String event, data) {
    _socket.emit(event, data);
  }

  @override
  void off(String event) {
    _socket.off(event);
  }

  @override
  void on(String event, Function(dynamic p1) callback) {
    _socket.on(event, callback);
  }

  @override
  Stream<dynamic> get stream {
    if (_controller != null && !_controller!.isClosed) {
      return _controller!.stream;
    } else {
      return const Stream.empty();
    }
  }
}
