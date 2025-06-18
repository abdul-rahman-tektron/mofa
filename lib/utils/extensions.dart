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
      // Step 1: Parse using the correct format
      final inputFormat = DateFormat('M/d/yyyy h:mm:ss a');
      final dateTime = inputFormat.parse(this);

      // Step 2: Format to desired output
      final outputFormat = DateFormat('dd MMM yyyy, hh:mm a');
      return outputFormat.format(dateTime);
    } catch (e) {
      print('Date parsing error: $e');
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
    try {
      final inputFormat = DateFormat('M/d/yyyy h:mm:ss a');
      final dateTime = inputFormat.parse(this);
      final outputFormat = DateFormat('dd/MM/yyyy');
      return outputFormat.format(dateTime);
    } catch (e) {
      return ''; // Return empty if parsing fails
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
}

extension IdTypeExtension on IdType {
  static IdType? fromString(String? value) {
    if (value == null) return IdType.nationalId;

    switch (value.toLowerCase()) {
      case "iqama":
      case "الإقامة":
        return IdType.iqama;
      case "national id":
      case "الهوية_الوطنية":
        return IdType.nationalId;
      case "passport":
      case "جواز_السفر":
        return IdType.passport;
      case "other":
      case "أخرى":
        return IdType.other;
      default:
        return IdType.nationalId;
    }
  }

  static IdType? fromInt(int? value) {
    switch (value ?? 0) {
      case 2244:
        return IdType.iqama;
      case 24:
        return IdType.nationalId;
      case 26:
        return IdType.passport;
      case 2245:
        return IdType.other;
      default:
        return IdType.nationalId;
    }
  }

  String translatedLabel(BuildContext context) {
    final lang = context.watchLang;
    switch (this) {
      case IdType.nationalId:
        return lang.translate(AppLanguageText.nationalIDExpiryDate);
      case IdType.iqama:
        return lang.translate(AppLanguageText.iqamaExpiryDate);
      case IdType.passport:
        return lang.translate(AppLanguageText.passportExpiryDate);
      case IdType.other:
        return lang.translate(AppLanguageText.documentExpiryDateOther);
      default:
        return lang.translate(AppLanguageText.nationalIDExpiryDate);
    }
  }

  String? Function(BuildContext, String?) get validator {
    final validation = CommonValidation();
    switch (this) {
      case IdType.nationalId:
        return validation.validateNationalIdExpiryDate;
      case IdType.iqama:
        return validation.validateIqamaExpiryDate;
      case IdType.passport:
        return validation.validatePassportExpiryDate;
      case IdType.other:
        return validation.validateDocumentExpiryDate;
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
