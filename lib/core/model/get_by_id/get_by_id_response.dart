// To parse this JSON data, do
//
//     final getByIdResponse = getByIdResponseFromJson(jsonString);

import 'dart:convert';

GetByIdResponse getByIdResponseFromJson(String str) => GetByIdResponse.fromJson(json.decode(str));

String getByIdResponseToJson(GetByIdResponse data) => json.encode(data.toJson());

class GetByIdResponse {
  GetByIdResult? result;
  int? statusCode;
  String? message;
  bool? status;

  GetByIdResponse({this.result, this.statusCode, this.message, this.status});

  factory GetByIdResponse.fromJson(Map<String, dynamic> json) => GetByIdResponse(
    result: json["result"] == null ? null : GetByIdResult.fromJson(json["result"]),
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

class GetByIdResult {
  List<AppointmentComment>? appointmentComments;
  GetByIdUser? user;
  Vehicle? vehicle;
  List<DeviceResult>? devices;

  GetByIdResult({this.appointmentComments, this.user, this.vehicle, this.devices});

  factory GetByIdResult.fromJson(Map<String, dynamic> json) => GetByIdResult(
    appointmentComments:
        json["appointmentComments"] == null
            ? []
            : List<AppointmentComment>.from(json["appointmentComments"]!.map((x) => AppointmentComment.fromJson(x))),
    user: json["user"] == null ? null : GetByIdUser.fromJson(json["user"]),
    vehicle: json["vehicle"] == null ? null : Vehicle.fromJson(json["vehicle"]),
    devices:
        json["devices"] == null ? [] : List<DeviceResult>.from(json["devices"]!.map((x) => DeviceResult.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "appointmentComments":
        appointmentComments == null ? [] : List<dynamic>.from(appointmentComments!.map((x) => x.toJson())),
    "user": user?.toJson(),
    "vehicle": vehicle?.toJson(),
    "devices": devices == null ? [] : List<dynamic>.from(devices!.map((x) => x.toJson())),
  };
}

class AppointmentComment {
  int? nId;
  int? nAppointmentId;
  int? nRoleId;
  int? nUserId;
  int? nCommentType;
  String? sComment;

  AppointmentComment({this.nId, this.nAppointmentId, this.nRoleId, this.nUserId, this.nCommentType, this.sComment});

  factory AppointmentComment.fromJson(Map<String, dynamic> json) => AppointmentComment(
    nId: json["n_ID"],
    nAppointmentId: json["n_AppointmentID"],
    nRoleId: json["n_RoleID"],
    nUserId: json["n_UserID"],
    nCommentType: json["n_CommentType"],
    sComment: json["s_Comment"],
  );

  Map<String, dynamic> toJson() => {
    "n_ID": nId,
    "n_AppointmentID": nAppointmentId,
    "n_RoleID": nRoleId,
    "n_UserID": nUserId,
    "n_CommentType": nCommentType,
    "s_Comment": sComment,
  };
}

class DeviceResult {
  int? appointmentDeviceId;
  int? appointmentId;
  int? deviceType;
  String? deviceTypeOthersValue;
  String? deviceModel;
  String? serialNumber;
  String? devicePurpose;
  int? approvalStatus;
  int? currentApprovalStatus;
  dynamic comment;

  DeviceResult({
    this.appointmentDeviceId,
    this.appointmentId,
    this.deviceType,
    this.deviceTypeOthersValue,
    this.deviceModel,
    this.serialNumber,
    this.devicePurpose,
    this.approvalStatus,
    this.currentApprovalStatus,
    this.comment,
  });

  factory DeviceResult.fromJson(Map<String, dynamic> json) => DeviceResult(
    appointmentDeviceId: json["appointmentDeviceId"],
    appointmentId: json["appointmentId"],
    deviceType: json["deviceType"],
    deviceTypeOthersValue: json["deviceTypeOthersValue"],
    deviceModel: json["deviceModel"],
    serialNumber: json["serialNumber"],
    devicePurpose: json["purpose"],
    approvalStatus: json["approvalStatus"],
    currentApprovalStatus: json["currentApprovalStatus"],
    comment: json["comment"],
  );

  Map<String, dynamic> toJson() => {
    "appointmentDeviceId": appointmentDeviceId,
    "appointmentId": appointmentId,
    "deviceType": deviceType,
    "deviceTypeOthersValue": deviceTypeOthersValue,
    "deviceModel": deviceModel,
    "serialNumber": serialNumber,
    "purpose": devicePurpose,
    "approvalStatus": approvalStatus,
    "currentApprovalStatus": currentApprovalStatus,
    "comment": comment,
  };
}

class GetByIdUser {
  int? nAppointmentId;
  int? nExternalRegistrationId;
  dynamic sAppointmentCode;
  dynamic sFullName;
  dynamic sCompanyName;
  dynamic sMobileNumber;
  dynamic sEmail;
  String? gender;
  String? nationality;
  int? nVisaType;
  int? nDocumentType;
  String? eidNumber;
  String? passportNumber;
  String? sVisaNo;
  String? dtEidExpiryDate;
  String? dtVisaExpiryDate;
  dynamic dtPassportExpiryDate;
  int? nVisitType;
  String? sVisitorTypeAr;
  dynamic sRemarks;
  String? sVisitorTypeEn;
  int? purpose;
  String? purposeOtherValue;
  String? checkinMaterial;
  int? nLocationId;
  String? sLocationNameAr;
  String? sLocationNameEn;
  int? nBuildingID;
  String? sBuildingNameEn;
  String? sBuildingNameAr;
  int? nDepartmentId;
  String? sDepartmentNameEn;
  String? sDepartmentNameAr;
  dynamic dtCovidDate;
  String? sVisitingPersonEmail;
  String? dtAppointmentStartTime;
  String? dtAppointmentEndTime;
  int? nHostId;
  bool? isCheckedIn;
  int? userId;
  int? nIsDeleted;
  String? iso3;
  String? sNationalityAr;
  String? sNationalityEn;
  dynamic expr1;
  String? sHostName;
  int? nDetailedCode;
  String? sApprovalStatusAr;
  String? sApprovalStatusEn;
  int? approvalStatus;
  dynamic sCovidFile;
  String? sCovidFileType;
  String? sPurposeA;
  String? sPurposeE;
  dynamic sPhotoUpload;
  dynamic sPhotoContentType;
  dynamic sEidFile;
  dynamic sEidContentType;
  dynamic sPassportFile;
  dynamic sPassportContentType;
  String? dTypeAr;
  String? dTypeEn;
  String? sServiceProviderFile;
  String? sSpContentType;
  String? sVisaFile;
  String? sVisaContentType;
  int? nSelfPass;
  String? sGroupKey;
  int? nVehiclePass;
  int? nIsVehicleAllowed;
  String? sVehicleNo;
  int? nArrivingByTaxi;
  String? sDriverLicenseFile;
  String? sDriverLicenseContentType;
  dynamic sVehicleRegistrationFile;
  dynamic sVehicleRegistrationContentType;
  String? sDeliveryNoteFile;
  String? sDeliveryNoteContentType;
  String? sVisitorNameEn;
  dynamic sVisitorName;
  String? sSponsor;
  String? visitorMobile;
  String? visitorEmail;
  String? sIqama;
  String? dTIqamaExpiry;
  String? sOthersDoc;
  String? sOthersValue;
  dynamic dTOthersExpiry;
  int? havePhoto;
  int? haveEid;
  int? haveVehicleRegistration;
  int? havePassport;
  int? haveIqama;
  int? haveVisa;
  int? haveOthers;
  int? nCurrentApproverOrderNo;
  int? nIsHostRequiredMoreInfo;
  int? pseudoApprovalStatus;
  String? dtDateOfBirth;

  GetByIdUser({
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
    this.sVisaNo,
    this.dtEidExpiryDate,
    this.dtPassportExpiryDate,
    this.dtVisaExpiryDate,
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
    this.nBuildingID,
    this.sBuildingNameAr,
    this.sBuildingNameEn,
    this.nDepartmentId,
    this.sDepartmentNameEn,
    this.sDepartmentNameAr,
    this.dtCovidDate,
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
    this.sOthersValue,
    this.dTOthersExpiry,
    this.havePhoto,
    this.haveEid,
    this.haveVisa,
    this.haveVehicleRegistration,
    this.havePassport,
    this.haveIqama,
    this.haveOthers,
    this.nCurrentApproverOrderNo,
    this.nIsHostRequiredMoreInfo,
    this.pseudoApprovalStatus,
    this.dtDateOfBirth,
  });

  factory GetByIdUser.fromJson(Map<String, dynamic> json) => GetByIdUser(
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
    sVisaNo: json["s_VisaNo"],
    dtEidExpiryDate: json["dt_EIDExpiryDate"],
    dtPassportExpiryDate: json["dt_PassportExpiryDate"],
    dtVisaExpiryDate: json["dt_VisaExpiryDate"],
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
    nBuildingID: json["n_BuildingID"],
    sBuildingNameAr: json["s_BuildingName_Ar"],
    sBuildingNameEn: json["s_BuildingName_En"],
    nDepartmentId: json["n_DepartmentID"],
    sDepartmentNameEn: json["s_DepartmentName_En"],
    sDepartmentNameAr: json["s_DepartmentName_Ar"],
    dtCovidDate: json["dt_CovidDate"],
    sVisitingPersonEmail: json["s_VisitingPersonEmail"],
    dtAppointmentStartTime: json["dt_AppointmentStartTime"],
    dtAppointmentEndTime: json["dt_AppointmentEndTime"],
    nHostId: json["n_HostID"],
    isCheckedIn: json["is_CheckedIN"],
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
    sOthersValue: json["s_OthersValue"],
    dTOthersExpiry: json["dT_OthersExpiry"],
    havePhoto: json["havePhoto"],
    haveEid: json["haveEid"],
    haveVisa: json["haveVisa"],
    haveVehicleRegistration: json["haveVehicleRegistration"],
    havePassport: json["havePassport"],
    haveIqama: json["haveIqama"],
    haveOthers: json["haveOthers"],
    nCurrentApproverOrderNo: json["n_CurrentApproverOrderNo"],
    nIsHostRequiredMoreInfo: json["n_IsHostRequiredMoreInfo"],
    pseudoApprovalStatus: json["pseudoApprovalStatus"],
    dtDateOfBirth: json["dt_DateOfBirth"],
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
    "s_VisaNo": sVisaNo,
    "dt_EIDExpiryDate": dtEidExpiryDate,
    "dt_VisaExpiryDate": dtVisaExpiryDate,
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
    "n_BuildingID": nBuildingID,
    "s_BuildingName_Ar": sBuildingNameAr,
    "s_BuildingName_En": sBuildingNameEn,
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
    "s_OthersValue": sOthersValue,
    "dT_OthersExpiry": dTOthersExpiry,
    "havePhoto": havePhoto,
    "haveEid": haveEid,
    "haveVehicleRegistration": haveVehicleRegistration,
    "havePassport": havePassport,
    "haveIqama": haveIqama,
    "haveVisa": haveVisa,
    "haveOthers": haveOthers,
    "n_CurrentApproverOrderNo": nCurrentApproverOrderNo,
    "n_IsHostRequiredMoreInfo": nIsHostRequiredMoreInfo,
    "pseudoApprovalStatus": pseudoApprovalStatus,
    "dt_DateOfBirth": dtDateOfBirth,
  };
}

class Vehicle {
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

  Vehicle({
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

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
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
