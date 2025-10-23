// To parse this JSON data, do
//
//     final duplicateAppointmentRequest = duplicateAppointmentRequestFromJson(jsonString);

import 'dart:convert';

DuplicateAppointmentRequest duplicateAppointmentRequestFromJson(String str) => DuplicateAppointmentRequest.fromJson(json.decode(str));

String duplicateAppointmentRequestToJson(DuplicateAppointmentRequest data) => json.encode(data.toJson());

class DuplicateAppointmentRequest {
  int? nAppointmentID;
  int? nExternalRegistrationId;
  String? nLocationId;
  String? sIqama;
  String? sEidNumber;
  String? sPassportNumber;
  String? sOthersValue;
  String? dFromDate;
  String? dToDate;

  DuplicateAppointmentRequest({
    this.nAppointmentID,
    this.nExternalRegistrationId,
    this.nLocationId,
    this.sIqama,
    this.sEidNumber,
    this.sPassportNumber,
    this.sOthersValue,
    this.dFromDate,
    this.dToDate,
  });

  factory DuplicateAppointmentRequest.fromJson(Map<String, dynamic> json) => DuplicateAppointmentRequest(
    nAppointmentID: json["N_AppointmentID"],
    nExternalRegistrationId: json["N_ExternalRegistrationID"],
    nLocationId: json["N_LocationID"],
    sIqama: json["S_Iqama"],
    sEidNumber: json["S_EIDNumber"],
    sPassportNumber: json["S_PassportNumber"],
    sOthersValue: json["S_OthersValue"],
    dFromDate: json["D_FromDate"],
    dToDate: json["D_ToDate"],
  );

  Map<String, dynamic> toJson() => {
    "N_AppointmentID": nAppointmentID,
    "N_ExternalRegistrationID": nExternalRegistrationId,
    "N_LocationID": nLocationId,
    "S_Iqama": sIqama,
    "S_EIDNumber": sEidNumber,
    "S_PassportNumber": sPassportNumber,
    "S_OthersValue": sOthersValue,
    "D_FromDate": dFromDate,
    "D_ToDate": dToDate,
  };
}
