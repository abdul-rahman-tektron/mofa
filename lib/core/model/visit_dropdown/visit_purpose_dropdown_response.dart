// To parse this JSON data, do
//
//     final visitPurposeDropdownResponse = visitPurposeDropdownResponseFromJson(jsonString);

import 'dart:convert';

VisitPurposeDropdownResponse visitPurposeDropdownResponseFromJson(String str) => VisitPurposeDropdownResponse.fromJson(json.decode(str));

String visitPurposeDropdownResponseToJson(VisitPurposeDropdownResponse data) => json.encode(data.toJson());

class VisitPurposeDropdownResponse {
  List<VisitPurposeDropdownResult>? result;
  int? statusCode;
  String? message;
  bool? status;

  VisitPurposeDropdownResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory VisitPurposeDropdownResponse.fromJson(Map<String, dynamic> json) => VisitPurposeDropdownResponse(
    result: json["result"] == null ? [] : List<VisitPurposeDropdownResult>.from(json["result"]!.map((x) => VisitPurposeDropdownResult.fromJson(x))),
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

class VisitPurposeDropdownResult {
  int? nPurposeId;
  String? sPurposeEn;
  String? sPurposeAr;

  VisitPurposeDropdownResult({
    this.nPurposeId,
    this.sPurposeEn,
    this.sPurposeAr,
  });

  factory VisitPurposeDropdownResult.fromJson(Map<String, dynamic> json) => VisitPurposeDropdownResult(
    nPurposeId: json["n_PurposeID"],
    sPurposeEn: json["s_PurposeEn"],
    sPurposeAr: json["s_PurposeAr"],
  );

  Map<String, dynamic> toJson() => {
    "n_PurposeID": nPurposeId,
    "s_PurposeEn": sPurposeEn,
    "s_PurposeAr": sPurposeAr,
  };
}
