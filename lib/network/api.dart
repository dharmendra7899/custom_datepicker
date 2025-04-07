import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/cupertino.dart';

class API1 {
  final String sign;
  final String salt;

  API1()
    : salt = _getRandomSalt(),
      sign = _generateSign('viaviweb', _getRandomSalt());

  static String _getRandomSalt() {
    final random = Random();
    return (random.nextInt(900)).toString(); // Same range as Java (0 - 899)
  }

  static String _generateSign(String apiKey, String salt) {
    final input = apiKey + salt;
    final bytes = utf8.encode(input);
    final digest = md5.convert(bytes);
    return digest.toString();
  }

  static String toBase64(String input) {
    try {
      var bytes = utf8.encode(input);
      return base64Encode(bytes);
    } catch (e) {
      debugPrint('Error encoding to Base64: $e');
      rethrow;
    }
  }

  //  FIXED: Added the toMap() method
  Map<String, String> toMap() {
    return {'sign': sign, 'salt': salt};
  }
}

class API {
  late String sign;
  late String salt;

  API() {
    String apiKey = "viaviweb";
    salt = _getRandomSalt().toString();
    sign = _md5(apiKey + salt);
  }

  //  Generate Random Salt (0 - 899)
  int _getRandomSalt() {
    final random = Random();
    return random.nextInt(900);
  }

  //  MD5 Hashing
  String _md5(String input) {
    return md5.convert(utf8.encode(input)).toString();
  }

  //  Base64 Encoding
  static String toBase64(String input) {
    final bytes = utf8.encode(input);
    return base64.encode(bytes);
  }

  //  Convert API to Map
  Map<String, String> toMap() {
    return {'sign': sign, 'salt': salt};
  }
}
