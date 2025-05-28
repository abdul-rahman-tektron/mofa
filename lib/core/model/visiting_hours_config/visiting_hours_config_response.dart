// To parse this JSON data, do
//
//     final visitingHoursConfigResponse = visitingHoursConfigResponseFromJson(jsonString);

import 'dart:convert';

VisitingHoursConfigResponse visitingHoursConfigResponseFromJson(String str) => VisitingHoursConfigResponse.fromJson(json.decode(str));

String visitingHoursConfigResponseToJson(VisitingHoursConfigResponse data) => json.encode(data.toJson());

class VisitingHoursConfigResponse {
  VisitingHoursConfigResult? result;
  int? statusCode;
  String? message;
  bool? status;

  VisitingHoursConfigResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory VisitingHoursConfigResponse.fromJson(Map<String, dynamic> json) => VisitingHoursConfigResponse(
    result: json["result"] == null ? null : VisitingHoursConfigResult.fromJson(json["result"]),
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

class VisitingHoursConfigResult {
  String? visitorsStartTime;
  String? visitorsEndTime;

  VisitingHoursConfigResult({
    this.visitorsStartTime,
    this.visitorsEndTime,
  });

  factory VisitingHoursConfigResult.fromJson(Map<String, dynamic> json) => VisitingHoursConfigResult(
    visitorsStartTime: json["visitorsStartTime"],
    visitorsEndTime: json["visitorsEndTime"],
  );

  Map<String, dynamic> toJson() => {
    "visitorsStartTime": visitorsStartTime,
    "visitorsEndTime": visitorsEndTime,
  };
}
