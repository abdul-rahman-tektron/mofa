class GetExternalAppointmentRequest {
  String? dFromDate;
  String? dToDate;
  int? nPageNumber;
  int? nPageSize;
  String? sSearch;
  int? nLocationId;       // Optional
  int? nApprovalStatus;   // Optional

  GetExternalAppointmentRequest({
    this.dFromDate,
    this.dToDate,
    this.nPageNumber,
    this.nPageSize,
    this.sSearch,
    this.nLocationId,
    this.nApprovalStatus,
  });

  factory GetExternalAppointmentRequest.fromJson(Map<String, dynamic> json) =>
      GetExternalAppointmentRequest(
        dFromDate: json["D_FromDate"],
        dToDate: json["D_ToDate"],
        nPageNumber: json["N_PageNumber"],
        nPageSize: json["N_PageSize"],
        sSearch: json["S_Search"],
        nLocationId: json["N_LocationId"],
        nApprovalStatus: json["N_ApprovalStatus"],
      );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      "D_FromDate": dFromDate,
      "D_ToDate": dToDate,
      "N_PageNumber": nPageNumber,
      "N_PageSize": nPageSize,
      "S_Search": sSearch,
    };

    if (nLocationId != null) {
      data["N_LocationId"] = nLocationId;
    }
    if (nApprovalStatus != null) {
      data["N_ApprovalStatus"] = nApprovalStatus;
    }

    return data;
  }
}
