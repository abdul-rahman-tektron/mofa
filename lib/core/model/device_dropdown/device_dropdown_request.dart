// To parse this JSON data, do
//
//     final deviceDropdownRequest = deviceDropdownRequestFromJson(jsonString);

import 'dart:convert';

DeviceDropdownRequest deviceDropdownRequestFromJson(String str) => DeviceDropdownRequest.fromJson(json.decode(str));

String deviceDropdownRequestToJson(DeviceDropdownRequest data) => json.encode(data.toJson());

class DeviceDropdownRequest {
  String? encryptedId;

  DeviceDropdownRequest({
    this.encryptedId,
  });

  factory DeviceDropdownRequest.fromJson(Map<String, dynamic> json) => DeviceDropdownRequest(
    encryptedId: json["encryptedId"],
  );

  Map<String, dynamic> toJson() => {
    "encryptedId": encryptedId,
  };
}
