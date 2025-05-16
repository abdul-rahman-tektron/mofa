// To parse this JSON data, do
//
//     final getFileRequest = getFileRequestFromJson(jsonString);

import 'dart:convert';

GetFileRequest getFileRequestFromJson(String str) => GetFileRequest.fromJson(json.decode(str));

String getFileRequestToJson(GetFileRequest data) => json.encode(data.toJson());

class GetFileRequest {
  int? id;
  int? type;

  GetFileRequest({
    this.id,
    this.type,
  });

  factory GetFileRequest.fromJson(Map<String, dynamic> json) => GetFileRequest(
    id: json["Id"],
    type: json["Type"],
  );

  Map<String, dynamic> toJson() => {
    "Id": id,
    "Type": type,
  };
}
