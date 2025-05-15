import 'dart:convert';

ForgetPasswordRequest forgetPasswordRequestFromJson(String str) => ForgetPasswordRequest.fromJson(json.decode(str));

String forgetPasswordRequestToJson(ForgetPasswordRequest data) => json.encode(data.toJson());

class ForgetPasswordRequest {
  String? sEmail;

  ForgetPasswordRequest({
    this.sEmail,
  });

  factory ForgetPasswordRequest.fromJson(Map<String, dynamic> json) => ForgetPasswordRequest(
    sEmail: json["S_Email"],
  );

  Map<String, dynamic> toJson() => {
    "S_Email": sEmail,
  };
}
