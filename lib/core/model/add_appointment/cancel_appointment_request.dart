import 'dart:convert';

CancelAppointmentRequest cancelAppointmentRequestFromJson(String str) => CancelAppointmentRequest.fromJson(json.decode(str));

String cancelAppointmentRequestToJson(CancelAppointmentRequest data) => json.encode(data.toJson());

class CancelAppointmentRequest {
  int? nAppointmentId;
  int? nLocationId;
  int? nUserId;
  int? nExternalRegistrationId;
  int? nUpdatedByExternal;

  CancelAppointmentRequest({
    this.nAppointmentId,
    this.nLocationId,
    this.nUserId,
    this.nExternalRegistrationId,
    this.nUpdatedByExternal,
  });

  factory CancelAppointmentRequest.fromJson(Map<String, dynamic> json) => CancelAppointmentRequest(
    nAppointmentId: json["N_AppointmentID"],
    nLocationId: json["N_LocationID"],
    nUserId: json["N_UserId"],
    nExternalRegistrationId: json["N_ExternalRegistrationID"],
    nUpdatedByExternal: json["N_UpdatedBy_External"],
  );

  Map<String, dynamic> toJson() => {
    "N_AppointmentID": nAppointmentId,
    "N_LocationID": nLocationId,
    "N_UserId": nUserId,
    "N_ExternalRegistrationID": nExternalRegistrationId,
    "N_UpdatedBy_External": nUpdatedByExternal,
  };
}
