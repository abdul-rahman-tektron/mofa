// To parse this JSON data, do
//
//     final resendOtpRequest = resendOtpRequestFromJson(jsonString);

import 'dart:convert';

ResendOtpRequest resendOtpRequestFromJson(String str) => ResendOtpRequest.fromJson(json.decode(str));

String resendOtpRequestToJson(ResendOtpRequest data) => json.encode(data.toJson());

class ResendOtpRequest {
  String? email;
  String? password;

  ResendOtpRequest({
    this.email,
    this.password,
  });

  factory ResendOtpRequest.fromJson(Map<String, dynamic> json) => ResendOtpRequest(
    email: json["email"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
  };
}

ValidateOtpRequest validateOtpRequestFromJson(String str) => ValidateOtpRequest.fromJson(json.decode(str));

String validateOtpRequestToJson(ValidateOtpRequest data) => json.encode(data.toJson());

class ValidateOtpRequest {
  String? email;
  String? password;
  String? otpCode;

  ValidateOtpRequest({
    this.email,
    this.password,
    this.otpCode,
  });

  factory ValidateOtpRequest.fromJson(Map<String, dynamic> json) => ValidateOtpRequest(
    email: json["email"],
    password: json["password"],
    otpCode: json["otpCode"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "otpCode": otpCode,
  };
}


ValidateOtpFailureRequest validateOtpFailureRequestFromJson(String str) => ValidateOtpFailureRequest.fromJson(json.decode(str));

String validateOtpFailureRequestToJson(ValidateOtpFailureRequest data) => json.encode(data.toJson());

class ValidateOtpFailureRequest {
  Result? result;
  int? statusCode;
  String? message;
  bool? status;

  ValidateOtpFailureRequest({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory ValidateOtpFailureRequest.fromJson(Map<String, dynamic> json) => ValidateOtpFailureRequest(
    result: json["result"] == null ? null : Result.fromJson(json["result"]),
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

class Result {
  bool? isOtpExpired;

  Result({
    this.isOtpExpired,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    isOtpExpired: json["isOTPExpired"],
  );

  Map<String, dynamic> toJson() => {
    "isOTPExpired": isOtpExpired,
  };
}

