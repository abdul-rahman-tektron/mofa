// To parse this JSON data, do
//
//     final locationDropdownResponse = locationDropdownResponseFromJson(jsonString);

import 'dart:convert';

LocationDropdownResponse locationDropdownResponseFromJson(String str) => LocationDropdownResponse.fromJson(json.decode(str));

String locationDropdownResponseToJson(LocationDropdownResponse data) => json.encode(data.toJson());

class LocationDropdownResponse {
  List<LocationDropdownResult>? result;
  int? statusCode;
  String? message;
  bool? status;

  LocationDropdownResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory LocationDropdownResponse.fromJson(Map<String, dynamic> json) => LocationDropdownResponse(
    result: json["result"] == null ? [] : List<LocationDropdownResult>.from(json["result"]!.map((x) => LocationDropdownResult.fromJson(x))),
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

class LocationDropdownResult {
  int? nLocationId;
  String? sLocationNameAr;
  String? sLocationNameEn;

  LocationDropdownResult({
    this.nLocationId,
    this.sLocationNameAr,
    this.sLocationNameEn,
  });

  factory LocationDropdownResult.fromJson(Map<String, dynamic> json) => LocationDropdownResult(
    nLocationId: json["n_LocationID"],
    sLocationNameAr: json["s_LocationName_Ar"],
    sLocationNameEn: json["s_LocationName_En"],
  );

  Map<String, dynamic> toJson() => {
    "n_LocationID": nLocationId,
    "s_LocationName_Ar": sLocationNameAr,
    "s_LocationName_En": sLocationNameEn,
  };
}
