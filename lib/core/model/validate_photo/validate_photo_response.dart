// To parse this JSON data, do
//
//     final validatePhotoResponse = validatePhotoResponseFromJson(jsonString);

import 'dart:convert';

ValidatePhotoResponse validatePhotoResponseFromJson(String str) => ValidatePhotoResponse.fromJson(json.decode(str));

String validatePhotoResponseToJson(ValidatePhotoResponse data) => json.encode(data.toJson());

class ValidatePhotoResponse {
  ValidatePhotoResult? result;
  int? statusCode;
  String? message;
  bool? status;

  ValidatePhotoResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory ValidatePhotoResponse.fromJson(Map<String, dynamic> json) => ValidatePhotoResponse(
    result: json["result"] == null ? null : ValidatePhotoResult.fromJson(json["result"]),
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

class ValidatePhotoResult {
  bool? isPhotoValid;
  List<dynamic>? photoErrors;

  ValidatePhotoResult({
    this.isPhotoValid,
    this.photoErrors,
  });

  factory ValidatePhotoResult.fromJson(Map<String, dynamic> json) => ValidatePhotoResult(
    isPhotoValid: json["isPhotoValid"],
    photoErrors: json["photoErrors"] == null ? [] : List<dynamic>.from(json["photoErrors"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "isPhotoValid": isPhotoValid,
    "photoErrors": photoErrors == null ? [] : List<dynamic>.from(photoErrors!.map((x) => x)),
  };
}
