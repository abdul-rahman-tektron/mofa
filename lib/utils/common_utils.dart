import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

mixin CommonUtils {
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.yellow.shade700;
      case 'rejected':
        return Colors.red.shade600;
      case 'cancelled':
        return Colors.orange;
      case 'expired':
        return Colors.grey;
      case 'request info':
        return Colors.teal.shade400;
      default:
        return Colors.black26;
    }
  }


  TimeOfDay? parseTimeStringToTimeOfDay(String timeStr) {
    try {
      final parsedTime = DateFormat.jm().parse(timeStr); // e.g., "08:00 AM"
      return TimeOfDay.fromDateTime(parsedTime);
    } catch (e) {
      print("Failed to parse time: $e");
      return null;
    }
  }

  TimeOfDay? parseFullDateStringToTimeOfDay(String fullDateStr) {
    try {
      final parsedDateTime = DateFormat("dd/MM/yyyy '،'hh:mm a").parse(fullDateStr);
      return TimeOfDay.fromDateTime(parsedDateTime);
    } catch (e) {
      print("Failed to parse time: $e");
      return null;
    }
  }

  bool isBeforeTimeOfDay(TimeOfDay a, TimeOfDay b) {
    return a.hour < b.hour || (a.hour == b.hour && a.minute < b.minute);
  }

  bool isAfterTimeOfDay(TimeOfDay a, TimeOfDay b) {
    return a.hour > b.hour || (a.hour == b.hour && a.minute > b.minute);
  }
}
