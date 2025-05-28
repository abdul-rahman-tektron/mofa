import 'dart:convert';

ValidatePhotoRequest validatePhotoRequestFromJson(String str) => ValidatePhotoRequest.fromJson(json.decode(str));

String validatePhotoRequestToJson(ValidatePhotoRequest data) => json.encode(data.toJson());

class ValidatePhotoRequest {
  String? fullName;
  String? photo;

  ValidatePhotoRequest({
    this.fullName,
    this.photo,
  });

  factory ValidatePhotoRequest.fromJson(Map<String, dynamic> json) => ValidatePhotoRequest(
    fullName: json["fullName"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "fullName": fullName,
    "photo": photo,
  };
}
