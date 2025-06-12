
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
  final String idType;
  final String documentId;
  final String expiryDate;
  final String vehicleNumber;
  final String? uploadedPhoto;
  final String? uploadedDocumentId;
  final String? uploadedVehicleRegistration;

  VisitorDetailModel({
    required this.visitorName,
    required this.companyName,
    required this.mobileNumber,
    required this.email,
    required this.nationality,
    required this.idType,
    required this.documentId,
    required this.expiryDate,
    required this.vehicleNumber,
    required this.uploadedPhoto,
    required this.uploadedDocumentId,
    required this.uploadedVehicleRegistration,
  });
}