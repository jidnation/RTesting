import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  //as singleton
  factory SecureStorage() {
    return _instance;
  }
  SecureStorage._internal();

  static final SecureStorage _instance = SecureStorage._internal();

  //To save secure data
  static Future writeSecureData(String key, String value) async {
    const _storage = FlutterSecureStorage();
    final _writeData = await _storage.write(key: key, value: value);
    return _writeData;
  }

  //To read the secured data
  static Future readSecureData(String key) async {
    const _storage = FlutterSecureStorage();
    final _readData = await _storage.read(key: key);
    return _readData;
  }

  //To delete the secured data
  static Future<void> deleteSecureData() async {
    const _storage = FlutterSecureStorage();
    await _storage.deleteAll();
  }
}
