import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/core/model/error/error_response.dart';
import 'package:mofa/core/model/forget_password/forget_password_request.dart';
import 'package:mofa/core/model/forget_password/forget_password_response.dart';
import 'package:mofa/core/model/get_profile/get_profile_response.dart';
import 'package:mofa/core/model/login/login_request.dart';
import 'package:mofa/core/model/login/login_response.dart';
import 'package:mofa/core/model/register/register_request.dart';
import 'package:mofa/core/model/register/register_response.dart';
import 'package:mofa/core/model/update_profile/update_profile_request.dart';
import 'package:mofa/core/model/update_profile/update_profile_response.dart';
import 'package:mofa/core/notifier/common_notifier.dart';
import 'package:mofa/core/remote/network/app_url.dart';
import 'package:mofa/core/remote/network/base_repository.dart';
import 'package:mofa/core/remote/network/method.dart';
import 'package:mofa/model/token_user_response.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/utils/common/app_routes.dart';
import 'package:mofa/utils/common/encrypt.dart';
import 'package:mofa/utils/common/secure_storage.dart';
import 'package:mofa/utils/common/toast_helper.dart';
import 'package:mofa/utils/common/widgets/common_popup.dart';
import 'package:provider/provider.dart';

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
  Future<Object?> apiUserLogin(LoginTokenRequest requestParams, BuildContext context) async {

    Response? response = await networkProvider.call(
      method: Method.POST,
      // pathUrl: AppUrl.pathLogin,
      pathUrl: AppUrl.pathToken,
      body: jsonEncode(requestParams.toJson()),
      headers: headerContentTypeAndAccept,
    );

    if (response?.statusCode == HttpStatus.ok) {
      LoginTokenResponse loginTokenResponse =
      loginTokenResponseFromJson(jsonEncode(response?.data));

      await SecureStorageHelper.setToken(loginTokenResponse.result?.token ?? "");


      await SecureStorageHelper.setUser(loginTokenUserResponseToJson(LoginTokenUserResponse.fromJson(decodeJwtPayload(loginTokenResponse.result?.token ?? ""))) );

      // Update CommonNotifier
      final commonNotifier = Provider.of<CommonNotifier>(context, listen: false);
      commonNotifier.updateUser(LoginTokenUserResponse.fromJson(decodeJwtPayload(loginTokenResponse.result?.token ?? "")));

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

  //api: Forget Password
  Future<Object?> apiForgetPassword(ForgetPasswordRequest requestParams, BuildContext context) async {

    // final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathForgetPassword,
      body: jsonEncode(requestParams),
      headers: headerContentTypeAndAccept,
    );

    if (response?.statusCode == HttpStatus.ok) {
      ForgetPasswordResponse forgetPasswordResponse =
      forgetPasswordResponseFromJson(jsonEncode(response?.data));

      if(forgetPasswordResponse.statusCode == HttpStatus.ok){
        Navigator.pop(context);
        commonPopup(context, LucideIcons.checkCircle2, "Password Reset Requested!",
            "A password reset link has been sent to your email address. Please check your inbox and follow the instructions to reset your password.");
      } else {
        ToastHelper.showError(forgetPasswordResponse.message ?? "");
      }
    } else {
      ForgetPasswordResponse forgetPasswordResponse =
      forgetPasswordResponseFromJson(jsonEncode(response?.data));

      ToastHelper.showError(forgetPasswordResponse.message ?? "");
    }
    return null;
  }

  //api: Update Profile
  Future<Object?> apiUpdateProfile(UpdateProfileRequest requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathUpdateProfile,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      UpdateProfileResponse updateProfileResponse =
      updateProfileResponseFromJson(jsonEncode(response?.data));

      if(updateProfileResponse.statusCode == HttpStatus.ok){
        ToastHelper.showSuccess(context.readLang.translate(AppLanguageText.profileUpdated) ?? "");
      }
    } else {
      ForgetPasswordResponse forgetPasswordResponse =
      forgetPasswordResponseFromJson(jsonEncode(response?.data));

      ToastHelper.showError(forgetPasswordResponse.message ?? "");
    }
    return null;
  }

  //api: Get Profile
  Future<Object?> apiGetProfile(Map requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathGetProfile,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      GetProfileResponse getProfileResponse =
      getProfileResponseFromJson(jsonEncode(response?.data));

      return getProfileResponse.result;
    }
    return null;
  }
}
