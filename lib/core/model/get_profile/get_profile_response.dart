// To parse this JSON data, do
//
//     final getProfileResponse = getProfileResponseFromJson(jsonString);

import 'dart:convert';

GetProfileResponse getProfileResponseFromJson(String str) => GetProfileResponse.fromJson(json.decode(str));

String getProfileResponseToJson(GetProfileResponse data) => json.encode(data.toJson());

class GetProfileResponse {
  GetProfileResult? result;
  int? statusCode;
  String? message;
  bool? status;

  GetProfileResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory GetProfileResponse.fromJson(Map<String, dynamic> json) => GetProfileResponse(
    result: json["result"] == null ? null : GetProfileResult.fromJson(json["result"]),
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

class GetProfileResult {
  String? sFullName;
  String? sMobileNumber;
  String? sEmail;
  String? sUserName;
  String? sCompanyName;
  int? nDocumentType;
  String? eidNumber;
  String? passportNumber;
  String? sIqama;
  String? sVisaNo;
  String? sOthersDoc;
  String? sOthersValue;
  String? iso3;
  String? dtDateOfBirth;

  GetProfileResult({
    this.sFullName,
    this.sMobileNumber,
    this.sEmail,
    this.sUserName,
    this.sCompanyName,
    this.nDocumentType,
    this.eidNumber,
    this.passportNumber,
    this.sIqama,
    this.sVisaNo,
    this.sOthersDoc,
    this.sOthersValue,
    this.iso3,
    this.dtDateOfBirth,
  });

  factory GetProfileResult.fromJson(Map<String, dynamic> json) => GetProfileResult(
    sFullName: json["s_FullName"],
    sMobileNumber: json["s_MobileNumber"],
    sEmail: json["s_Email"],
    sUserName: json["s_UserName"],
    sCompanyName: json["s_CompanyName"],
    nDocumentType: json["n_DocumentType"],
    eidNumber: json["eidNumber"],
    passportNumber: json["passportNumber"],
    sIqama: json["s_Iqama"],
    sVisaNo: json["s_VisaNo"],
    sOthersDoc: json["s_OthersDoc"],
    sOthersValue: json["s_OthersValue"],
    iso3: json["iso3"],
    dtDateOfBirth: json["dt_DateOfBirth"],
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
    "s_VisaNo": sVisaNo,
    "s_OthersDoc": sOthersDoc,
    "s_OthersValue": sOthersValue,
    "iso3": iso3,
    "dt_DateOfBirth": dtDateOfBirth,
  };
}
