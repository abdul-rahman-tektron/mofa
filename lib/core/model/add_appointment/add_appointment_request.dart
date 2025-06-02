// To parse this JSON data, do
//
//     final addAppointmentRequest = addAppointmentRequestFromJson(jsonString);

import 'dart:convert';

AddAppointmentRequest addAppointmentRequestFromJson(String str) => AddAppointmentRequest.fromJson(json.decode(str));

String addAppointmentRequestToJson(AddAppointmentRequest data) => json.encode(data.toJson());

class AddAppointmentRequest {
  String? gender;
  int? nVisitType;
  int? nVisaType;
  String? sVehicleNo;
  List<DeviceModel>? devices;
  int? nLocationId;
  int? nDepartmentId;
  int? nSectionId;
  String? sVisitingPersonEmail;
  String? sAppointmentTitle;
  DateTime? dtAppointmentStartTime;
  DateTime? dtAppointmentEndTime;
  String? dtCovidDate;
  int? nHostId;
  String? sHostComments;
  int? nApprovedHost;
  int? nApprovedSecurity;
  int? approvalStatus;
  int? purpose;
  String? purposeOtherValue;
  String? remarks;
  String? checkinMaterial;
  String? sGroupKey;
  int? isCheckedIn;
  String? sCovidFile;
  String? sCovidContentType;
  String? sVisaFile;
  String? sVisaContentType;
  String? sServiceProviderFile;
  String? sSpContentType;
  int? userId;
  int? nExternalRegistrationId;
  int? nAppointmentId;
  int? nIsExternalAppointment;
  int? nCreatedByStaff;
  int? nUpdatedByStaff;
  int? nCreatedByExternal;
  int? nUpdatedByExternal;
  String? dtUpdatedDateExternal;
  String? icaEidPhoto;
  String? icaStatus;
  String? dtLatestTestDate;
  String? sLatestTestResult;
  String? sVaccineStatus;
  int? nCurrentStage;
  String? sApprovalNumber;
  int? nSelfPass;
  String? hostName;
  int? nProcessId;
  List<dynamic> tblApprovals;
  int? nVehiclePass;
  List<dynamic> tblVehicleDetails;
  bool? nArrivingByTaxi;
  String? sDriverLicenseFile;
  String? sDriverLicenseContentType;
  String? sDeliveryNoteFile;
  String? sDeliveryNoteContentType;
  String? sApprovalReferenceNumber;
  int? lastAppointmentId;
  String? fullName;
  String? sponsor;
  String? mobileNo;
  String? email;
  int? idType;
  String? sIqama;
  String? eidNumber;
  String? passportNumber;
  String? sOthersDoc;
  String? sOthersValue;
  String? dtIqamaExpiry;
  String? dtEidExpiryDate;
  String? dtPassportExpiryDate;
  String? dtOthersExpiry;
  String? nationality;
  String? resubmissionComments;
  int? havePhoto;
  int? haveIqama;
  int? haveEid;
  int? havePassport;
  int? haveOthers;
  int? haveVehicleRegistration;
  int? nVisitCreatedFrom;
  int? nVisitUpdatedFrom;
  int? nPlateLetter1;
  int? nPlateLetter2;
  int? nPlateLetter3;
  int? nPlateSource;
  String? sPlateNumber;

  AddAppointmentRequest({
    this.gender = "",
    this.nVisitType,
    this.nVisaType = 0,
    this.sVehicleNo = "",
    this.devices,
    this.nLocationId,
    this.nDepartmentId = 0,
    this.nSectionId = 0,
    this.sVisitingPersonEmail,
    this.sAppointmentTitle = "",
    this.dtAppointmentStartTime,
    this.dtAppointmentEndTime,
    this.dtCovidDate = "",
    this.nHostId = 0,
    this.sHostComments = "",
    this.nApprovedHost = 0,
    this.nApprovedSecurity = 0,
    this.approvalStatus = 50,
    this.purpose,
    this.purposeOtherValue = "",
    this.remarks = "",
    this.checkinMaterial = "",
    this.sGroupKey = "",
    this.isCheckedIn = 0,
    this.sCovidFile = "",
    this.sCovidContentType = "",
    this.sVisaFile = "",
    this.sVisaContentType = "",
    this.sServiceProviderFile = "",
    this.sSpContentType = "",
    this.userId = 0,
    this.nExternalRegistrationId = 0,
    this.nAppointmentId = 0,
    this.nIsExternalAppointment = 1,
    this.nCreatedByStaff = 0,
    this.nUpdatedByStaff = 0,
    this.nCreatedByExternal,
    this.nUpdatedByExternal = 0,
    this.dtUpdatedDateExternal = "",
    this.icaEidPhoto = "",
    this.icaStatus = "",
    this.dtLatestTestDate = "",
    this.sLatestTestResult = "",
    this.sVaccineStatus = "",
    this.nCurrentStage = 0,
    this.sApprovalNumber = "",
    this.nSelfPass = 0,
    this.hostName = "",
    this.nProcessId = 1,
    this.tblApprovals = const [],
    this.nVehiclePass = 0,
    this.tblVehicleDetails = const [],
    this.nArrivingByTaxi = true,
    this.sDriverLicenseFile = "",
    this.sDriverLicenseContentType = "",
    this.sDeliveryNoteFile = "",
    this.sDeliveryNoteContentType = "",
    this.sApprovalReferenceNumber = "",
    this.lastAppointmentId,
    this.fullName,
    this.sponsor,
    this.mobileNo,
    this.email,
    this.idType,
    this.sIqama,
    this.eidNumber,
    this.passportNumber,
    this.sOthersDoc,
    this.sOthersValue,
    this.dtIqamaExpiry,
    this.dtEidExpiryDate,
    this.dtPassportExpiryDate,
    this.dtOthersExpiry,
    this.nationality,
    this.resubmissionComments,
    this.havePhoto,
    this.haveIqama,
    this.haveEid,
    this.havePassport,
    this.haveOthers,
    this.haveVehicleRegistration,
    this.nVisitCreatedFrom,
    this.nVisitUpdatedFrom,
    this.nPlateLetter1,
    this.nPlateLetter2,
    this.nPlateLetter3,
    this.nPlateSource,
    this.sPlateNumber,
  });

  factory AddAppointmentRequest.fromJson(Map<String, dynamic> json) => AddAppointmentRequest(
    gender: json["Gender"] ?? "",
    nVisitType: json["N_VisitType"] ?? 0,
    nVisaType: json["N_VisaType"] ?? 0,
    sVehicleNo: json["S_VehicleNo"] ?? "",
    devices:
        json["Devices"] == null
            ? []
            : List<DeviceModel>.from(json["Devices"].where((x) => x != null).map((x) => DeviceModel.fromJson(x))),
    nLocationId: json["N_LocationID"] ?? 0,
    nDepartmentId: json["N_DepartmentID"] ?? 0,
    nSectionId: json["N_SectionID"] ?? 0,
    sVisitingPersonEmail: json["S_VisitingPersonEmail"] ?? "",
    sAppointmentTitle: json["S_AppointmentTitle"] ?? "",
    dtAppointmentStartTime:
        json["Dt_AppointmentStartTime"] == null ? DateTime.now() : DateTime.parse(json["Dt_AppointmentStartTime"]),
    dtAppointmentEndTime:
        json["Dt_AppointmentEndTime"] == null ? DateTime.now() : DateTime.parse(json["Dt_AppointmentEndTime"]),
    dtCovidDate: json["Dt_CovidDate"] ?? "",
    nHostId: json["N_HostID"] ?? 0,
    sHostComments: json["S_HostComments"] ?? "",
    nApprovedHost: json["N_Approved_Host"] ?? 0,
    nApprovedSecurity: json["N_Approved_Security"] ?? 0,
    approvalStatus: json["ApprovalStatus"] ?? 50,
    purpose: json["Purpose"] ?? 0,
    purposeOtherValue: json["PurposeOtherValue"] ?? "",
    remarks: json["Remarks"] ?? "",
    checkinMaterial: json["CheckinMaterial"] ?? "",
    sGroupKey: json["S_GroupKey"] ?? "",
    isCheckedIn: json["Is_CheckedIN"] ?? 0,
    sCovidFile: json["S_CovidFile"] ?? "",
    sCovidContentType: json["S_CovidContentType"] ?? "",
    sVisaFile: json["S_VisaFile"] ?? "",
    sVisaContentType: json["S_VisaContentType"] ?? "",
    sServiceProviderFile: json["S_ServiceProviderFile"] ?? "",
    sSpContentType: json["S_SPContentType"] ?? "",
    userId: json["user_id"] ?? 0,
    nExternalRegistrationId: json["N_ExternalRegistrationID"] ?? 0,
    nAppointmentId: json["N_AppointmentID"] ?? 0,
    nIsExternalAppointment: json["N_IsExternalAppointment"] ?? 1,
    nCreatedByStaff: json["N_CreatedBy_Staff"] ?? 0,
    nUpdatedByStaff: json["N_UpdatedBy_Staff"] ?? 0,
    nCreatedByExternal: json["N_CreatedBy_External"] ?? 0,
    nUpdatedByExternal: json["N_UpdatedBy_External"] ?? 0,
    dtUpdatedDateExternal: json["Dt_UpdatedDate_External"] ?? "",
    icaEidPhoto: json["ICA_EIDPhoto"] ?? "",
    icaStatus: json["ICA_Status"] ?? "",
    dtLatestTestDate: json["Dt_LatestTestDate"] ?? "",
    sLatestTestResult: json["S_LatestTestResult"] ?? "",
    sVaccineStatus: json["S_VaccineStatus"] ?? "",
    nCurrentStage: json["N_CurrentStage"] ?? 0,
    sApprovalNumber: json["S_ApprovalNumber"] ?? "",
    nSelfPass: json["N_SelfPass"] ?? 0,
    hostName: json["HostName"] ?? "",
    nProcessId: json["N_ProcessID"] ?? 1,
    tblApprovals: json["tblApprovals"] == null ? [] : List<dynamic>.from(json["tblApprovals"]!.map((x) => x)),
    nVehiclePass: json["N_VehiclePass"] ?? 0,
    tblVehicleDetails:
        json["tblVehicleDetails"] == null ? [] : List<dynamic>.from(json["tblVehicleDetails"]!.map((x) => x)),
    nArrivingByTaxi: json["N_ArrivingByTaxi"] ?? true,
    sDriverLicenseFile: json["S_DriverLicenseFile"] ?? "",
    sDriverLicenseContentType: json["S_DriverLicenseContentType"] ?? "",
    sDeliveryNoteFile: json["S_DeliveryNoteFile"] ?? "",
    sDeliveryNoteContentType: json["S_DeliveryNoteContentType"] ?? "",
    sApprovalReferenceNumber: json["S_ApprovalReferenceNumber"] ?? "",
    lastAppointmentId: json["LastAppointmentId"],
    fullName: json["FullName"],
    sponsor: json["Sponsor"],
    mobileNo: json["MobileNo"],
    email: json["Email"],
    idType: json["IDType"],
    sIqama: json["S_Iqama"],
    eidNumber: json["EIDNumber"],
    passportNumber: json["PassportNumber"],
    sOthersDoc: json["S_OthersDoc"],
    sOthersValue: json["S_OthersValue"],
    dtIqamaExpiry: json["Dt_IqamaExpiry"],
    dtEidExpiryDate: json["Dt_EIDExpiryDate"],
    dtPassportExpiryDate: json["Dt_PassportExpiryDate"],
    dtOthersExpiry: json["Dt_OthersExpiry"],
    nationality: json["Nationality"],
    resubmissionComments: json["ReSubmissionComment"],
    havePhoto: json["havePhoto"],
    haveIqama: json["haveIqama"],
    haveEid: json["haveEid"],
    havePassport: json["havePassport"],
    haveOthers: json["haveOthers"],
    haveVehicleRegistration: json["haveVehicleRegistration"],
    nVisitCreatedFrom: json["N_VisitCreatedFrom"],
    nVisitUpdatedFrom: json["N_VisitUpdatedFrom"],
    nPlateLetter1: json['N_PlateLetter1'],
    nPlateLetter2: json['N_PlateLetter2'],
    nPlateLetter3: json['N_PlateLetter3'],
    nPlateSource: json['N_PlateSource'],
    sPlateNumber: json['S_PlateNumber'],
  );

  Map<String, dynamic> toJson() => {
    "Gender": gender,
    "N_VisitType": nVisitType,
    "N_VisaType": nVisaType,
    "S_VehicleNo": sVehicleNo,
    "Devices": devices == null ? [] : List<dynamic>.from(devices!.map((x) => x.toJson())),
    "N_LocationID": nLocationId,
    "N_DepartmentID": nDepartmentId,
    "N_SectionID": nSectionId,
    "S_VisitingPersonEmail": sVisitingPersonEmail,
    "S_AppointmentTitle": sAppointmentTitle,
    "Dt_AppointmentStartTime": dtAppointmentStartTime?.toIso8601String(),
    "Dt_AppointmentEndTime": dtAppointmentEndTime?.toIso8601String(),
    "Dt_CovidDate": dtCovidDate,
    "N_HostID": nHostId,
    "S_HostComments": sHostComments,
    "N_Approved_Host": nApprovedHost,
    "N_Approved_Security": nApprovedSecurity,
    "ApprovalStatus": approvalStatus,
    "Purpose": purpose,
    "PurposeOtherValue": purposeOtherValue,
    "Remarks": remarks,
    "CheckinMaterial": checkinMaterial,
    "S_GroupKey": sGroupKey,
    "Is_CheckedIN": isCheckedIn,
    "S_CovidFile": sCovidFile,
    "S_CovidContentType": sCovidContentType,
    "S_VisaFile": sVisaFile,
    "S_VisaContentType": sVisaContentType,
    "S_ServiceProviderFile": sServiceProviderFile,
    "S_SPContentType": sSpContentType,
    "user_id": userId,
    "N_ExternalRegistrationID": nExternalRegistrationId,
    "N_AppointmentID": nAppointmentId,
    "N_IsExternalAppointment": nIsExternalAppointment,
    "N_CreatedBy_Staff": nCreatedByStaff,
    "N_UpdatedBy_Staff": nUpdatedByStaff,
    "N_CreatedBy_External": nCreatedByExternal,
    "N_UpdatedBy_External": nUpdatedByExternal,
    "Dt_UpdatedDate_External": dtUpdatedDateExternal,
    "ICA_EIDPhoto": icaEidPhoto,
    "ICA_Status": icaStatus,
    "Dt_LatestTestDate": dtLatestTestDate,
    "S_LatestTestResult": sLatestTestResult,
    "S_VaccineStatus": sVaccineStatus,
    "N_CurrentStage": nCurrentStage,
    "S_ApprovalNumber": sApprovalNumber,
    "N_SelfPass": nSelfPass,
    "HostName": hostName,
    "N_ProcessID": nProcessId,
    "tblApprovals": List<dynamic>.from(tblApprovals.map((x) => x)),
    "N_VehiclePass": nVehiclePass,
    "tblVehicleDetails": List<dynamic>.from(tblVehicleDetails.map((x) => x)),
    "N_ArrivingByTaxi": nArrivingByTaxi,
    "S_DriverLicenseFile": sDriverLicenseFile,
    "S_DriverLicenseContentType": sDriverLicenseContentType,
    "S_DeliveryNoteFile": sDeliveryNoteFile,
    "S_DeliveryNoteContentType": sDeliveryNoteContentType,
    "S_ApprovalReferenceNumber": sApprovalReferenceNumber,
    "LastAppointmentId": lastAppointmentId,
    "FullName": fullName,
    "Sponsor": sponsor,
    "MobileNo": mobileNo,
    "Email": email,
    "IDType": idType,
    "S_Iqama": sIqama,
    "EIDNumber": eidNumber,
    "PassportNumber": passportNumber,
    "S_OthersDoc": sOthersDoc,
    "S_OthersValue": sOthersValue,
    "Dt_IqamaExpiry": dtIqamaExpiry,
    "Dt_EIDExpiryDate": dtEidExpiryDate,
    "Dt_PassportExpiryDate": dtPassportExpiryDate,
    "Dt_OthersExpiry": dtOthersExpiry,
    "Nationality": nationality,
    "ReSubmissionComment": resubmissionComments,
    "havePhoto": havePhoto,
    "haveIqama": haveIqama,
    "haveEid": haveEid,
    "havePassport": havePassport,
    "haveOthers": haveOthers,
    "haveVehicleRegistration": haveVehicleRegistration,
    "N_VisitCreatedFrom": nVisitCreatedFrom,
    "N_VisitUpdatedFrom": nVisitUpdatedFrom,
    'N_PlateLetter1': nPlateLetter1,
    'N_PlateLetter2': nPlateLetter2,
    'N_PlateLetter3': nPlateLetter3,
    'N_PlateSource': nPlateSource,
    'S_PlateNumber': sPlateNumber,
  };
}

class DeviceModel {
  int? appointmentDeviceId;
  int? deviceType;
  String? deviceTypeString;
  String? deviceTypeOthersValue;
  String? deviceModel;
  String? serialNumber;
  int? devicePurpose;
  String? devicePurposeString;
  String? devicePurposeOthersValue;
  int? approvalStatus;

  DeviceModel({
    this.appointmentDeviceId = 0,
    this.deviceType,
    this.deviceTypeOthersValue = "",
    this.deviceModel = "",
    this.serialNumber = "",
    this.devicePurpose,
    this.devicePurposeString = "",
    this.deviceTypeString = "",
    this.devicePurposeOthersValue = "",
    this.approvalStatus = 50, // STATUS_IDS.PENDING from reference
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) => DeviceModel(
    appointmentDeviceId: json["appointmentDeviceId"] ?? 0,
    deviceType: json["DeviceType"] ?? 0,
    deviceTypeOthersValue: json["DeviceTypeOthersValue"] ?? "",
    deviceModel: json["DeviceModel"] ?? "",
    serialNumber: json["SerialNumber"] ?? "",
    devicePurposeString: json["DevicePurposeString"] ?? "",
    deviceTypeString: json["DeviceTypeString"] ?? "",
    devicePurpose: json["DevicePurpose"] ?? 0,
    devicePurposeOthersValue: json["DevicePurposeOthersValue"] ?? "",
    approvalStatus: json["ApprovalStatus"] ?? 50,
  );

  Map<String, dynamic> toJson() => {
    "appointmentDeviceId": appointmentDeviceId,
    "DeviceType": deviceType,
    "DeviceTypeOthersValue": deviceTypeOthersValue,
    "DeviceModel": deviceModel,
    "SerialNumber": serialNumber,
    "DevicePurposeString": devicePurposeString,
    "DeviceTypeString": deviceTypeString,
    "DevicePurpose": devicePurpose,
    "DevicePurposeOthersValue": devicePurposeOthersValue,
    "ApprovalStatus": approvalStatus,
  };
}
