// To parse this JSON data, do
//
//     final duplicateAppointmentResponse = duplicateAppointmentResponseFromJson(jsonString);

import 'dart:convert';

DuplicateAppointmentResponse duplicateAppointmentResponseFromJson(String str) => DuplicateAppointmentResponse.fromJson(json.decode(str));

String duplicateAppointmentResponseToJson(DuplicateAppointmentResponse data) => json.encode(data.toJson());

class DuplicateAppointmentResponse {
  dynamic result;
  int? statusCode;
  String? message;
  bool? status;

  DuplicateAppointmentResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory DuplicateAppointmentResponse.fromJson(Map<String, dynamic> json) => DuplicateAppointmentResponse(
    result: json["result"],
    statusCode: json["statusCode"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "statusCode": statusCode,
    "message": message,
    "status": status,
  };
}
