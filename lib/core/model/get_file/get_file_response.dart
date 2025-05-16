// To parse this JSON data, do
//
//     final getFileResponse = getFileResponseFromJson(jsonString);

import 'dart:convert';

GetFileResponse getFileResponseFromJson(String str) => GetFileResponse.fromJson(json.decode(str));

String getFileResponseToJson(GetFileResponse data) => json.encode(data.toJson());

class GetFileResponse {
  GetFileResult? result;
  int? statusCode;
  String? message;
  bool? status;

  GetFileResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory GetFileResponse.fromJson(Map<String, dynamic> json) => GetFileResponse(
    result: json["result"] == null ? null : GetFileResult.fromJson(json["result"]),
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

class GetFileResult {
  int? id;
  String? photoFile;
  String? contentType;
  dynamic type;

  GetFileResult({
    this.id,
    this.photoFile,
    this.contentType,
    this.type,
  });

  factory GetFileResult.fromJson(Map<String, dynamic> json) => GetFileResult(
    id: json["id"],
    photoFile: json["photoFile"],
    contentType: json["contentType"],
    type: json["type"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "photoFile": photoFile,
    "contentType": contentType,
    "type": type,
  };
}
