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

  dynamic toDateTime({String format = 'dd/MM/yyyy'}) {
    if (trim().isEmpty) return "";
    return DateFormat(format).parse(this);
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