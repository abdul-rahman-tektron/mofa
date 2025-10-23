// To parse this JSON data, do
//
//     final documentIdDropdownResponse = documentIdDropdownResponseFromJson(jsonString);

import 'dart:convert';

DocumentIdDropdownResponse documentIdDropdownResponseFromJson(String str) => DocumentIdDropdownResponse.fromJson(json.decode(str));

String documentIdDropdownResponseToJson(DocumentIdDropdownResponse data) => json.encode(data.toJson());

class DocumentIdDropdownResponse {
  List<DocumentIdModel>? result;
  int? statusCode;
  String? message;
  bool? status;

  DocumentIdDropdownResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory DocumentIdDropdownResponse.fromJson(Map<String, dynamic> json) => DocumentIdDropdownResponse(
    result: json["result"] == null ? [] : List<DocumentIdModel>.from(json["result"]!.map((x) => DocumentIdModel.fromJson(x))),
    statusCode: json["statusCode"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "statusCode": statusCode,
    "message": message,
    "status": status,
  };
}

class DocumentIdModel {
  int? nDetailedCode;
  int? nMasterCode;
  String? sDescA;
  String? sDescE;
  dynamic sUniqueCode;
  int? nIsShown;
  int? nIsDefault;

  DocumentIdModel({
    this.nDetailedCode,
    this.nMasterCode,
    this.sDescA,
    this.sDescE,
    this.sUniqueCode,
    this.nIsShown,
    this.nIsDefault,
  });

  factory DocumentIdModel.fromJson(Map<String, dynamic> json) => DocumentIdModel(
    nDetailedCode: json["n_DetailedCode"],
    nMasterCode: json["n_MasterCode"],
    sDescA: json["s_Desc_A"],
    sDescE: json["s_Desc_E"],
    sUniqueCode: json["s_UniqueCode"],
    nIsShown: json["n_IsShown"],
    nIsDefault: json["n_IsDefault"],
  );

  Map<String, dynamic> toJson() => {
    "n_DetailedCode": nDetailedCode,
    "n_MasterCode": nMasterCode,
    "s_Desc_A": sDescA,
    "s_Desc_E": sDescE,
    "s_UniqueCode": sUniqueCode,
    "n_IsShown": nIsShown,
    "n_IsDefault": nIsDefault,
  };
}
