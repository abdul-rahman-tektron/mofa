import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class ErrorHandler {
  static final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Initialize Crashlytics and set global error handling
  static Future<void> initialize() async {
    FlutterError.onError = _crashlytics.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// Set global custom keys (e.g., screen, user)
  static Future<void> setContext({
    String? screen,
    String? userId,
    Map<String, dynamic>? extras,
  }) async {
    if (screen != null) {
      await _crashlytics.setCustomKey('screen', screen);
    }
    if (userId != null) {
      await _crashlytics.setUserIdentifier(userId);
    }
    extras?.forEach((key, value) async {
      await _crashlytics.setCustomKey(key, value.toString());
    });
  }

  /// Log messages manually
  static void log(String message) {
    _crashlytics.log(message);
  }

  /// Record handled exceptions
  static Future<void> recordError(
      dynamic error,
      StackTrace? stack, {
        bool fatal = false,
        String? reason,
        Map<String, dynamic>? context,
      }) async {
    try {
      if (context != null) {
        for (final entry in context.entries) {
          await _crashlytics.setCustomKey(entry.key, entry.value.toString());
        }
      }
      await _crashlytics.recordError(error, stack, fatal: fatal, reason: reason);
    } catch (e, s) {
      log('Error logging failed: $e');
      log('$s');
    }
  }

  /// Force crash (for testing)
  static void crash() {
    _crashlytics.crash();
  }
}
