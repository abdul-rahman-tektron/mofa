// To parse this JSON data, do
//
//     final updateProfileRequest = updateProfileRequestFromJson(jsonString);

import 'dart:convert';

UpdateProfileRequest updateProfileRequestFromJson(String str) => UpdateProfileRequest.fromJson(json.decode(str));

String updateProfileRequestToJson(UpdateProfileRequest data) => json.encode(data.toJson());

class UpdateProfileRequest {
  int? nExternalRegistrationId;
  String? sFullName;
  String? sCompanyName;
  String? sMobileNumber;
  String? sEmail;
  String? sUserName;
  int? nDocumentType;
  String? eidNumber;
  String? passportNumber;
  String? sIqama;
  String? sOthersDoc;
  String? sOthersValue;
  String? iso3;

  UpdateProfileRequest({
    this.nExternalRegistrationId,
    this.sFullName,
    this.sCompanyName,
    this.sMobileNumber,
    this.sEmail,
    this.sUserName,
    this.nDocumentType,
    this.eidNumber,
    this.passportNumber,
    this.sIqama,
    this.sOthersDoc,
    this.sOthersValue,
    this.iso3,
  });

  factory UpdateProfileRequest.fromJson(Map<String, dynamic> json) => UpdateProfileRequest(
    nExternalRegistrationId: json["n_ExternalRegistrationID"],
    sFullName: json["s_FullName"],
    sCompanyName: json["s_CompanyName"],
    sMobileNumber: json["s_MobileNumber"],
    sEmail: json["s_Email"],
    sUserName: json["s_UserName"],
    nDocumentType: json["n_DocumentType"],
    eidNumber: json["eidNumber"],
    passportNumber: json["passportNumber"],
    sIqama: json["S_Iqama"],
    sOthersDoc: json["S_OthersDoc"],
    sOthersValue: json["S_OthersValue"],
    iso3: json["iso3"],
  );

  Map<String, dynamic> toJson() => {
    "n_ExternalRegistrationID": nExternalRegistrationId,
    "s_FullName": sFullName,
    "s_CompanyName": sCompanyName,
    "s_MobileNumber": sMobileNumber,
    "s_Email": sEmail,
    "s_UserName": sUserName,
    "n_DocumentType": nDocumentType,
    "eidNumber": eidNumber,
    "passportNumber": passportNumber,
    "S_Iqama": sIqama,
    "S_OthersDoc": sOthersDoc,
    "S_OthersValue": sOthersValue,
    "iso3": iso3,
  };
}
