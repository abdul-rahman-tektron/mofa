// To parse this JSON data, do
//
//     final validateEmailResponse = validateEmailResponseFromJson(jsonString);

import 'dart:convert';

ValidateEmailResponse validateEmailResponseFromJson(String str) => ValidateEmailResponse.fromJson(json.decode(str));

String validateEmailResponseToJson(ValidateEmailResponse data) => json.encode(data.toJson());

class ValidateEmailResponse {
  dynamic result;
  int? statusCode;
  String? message;
  bool? status;

  ValidateEmailResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory ValidateEmailResponse.fromJson(Map<String, dynamic> json) => ValidateEmailResponse(
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
