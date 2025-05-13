class AppointmentModel {
  Result? result;
  int? statusCode;
  String? message;
  bool? status;

  AppointmentModel({this.result, this.statusCode, this.message, this.status});

  AppointmentModel.fromJson(Map<String, dynamic> json) {
    result =
    json['result'] != null ? new Result.fromJson(json['result']) : null;
    statusCode = json['statusCode'];
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['status'] = this.status;
    return data;
  }
}

class Result {
  Pagination? pagination;
  List<Data>? data;

  Result({this.pagination, this.data});

  Result.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? pageNumber;
  int? pageSize;
  int? count;
  int? pages;

  Pagination({this.pageNumber, this.pageSize, this.count, this.pages});

  Pagination.fromJson(Map<String, dynamic> json) {
    pageNumber = json['pageNumber'];
    pageSize = json['pageSize'];
    count = json['count'];
    pages = json['pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pageNumber'] = this.pageNumber;
    data['pageSize'] = this.pageSize;
    data['count'] = this.count;
    data['pages'] = this.pages;
    return data;
  }
}

class Data {
  int? nAppointmentID;
  String? sAppointmentCode;
  String? sVisitorName;
  String? sVisitorNameEn;
  String? sSponsor;
  String? dtAppointmentStartTime;
  String? dtAppointmentEndTime;
  String? sMobileNo;
  String? sLocationNameEn;
  String? sLocationNameAr;
  String? sEmail;
  String? sPurpose;
  String? sHostName;
  int? nIsVehicleAllowed;
  String? sVehicleNo;
  String? dtCreatedDateExternal;
  int? approvalStatus;
  String? currentRoleAppointmentStatusEN;
  String? currentRoleAppointmentStatusAR;
  String? overAllAppointmentStatusEN;
  String? overAllAppointmentStatusAR;
  int? checkinID;
  int? nCheckedInStatus;

  Data(
      {this.nAppointmentID,
        this.sAppointmentCode,
        this.sVisitorName,
        this.sVisitorNameEn,
        this.sSponsor,
        this.dtAppointmentStartTime,
        this.dtAppointmentEndTime,
        this.sMobileNo,
        this.sLocationNameEn,
        this.sLocationNameAr,
        this.sEmail,
        this.sPurpose,
        this.sHostName,
        this.nIsVehicleAllowed,
        this.sVehicleNo,
        this.dtCreatedDateExternal,
        this.approvalStatus,
        this.currentRoleAppointmentStatusEN,
        this.currentRoleAppointmentStatusAR,
        this.overAllAppointmentStatusEN,
        this.overAllAppointmentStatusAR,
        this.checkinID,
        this.nCheckedInStatus});

  Data.fromJson(Map<String, dynamic> json) {
    nAppointmentID = json['n_AppointmentID'];
    sAppointmentCode = json['s_AppointmentCode'];
    sVisitorName = json['s_VisitorName'];
    sVisitorNameEn = json['s_VisitorName_En'];
    sSponsor = json['s_Sponsor'];
    dtAppointmentStartTime = json['dt_AppointmentStartTime'];
    dtAppointmentEndTime = json['dt_AppointmentEndTime'];
    sMobileNo = json['s_MobileNo'];
    sLocationNameEn = json['s_LocationName_En'];
    sLocationNameAr = json['s_LocationName_Ar'];
    sEmail = json['s_Email'];
    sPurpose = json['s_Purpose'];
    sHostName = json['s_HostName'];
    nIsVehicleAllowed = json['n_IsVehicleAllowed'];
    sVehicleNo = json['s_VehicleNo'];
    dtCreatedDateExternal = json['dt_CreatedDate_External'];
    approvalStatus = json['approvalStatus'];
    currentRoleAppointmentStatusEN = json['currentRoleAppointmentStatusEN'];
    currentRoleAppointmentStatusAR = json['currentRoleAppointmentStatusAR'];
    overAllAppointmentStatusEN = json['overAllAppointmentStatusEN'];
    overAllAppointmentStatusAR = json['overAllAppointmentStatusAR'];
    checkinID = json['checkinID'];
    nCheckedInStatus = json['n_CheckedInStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['n_AppointmentID'] = this.nAppointmentID;
    data['s_AppointmentCode'] = this.sAppointmentCode;
    data['s_VisitorName'] = this.sVisitorName;
    data['s_VisitorName_En'] = this.sVisitorNameEn;
    data['s_Sponsor'] = this.sSponsor;
    data['dt_AppointmentStartTime'] = this.dtAppointmentStartTime;
    data['dt_AppointmentEndTime'] = this.dtAppointmentEndTime;
    data['s_MobileNo'] = this.sMobileNo;
    data['s_LocationName_En'] = this.sLocationNameEn;
    data['s_LocationName_Ar'] = this.sLocationNameAr;
    data['s_Email'] = this.sEmail;
    data['s_Purpose'] = this.sPurpose;
    data['s_HostName'] = this.sHostName;
    data['n_IsVehicleAllowed'] = this.nIsVehicleAllowed;
    data['s_VehicleNo'] = this.sVehicleNo;
    data['dt_CreatedDate_External'] = this.dtCreatedDateExternal;
    data['approvalStatus'] = this.approvalStatus;
    data['currentRoleAppointmentStatusEN'] =
        this.currentRoleAppointmentStatusEN;
    data['currentRoleAppointmentStatusAR'] =
        this.currentRoleAppointmentStatusAR;
    data['overAllAppointmentStatusEN'] = this.overAllAppointmentStatusEN;
    data['overAllAppointmentStatusAR'] = this.overAllAppointmentStatusAR;
    data['checkinID'] = this.checkinID;
    data['n_CheckedInStatus'] = this.nCheckedInStatus;
    return data;
  }
}
