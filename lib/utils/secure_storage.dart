import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mofa/res/app_strings.dart';
import 'package:mofa/utils/error_handler.dart';

class SecureStorageHelper {
  static FlutterSecureStorage? _secureStorage;

  // Initialize with encryptedSharedPreferences on Android
  static Future init() async {
    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    );
  }

  // Safe read wrapper to handle BadPaddingException
  static Future<String?> _safeRead(String key) async {
    try {
      return await _secureStorage?.read(key: key);
    } catch (e, stack) {
      await ErrorHandler.recordError(e, stack, context: {
        'widget': 'Secure Storage',
        'action': 'Fetching data from Local',
      });

      if (e is PlatformException && e.code == 'BadPaddingException') {
        await _secureStorage?.deleteAll(); // Optional: clear on corruption
      }
      return null;
    }
  }

  static Future<void> setUser(String value) async {
    await _secureStorage?.write(key: AppStrings.userKey, value: value);
  }

  static Future<String?> getUser() async {
    return await _safeRead(AppStrings.userKey);
  }

  static Future<void> setRememberMe(String value) async {
    await _secureStorage?.write(key: AppStrings.rememberMeKey, value: value);
  }

  static Future<String?> getRememberMe() async {
    return await _safeRead(AppStrings.rememberMeKey);
  }

  static Future<void> setToken(String value) async {
    await _secureStorage?.write(key: AppStrings.accessToken, value: value);
  }

  static Future<String?> getToken() async {
    return await _safeRead(AppStrings.accessToken);
  }

  static Future<void> setLanguageCode(String value) async {
    await _secureStorage?.write(key: AppStrings.languageCode, value: value);
  }

  static Future<String?> getLanguageCode() async {
    return await _safeRead(AppStrings.languageCode);
  }

  static Future<void> setAppointmentData(String value) async {
    await _secureStorage?.write(key: AppStrings.appointmentData, value: value);
  }

  static Future<String?> getAppointmentData() async {
    return await _safeRead(AppStrings.appointmentData);
  }

  static Future<void> setUploadedImage(String value) async {
    await _secureStorage?.write(key: AppStrings.uploadedImageCode, value: value);
  }

  static Future<String?> getUploadedImage() async {
    return await _safeRead(AppStrings.uploadedImageCode);
  }

  static Future<void> setCaptchaData(String value) async {
    await _secureStorage?.write(key: AppStrings.uploadedImageCode, value: value);
  }

  static Future<String?> getCaptchaData() async {
    return await _safeRead(AppStrings.uploadedImageCode);
  }

  static Future<void> removeParticularKey(String key) async {
    await _secureStorage?.delete(key: key);
  }

  static Future<void> clear() async {
    await _secureStorage?.deleteAll();
  }

  static Future<void> clearExceptRememberMe() async {
    final rememberMeValue = await getRememberMe();
    await _secureStorage?.deleteAll();
    if (rememberMeValue != null) {
      await setRememberMe(rememberMeValue);
    }
  }
}
