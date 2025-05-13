import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/core/model/error/error_response.dart';
import 'package:mofa/core/model/login/login_request.dart';
import 'package:mofa/core/model/login/login_response.dart';
import 'package:mofa/core/model/register/register_request.dart';
import 'package:mofa/core/model/register/register_response.dart';
import 'package:mofa/core/remote/network/app_url.dart';
import 'package:mofa/core/remote/network/base_repository.dart';
import 'package:mofa/core/remote/network/method.dart';
import 'package:mofa/utils/common/app_routes.dart';
import 'package:mofa/utils/common/secure_storage.dart';
import 'package:mofa/utils/common/widgets/common_popup.dart';

class AuthRepository extends BaseRepository {
  AuthRepository._internal();

  static final AuthRepository _singleInstance = AuthRepository._internal();

  factory AuthRepository() => _singleInstance;

  ErrorResponse _errorResponseMessage = ErrorResponse();

  ErrorResponse get errorResponseMessage => _errorResponseMessage;

  set errorResponseMessage(ErrorResponse value) {
    if (value == _errorResponseMessage) return;
    _errorResponseMessage = value;
    notifyListeners();
  }

  //api: Logins
  Future<Object?> apiUserLogin(LoginRequest requestParams, BuildContext context) async {

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathLogin,
      body: jsonEncode(requestParams.toJson()),
      headers: headerContentTypeAndAccept,
    );

    if (response?.statusCode == HttpStatus.ok) {
      LoginResponse loginResponse =
      loginResponseFromJson(jsonEncode(response?.data));

      await SecureStorageHelper.setToken(loginResponse.result?.token ?? "");
      await SecureStorageHelper.setUser(jsonEncode(loginResponse.result?.user) ?? "");

      return "Success"; //Success message
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
    return null;
  }


  //api: Country List
  Future<Object?> apiCountryList(Map requestParams, BuildContext context) async {

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathCountryList,
      body: jsonEncode(requestParams),
      headers: headerContentTypeAndAccept,
    );

    if (response?.statusCode == HttpStatus.ok) {
      CountryResponse countryResponse =
      countryResponseFromJson(jsonEncode(response?.data));

      return countryResponse.result;
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
  }

  //api: Registration
  Future<Object?> apiRegistration(RegisterRequest requestParams, BuildContext context) async {

    // final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathRegister,
      body: jsonEncode(requestParams),
      headers: headerContentTypeAndAccept,
    );

    if (response?.statusCode == HttpStatus.ok) {
      RegisterResponse registerResponse =
      registerResponseFromJson(jsonEncode(response?.data));

      registerSuccessPopup(context, "Registered Successfully",
          "An account activation link has been sent to your email address. Please check your inbox and follow the instructions to activate your account.");
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
    return null;
  }
}
