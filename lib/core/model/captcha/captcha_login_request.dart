import 'dart:convert';

CaptchaLoginRequest captchaLoginRequestFromJson(String str) => CaptchaLoginRequest.fromJson(json.decode(str));

String captchaLoginRequestToJson(CaptchaLoginRequest data) => json.encode(data.toJson());

class CaptchaLoginRequest {
  String? email;
  String? password;
  String? dntCaptchaText;
  String? dntCaptchaInputText;
  String? dntCaptchaToken;

  CaptchaLoginRequest({
    this.email,
    this.password,
    this.dntCaptchaText,
    this.dntCaptchaInputText,
    this.dntCaptchaToken,
  });

  factory CaptchaLoginRequest.fromJson(Map<String, dynamic> json) => CaptchaLoginRequest(
    email: json["email"],
    password: json["password"],
    dntCaptchaText: json["DNTCaptchaText"],
    dntCaptchaInputText: json["DNTCaptchaInputText"],
    dntCaptchaToken: json["DNTCaptchaToken"],
  );

  Map<String, dynamic> toJson() => {
    "email": email,
    "password": password,
    "DNTCaptchaText": dntCaptchaText,
    "DNTCaptchaInputText": dntCaptchaInputText,
    "DNTCaptchaToken": dntCaptchaToken,
  };
}
