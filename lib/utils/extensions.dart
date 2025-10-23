import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/utils/common_validation.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

extension BackendDateFormat on String {
  String toDisplayDateFormat() {
    try {
      final parsed = DateFormat("M/d/yyyy h:mm:ss a").parse(this);
      return DateFormat("dd/MM/yyyy").format(parsed);
    } catch (_) {
      return "";
    }
  }

  String? apiDateFormat() {
    try {
      final inputFormat = DateFormat("dd/MM/yyyy");
      final outputFormat = DateFormat("yyyy-MM-dd");
      final date = inputFormat.parse(this);
      return outputFormat.format(date);
    } catch (_) {
      return null; // or return "" or fallback date
    }
  }


  DateTime? toDateTime() {
    final trimmed = trim();
    if (trimmed.isEmpty) return null;

    try {
      // Try with Arabic comma format
      return DateFormat("dd/MM/yyyy, hh:mm a").parse(trimmed);
    } catch (_) {
      try {
        // Try plain date format
        return DateFormat("dd/MM/yyyy").parse(trimmed);
      } catch (_) {
        return null;
      }
    }
  }

  bool get isNotNullOrEmpty => this != null && this!.trim().isNotEmpty;

  String formatDateTime() {
    try {
      // Step 1: Parse using en-US input format
      final inputFormat = DateFormat('M/d/yyyy h:mm:ss a', 'en');
      final dateTime = inputFormat.parse(this);

      debugPrint("🟢 Raw Input: $this");
      debugPrint("🟢 Parsed DateTime: $dateTime");

      // Step 2: Output with current locale (Arabic/English)
      final currentLocale = Intl.getCurrentLocale();
      final outputFormat = DateFormat('dd MMM yyyy, hh:mm a', currentLocale);
      final formatted = outputFormat.format(dateTime);

      debugPrint("🌍 Current Locale: $currentLocale");
      debugPrint("📌 Formatted: $formatted");

      return formatted;
    } catch (e) {
      debugPrint('❌ Date parsing error: $e');
      return "";
    }
  }
}

extension FormatApiDateTime on String {
  /// Converts a datetime string like "7/11/2025 3:00:20 PM"
  /// to "11/07/2025 ,03:00 PM"
  String toDisplayDateTime() {
    try {
      final inputFormat = DateFormat('M/d/yyyy h:mm:ss a');
      final dateTime = inputFormat.parse(this);
      final outputFormat = DateFormat('dd/MM/yyyy, h:mm a');
      return outputFormat.format(dateTime);
    } catch (e) {
      return ''; // Return empty if parsing fails
    }
  }

  String toDisplayDateTimeString() {
    try {
      final dateTime = DateTime.parse(this);
      final outputFormat = DateFormat('dd/MM/yyyy, h:mm a');
      return outputFormat.format(dateTime);
    } catch (e) {
      return ''; // Return empty if parsing fails
    }
  }

  String toDisplayDateOnly() {
    if (this == null || this!.trim().isEmpty) return '';
    final dateString = this!.trim();
    try {
      DateTime dateTime;

      // Try ISO 8601 first
      try {
        dateTime = DateTime.parse(dateString);
      } catch (_) {
        // Fallback to old format
        final inputFormat = DateFormat('M/d/yyyy h:mm:ss a');
        dateTime = inputFormat.parse(dateString);
      }

      final outputFormat = DateFormat('dd/MM/yyyy');
      return outputFormat.format(dateTime);
    } catch (e) {
      debugPrint('Failed to parse date: $dateString, error: $e');
      return '';
    }
  }


  String toDisplayDate() {
    try {
      final dateTime = DateTime.parse(this); // Parses ISO 8601 format
      final outputFormat = DateFormat('dd/MM/yyyy');
      return outputFormat.format(dateTime);
    } catch (e) {
      return ''; // Return empty string on failure
    }
  }
}

extension FileBase64Extension on File {
  /// Converts this File to a base64-encoded string
  Future<String> toBase64() async {
    try {
      if (!await exists()) return "";
      final bytes = await readAsBytes();
      if (bytes.isEmpty) return "";
      return base64Encode(bytes);
    } catch (e) {
      // In case of any read/encoding errors, return an empty string
      return "";
    }
  }
}

extension Base64ByteExtension on String? {
  /// Converts this File to a base64-encoded string
  Uint8List? decodeBase64OrNull() {
    if (this == null) return null;
    try {
      return Uint8List.fromList(base64Decode(this!));
    } catch (e) {
      // Optionally log or handle the decoding error
      return null;
    }
  }
}

extension Base64ToFileExtension on String {
  /// Converts a base64 string back to a File at the given [fileName]
  Future<File> toFile({required String fileName}) async {
    final bytes = base64Decode(this);
    final dir = await getApplicationDocumentsDirectory();
    final filePath = path.join(dir.path, fileName);
    final file = File(filePath);
    return await file.writeAsBytes(bytes);
  }

  bool isArabic() {
    final arabicRegExp = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');
    return arabicRegExp.hasMatch(this);
  }
}

extension IdTypeExtension on IdType {
  // static IdType? fromString(String? value) {
  //   if (value == null) return IdType.nationalId;
  //
  //   switch (value.toLowerCase()) {
  //     case "iqama":
  //     case "الإقامة":
  //       return IdType.iqama;
  //     case "national id":
  //     case "الهوية_الوطنية":
  //       return IdType.nationalId;
  //     case "passport":
  //     case "جواز_السفر":
  //       return IdType.passport;
  //       case "passport":
  //     case "جواز_السفر":
  //       return IdType.passport;
  //     case "other":
  //     case "أخرى":
  //       return IdType.other;
  //     default:
  //       return IdType.nationalId;
  //   }
  // }
  //
  static IdType fromId(int? id) {
    switch (id) {
      case 24:
        return IdType.nationalId;
      case 26:
        return IdType.passport;
      case 2244:
        return IdType.iqama;
      case 2294:
        return IdType.visa;
      default:
        return IdType.nationalId;
    }
  }

  static String translatedLabel(BuildContext context, int? id) {
    final lang = context.watchLang;

    switch (id) {
      case 24:   // National ID
        return lang.translate(AppLanguageText.nationalIDExpiryDate);
      case 26:   // Passport
        return lang.translate(AppLanguageText.passportExpiryDate);
      case 2244: // Iqama
        return lang.translate(AppLanguageText.iqamaExpiryDate);
      case 2294: // Visa
        return lang.translate(AppLanguageText.visaExpiryDate);
      default:   // Other
        return lang.translate(AppLanguageText.nationalIDExpiryDate);
    }
  }

  static String? Function(BuildContext, String?) validatorById(int? id) {
    final validation = CommonValidation();

    switch (id) {
      case 24:   // National ID
        return validation.validateNationalIdExpiryDate;
      case 26:   // Passport
        return validation.validatePassportExpiryDate;
      case 2244: // Iqama
        return validation.validateIqamaExpiryDate;
      case 2294: // Visa
        return validation.validatePassportExpiryDate; // assuming same as passport
      default:   // Other
        return validation.validateNationalIdExpiryDate;
    }
  }
}

extension ApplyPassCategoryExtension on ApplyPassCategory {
  /// Returns a user-friendly string
  String label(BuildContext context) {
    switch (this) {
      case ApplyPassCategory.myself:
        return context.watchLang.translate(AppLanguageText.myself);
      case ApplyPassCategory.someoneElse:
        return context.watchLang.translate(AppLanguageText.someoneElse);
      case ApplyPassCategory.group:
        return context.watchLang.translate(AppLanguageText.group);
    }
  }

  /// Parses a string and returns the corresponding enum value
  static ApplyPassCategory? fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'myself':
        return ApplyPassCategory.myself;
      case 'someone else':
      case 'someoneelse':
        return ApplyPassCategory.someoneElse;
      case 'group':
        return ApplyPassCategory.group;
      default:
        return null;
    }
  }
}
