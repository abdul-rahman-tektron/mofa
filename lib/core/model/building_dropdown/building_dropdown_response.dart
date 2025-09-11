// To parse this JSON data, do
//
//     final buildingDropdownResponse = buildingDropdownResponseFromJson(jsonString);

import 'dart:convert';

BuildingDropdownResponse buildingDropdownResponseFromJson(String str) => BuildingDropdownResponse.fromJson(json.decode(str));

String buildingDropdownResponseToJson(BuildingDropdownResponse data) => json.encode(data.toJson());

class BuildingDropdownResponse {
  List<BuildingDropdownResult>? result;
  int? statusCode;
  String? message;
  bool? status;

  BuildingDropdownResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory BuildingDropdownResponse.fromJson(Map<String, dynamic> json) => BuildingDropdownResponse(
    result: json["result"] == null ? [] : List<BuildingDropdownResult>.from(json["result"]!.map((x) => BuildingDropdownResult.fromJson(x))),
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

class BuildingDropdownResult {
  int? nBuildingId;
  String? sBuildingNameAr;
  String? sBuildingNameEn;

  BuildingDropdownResult({
    this.nBuildingId,
    this.sBuildingNameAr,
    this.sBuildingNameEn,
  });

  factory BuildingDropdownResult.fromJson(Map<String, dynamic> json) => BuildingDropdownResult(
    nBuildingId: json["n_BuildingID"],
    sBuildingNameAr: json["s_BuildingName_Ar"],
    sBuildingNameEn: json["s_BuildingName_En"],
  );

  Map<String, dynamic> toJson() => {
    "n_BuildingID": nBuildingId,
    "s_BuildingName_Ar": sBuildingNameAr,
    "s_BuildingName_En": sBuildingNameEn,
  };
}
