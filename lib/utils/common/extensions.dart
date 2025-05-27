import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/utils/common/common_validation.dart';
import 'package:mofa/utils/common/enum_values.dart';
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
      return DateFormat("dd/MM/yyyy ،hh:mm a").parse(trimmed);
    } catch (_) {
      try {
        // Try plain date format
        return DateFormat("dd/MM/yyyy").parse(trimmed);
      } catch (_) {
        return null;
      }
    }
  }

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
      final outputFormat = DateFormat('dd/MM/yyyy ,h:mm a');
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
    switch (value?.toLowerCase()) {
      case "iqama":
        return IdType.iqama;
      case "national id":
        return IdType.nationalId;
      case "passport":
        return IdType.passport;
      case "other":
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

  String? Function(String?) get validator {
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
      default:
        return validation.validateNationalIdExpiryDate;
    }
  }
}