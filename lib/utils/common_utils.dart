import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/notifier/language_notifier.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:provider/provider.dart';

mixin CommonUtils {
  static Color getStatusColor(String statusKey) {
    switch (statusKey.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.yellow;
      case 'rejected':
        return Colors.red;
      case 'cancelled':
        return Colors.orange;
      case 'expired':
        return Colors.grey;
      case 'request info':
        return Colors.teal;
      default:
        return Colors.black26;
    }
  }

  static String getTranslatedStatus(BuildContext context, String statusKey) {
    final lang = context.readLang;

    switch (statusKey.toLowerCase()) {
      case 'approved':
        return lang.translate(AppLanguageText.approved);
      case 'pending':
        return lang.translate(AppLanguageText.pending);
      case 'rejected':
        return lang.translate(AppLanguageText.rejected);
      case 'cancelled':
        return lang.translate(AppLanguageText.canceled);
      case 'expired':
        return lang.translate(AppLanguageText.expired);
      case 'request info':
        return lang.translate(AppLanguageText.requestInfo);
      default:
        return statusKey; // fallback
    }
  }


  static TimeOfDay? parseTimeStringToTimeOfDay(String timeStr) {
    try {
      final parsedTime = DateFormat.jm().parse(timeStr);
      return TimeOfDay.fromDateTime(parsedTime);
    } catch (e) {
      print("Failed to parse time: $e");
      return null;
    }
  }

  static TimeOfDay? parseFullDateStringToTimeOfDay(String fullDateStr) {
    try {
      final parsedDateTime = DateFormat("dd/MM/yyyy, hh:mm a").parse(fullDateStr);
      return TimeOfDay.fromDateTime(parsedDateTime);
    } catch (e) {
      print("Failed to parse time: $e");
      return null;
    }
  }

  static bool isBeforeTimeOfDay(TimeOfDay a, TimeOfDay b) {
    return a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute);
  }

  static bool isAfterTimeOfDay(TimeOfDay a, TimeOfDay b) {
    return a.hour > b.hour || (a.hour == b.hour && a.minute > b.minute);
  }

  static String formatIsoToReadable(String isoDateStr) {
    try {
      final dateTime = DateTime.parse(isoDateStr);
      final formatter = DateFormat("MMM d, y 'at' h:mm a");
      return formatter.format(dateTime);
    } catch (e) {
      print("Error formatting date: $e");
      return isoDateStr; // fallback to original
    }
  }

  String getLocalizedText({
    required String currentLang,
    required String? arabic,
    required String? english,
    String fallback = 'Unknown',
  }) {
    if (currentLang.toLowerCase() == LanguageCode.ar.name.toLowerCase()) {
      return arabic ?? fallback;
    } else {
      return english ?? fallback;
    }
  }

  static String getLocalizedString({
    required String currentLang,
    required String? Function() getArabic,
    required String? Function() getEnglish,
    String fallback = 'Unknown',
  }) {
    if (currentLang == LanguageCode.ar.name) {
      return getArabic() ?? fallback;
    } else {
      return getEnglish() ?? fallback;
    }
  }
}