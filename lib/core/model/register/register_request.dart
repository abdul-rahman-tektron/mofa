import 'dart:convert';

RegisterRequest registerRequestFromJson(String str) =>
    RegisterRequest.fromJson(json.decode(str));

String registerRequestToJson(RegisterRequest data) =>
    json.encode(data.toJson());

class RegisterRequest {
  String? sFullName;
  String? sCompanyName;
  String? sMobileNumber;
  String? sEmail;
  String? sUserName;
  int? nDocumentType;
  String? sIqama;
  String? eidNumber;
  String? passportNumber;
  String? sOthersValue;
  String? sOthersDoc;
  String? iso3;

  RegisterRequest({
    this.sFullName,
    this.sCompanyName,
    this.sMobileNumber,
    this.sEmail,
    this.sUserName,
    this.nDocumentType,
    this.sIqama,
    this.eidNumber,
    this.passportNumber,
    this.sOthersValue,
    this.sOthersDoc,
    this.iso3,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) => RegisterRequest(
    sFullName: json["S_FullName"],
    sCompanyName: json["S_CompanyName"],
    sMobileNumber: json["S_MobileNumber"],
    sEmail: json["S_Email"],
    sUserName: json["S_UserName"],
    nDocumentType: json["N_DocumentType"],
    sIqama: json["S_Iqama"],
    eidNumber: json["EIDNumber"],
    passportNumber: json["PassportNumber"],
    sOthersValue: json["S_OthersValue"],
    sOthersDoc: json["S_OthersDoc"],
    iso3: json["iso3"],
  );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};

    void addIfNotEmpty(String key, dynamic value) {
      if (value != null && value.toString().trim().isNotEmpty) {
        data[key] = value;
      }
    }

    addIfNotEmpty("S_FullName", sFullName);
    addIfNotEmpty("S_CompanyName", sCompanyName);
    addIfNotEmpty("S_MobileNumber", sMobileNumber);
    addIfNotEmpty("S_Email", sEmail);
    addIfNotEmpty("S_UserName", sUserName);
    if (nDocumentType != null) data["N_DocumentType"] = nDocumentType;
    addIfNotEmpty("S_Iqama", sIqama);
    addIfNotEmpty("EIDNumber", eidNumber);
    addIfNotEmpty("PassportNumber", passportNumber);
    addIfNotEmpty("S_OthersValue", sOthersValue);
    addIfNotEmpty("S_OthersDoc", sOthersDoc);
    addIfNotEmpty("iso3", iso3);

    return data;
  }
}
