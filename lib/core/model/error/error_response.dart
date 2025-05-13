// To parse this JSON data, do
//
//     final errorResponse = errorResponseFromJson(jsonString);

import 'dart:convert';

ErrorResponse errorResponseFromJson(String str) => ErrorResponse.fromJson(json.decode(str));

String errorResponseToJson(ErrorResponse data) => json.encode(data.toJson());

class ErrorResponse {
  String? type;
  String? title;
  dynamic status;
  String? traceId;

  ErrorResponse({
    this.type,
    this.title,
    this.status,
    this.traceId,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
    type: json["type"],
    title: json["title"],
    status: json["status"],
    traceId: json["traceId"],
  );

  Map<String, dynamic> toJson() => {
    "type": type,
    "title": title,
    "status": status,
    "traceId": traceId,
  };
}
