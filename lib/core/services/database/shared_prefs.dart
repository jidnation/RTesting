// ignore_for_file: avoid_positional_boolean_parameters

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  factory SharedPrefs() {
    return _instance;
  }
  SharedPrefs._internal();

  static final SharedPrefs _instance = SharedPrefs._internal();

  static Future<bool> setBool(String key, bool value) async {
    final shared = await SharedPreferences.getInstance();
    return shared.setBool(key, value);
  }

  static Future<bool> setString(String key, String? value) async {
    final shared = await SharedPreferences.getInstance();
    return shared.setString(key, value!);
  }

  static Future<String?> getString(String key) async {
    final shared = await SharedPreferences.getInstance();
    return shared.getString(key);
  }

  static Future<bool?> getBool(String key) async {
    final shared = await SharedPreferences.getInstance();
    return shared.getBool(key);
  }

  static Future<bool> dispose(String key) async {
    final shared = await SharedPreferences.getInstance();
    return shared.remove(key);
  }
}
