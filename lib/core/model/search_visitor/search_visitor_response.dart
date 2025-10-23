// To parse this JSON data, do
//
//     final searchVisitorResponse = searchVisitorResponseFromJson(jsonString);

import 'dart:convert';

SearchVisitorResponse searchVisitorResponseFromJson(String str) => SearchVisitorResponse.fromJson(json.decode(str));

String searchVisitorResponseToJson(SearchVisitorResponse data) => json.encode(data.toJson());

class SearchVisitorResponse {
  SearchVisitorResult? result;
  int? statusCode;
  String? message;
  bool? status;

  SearchVisitorResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory SearchVisitorResponse.fromJson(Map<String, dynamic> json) => SearchVisitorResponse(
    result: json["result"] == null ? null : SearchVisitorResult.fromJson(json["result"]),
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

class SearchVisitorResult {
  List<dynamic>? appointmentComments;
  SearchVisitorAppointment? appointment;
  dynamic appointmentNextApprover;
  SearchVisitorVehicle? vehicle;

  SearchVisitorResult({
    this.appointmentComments,
    this.appointment,
    this.appointmentNextApprover,
    this.vehicle,
  });

  factory SearchVisitorResult.fromJson(Map<String, dynamic> json) => SearchVisitorResult(
    appointmentComments: json["appointmentComments"] == null ? [] : List<dynamic>.from(json["appointmentComments"]!.map((x) => x)),
    appointment: json["appointment"] == null ? null : SearchVisitorAppointment.fromJson(json["appointment"]),
    appointmentNextApprover: json["appointmentNextApprover"],
    vehicle: json["vehicle"] == null ? null : SearchVisitorVehicle.fromJson(json["vehicle"]),
  );

  Map<String, dynamic> toJson() => {
    "appointmentComments": appointmentComments == null ? [] : List<dynamic>.from(appointmentComments!.map((x) => x)),
    "appointment": appointment?.toJson(),
    "appointmentNextApprover": appointmentNextApprover,
    "vehicle": vehicle?.toJson(),
  };
}

class SearchVisitorAppointment {
  int? nAppointmentId;
  int? nRoleId;
  int? nUpdatedBy;
  int? nEmployeeId;
  String? sAppointmentCode;
  dynamic sMaxAccessLevelIDs;
  dynamic nIsKioskVisit;
  int? nVisitType;
  int? nLocationId;
  int? nFloorId;
  int? nDepartmentId;
  dynamic sDepartmentNameAr;
  dynamic sDepartmentNameEn;
  int? nSectionId;
  String? sVisitingPersonEmail;
  String? sAppointmentTitle;
  String? dtAppointmentStartTime;
  String? dtAppointmentEndTime;
  int? nHostId;
  String? sHostComments;
  int? nApprovedHost;
  int? nApprovedSecurity;
  DateTime? dtCreatedDateStaff;
  dynamic dtUpdatedDateStaff;
  DateTime? dtCreatedDateExternal;
  dynamic dtUpdatedDateExternal;
  int? approvalStatus;
  int? nMeetingRoomId;
  String? sGroupKey;
  int? checkinId;
  int? nCheckedInStatus;
  int? userId;
  int? nIsDeleted;
  String? sVisitorNameEn;
  String? sSponsor;
  String? sMobileNo;
  String? sEmail;
  dynamic createdBy;
  int? nDetailedCode;
  int? purpose;
  dynamic sPurposeAr;
  dynamic sPurpose;
  dynamic sPhotos;
  dynamic sPhotoContentType;
  String? sLocationNameAr;
  String? sLocationNameEn;
  dynamic sMapLocationLink;
  int? nExternalRegistrationId;
  int? nVisaType;
  String? nationality;
  dynamic sNationalityEn;
  dynamic sNationalityAr;
  String? sRemarks;
  dynamic sEidFile;
  dynamic sEidContentType;
  dynamic sPassportFile;
  dynamic sPassportContentType;
  String? sServiceProviderFile;
  String? sSpContentType;
  bool? nIsExternalAppointment;
  String? sApprovalStatusAr;
  String? sApprovalStatusEn;
  int? nDocumentType;
  String? eidNumber;
  String? passportNumber;
  dynamic sCardNo;
  String? visitTypeAr;
  String? visitTypeEn;
  dynamic sHostName;
  dynamic sHostEmail;
  String? sApprovalNumber;
  int? nIsVehicleAllowed;
  String? sVehicleNo;
  int? nProcessId;
  int? nBuildingId;
  dynamic sBuildingNameEn;
  dynamic sBuildingNameAr;
  String? dtEidExpiryDate;
  dynamic dtPassportExpiryDate;
  String? sIqama;
  dynamic dtIqamaExpiry;
  String? dtDateOfBirth;
  String? sOthersDoc;
  String? sOthersValue;
  dynamic dtOthersExpiry;
  String? sVisaFile;
  String? sVisaContentType;
  int? nSelfPass;
  int? safetyStatus;
  dynamic safetyStatusEn;
  dynamic safetyStatusAr;
  int? nArrivingByTaxi;
  dynamic nVisitingAreaId;
  int? nAccessGroupId;
  int? nCreatedByStaff;
  int? nGateId;
  dynamic sGateNameEn;
  dynamic sGateNameAr;
  dynamic nUpdatedByStaff;
  int? nIsMobileAllowed;
  int? nIsLaptopAllowed;
  dynamic sAllowedReason;
  dynamic sHostAccessAreasIDs;
  dynamic sVehicleRegistrationFile;
  dynamic sVehicleRegistrationContentType;
  dynamic purposeOtherValue;
  int? havePhoto;
  int? haveEid;
  int? haveIqama;
  int? haveOthers;
  int? haveVehicleRegistration;
  int? havePassport;
  dynamic devices;
  int? nNextDevicesApproverRoleId;
  int? nDevicesApprovalStatus;
  int? nCurrentApproverOrderNo;
  int? nBadgePrintStatus;
  int? nIsHostRequiredMoreInfo;

  SearchVisitorAppointment({
    this.nAppointmentId,
    this.nRoleId,
    this.nUpdatedBy,
    this.nEmployeeId,
    this.sAppointmentCode,
    this.sMaxAccessLevelIDs,
    this.nIsKioskVisit,
    this.nVisitType,
    this.nLocationId,
    this.nFloorId,
    this.nDepartmentId,
    this.sDepartmentNameAr,
    this.sDepartmentNameEn,
    this.nSectionId,
    this.sVisitingPersonEmail,
    this.sAppointmentTitle,
    this.dtAppointmentStartTime,
    this.dtAppointmentEndTime,
    this.nHostId,
    this.sHostComments,
    this.nApprovedHost,
    this.nApprovedSecurity,
    this.dtCreatedDateStaff,
    this.dtUpdatedDateStaff,
    this.dtCreatedDateExternal,
    this.dtUpdatedDateExternal,
    this.approvalStatus,
    this.nMeetingRoomId,
    this.sGroupKey,
    this.checkinId,
    this.nCheckedInStatus,
    this.userId,
    this.nIsDeleted,
    this.sVisitorNameEn,
    this.sSponsor,
    this.sMobileNo,
    this.sEmail,
    this.createdBy,
    this.nDetailedCode,
    this.purpose,
    this.sPurposeAr,
    this.sPurpose,
    this.sPhotos,
    this.sPhotoContentType,
    this.sLocationNameAr,
    this.sLocationNameEn,
    this.sMapLocationLink,
    this.nExternalRegistrationId,
    this.nVisaType,
    this.nationality,
    this.sNationalityEn,
    this.sNationalityAr,
    this.sRemarks,
    this.sEidFile,
    this.sEidContentType,
    this.sPassportFile,
    this.sPassportContentType,
    this.sServiceProviderFile,
    this.sSpContentType,
    this.nIsExternalAppointment,
    this.sApprovalStatusAr,
    this.sApprovalStatusEn,
    this.nDocumentType,
    this.eidNumber,
    this.passportNumber,
    this.sCardNo,
    this.visitTypeAr,
    this.visitTypeEn,
    this.sHostName,
    this.sHostEmail,
    this.sApprovalNumber,
    this.nIsVehicleAllowed,
    this.sVehicleNo,
    this.nProcessId,
    this.nBuildingId,
    this.sBuildingNameEn,
    this.sBuildingNameAr,
    this.dtEidExpiryDate,
    this.dtPassportExpiryDate,
    this.sIqama,
    this.dtIqamaExpiry,
    this.dtDateOfBirth,
    this.sOthersDoc,
    this.sOthersValue,
    this.dtOthersExpiry,
    this.sVisaFile,
    this.sVisaContentType,
    this.nSelfPass,
    this.safetyStatus,
    this.safetyStatusEn,
    this.safetyStatusAr,
    this.nArrivingByTaxi,
    this.nVisitingAreaId,
    this.nAccessGroupId,
    this.nCreatedByStaff,
    this.nGateId,
    this.sGateNameEn,
    this.sGateNameAr,
    this.nUpdatedByStaff,
    this.nIsMobileAllowed,
    this.nIsLaptopAllowed,
    this.sAllowedReason,
    this.sHostAccessAreasIDs,
    this.sVehicleRegistrationFile,
    this.sVehicleRegistrationContentType,
    this.purposeOtherValue,
    this.havePhoto,
    this.haveEid,
    this.haveIqama,
    this.haveOthers,
    this.haveVehicleRegistration,
    this.havePassport,
    this.devices,
    this.nNextDevicesApproverRoleId,
    this.nDevicesApprovalStatus,
    this.nCurrentApproverOrderNo,
    this.nBadgePrintStatus,
    this.nIsHostRequiredMoreInfo,
  });

  factory SearchVisitorAppointment.fromJson(Map<String, dynamic> json) => SearchVisitorAppointment(
    nAppointmentId: json["n_AppointmentID"],
    nRoleId: json["n_RoleID"],
    nUpdatedBy: json["n_UpdatedBy"],
    nEmployeeId: json["n_EmployeeID"],
    sAppointmentCode: json["s_AppointmentCode"],
    sMaxAccessLevelIDs: json["s_MaxAccessLevelIDs"],
    nIsKioskVisit: json["n_IsKioskVisit"],
    nVisitType: json["n_VisitType"],
    nLocationId: json["n_LocationID"],
    nFloorId: json["n_FloorID"],
    nDepartmentId: json["n_DepartmentID"],
    sDepartmentNameAr: json["s_DepartmentName_Ar"],
    sDepartmentNameEn: json["s_DepartmentName_En"],
    nSectionId: json["n_SectionID"],
    sVisitingPersonEmail: json["s_VisitingPersonEmail"],
    sAppointmentTitle: json["s_AppointmentTitle"],
    dtAppointmentStartTime: json["dt_AppointmentStartTime"],
    dtAppointmentEndTime: json["dt_AppointmentEndTime"],
    nHostId: json["n_HostID"],
    sHostComments: json["s_HostComments"],
    nApprovedHost: json["n_Approved_Host"],
    nApprovedSecurity: json["n_Approved_Security"],
    dtCreatedDateStaff: json["dt_CreatedDate_Staff"] == null ? null : DateTime.parse(json["dt_CreatedDate_Staff"]),
    dtUpdatedDateStaff: json["dt_UpdatedDate_Staff"],
    dtCreatedDateExternal: json["dt_CreatedDate_External"] == null ? null : DateTime.parse(json["dt_CreatedDate_External"]),
    dtUpdatedDateExternal: json["dt_UpdatedDate_External"],
    approvalStatus: json["approvalStatus"],
    nMeetingRoomId: json["n_MeetingRoomID"],
    sGroupKey: json["s_GroupKey"],
    checkinId: json["checkinID"],
    nCheckedInStatus: json["n_CheckedInStatus"],
    userId: json["userId"],
    nIsDeleted: json["n_IsDeleted"],
    sVisitorNameEn: json["s_VisitorName_En"],
    sSponsor: json["s_Sponsor"],
    sMobileNo: json["s_MobileNo"],
    sEmail: json["s_Email"],
    createdBy: json["createdBy"],
    nDetailedCode: json["n_DetailedCode"],
    purpose: json["purpose"],
    sPurposeAr: json["s_PurposeAr"],
    sPurpose: json["s_Purpose"],
    sPhotos: json["s_Photos"],
    sPhotoContentType: json["s_PhotoContentType"],
    sLocationNameAr: json["s_LocationName_Ar"],
    sLocationNameEn: json["s_LocationName_En"],
    sMapLocationLink: json["s_MapLocationLink"],
    nExternalRegistrationId: json["n_ExternalRegistrationID"],
    nVisaType: json["n_VisaType"],
    nationality: json["nationality"],
    sNationalityEn: json["s_Nationality_En"],
    sNationalityAr: json["s_Nationality_Ar"],
    sRemarks: json["s_Remarks"],
    sEidFile: json["s_EIDFile"],
    sEidContentType: json["s_EIDContentType"],
    sPassportFile: json["s_PassportFile"],
    sPassportContentType: json["s_PassportContentType"],
    sServiceProviderFile: json["s_ServiceProviderFile"],
    sSpContentType: json["s_SPContentType"],
    nIsExternalAppointment: json["n_IsExternalAppointment"],
    sApprovalStatusAr: json["s_ApprovalStatusAr"],
    sApprovalStatusEn: json["s_ApprovalStatusEn"],
    nDocumentType: json["n_DocumentType"],
    eidNumber: json["eidNumber"],
    passportNumber: json["passportNumber"],
    sCardNo: json["s_CardNo"],
    visitTypeAr: json["visitType_Ar"],
    visitTypeEn: json["visitType_En"],
    sHostName: json["s_HostName"],
    sHostEmail: json["s_HostEmail"],
    sApprovalNumber: json["s_ApprovalNumber"],
    nIsVehicleAllowed: json["n_IsVehicleAllowed"],
    sVehicleNo: json["s_VehicleNo"],
    nProcessId: json["n_ProcessID"],
    nBuildingId: json["n_BuildingID"],
    sBuildingNameEn: json["s_BuildingName_En"],
    sBuildingNameAr: json["s_BuildingName_Ar"],
    dtEidExpiryDate: json["dt_EIDExpiryDate"],
    dtPassportExpiryDate: json["dt_PassportExpiryDate"],
    sIqama: json["s_Iqama"],
    dtIqamaExpiry: json["dt_IqamaExpiry"],
    dtDateOfBirth: json["dt_DateOfBirth"],
    sOthersDoc: json["s_OthersDoc"],
    sOthersValue: json["s_OthersValue"],
    dtOthersExpiry: json["dt_OthersExpiry"],
    sVisaFile: json["s_VisaFile"],
    sVisaContentType: json["s_VisaContentType"],
    nSelfPass: json["n_SelfPass"],
    safetyStatus: json["safetyStatus"],
    safetyStatusEn: json["safetyStatusEn"],
    safetyStatusAr: json["safetyStatusAr"],
    nArrivingByTaxi: json["n_ArrivingByTaxi"],
    nVisitingAreaId: json["n_VisitingAreaID"],
    nAccessGroupId: json["n_AccessGroupID"],
    nCreatedByStaff: json["n_CreatedBy_Staff"],
    nGateId: json["n_GateID"],
    sGateNameEn: json["s_GateName_En"],
    sGateNameAr: json["s_GateName_Ar"],
    nUpdatedByStaff: json["n_UpdatedBy_Staff"],
    nIsMobileAllowed: json["n_IsMobileAllowed"],
    nIsLaptopAllowed: json["n_IsLaptopAllowed"],
    sAllowedReason: json["s_AllowedReason"],
    sHostAccessAreasIDs: json["s_HostAccessAreasIDs"],
    sVehicleRegistrationFile: json["s_VehicleRegistrationFile"],
    sVehicleRegistrationContentType: json["s_VehicleRegistrationContentType"],
    purposeOtherValue: json["purposeOtherValue"],
    havePhoto: json["havePhoto"],
    haveEid: json["haveEid"],
    haveIqama: json["haveIqama"],
    haveOthers: json["haveOthers"],
    haveVehicleRegistration: json["haveVehicleRegistration"],
    havePassport: json["havePassport"],
    devices: json["devices"],
    nNextDevicesApproverRoleId: json["n_NextDevicesApproverRoleId"],
    nDevicesApprovalStatus: json["n_DevicesApprovalStatus"],
    nCurrentApproverOrderNo: json["n_CurrentApproverOrderNo"],
    nBadgePrintStatus: json["n_BadgePrintStatus"],
    nIsHostRequiredMoreInfo: json["n_IsHostRequiredMoreInfo"],
  );

  Map<String, dynamic> toJson() => {
    "n_AppointmentID": nAppointmentId,
    "n_RoleID": nRoleId,
    "n_UpdatedBy": nUpdatedBy,
    "n_EmployeeID": nEmployeeId,
    "s_AppointmentCode": sAppointmentCode,
    "s_MaxAccessLevelIDs": sMaxAccessLevelIDs,
    "n_IsKioskVisit": nIsKioskVisit,
    "n_VisitType": nVisitType,
    "n_LocationID": nLocationId,
    "n_FloorID": nFloorId,
    "n_DepartmentID": nDepartmentId,
    "s_DepartmentName_Ar": sDepartmentNameAr,
    "s_DepartmentName_En": sDepartmentNameEn,
    "n_SectionID": nSectionId,
    "s_VisitingPersonEmail": sVisitingPersonEmail,
    "s_AppointmentTitle": sAppointmentTitle,
    "dt_AppointmentStartTime": dtAppointmentStartTime,
    "dt_AppointmentEndTime": dtAppointmentEndTime,
    "n_HostID": nHostId,
    "s_HostComments": sHostComments,
    "n_Approved_Host": nApprovedHost,
    "n_Approved_Security": nApprovedSecurity,
    "dt_CreatedDate_Staff": dtCreatedDateStaff?.toIso8601String(),
    "dt_UpdatedDate_Staff": dtUpdatedDateStaff,
    "dt_CreatedDate_External": dtCreatedDateExternal?.toIso8601String(),
    "dt_UpdatedDate_External": dtUpdatedDateExternal,
    "approvalStatus": approvalStatus,
    "n_MeetingRoomID": nMeetingRoomId,
    "s_GroupKey": sGroupKey,
    "checkinID": checkinId,
    "n_CheckedInStatus": nCheckedInStatus,
    "userId": userId,
    "n_IsDeleted": nIsDeleted,
    "s_VisitorName_En": sVisitorNameEn,
    "s_Sponsor": sSponsor,
    "s_MobileNo": sMobileNo,
    "s_Email": sEmail,
    "createdBy": createdBy,
    "n_DetailedCode": nDetailedCode,
    "purpose": purpose,
    "s_PurposeAr": sPurposeAr,
    "s_Purpose": sPurpose,
    "s_Photos": sPhotos,
    "s_PhotoContentType": sPhotoContentType,
    "s_LocationName_Ar": sLocationNameAr,
    "s_LocationName_En": sLocationNameEn,
    "s_MapLocationLink": sMapLocationLink,
    "n_ExternalRegistrationID": nExternalRegistrationId,
    "n_VisaType": nVisaType,
    "nationality": nationality,
    "s_Nationality_En": sNationalityEn,
    "s_Nationality_Ar": sNationalityAr,
    "s_Remarks": sRemarks,
    "s_EIDFile": sEidFile,
    "s_EIDContentType": sEidContentType,
    "s_PassportFile": sPassportFile,
    "s_PassportContentType": sPassportContentType,
    "s_ServiceProviderFile": sServiceProviderFile,
    "s_SPContentType": sSpContentType,
    "n_IsExternalAppointment": nIsExternalAppointment,
    "s_ApprovalStatusAr": sApprovalStatusAr,
    "s_ApprovalStatusEn": sApprovalStatusEn,
    "n_DocumentType": nDocumentType,
    "eidNumber": eidNumber,
    "passportNumber": passportNumber,
    "s_CardNo": sCardNo,
    "visitType_Ar": visitTypeAr,
    "visitType_En": visitTypeEn,
    "s_HostName": sHostName,
    "s_HostEmail": sHostEmail,
    "s_ApprovalNumber": sApprovalNumber,
    "n_IsVehicleAllowed": nIsVehicleAllowed,
    "s_VehicleNo": sVehicleNo,
    "n_ProcessID": nProcessId,
    "n_BuildingID": nBuildingId,
    "s_BuildingName_En": sBuildingNameEn,
    "s_BuildingName_Ar": sBuildingNameAr,
    "dt_EIDExpiryDate": dtEidExpiryDate,
    "dt_PassportExpiryDate": dtPassportExpiryDate,
    "s_Iqama": sIqama,
    "dt_IqamaExpiry": dtIqamaExpiry,
    "dt_DateOfBirth": dtDateOfBirth,
    "s_OthersDoc": sOthersDoc,
    "s_OthersValue": sOthersValue,
    "dt_OthersExpiry": dtOthersExpiry,
    "s_VisaFile": sVisaFile,
    "s_VisaContentType": sVisaContentType,
    "n_SelfPass": nSelfPass,
    "safetyStatus": safetyStatus,
    "safetyStatusEn": safetyStatusEn,
    "safetyStatusAr": safetyStatusAr,
    "n_ArrivingByTaxi": nArrivingByTaxi,
    "n_VisitingAreaID": nVisitingAreaId,
    "n_AccessGroupID": nAccessGroupId,
    "n_CreatedBy_Staff": nCreatedByStaff,
    "n_GateID": nGateId,
    "s_GateName_En": sGateNameEn,
    "s_GateName_Ar": sGateNameAr,
    "n_UpdatedBy_Staff": nUpdatedByStaff,
    "n_IsMobileAllowed": nIsMobileAllowed,
    "n_IsLaptopAllowed": nIsLaptopAllowed,
    "s_AllowedReason": sAllowedReason,
    "s_HostAccessAreasIDs": sHostAccessAreasIDs,
    "s_VehicleRegistrationFile": sVehicleRegistrationFile,
    "s_VehicleRegistrationContentType": sVehicleRegistrationContentType,
    "purposeOtherValue": purposeOtherValue,
    "havePhoto": havePhoto,
    "haveEid": haveEid,
    "haveIqama": haveIqama,
    "haveOthers": haveOthers,
    "haveVehicleRegistration": haveVehicleRegistration,
    "havePassport": havePassport,
    "devices": devices,
    "n_NextDevicesApproverRoleId": nNextDevicesApproverRoleId,
    "n_DevicesApprovalStatus": nDevicesApprovalStatus,
    "n_CurrentApproverOrderNo": nCurrentApproverOrderNo,
    "n_BadgePrintStatus": nBadgePrintStatus,
    "n_IsHostRequiredMoreInfo": nIsHostRequiredMoreInfo,
  };
}

class SearchVisitorVehicle {
  int? nVehicleId;
  int? nAppointmentId;
  int? nPlateSource;
  dynamic sPlateCode;
  String? sPlateNumber;
  dynamic sModelNumber;
  dynamic sColor;
  int? nCreatedBy;
  DateTime? dtCreatedDate;
  int? nUpdatedBy;
  dynamic dtUpdatedDate;
  int? nIsDeleted;
  String? sDescA;
  String? sDescE;
  int? nPlateLetter1;
  int? nPlateLetter2;
  int? nPlateLetter3;

  SearchVisitorVehicle({
    this.nVehicleId,
    this.nAppointmentId,
    this.nPlateSource,
    this.sPlateCode,
    this.sPlateNumber,
    this.sModelNumber,
    this.sColor,
    this.nCreatedBy,
    this.dtCreatedDate,
    this.nUpdatedBy,
    this.dtUpdatedDate,
    this.nIsDeleted,
    this.sDescA,
    this.sDescE,
    this.nPlateLetter1,
    this.nPlateLetter2,
    this.nPlateLetter3,
  });

  factory SearchVisitorVehicle.fromJson(Map<String, dynamic> json) => SearchVisitorVehicle(
    nVehicleId: json["n_VehicleID"],
    nAppointmentId: json["n_AppointmentID"],
    nPlateSource: json["n_PlateSource"],
    sPlateCode: json["s_PlateCode"],
    sPlateNumber: json["s_PlateNumber"],
    sModelNumber: json["s_ModelNumber"],
    sColor: json["s_Color"],
    nCreatedBy: json["n_CreatedBy"],
    dtCreatedDate: json["dt_CreatedDate"] == null ? null : DateTime.parse(json["dt_CreatedDate"]),
    nUpdatedBy: json["n_UpdatedBy"],
    dtUpdatedDate: json["dt_UpdatedDate"],
    nIsDeleted: json["n_IsDeleted"],
    sDescA: json["s_Desc_A"],
    sDescE: json["s_Desc_E"],
    nPlateLetter1: json["n_PlateLetter1"],
    nPlateLetter2: json["n_PlateLetter2"],
    nPlateLetter3: json["n_PlateLetter3"],
  );

  Map<String, dynamic> toJson() => {
    "n_VehicleID": nVehicleId,
    "n_AppointmentID": nAppointmentId,
    "n_PlateSource": nPlateSource,
    "s_PlateCode": sPlateCode,
    "s_PlateNumber": sPlateNumber,
    "s_ModelNumber": sModelNumber,
    "s_Color": sColor,
    "n_CreatedBy": nCreatedBy,
    "dt_CreatedDate": dtCreatedDate?.toIso8601String(),
    "n_UpdatedBy": nUpdatedBy,
    "dt_UpdatedDate": dtUpdatedDate,
    "n_IsDeleted": nIsDeleted,
    "s_Desc_A": sDescA,
    "s_Desc_E": sDescE,
    "n_PlateLetter1": nPlateLetter1,
    "n_PlateLetter2": nPlateLetter2,
    "n_PlateLetter3": nPlateLetter3,
  };
}
