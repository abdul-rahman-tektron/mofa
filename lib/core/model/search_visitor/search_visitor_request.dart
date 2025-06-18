import 'dart:convert';

SearchVisitorRequest searchVisitorRequestFromJson(String str) => SearchVisitorRequest.fromJson(json.decode(str));

String searchVisitorRequestToJson(SearchVisitorRequest data) => json.encode(data.toJson());

class SearchVisitorRequest {
  int? nUserId;
  int? nHostId;
  int? nEmployeeId;
  String? sId;
  String? sPassportNumber;
  String? sIqama;
  String? sEmail;
  String? sNumber;

  SearchVisitorRequest({
    this.nUserId,
    this.nHostId,
    this.nEmployeeId,
    this.sId,
    this.sPassportNumber,
    this.sIqama,
    this.sEmail,
    this.sNumber,
  });

  factory SearchVisitorRequest.fromJson(Map<String, dynamic> json) => SearchVisitorRequest(
    nUserId: json["N_UserId"],
    nHostId: json["N_HostID"],
    nEmployeeId: json["N_EmployeeID"],
    sId: json["S_Id"],
    sPassportNumber: json["S_PassportNumber"],
    sIqama: json["S_Iqama"],
    sEmail: json["S_Email"],
    sNumber: json["S_Number"],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    // Always include these fields
    if (nUserId != null) data["N_UserId"] = nUserId;
    if (nHostId != null) data["N_HostID"] = nHostId;
    if (nEmployeeId != null) data["N_EmployeeID"] = nEmployeeId;

    // Include these fields only if not null or empty
    if (sId != null && sId!.isNotEmpty) data["S_Id"] = sId;
    if (sPassportNumber != null && sPassportNumber!.isNotEmpty) data["S_PassportNumber"] = sPassportNumber;
    if (sIqama != null && sIqama!.isNotEmpty) data["S_Iqama"] = sIqama;
    if (sEmail != null && sEmail!.isNotEmpty) data["S_Email"] = sEmail;
    if (sNumber != null && sNumber!.isNotEmpty) data["S_Number"] = sNumber;

    return data;
  }
}
