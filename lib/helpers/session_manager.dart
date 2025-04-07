import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SessionManager {
  Future<void> setUserId(String userId);

  Future<String> getUserId();

  Future<String> getSession();

  Future<void> setSession(String userData);

  Future<void> setWalkThrough();

  Future<bool> isWalkThrough();

  Future<void> clearSession();
}

class SessionManagerImp implements SessionManager {
  final SharedPreferences sharedPreferences;

  SessionManagerImp({required this.sharedPreferences});

  @override
  Future<String> getSession() async {
    var data = sharedPreferences.getString(Keys.USERDETAILS.toString());
    if (data != null) {
      try {
      //  return JobsApp.fromJson(jsonDecode(data));
        return "Test";
      } catch (e) {
        debugPrint('Error decoding session data: $e');
        //return null;
        return "";
      }
    }
    return "";
  }

  @override
  Future<void> setSession(String userData) async {
    await sharedPreferences.setString(
      Keys.USERDETAILS.toString(),"Test"
      //jsonEncode(userData.toJson()),
    );
  }

  @override
  Future<void> setWalkThrough() async {
    sharedPreferences.setBool(Keys.WALKTHROUGH.toString(), false);
  }

  @override
  Future<bool> isWalkThrough() async {
    return sharedPreferences.getBool(Keys.WALKTHROUGH.toString()) ?? true;
  }

  @override
  Future<String> getUserId() async {
    return sharedPreferences.getString(Keys.USERID.toString()) ?? '';
  }

  @override
  Future<void> setUserId(String userId) async {
    await sharedPreferences.setString(Keys.USERID.toString(), userId);
  }

  @override
  Future<void> clearSession() async {
    await sharedPreferences.remove(Keys.USERID.toString());
    await sharedPreferences.remove(Keys.USERDETAILS.toString());
  }
}

enum Keys { USERDETAILS, WALKTHROUGH, USERID }
