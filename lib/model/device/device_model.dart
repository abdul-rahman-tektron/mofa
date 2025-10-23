
class DeviceDetailModel {
  final String type;
  final String model;
  final String serialNumber;
  final String purpose;

  DeviceDetailModel({
    required this.type,
    required this.model,
    required this.serialNumber,
    required this.purpose,
  });
}

class VisitorDetailModel {
  final String visitorName;
  final String companyName;
  final String mobileNumber;
  final String email;
  final String nationality;
  final String nationalityId;
  final String idType;
  final String documentId;
  final String documentTypeValue;
  final String expiryDate;
  final String dateOfBirth;
  final int? lastAppointmentId;
  final String? uploadedPhoto;
  final String? uploadedDocumentId;
  final String? uploadedVehicleRegistration;

  VisitorDetailModel({
    required this.visitorName,
    required this.companyName,
    required this.mobileNumber,
    required this.email,
    required this.nationality,
    required this.nationalityId,
    required this.idType,
    required this.documentTypeValue,
    required this.documentId,
    this.lastAppointmentId = 0,
    required this.expiryDate,
    required this.dateOfBirth,
    required this.uploadedPhoto,
    required this.uploadedDocumentId,
    required this.uploadedVehicleRegistration,
  });
}