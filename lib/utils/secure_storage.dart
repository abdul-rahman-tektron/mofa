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

  static Future<void> setRememberMe(String value) async {
    await _secureStorage?.write(key: AppStrings.rememberMeKey, value: value);
  }

  static Future<String?> getRememberMe() async {
    return await _secureStorage?.read(key: AppStrings.rememberMeKey);
  }

  static Future<void> setToken(String value) async {
    await _secureStorage?.write(key: AppStrings.accessToken, value: value);
  }

  static Future<String?> getToken() async {
    return await _secureStorage?.read(key: AppStrings.accessToken);
  }

  static Future<void> setLanguageCode(String value) async {
    await _secureStorage?.write(key: AppStrings.languageCode, value: value);
  }

  static Future<String?> getLanguageCode() async {
    return await _secureStorage?.read(key: AppStrings.languageCode);
  }

  static Future<void> setAppointmentData(String value) async {
    await _secureStorage?.write(key: AppStrings.appointmentData, value: value);
  }

  static Future<String?> getAppointmentData() async {
    return await _secureStorage?.read(key: AppStrings.appointmentData);
  }

  static Future<void> setUploadedImage(String value) async {
    await _secureStorage?.write(key: AppStrings.uploadedImageCode, value: value);
  }

  static Future<String?> getUploadedImage() async {
    return await _secureStorage?.read(key: AppStrings.uploadedImageCode);
  }

  static Future<void> setCaptchaData(String value) async {
    await _secureStorage?.write(key: AppStrings.uploadedImageCode, value: value);
  }

  static Future<String?> getCaptchaData() async {
    return await _secureStorage?.read(key: AppStrings.uploadedImageCode);
  }

  static Future<void> removeParticularKey(String key) async {
    await _secureStorage?.delete(key: key);
  }

  static Future<void> clear() async {
    await _secureStorage?.deleteAll();
  }

  static Future<void> clearExceptRememberMe() async {
    final rememberMeValue = await getRememberMe(); // Step 1: Save current rememberMe value
    await _secureStorage?.deleteAll();             // Step 2: Clear everything
    if (rememberMeValue != null) {                 // Step 3: Restore rememberMe value
      await setRememberMe(rememberMeValue);
    }
  }
}

