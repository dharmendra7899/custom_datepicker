/*
import 'package:family_location_app/core/constant/urls.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  late IO.Socket socket;

  Future<void> connect(String token) async {
    print("TOKEN::: $token");
    var url = "${YUrls.webSocketUrl}?authToken=$token";
    socket = IO.io(url, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
      'reconnection': true,
      'reconnectionAttempts': 5,
      'reconnectionDelay': 1000,
    });

    socket.connect();
    print("Socket connection initiated...");
  }

  void on(String event, Function(dynamic) callback) {
    socket.on(event, callback);
  }

  void emit(String event, dynamic data) {
    socket.emit(event, data);
  }

  void disconnect() {
    socket.disconnect();
    print("Socket disconnected.");
  }
}
*/
