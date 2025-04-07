import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class Printer {
  static void printRequest(RequestOptions request) {
    if (kDebugMode) {
      print("╔═╣ Request ║ ${request.method.toUpperCase()} ");
      print("║");
      print("║  ${request.uri}");
      print("║");
      print(
        "║═╣ Headers ║══════════════════════════════════════════════════════════════════════════════",
      );
      prettyPrint(jsonEncode(request.headers));
      print(
        "║═╣ Body ║═════════════════════════════════════════════════════════════════════════════════",
      );

      if (request.data != null) {
        if (request.data is Map || request.data is List) {
          prettyPrint(jsonEncode(request.data));
        } else {
          print(request.data.toString());
        }
      } else {
        print("║  (Empty Body)");
      }

      print(
        '╚══════════════════════════════════════════════════════════════════════════════════════════╝',
      );
    }
  }

  static void printResponse(Response response) {
    if (kDebugMode) {
      print("╔═╣ Response ║ Status: ${response.statusCode}");
      print("║");
      print("║  ${response.requestOptions.uri}");
      print("║");
      print(
        "║═╣ Body ║═════════════════════════════════════════════════════════════════════════════════",
      );

      if (response.data != null) {
        if (response.data is Map || response.data is List) {
          prettyPrint(jsonEncode(response.data));
        } else {
          print(response.data.toString());
        }
      } else {
        print("║  (Empty Body)");
      }

      print(
        '╚══════════════════════════════════════════════════════════════════════════════════════════╝',
      );
    }
  }

  static void prettyPrint(String jsonString) {
    try {
      final jsonData = jsonDecode(jsonString);
      const encoder = JsonEncoder.withIndent('  ');
      final prettyString = encoder.convert(jsonData);

      if (prettyString.length > 1000) {
        int startIndex = 0;
        while (startIndex < prettyString.length) {
          int endIndex =
              (startIndex + 1000 <= prettyString.length - 1)
                  ? startIndex + 1000
                  : prettyString.length - 1;

          while (endIndex > startIndex && prettyString[endIndex] != '\n') {
            endIndex--;
          }
          endIndex =
              endIndex < prettyString.length
                  ? endIndex
                  : prettyString.length - 1;

          if (kDebugMode) {
            print(prettyString.substring(startIndex, endIndex));
          }
          startIndex = endIndex + 1;
        }
      } else {
        if (kDebugMode) {
          print(prettyString);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("║ Invalid JSON, raw output:");
        print(jsonString);
      }
    }
  }
}
