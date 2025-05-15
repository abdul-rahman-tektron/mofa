

import 'dart:convert';

ForgetPasswordResponse forgetPasswordResponseFromJson(String str) => ForgetPasswordResponse.fromJson(json.decode(str));

String forgetPasswordResponseToJson(ForgetPasswordResponse data) => json.encode(data.toJson());

class ForgetPasswordResponse {
  String? result;
  int? statusCode;
  String? message;
  bool? status;

  ForgetPasswordResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory ForgetPasswordResponse.fromJson(Map<String, dynamic> json) => ForgetPasswordResponse(
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
