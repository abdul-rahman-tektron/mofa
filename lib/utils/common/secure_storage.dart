import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mofa/res/app_strings.dart';

class SecureStorageHelper {
  static FlutterSecureStorage? _secureStorage;

  // Call this in main() before runApp()
  static Future init() async {
    _secureStorage = const FlutterSecureStorage();
  }

  static Future<void> setUser(String value) async {
    await _secureStorage?.write(key: AppStrings.userKey, value: value);
  }

  static Future<String?> getUser() async {
    return await _secureStorage?.read(key: AppStrings.userKey);
  }

  static Future<void> setToken(String value) async {
    await _secureStorage?.write(key: AppStrings.accessToken, value: value);
  }

  static Future<String?> getToken() async {
    return await _secureStorage?.read(key: AppStrings.accessToken);
  }

  static Future<void> setLanguageCode(String value) async {
    await _secureStorage?.write(key: AppStrings.accessToken, value: value);
  }

  static Future<String?> getLanguageCode() async {
    return await _secureStorage?.read(key: AppStrings.accessToken);
  }

  static Future<void> removeParticularKey(String key) async {
    await _secureStorage?.delete(key: key);
  }

  static Future<void> clear() async {
    await _secureStorage?.deleteAll();
  }
}

