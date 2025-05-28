// To parse this JSON data, do
//
//     final validatePhotoConfigResponse = validatePhotoConfigResponseFromJson(jsonString);

import 'dart:convert';

ValidatePhotoConfigResponse validatePhotoConfigResponseFromJson(String str) => ValidatePhotoConfigResponse.fromJson(json.decode(str));

String validatePhotoConfigResponseToJson(ValidatePhotoConfigResponse data) => json.encode(data.toJson());

class ValidatePhotoConfigResponse {
  ValidatePhotoConfigResult? result;
  int? statusCode;
  String? message;
  bool? status;

  ValidatePhotoConfigResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory ValidatePhotoConfigResponse.fromJson(Map<String, dynamic> json) => ValidatePhotoConfigResponse(
    result: json["result"] == null ? null : ValidatePhotoConfigResult.fromJson(json["result"]),
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

class ValidatePhotoConfigResult {
  String? ipAddresses;
  bool? isValidatePhotoFromFr;

  ValidatePhotoConfigResult({
    this.ipAddresses,
    this.isValidatePhotoFromFr,
  });

  factory ValidatePhotoConfigResult.fromJson(Map<String, dynamic> json) => ValidatePhotoConfigResult(
    ipAddresses: json["ipAddresses"],
    isValidatePhotoFromFr: json["isValidatePhotoFromFR"],
  );

  Map<String, dynamic> toJson() => {
    "ipAddresses": ipAddresses,
    "isValidatePhotoFromFR": isValidatePhotoFromFr,
  };
}
