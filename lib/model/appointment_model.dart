import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Appointment {
  final String refNo;
  final String name;
  final String companyName;
  final String email;
  final String startDate;
  final String endDate;
  final String mobile;
  final String host;
  final String location;
  final String printStatus;

  Appointment({
    required this.refNo,
    required this.name,
    required this.companyName,
    required this.email,
    required this.startDate,
    required this.endDate,
    required this.mobile,
    required this.host,
    required this.location,
    required this.printStatus,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      refNo: json['s_AppointmentCode'] ?? '',
      name: json['s_VisitorName'] ?? '',
      companyName: json['s_Sponsor'] ?? '',
      email: json['s_Email'] ?? '',
      startDate: _formatDate(json['dt_AppointmentStartTime']),
      endDate: _formatDate(json['dt_AppointmentEndTime']),
      mobile: json['s_MobileNo'] ?? '',
      host: json['s_HostName'] ?? '',
      location: json['s_LocationName_En'] ?? '',
      printStatus: json['s_BadgePrintStatus_En'] ?? '',
    );
  }

  static String _formatDate(String? rawDate) {
    if (rawDate == null) return '';
    DateTime dt = DateTime.parse(rawDate);
    return DateFormat('yyyy-MM-dd').format(dt);
  }
}
