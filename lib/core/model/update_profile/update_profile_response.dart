// To parse this JSON data, do
//
//     final updateProfileResponse = updateProfileResponseFromJson(jsonString);

import 'dart:convert';

UpdateProfileResponse updateProfileResponseFromJson(String str) => UpdateProfileResponse.fromJson(json.decode(str));

String updateProfileResponseToJson(UpdateProfileResponse data) => json.encode(data.toJson());

class UpdateProfileResponse {
  UpdateProfileResult? result;
  int? statusCode;
  String? message;
  bool? status;

  UpdateProfileResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) => UpdateProfileResponse(
    result: json["result"] == null ? null : UpdateProfileResult.fromJson(json["result"]),
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

class UpdateProfileResult {
  String? sFullName;
  String? sMobileNumber;
  String? sEmail;
  String? sUserName;
  String? sCompanyName;
  int? nDocumentType;
  dynamic eidNumber;
  dynamic passportNumber;
  String? sIqama;
  dynamic sOthersDoc;
  dynamic sOthersValue;
  String? iso3;

  UpdateProfileResult({
    this.sFullName,
    this.sMobileNumber,
    this.sEmail,
    this.sUserName,
    this.sCompanyName,
    this.nDocumentType,
    this.eidNumber,
    this.passportNumber,
    this.sIqama,
    this.sOthersDoc,
    this.sOthersValue,
    this.iso3,
  });

  factory UpdateProfileResult.fromJson(Map<String, dynamic> json) => UpdateProfileResult(
    sFullName: json["s_FullName"],
    sMobileNumber: json["s_MobileNumber"],
    sEmail: json["s_Email"],
    sUserName: json["s_UserName"],
    sCompanyName: json["s_CompanyName"],
    nDocumentType: json["n_DocumentType"],
    eidNumber: json["eidNumber"],
    passportNumber: json["passportNumber"],
    sIqama: json["s_Iqama"],
    sOthersDoc: json["s_OthersDoc"],
    sOthersValue: json["s_OthersValue"],
    iso3: json["iso3"],
  );

  Map<String, dynamic> toJson() => {
    "s_FullName": sFullName,
    "s_MobileNumber": sMobileNumber,
    "s_Email": sEmail,
    "s_UserName": sUserName,
    "s_CompanyName": sCompanyName,
    "n_DocumentType": nDocumentType,
    "eidNumber": eidNumber,
    "passportNumber": passportNumber,
    "s_Iqama": sIqama,
    "s_OthersDoc": sOthersDoc,
    "s_OthersValue": sOthersValue,
    "iso3": iso3,
  };
}
