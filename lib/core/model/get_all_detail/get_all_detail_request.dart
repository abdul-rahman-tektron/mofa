// To parse this JSON data, do
//
//     final getExternalAppointmentRequest = getExternalAppointmentRequestFromJson(jsonString);

import 'dart:convert';

GetExternalAppointmentRequest GetExternalAppointmentRequestFromJson(String str) => GetExternalAppointmentRequest.fromJson(json.decode(str));

String getExternalAppointmentRequestToJson(GetExternalAppointmentRequest data) => json.encode(data.toJson());

class GetExternalAppointmentRequest {
  DateTime? dFromDate;
  String? dToDate;
  int? nPageNumber;
  int? nPageSize;
  String? sSearch;

  GetExternalAppointmentRequest({
    this.dFromDate,
    this.dToDate,
    this.nPageNumber,
    this.nPageSize,
    this.sSearch,
  });

  factory GetExternalAppointmentRequest.fromJson(Map<String, dynamic> json) => GetExternalAppointmentRequest(
    dFromDate: json["D_FromDate"] == null ? null : DateTime.parse(json["D_FromDate"]),
    dToDate: json["D_ToDate"],
    nPageNumber: json["N_PageNumber"],
    nPageSize: json["N_PageSize"],
    sSearch: json["S_Search"],
  );

  Map<String, dynamic> toJson() => {
    "D_FromDate": "${dFromDate!.year.toString().padLeft(4, '0')}-${dFromDate!.month.toString().padLeft(2, '0')}-${dFromDate!.day.toString().padLeft(2, '0')}",
    "D_ToDate": dToDate,
    "N_PageNumber": nPageNumber,
    "N_PageSize": nPageSize,
    "S_Search": sSearch,
  };
}
