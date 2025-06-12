import 'dart:convert';

LoginTokenResponse loginTokenResponseFromJson(String str) => LoginTokenResponse.fromJson(json.decode(str));

String loginTokenResponseToJson(LoginTokenResponse data) => json.encode(data.toJson());

class LoginTokenResponse {
  TokenResult? result;
  int? statusCode;
  String? message;
  bool? status;

  LoginTokenResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory LoginTokenResponse.fromJson(Map<String, dynamic> json) => LoginTokenResponse(
    result: json["result"] == null ? null : TokenResult.fromJson(json["result"]),
    statusCode: json["statusCode"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
    "statusCode": statusCode,
    "message": message,
    "status": status,
  };
}

class TokenResult {
  String? token;

  TokenResult({
    this.token,
  });

  factory TokenResult.fromJson(Map<String, dynamic> json) => TokenResult(
    token: json["token"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
  };
}


LoginTokenFailureResponse loginTokenFailureResponseFromJson(String str) => LoginTokenFailureResponse.fromJson(json.decode(str));

String loginTokenFailureResponseToJson(LoginTokenFailureResponse data) => json.encode(data.toJson());

class LoginTokenFailureResponse {
  LoginFailureResult? result;
  int? statusCode;
  String? message;
  bool? status;

  LoginTokenFailureResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory LoginTokenFailureResponse.fromJson(Map<String, dynamic> json) => LoginTokenFailureResponse(
    result: json["result"] == null ? null : LoginFailureResult.fromJson(json["result"]),
    statusCode: json["statusCode"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
    "statusCode": statusCode,
    "message": message,
    "status": status,
  };
}

class LoginFailureResult {
  int? remainingFailedLoginAttempts;
  dynamic accountLockoutEndTime;
  int? accountLockoutStatus;

  LoginFailureResult({
    this.remainingFailedLoginAttempts,
    this.accountLockoutEndTime,
    this.accountLockoutStatus,
  });

  factory LoginFailureResult.fromJson(Map<String, dynamic> json) => LoginFailureResult(
    remainingFailedLoginAttempts: json["remainingFailedLoginAttempts"],
    accountLockoutEndTime: json["accountLockoutEndTime"],
    accountLockoutStatus: json["accountLockoutStatus"],
  );

  Map<String, dynamic> toJson() => {
    "remainingFailedLoginAttempts": remainingFailedLoginAttempts,
    "accountLockoutEndTime": accountLockoutEndTime,
    "accountLockoutStatus": accountLockoutStatus,
  };
}

CaptchaLoginOtpResponse captchaLoginOtpResponseFromJson(String str) => CaptchaLoginOtpResponse.fromJson(json.decode(str));

String captchaLoginOtpResponseToJson(CaptchaLoginOtpResponse data) => json.encode(data.toJson());

class CaptchaLoginOtpResponse {
  LoginOTPResult? result;
  int? statusCode;
  String? message;
  bool? status;

  CaptchaLoginOtpResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory CaptchaLoginOtpResponse.fromJson(Map<String, dynamic> json) => CaptchaLoginOtpResponse(
    result: json["result"] == null ? null : LoginOTPResult.fromJson(json["result"]),
    statusCode: json["statusCode"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
    "statusCode": statusCode,
    "message": message,
    "status": status,
  };
}

class LoginOTPResult {
  int? accountLockoutStatus;

  LoginOTPResult({
    this.accountLockoutStatus,
  });

  factory LoginOTPResult.fromJson(Map<String, dynamic> json) => LoginOTPResult(
    accountLockoutStatus: json["accountLockoutStatus"],
  );

  Map<String, dynamic> toJson() => {
    "accountLockoutStatus": accountLockoutStatus,
  };
}

CaptchaFailureResponse captchaFailureResponseFromJson(String str) => CaptchaFailureResponse.fromJson(json.decode(str));

String captchaFailureResponseToJson(CaptchaFailureResponse data) => json.encode(data.toJson());

class CaptchaFailureResponse {
  CaptchaFailureResult? result;
  int? statusCode;
  String? message;
  bool? status;

  CaptchaFailureResponse({
    this.result,
    this.statusCode,
    this.message,
    this.status,
  });

  factory CaptchaFailureResponse.fromJson(Map<String, dynamic> json) => CaptchaFailureResponse(
    result: json["result"] == null ? null : CaptchaFailureResult.fromJson(json["result"]),
    statusCode: json["statusCode"],
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "result": result?.toJson(),
    "statusCode": statusCode,
    "message": message,
    "status": status,
  };
}

class CaptchaFailureResult {
  bool? isCaptchaValid;

  CaptchaFailureResult({
    this.isCaptchaValid,
  });

  factory CaptchaFailureResult.fromJson(Map<String, dynamic> json) => CaptchaFailureResult(
    isCaptchaValid: json["isCaptchaValid"],
  );

  Map<String, dynamic> toJson() => {
    "isCaptchaValid": isCaptchaValid,
  };
}
