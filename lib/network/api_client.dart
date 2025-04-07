import 'dart:io';
import 'response_model.dart';

abstract interface class ApiClient {
  Future<ResponseModel?> postApi({
    required String url,
    bool? isEncrypted,
    Map<String, dynamic>? body,
  });

  Future<ResponseModel?> getApi({required String url});

  Future<ResponseModel?> deleteApi({
    required String url,
    Map<String, dynamic>? body,
  });

  Future<ResponseModel?> putApi({
    required String url,
    required Map<String, dynamic> body,
  });

  Future<ResponseModel?> patchApi({
    required String url,
    required Map<String, dynamic> body,
  });

  Future<ResponseModel?> multipartApi({
    required String url,
    Map<String, dynamic>? body,
    File? userImage,
    File? aadhaarImage,
    File? panImage,
  });


}

abstract class SocketService {
  Future<void> connect();

  void emit(String event, dynamic data);

  void on(String event, Function(dynamic) callback);

  void off(String event);

  Stream<dynamic> get stream;
}
