// To parse this JSON data, do
//
//     final visitPurposeDropdownRequest = visitPurposeDropdownRequestFromJson(jsonString);

import 'dart:convert';

VisitPurposeDropdownRequest visitPurposeDropdownRequestFromJson(String str) => VisitPurposeDropdownRequest.fromJson(json.decode(str));

String visitPurposeDropdownRequestToJson(VisitPurposeDropdownRequest data) => json.encode(data.toJson());

class VisitPurposeDropdownRequest {
  String? encryptedVisitRequestTypeId;

  VisitPurposeDropdownRequest({
    this.encryptedVisitRequestTypeId,
  });

  factory VisitPurposeDropdownRequest.fromJson(Map<String, dynamic> json) => VisitPurposeDropdownRequest(
    encryptedVisitRequestTypeId: json["encryptedVisitRequestTypeID"],
  );

  Map<String, dynamic> toJson() => {
    "encryptedVisitRequestTypeID": encryptedVisitRequestTypeId,
  };
}
