import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
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
      final outputFormat = DateFormat('dd MMM yyyy, h:mm a');
      return outputFormat.format(dateTime);
    } catch (e) {
      print('Date parsing error: $e');
      return "";
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