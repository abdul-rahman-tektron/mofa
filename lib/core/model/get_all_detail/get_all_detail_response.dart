// To parse this JSON data, do
//
//     final getExternalAppointmentResponse = getExternalAppointmentResponseFromJson(jsonString);

import 'dart:convert';

GetExternalAppointmentResponse getExternalAppointmentResponseFromJson(String str) => GetExternalAppointmentResponse.fromJson(json.decode(str));

String getExternalAppointmentResponseToJson(GetExternalAppointmentResponse data) => json.encode(data.toJson());

class GetExternalAppointmentResponse {
  GetExternalAppointmentResult? result;
  int? statusCode;
  String? message;
  bool? status;

  GetExternalAppointmentResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory GetExternalAppointmentResponse.fromJson(Map<String, dynamic> json) => GetExternalAppointmentResponse(
    result: json["result"] == null ? null : GetExternalAppointmentResult.fromJson(json["result"]),
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

class GetExternalAppointmentResult {
  Pagination? pagination;
  List<GetExternalAppointmentData>? data;

  GetExternalAppointmentResult({
    this.pagination,
    this.data,
  });

  factory GetExternalAppointmentResult.fromJson(Map<String, dynamic> json) => GetExternalAppointmentResult(
    pagination: json["pagination"] == null ? null : Pagination.fromJson(json["pagination"]),
    data: json["data"] == null ? [] : List<GetExternalAppointmentData>.from(json["data"]!.map((x) => GetExternalAppointmentData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pagination": pagination?.toJson(),
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class GetExternalAppointmentData {
  int? nAppointmentId;
  int? nExternalRegistrationId;
  String? sAppointmentCode;
  dynamic sFullName;
  dynamic sCompanyName;
  dynamic sMobileNumber;
  String? sEmail;
  String? gender;
  String? nationality;
  int? nVisaType;
  int? nDocumentType;
  String? eidNumber;
  String? passportNumber;
  dynamic dtEidExpiryDate;
  dynamic dtPassportExpiryDate;
  int? nVisitType;
  String? sVisitorTypeAr;
  String? sRemarks;
  String? sVisitorTypeEn;
  int? purpose;
  dynamic purposeOtherValue;
  dynamic checkinMaterial;
  int? nLocationId;
  String? sLocationNameAr;
  String? sLocationNameEn;
  int? nBuildingId;
  String? sBuildingNameEn;
  String? sBuildingNameAr;
  int? nDepartmentId;
  String? sDepartmentNameEn;
  dynamic sDepartmentNameAr;
  String? dtCovidDate;
  String? sVisitingPersonEmail;
  String? dtAppointmentStartTime;
  String? dtAppointmentEndTime;
  int? nHostId;
  bool? isCheckedIn;
  int? userId;
  int? nIsDeleted;
  dynamic iso3;
  String? sNationalityAr;
  String? sNationalityEn;
  dynamic expr1;
  String? sHostName;
  int? nDetailedCode;
  String? sApprovalStatusAr;
  String? sApprovalStatusEn;
  String? sQRCodeValue;
  int? approvalStatus;
  dynamic sCovidFile;
  dynamic sCovidFileType;
  dynamic sPurposeA;
  dynamic sPurposeE;
  dynamic sPhotoUpload;
  dynamic sPhotoContentType;
  dynamic sEidFile;
  dynamic sEidContentType;
  dynamic sPassportFile;
  dynamic sPassportContentType;
  dynamic dTypeAr;
  dynamic dTypeEn;
  dynamic sServiceProviderFile;
  dynamic sSpContentType;
  dynamic sVisaFile;
  dynamic sVisaContentType;
  int? nSelfPass;
  String? sGroupKey;
  int? nVehiclePass;
  int? nIsVehicleAllowed;
  String? sVehicleNo;
  int? nArrivingByTaxi;
  dynamic sDriverLicenseFile;
  dynamic sDriverLicenseContentType;
  dynamic sVehicleRegistrationFile;
  dynamic sVehicleRegistrationContentType;
  dynamic sDeliveryNoteFile;
  dynamic sDeliveryNoteContentType;
  dynamic sVisitorNameEn;
  String? sVisitorName;
  String? sSponsor;
  dynamic visitorMobile;
  dynamic visitorEmail;
  String? sIqama;
  dynamic dTIqamaExpiry;
  dynamic sOthersDoc;
  String? sVisaNo;
  dynamic dtVisaExpiryDate;
  dynamic sOthersValue;
  dynamic dTOthersExpiry;
  int? havePhoto;
  int? haveEid;
  int? haveVehicleRegistration;
  int? havePassport;
  int? haveIqama;
  int? haveVisa;
  int? haveOthers;
  String? sQrCodeValue;
  int? nCurrentApproverOrderNo;
  int? nIsHostRequiredMoreInfo;
  int? pseudoApprovalStatus;
  String? sApplyForEn;
  String? sApplyForAr;
  String? sHostEmail;
  String? sIsVehicleAllowedEn;
  String? sIsVehicleAllowedAr;
  DateTime? dtDateOfBirth;

  GetExternalAppointmentData({
    this.nAppointmentId,
    this.nExternalRegistrationId,
    this.sAppointmentCode,
    this.sFullName,
    this.sCompanyName,
    this.sMobileNumber,
    this.sEmail,
    this.gender,
    this.nationality,
    this.nVisaType,
    this.nDocumentType,
    this.eidNumber,
    this.passportNumber,
    this.dtEidExpiryDate,
    this.dtPassportExpiryDate,
    this.nVisitType,
    this.sVisitorTypeAr,
    this.sRemarks,
    this.sVisitorTypeEn,
    this.purpose,
    this.purposeOtherValue,
    this.checkinMaterial,
    this.nLocationId,
    this.sLocationNameAr,
    this.sLocationNameEn,
    this.nBuildingId,
    this.sBuildingNameEn,
    this.sBuildingNameAr,
    this.nDepartmentId,
    this.sDepartmentNameEn,
    this.sDepartmentNameAr,
    this.dtCovidDate,
    this.sQRCodeValue,
    this.sVisitingPersonEmail,
    this.dtAppointmentStartTime,
    this.dtAppointmentEndTime,
    this.nHostId,
    this.isCheckedIn,
    this.userId,
    this.nIsDeleted,
    this.iso3,
    this.sNationalityAr,
    this.sNationalityEn,
    this.expr1,
    this.sHostName,
    this.nDetailedCode,
    this.sApprovalStatusAr,
    this.sApprovalStatusEn,
    this.approvalStatus,
    this.sCovidFile,
    this.sCovidFileType,
    this.sPurposeA,
    this.sPurposeE,
    this.sPhotoUpload,
    this.sPhotoContentType,
    this.sEidFile,
    this.sEidContentType,
    this.sPassportFile,
    this.sPassportContentType,
    this.dTypeAr,
    this.dTypeEn,
    this.sServiceProviderFile,
    this.sSpContentType,
    this.sVisaFile,
    this.sVisaContentType,
    this.nSelfPass,
    this.sGroupKey,
    this.nVehiclePass,
    this.nIsVehicleAllowed,
    this.sVehicleNo,
    this.nArrivingByTaxi,
    this.sDriverLicenseFile,
    this.sDriverLicenseContentType,
    this.sVehicleRegistrationFile,
    this.sVehicleRegistrationContentType,
    this.sDeliveryNoteFile,
    this.sDeliveryNoteContentType,
    this.sVisitorNameEn,
    this.sVisitorName,
    this.sSponsor,
    this.visitorMobile,
    this.visitorEmail,
    this.sIqama,
    this.dTIqamaExpiry,
    this.sOthersDoc,
    this.sVisaNo,
    this.dtVisaExpiryDate,
    this.sOthersValue,
    this.dTOthersExpiry,
    this.havePhoto,
    this.haveEid,
    this.haveVehicleRegistration,
    this.havePassport,
    this.haveIqama,
    this.haveVisa,
    this.haveOthers,
    this.sQrCodeValue,
    this.nCurrentApproverOrderNo,
    this.nIsHostRequiredMoreInfo,
    this.pseudoApprovalStatus,
    this.sApplyForEn,
    this.sApplyForAr,
    this.sHostEmail,
    this.sIsVehicleAllowedEn,
    this.sIsVehicleAllowedAr,
    this.dtDateOfBirth,
  });

  factory GetExternalAppointmentData.fromJson(Map<String, dynamic> json) => GetExternalAppointmentData(
    nAppointmentId: json["n_AppointmentID"],
    nExternalRegistrationId: json["n_ExternalRegistrationID"],
    sAppointmentCode: json["s_AppointmentCode"],
    sFullName: json["s_FullName"],
    sCompanyName: json["s_CompanyName"],
    sMobileNumber: json["s_MobileNumber"],
    sEmail: json["s_Email"],
    gender: json["gender"],
    nationality: json["nationality"],
    nVisaType: json["n_VisaType"],
    nDocumentType: json["n_DocumentType"],
    eidNumber: json["eidNumber"],
    passportNumber: json["passportNumber"],
    dtEidExpiryDate: json["dt_EIDExpiryDate"],
    dtPassportExpiryDate: json["dt_PassportExpiryDate"],
    nVisitType: json["n_VisitType"],
    sVisitorTypeAr: json["s_VisitorType_Ar"],
    sRemarks: json["s_Remarks"],
    sVisitorTypeEn: json["s_VisitorType_En"],
    purpose: json["purpose"],
    purposeOtherValue: json["purposeOtherValue"],
    checkinMaterial: json["checkinMaterial"],
    nLocationId: json["n_LocationID"],
    sLocationNameAr: json["s_LocationName_Ar"],
    sLocationNameEn: json["s_LocationName_En"],
    nBuildingId: json["n_BuildingID"],
    sBuildingNameEn: json["s_BuildingName_En"],
    sBuildingNameAr: json["s_BuildingName_Ar"],
    nDepartmentId: json["n_DepartmentID"],
    sDepartmentNameEn: json["s_DepartmentName_En"],
    sDepartmentNameAr: json["s_DepartmentName_Ar"],
    dtCovidDate: json["dt_CovidDate"],
    sVisitingPersonEmail: json["s_VisitingPersonEmail"],
    dtAppointmentStartTime: json["dt_AppointmentStartTime"],
    dtAppointmentEndTime: json["dt_AppointmentEndTime"],
    nHostId: json["n_HostID"],
    isCheckedIn: json["is_CheckedIN"],
    sQRCodeValue: json["s_QRCodeValue"],
    userId: json["user_id"],
    nIsDeleted: json["n_IsDeleted"],
    iso3: json["iso3"],
    sNationalityAr: json["s_Nationality_Ar"],
    sNationalityEn: json["s_Nationality_En"],
    expr1: json["expr1"],
    sHostName: json["s_HostName"],
    nDetailedCode: json["n_DetailedCode"],
    sApprovalStatusAr: json["s_ApprovalStatusAr"],
    sApprovalStatusEn: json["s_ApprovalStatusEn"],
    approvalStatus: json["approvalStatus"],
    sCovidFile: json["s_CovidFile"],
    sCovidFileType: json["s_CovidFileType"],
    sPurposeA: json["s_Purpose_A"],
    sPurposeE: json["s_Purpose_E"],
    sPhotoUpload: json["s_PhotoUpload"],
    sPhotoContentType: json["s_PhotoContentType"],
    sEidFile: json["s_EIDFile"],
    sEidContentType: json["s_EIDContentType"],
    sPassportFile: json["s_PassportFile"],
    sPassportContentType: json["s_PassportContentType"],
    dTypeAr: json["dType_Ar"],
    dTypeEn: json["dType_En"],
    sServiceProviderFile: json["s_ServiceProviderFile"],
    sSpContentType: json["s_SPContentType"],
    sVisaFile: json["s_VisaFile"],
    sVisaContentType: json["s_VisaContentType"],
    nSelfPass: json["n_SelfPass"],
    sGroupKey: json["s_GroupKey"],
    nVehiclePass: json["n_VehiclePass"],
    nIsVehicleAllowed: json["n_IsVehicleAllowed"],
    sVehicleNo: json["s_VehicleNo"],
    nArrivingByTaxi: json["n_ArrivingByTaxi"],
    sDriverLicenseFile: json["s_DriverLicenseFile"],
    sDriverLicenseContentType: json["s_DriverLicenseContentType"],
    sVehicleRegistrationFile: json["s_VehicleRegistrationFile"],
    sVehicleRegistrationContentType: json["s_VehicleRegistrationContentType"],
    sDeliveryNoteFile: json["s_DeliveryNoteFile"],
    sDeliveryNoteContentType: json["s_DeliveryNoteContentType"],
    sVisitorNameEn: json["s_VisitorName_En"],
    sVisitorName: json["s_VisitorName"],
    sSponsor: json["s_Sponsor"],
    visitorMobile: json["visitorMobile"],
    visitorEmail: json["visitorEmail"],
    sIqama: json["s_Iqama"],
    dTIqamaExpiry: json["dT_IqamaExpiry"],
    sOthersDoc: json["s_OthersDoc"],
    sVisaNo: json["s_VisaNo"],
    dtVisaExpiryDate: json["dt_VisaExpiryDate"],
    sOthersValue: json["s_OthersValue"],
    dTOthersExpiry: json["dT_OthersExpiry"],
    havePhoto: json["havePhoto"],
    haveEid: json["haveEid"],
    haveVehicleRegistration: json["haveVehicleRegistration"],
    havePassport: json["havePassport"],
    haveIqama: json["haveIqama"],
    haveVisa: json["haveVisa"],
    haveOthers: json["haveOthers"],
    sQrCodeValue: json["s_QRCodeValue"],
    nCurrentApproverOrderNo: json["n_CurrentApproverOrderNo"],
    nIsHostRequiredMoreInfo: json["n_IsHostRequiredMoreInfo"],
    pseudoApprovalStatus: json["pseudoApprovalStatus"],
    sApplyForEn: json["s_ApplyFor_En"],
    sApplyForAr: json["s_ApplyFor_Ar"],
    sHostEmail: json["s_HostEmail"],
    sIsVehicleAllowedEn: json["s_IsVehicleAllowed_En"],
    sIsVehicleAllowedAr: json["s_IsVehicleAllowed_Ar"],
    dtDateOfBirth: json["dt_DateOfBirth"] == null ? null : DateTime.parse(json["dt_DateOfBirth"]),
  );

  Map<String, dynamic> toJson() => {
    "n_AppointmentID": nAppointmentId,
    "n_ExternalRegistrationID": nExternalRegistrationId,
    "s_AppointmentCode": sAppointmentCode,
    "s_FullName": sFullName,
    "s_CompanyName": sCompanyName,
    "s_MobileNumber": sMobileNumber,
    "s_Email": sEmail,
    "gender": gender,
    "nationality": nationality,
    "n_VisaType": nVisaType,
    "n_DocumentType": nDocumentType,
    "eidNumber": eidNumber,
    "passportNumber": passportNumber,
    "dt_EIDExpiryDate": dtEidExpiryDate,
    "dt_PassportExpiryDate": dtPassportExpiryDate,
    "n_VisitType": nVisitType,
    "s_VisitorType_Ar": sVisitorTypeAr,
    "s_Remarks": sRemarks,
    "s_VisitorType_En": sVisitorTypeEn,
    "purpose": purpose,
    "purposeOtherValue": purposeOtherValue,
    "checkinMaterial": checkinMaterial,
    "n_LocationID": nLocationId,
    "s_LocationName_Ar": sLocationNameAr,
    "s_LocationName_En": sLocationNameEn,
    "n_BuildingID": nBuildingId,
    "s_BuildingName_En": sBuildingNameEn,
    "s_BuildingName_Ar": sBuildingNameAr,
    "n_DepartmentID": nDepartmentId,
    "s_DepartmentName_En": sDepartmentNameEn,
    "s_DepartmentName_Ar": sDepartmentNameAr,
    "dt_CovidDate": dtCovidDate,
    "s_VisitingPersonEmail": sVisitingPersonEmail,
    "dt_AppointmentStartTime": dtAppointmentStartTime,
    "dt_AppointmentEndTime": dtAppointmentEndTime,
    "n_HostID": nHostId,
    "is_CheckedIN": isCheckedIn,
    "user_id": userId,
    "n_IsDeleted": nIsDeleted,
    "iso3": iso3,
    "s_Nationality_Ar": sNationalityAr,
    "s_Nationality_En": sNationalityEn,
    "expr1": expr1,
    "s_HostName": sHostName,
    "n_DetailedCode": nDetailedCode,
    "s_ApprovalStatusAr": sApprovalStatusAr,
    "s_ApprovalStatusEn": sApprovalStatusEn,
    "approvalStatus": approvalStatus,
    "s_CovidFile": sCovidFile,
    "s_CovidFileType": sCovidFileType,
    "s_Purpose_A": sPurposeA,
    "s_Purpose_E": sPurposeE,
    "s_PhotoUpload": sPhotoUpload,
    "s_PhotoContentType": sPhotoContentType,
    "s_EIDFile": sEidFile,
    "s_EIDContentType": sEidContentType,
    "s_PassportFile": sPassportFile,
    "s_PassportContentType": sPassportContentType,
    "dType_Ar": dTypeAr,
    "dType_En": dTypeEn,
    "s_ServiceProviderFile": sServiceProviderFile,
    "s_SPContentType": sSpContentType,
    "s_VisaFile": sVisaFile,
    "s_VisaContentType": sVisaContentType,
    "n_SelfPass": nSelfPass,
    "s_GroupKey": sGroupKey,
    "n_VehiclePass": nVehiclePass,
    "n_IsVehicleAllowed": nIsVehicleAllowed,
    "s_VehicleNo": sVehicleNo,
    "n_ArrivingByTaxi": nArrivingByTaxi,
    "s_DriverLicenseFile": sDriverLicenseFile,
    "s_DriverLicenseContentType": sDriverLicenseContentType,
    "s_VehicleRegistrationFile": sVehicleRegistrationFile,
    "s_VehicleRegistrationContentType": sVehicleRegistrationContentType,
    "s_DeliveryNoteFile": sDeliveryNoteFile,
    "s_DeliveryNoteContentType": sDeliveryNoteContentType,
    "s_VisitorName_En": sVisitorNameEn,
    "s_VisitorName": sVisitorName,
    "s_Sponsor": sSponsor,
    "visitorMobile": visitorMobile,
    "visitorEmail": visitorEmail,
    "s_Iqama": sIqama,
    "dT_IqamaExpiry": dTIqamaExpiry,
    "s_OthersDoc": sOthersDoc,
    "s_VisaNo": sVisaNo,
    "dt_VisaExpiryDate": dtVisaExpiryDate,
    "s_OthersValue": sOthersValue,
    "dT_OthersExpiry": dTOthersExpiry,
    "havePhoto": havePhoto,
    "haveEid": haveEid,
    "haveVehicleRegistration": haveVehicleRegistration,
    "havePassport": havePassport,
    "haveIqama": haveIqama,
    "haveVisa": haveVisa,
    "haveOthers": haveOthers,
    "s_QRCodeValue": sQrCodeValue,
    "n_CurrentApproverOrderNo": nCurrentApproverOrderNo,
    "n_IsHostRequiredMoreInfo": nIsHostRequiredMoreInfo,
    "pseudoApprovalStatus": pseudoApprovalStatus,
    "s_ApplyFor_En": sApplyForEn,
    "s_ApplyFor_Ar": sApplyForAr,
    "s_HostEmail": sHostEmail,
    "s_IsVehicleAllowed_En": sIsVehicleAllowedEn,
    "s_IsVehicleAllowed_Ar": sIsVehicleAllowedAr,
    "dt_DateOfBirth": dtDateOfBirth?.toIso8601String(),
  };
}

class Pagination {
  int? pageNumber;
  int? pageSize;
  int? count;
  int? pages;

  Pagination({
    this.pageNumber,
    this.pageSize,
    this.count,
    this.pages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
    pageNumber: json["pageNumber"],
    pageSize: json["pageSize"],
    count: json["count"],
    pages: json["pages"],
  );

  Map<String, dynamic> toJson() => {
    "pageNumber": pageNumber,
    "pageSize": pageSize,
    "count": count,
    "pages": pages,
  };
}

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
