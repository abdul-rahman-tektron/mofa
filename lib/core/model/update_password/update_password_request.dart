// To parse this JSON data, do
//
//     final updatePasswordRequest = updatePasswordRequestFromJson(jsonString);

import 'dart:convert';

UpdatePasswordRequest updatePasswordRequestFromJson(String str) => UpdatePasswordRequest.fromJson(json.decode(str));

String updatePasswordRequestToJson(UpdatePasswordRequest data) => json.encode(data.toJson());

class UpdatePasswordRequest {
  String? sEmail;
  String? sOldPassword;
  String? sPassword;

  UpdatePasswordRequest({
    this.sEmail,
    this.sOldPassword,
    this.sPassword,
  });

  factory UpdatePasswordRequest.fromJson(Map<String, dynamic> json) => UpdatePasswordRequest(
    sEmail: json["s_Email"],
    sOldPassword: json["S_OldPassword"],
    sPassword: json["s_Password"],
  );

  Map<String, dynamic> toJson() => {
    "s_Email": sEmail,
    "S_OldPassword": sOldPassword,
    "s_Password": sPassword,
  };
}
