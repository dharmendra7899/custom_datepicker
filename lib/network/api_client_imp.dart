import 'dart:convert';
import 'dart:io';
import 'package:custom_datepicker/constant/messages.dart';
import 'package:custom_datepicker/helpers/session_manager.dart';
import 'package:custom_datepicker/network/api.dart';
import 'package:custom_datepicker/network/api_client.dart';
import 'package:custom_datepicker/network/response_model.dart';
import 'package:custom_datepicker/utils/printer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'connectivity_validator.dart';
import 'server_error.dart';

class ApiClientImp implements ApiClient {
  final Dio _dio;
  final SessionManager sessionManager;

  ApiClientImp({required this.sessionManager}) : _dio = Dio() {
    // _dio.options.baseUrl = AppUrls.localBaseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 60);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
  }

  // Build Headers
  Future<Map<String, String>> _buildHeaders() async {
    return {'Content-Type': 'multipart/form-data'};
  }

  // Handle Dio Errors
  void _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      throw ServerError(408, Messages.NETWORK_TIMEOUT);
    } else if (e.response != null) {
      throw ServerError(
        e.response!.statusCode ?? 500,
        e.response!.data['msg'] ?? Messages.SERVER_NOT_RESPONDING,
      );
    } else {
      throw ServerError(500, Messages.SERVER_NOT_RESPONDING);
    }
  }

  // Handle Request
  Future<ResponseModel?> _handleRequest(Future<Response> request) async {
    if (!await ConnectivityProvider.checkConnectivity()) {
      throw ServerError(503, Messages.NO_INTERNET);
    }

    try {
      final response = await request;
      Printer.printResponse(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        return ResponseModel.fromJson(response.data);
      } else {
        throw ServerError(
          response.statusCode ?? 500,
          response.data['msg'] ?? Messages.SERVER_NOT_RESPONDING,
        );
      }
    } on DioException catch (e) {
      _handleDioError(e);
    } catch (e) {
      rethrow;
    }
    return null;
  }

  // POST Request with Base64 + MD5 Sign (as FormData)
  @override
  Future<ResponseModel?> postApi({
    required String url,
    bool? isEncrypted,
    Map<String, dynamic>? body,
  }) async {
    if (body != null) {
      final api = API();
      body.addAll(api.toMap());
      final encodedBody = API.toBase64(json.encode(body));
      final formData = FormData.fromMap({'data': '"$encodedBody"'});
      for (var field in formData.fields) {
        Printer.prettyPrint("${field.key}:${field.value}");
      }
      return _handleRequest(
        _dio.post(url, data: isEncrypted == true ? body : formData),
      );
    }
    return null;
  }

  // GET Request
  @override
  Future<ResponseModel?> getApi({required String url}) async {
    final headers = await _buildHeaders();
    return _handleRequest(_dio.get(url, options: Options(headers: headers)));
  }

  // DELETE Request with Base64
  @override
  Future<ResponseModel?> deleteApi({
    required String url,
    Map<String, dynamic>? body,
  }) async {
    final headers = await _buildHeaders();

    if (body != null) {
      final api = API();
      body.addAll(api.toMap());
      final encodedBody = API.toBase64(json.encode(body));

      final formData = FormData.fromMap({'data': '"$encodedBody"'});

      return _handleRequest(
        _dio.delete(url, data: formData, options: Options(headers: headers)),
      );
    }
    return null;
  }

  // PUT Request with Base64
  @override
  Future<ResponseModel?> putApi({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final headers = await _buildHeaders();

    final api = API();
    body.addAll(api.toMap());
    final encodedBody = API.toBase64(json.encode(body));

    final formData = FormData.fromMap({'data': '"$encodedBody"'});

    return _handleRequest(
      _dio.put(url, data: formData, options: Options(headers: headers)),
    );
  }

  // PATCH Request with Base64
  @override
  Future<ResponseModel?> patchApi({
    required String url,
    required Map<String, dynamic> body,
  }) async {
    final headers = await _buildHeaders();

    final api = API();
    body.addAll(api.toMap());
    final encodedBody = API.toBase64(json.encode(body));

    final formData = FormData.fromMap({'data': '"$encodedBody"'});

    return _handleRequest(
      _dio.patch(url, data: formData, options: Options(headers: headers)),
    );
  }

  @override
  Future<ResponseModel?> multipartApi({
    required String url,
    Map<String, dynamic>? body,
    File? userImage,
    File? aadhaarImage,
    File? panImage,
  }) async {
    try {
      // final options = RequestOptions(path: url, data: body);
      // Printer.printRequest(options);
      final headers = await _buildHeaders();
      String? encodedBody;
      if (body != null) {
        final api = API();
        body.addAll(api.toMap());
        encodedBody = API.toBase64(json.encode(body));
      }
      FormData formData = FormData.fromMap({
        if (encodedBody != null) 'data': '"$encodedBody"',
        if (userImage != null)
          'user_image': await MultipartFile.fromFile(
            userImage.path,
            filename: userImage.path.split('/').last,
          ),
        if (aadhaarImage != null)
          'aadhaar_image': await MultipartFile.fromFile(
            aadhaarImage.path,
            filename: aadhaarImage.path.split('/').last,
          ),
        if (panImage != null)
          'pan_image': await MultipartFile.fromFile(
            panImage.path,
            filename: panImage.path.split('/').last,
          ),
      });

      if (userImage != null) debugPrint("User Image: ${userImage.path}");
      if (aadhaarImage != null) {
        debugPrint("Aadhaar Image: ${aadhaarImage.path}");
      }
      if (panImage != null) debugPrint("Pan Image: ${panImage.path}");
      for (var field in formData.fields) {
        Printer.prettyPrint("${field.key}:${field.value}");
      }
      final response = await _dio.post(
        url,
        data: formData,
        options: Options(headers: headers, contentType: 'multipart/form-data'),
      );

      return _handleRequest(Future.value(response));
    } catch (e) {
      debugPrint('Error in multipartApi: $e');
      return null;
    }
  }
}
