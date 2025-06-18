// To parse this JSON data, do
//
//     final countryResponse = countryResponseFromJson(jsonString);

import 'dart:convert';

CountryResponse countryResponseFromJson(String str) => CountryResponse.fromJson(json.decode(str));

String countryResponseToJson(CountryResponse data) => json.encode(data.toJson());

class CountryResponse {
  List<CountryData>? result;
  int? statusCode;
  String? message;
  bool? status;

  CountryResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) => CountryResponse(
    result: json["result"] == null ? [] : List<CountryData>.from(json["result"]!.map((x) => CountryData.fromJson(x))),
    statusCode: json["statusCode"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result == null ? [] : List<dynamic>.from(result!.map((x) => x.toJson())),
    "statusCode": statusCode,
    "message": message,
    "status": status,
  };
}

class CountryData {
  int? id;
  String? name;
  String? nameAr;
  String? iso3;
  String? folderflag;
  String? flag;
  int? phonecode;

  CountryData({
    this.id,
    this.name,
    this.nameAr,
    this.iso3,
    this.folderflag,
    this.flag,
    this.phonecode,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) => CountryData(
    id: json["id"],
    name: json["name"],
    nameAr: json["name_Ar"],
    iso3: json["iso3"],
    folderflag: json["folderflag"],
    flag: json["flag"],
    phonecode: json["phonecode"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "name_Ar": nameAr,
    "iso3": iso3,
    "folderflag": folderflag,
    "flag": flag,
    "phonecode": phonecode,
  };

}
