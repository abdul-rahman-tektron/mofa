// To parse this JSON data, do
//
//     final getCaptchaResponse = getCaptchaResponseFromJson(jsonString);

import 'dart:convert';

GetCaptchaResponse getCaptchaResponseFromJson(String str) => GetCaptchaResponse.fromJson(json.decode(str));

String getCaptchaResponseToJson(GetCaptchaResponse data) => json.encode(data.toJson());

class GetCaptchaResponse {
  String? dntCaptchaImgUrl;
  String? dntCaptchaId;
  String? dntCaptchaTextValue;
  String? dntCaptchaTokenValue;

  GetCaptchaResponse({
    this.dntCaptchaImgUrl,
    this.dntCaptchaId,
    this.dntCaptchaTextValue,
    this.dntCaptchaTokenValue,
  });

  factory GetCaptchaResponse.fromJson(Map<String, dynamic> json) => GetCaptchaResponse(
    dntCaptchaImgUrl: json["dntCaptchaImgUrl"],
    dntCaptchaId: json["dntCaptchaId"],
    dntCaptchaTextValue: json["dntCaptchaTextValue"],
    dntCaptchaTokenValue: json["dntCaptchaTokenValue"],
  );

  Map<String, dynamic> toJson() => {
    "dntCaptchaImgUrl": dntCaptchaImgUrl,
    "dntCaptchaId": dntCaptchaId,
    "dntCaptchaTextValue": dntCaptchaTextValue,
    "dntCaptchaTokenValue": dntCaptchaTokenValue,
  };
}
