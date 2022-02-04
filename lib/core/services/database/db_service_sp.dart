import 'package:shared_preferences/shared_preferences.dart';

class DatabaseServiceSp {
  static final DatabaseServiceSp _instance = DatabaseServiceSp._internal();
  DatabaseServiceSp._internal();

  factory DatabaseServiceSp() {
    return _instance;
  }

  static const String usernameKey = 'usernameKey';
  static const String emailKey = 'emailKey';

  static Future<bool> saveUsername(String username) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    return await shared.setString(usernameKey, username);
  }

  static Future<bool> saveEmail(String email) async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    return await shared.setString(emailKey, email);
  }

  static Future<String?> getUsername() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getString(usernameKey);
  }

  static Future<String?> getEmail() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    return shared.getString(emailKey);
  }

  static Future<void> dispose() async {
    SharedPreferences shared = await SharedPreferences.getInstance();
    shared.remove(usernameKey);
    shared.remove(emailKey);
  }
}
