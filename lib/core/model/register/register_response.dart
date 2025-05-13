// To parse this JSON data, do
//
//     final registerResponse = registerResponseFromJson(jsonString);

import 'dart:convert';

RegisterResponse registerResponseFromJson(String str) => RegisterResponse.fromJson(json.decode(str));

String registerResponseToJson(RegisterResponse data) => json.encode(data.toJson());

class RegisterResponse {
  dynamic result;
  int? statusCode;
  String? message;
  bool? status;

  RegisterResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) => RegisterResponse(
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
