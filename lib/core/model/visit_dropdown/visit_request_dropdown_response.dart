// To parse this JSON data, do
//
//     final visitRequestDropdownResponse = visitRequestDropdownResponseFromJson(jsonString);

import 'dart:convert';

VisitRequestDropdownResponse visitRequestDropdownResponseFromJson(String str) => VisitRequestDropdownResponse.fromJson(json.decode(str));

String visitRequestDropdownResponseToJson(VisitRequestDropdownResponse data) => json.encode(data.toJson());

class VisitRequestDropdownResponse {
  List<VisitRequestDropdownResult>? result;
  int? statusCode;
  String? message;
  bool? status;

  VisitRequestDropdownResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory VisitRequestDropdownResponse.fromJson(Map<String, dynamic> json) => VisitRequestDropdownResponse(
    result: json["result"] == null ? [] : List<VisitRequestDropdownResult>.from(json["result"]!.map((x) => VisitRequestDropdownResult.fromJson(x))),
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

class VisitRequestDropdownResult {
  int? nDetailedCode;
  int? nMasterCode;
  String? sDescA;
  String? sDescE;
  String? sUniqueCode;
  int? nIsShown;
  int? nIsDefault;

  VisitRequestDropdownResult({
    this.nDetailedCode,
    this.nMasterCode,
    this.sDescA,
    this.sDescE,
    this.sUniqueCode,
    this.nIsShown,
    this.nIsDefault,
  });

  factory VisitRequestDropdownResult.fromJson(Map<String, dynamic> json) => VisitRequestDropdownResult(
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
