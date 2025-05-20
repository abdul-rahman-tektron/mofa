// To parse this JSON data, do
//
//     final addAppointmentResponse = addAppointmentResponseFromJson(jsonString);

import 'dart:convert';

AddAppointmentResponse addAppointmentResponseFromJson(String str) => AddAppointmentResponse.fromJson(json.decode(str));

String addAppointmentResponseToJson(AddAppointmentResponse data) => json.encode(data.toJson());

class AddAppointmentResponse {
  AddAppointmentResult? result;
  int? statusCode;
  String? message;
  bool? status;

  AddAppointmentResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory AddAppointmentResponse.fromJson(Map<String, dynamic> json) => AddAppointmentResponse(
    result: json["result"] == null ? null : AddAppointmentResult.fromJson(json["result"]),
    statusCode: json["statusCode"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
    "statusCode": statusCode,
    "message": message,
    "status": status,
  };
}

class AddAppointmentResult {
  int? id;

  AddAppointmentResult({
    this.id,
  });

  factory AddAppointmentResult.fromJson(Map<String, dynamic> json) => AddAppointmentResult(
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
  };
}
