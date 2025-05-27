// To parse this JSON data, do
//
//     final loginTokenUserResponse = loginTokenUserResponseFromJson(jsonString);

import 'dart:convert';

LoginTokenUserResponse loginTokenUserResponseFromJson(String str) => LoginTokenUserResponse.fromJson(json.decode(str));

String loginTokenUserResponseToJson(LoginTokenUserResponse data) => json.encode(data.toJson());

class LoginTokenUserResponse {
  String? httpSchemasXmlsoapOrgWs200505IdentityClaimsSid;
  String? userId;
  String? username;
  String? email;
  String? fullName;
  String? roleId;
  String? locationId;
  String? isExternalUser;
  String? ipAddress;
  int? exp;
  String? iss;
  String? aud;

  LoginTokenUserResponse({
    this.httpSchemasXmlsoapOrgWs200505IdentityClaimsSid,
    this.userId,
    this.username,
    this.email,
    this.fullName,
    this.roleId,
    this.locationId,
    this.isExternalUser,
    this.ipAddress,
    this.exp,
    this.iss,
    this.aud,
  });

  factory LoginTokenUserResponse.fromJson(Map<String, dynamic> json) => LoginTokenUserResponse(
    httpSchemasXmlsoapOrgWs200505IdentityClaimsSid: json["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid"],
    userId: json["UserId"],
    username: json["Username"],
    email: json["Email"],
    fullName: json["FullName"],
    roleId: json["RoleId"],
    locationId: json["LocationID"],
    isExternalUser: json["IsExternalUser"],
    ipAddress: json["IpAddress"],
    exp: json["exp"],
    iss: json["iss"],
    aud: json["aud"],
  );

  Map<String, dynamic> toJson() => {
    "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/sid": httpSchemasXmlsoapOrgWs200505IdentityClaimsSid,
    "UserId": userId,
    "Username": username,
    "Email": email,
    "FullName": fullName,
    "RoleId": roleId,
    "LocationID": locationId,
    "IsExternalUser": isExternalUser,
    "IpAddress": ipAddress,
    "exp": exp,
    "iss": iss,
    "aud": aud,
  };
}
