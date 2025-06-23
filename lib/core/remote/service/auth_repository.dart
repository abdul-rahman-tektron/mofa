import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/captcha/captcha_login_response.dart';
import 'package:mofa/core/model/captcha/get_captcha_response.dart';
import 'package:mofa/core/model/captcha/resend_otp_request.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/core/model/error/error_response.dart';
import 'package:mofa/core/model/forget_password/forget_password_request.dart';
import 'package:mofa/core/model/forget_password/forget_password_response.dart';
import 'package:mofa/core/model/get_profile/get_profile_response.dart';
import 'package:mofa/core/model/captcha/captcha_login_request.dart';
import 'package:mofa/core/model/login/login_request.dart';
import 'package:mofa/core/model/login/login_response.dart';
import 'package:mofa/core/model/register/register_request.dart';
import 'package:mofa/core/model/register/register_response.dart';
import 'package:mofa/core/model/update_password/update_password_request.dart';
import 'package:mofa/core/model/update_profile/update_profile_request.dart';
import 'package:mofa/core/model/update_profile/update_profile_response.dart';
import 'package:mofa/core/notifier/common_notifier.dart';
import 'package:mofa/core/remote/network/app_url.dart';
import 'package:mofa/core/remote/network/base_repository.dart';
import 'package:mofa/core/remote/network/method.dart';
import 'package:mofa/model/token_user_response.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/encrypt.dart';
import 'package:mofa/utils/error_handler.dart';
import 'package:mofa/utils/secure_storage.dart';
import 'package:mofa/utils/toast_helper.dart';
import 'package:mofa/utils/common/widgets/common_popup.dart';
import 'package:provider/provider.dart';

class AuthRepository extends BaseRepository with CommonFunctions {
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


      await SecureStorageHelper.setUser(loginTokenUserResponseToJson(
          LoginTokenUserResponse.fromJson(decodeJwtPayload(loginTokenResponse.result?.token ?? ""))));

      // Update CommonNotifier
      final commonNotifier = Provider.of<CommonNotifier>(context, listen: false);
      commonNotifier.updateUser(
          LoginTokenUserResponse.fromJson(decodeJwtPayload(loginTokenResponse.result?.token ?? "")));

      return "Success"; //Success message
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
    return null;
  }

  String urlEncodedBody(Map<String, dynamic> data) {
    return data.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }

  //api: Logins
  Future<Object?> apiUserCaptchaLogin(CaptchaLoginRequest requestParams, BuildContext context) async {

    // Convert to x-www-form-urlencoded
    final encodedBody = requestParams.toJson().entries.map((e) {
      return '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent('${e.value}')}' ;
    }).join('&');

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathCaptchaLogin,
      body: encodedBody,
      headers: headerUrlEncodedWithCredentials,
    );

    if (response?.statusCode == HttpStatus.ok) {
      final result = response?.data['result'];
      if (result.containsKey('token')) {
        // Token login
        LoginTokenResponse loginTokenResponse = loginTokenResponseFromJson(jsonEncode(response?.data));
        await SecureStorageHelper.setToken(loginTokenResponse.result?.token ?? "");

        await SecureStorageHelper.setUser(
          loginTokenUserResponseToJson(
            LoginTokenUserResponse.fromJson(decodeJwtPayload(loginTokenResponse.result?.token ?? "")),
          ),
        );

        final commonNotifier = Provider.of<CommonNotifier>(context, listen: false);
        commonNotifier.updateUser(
          LoginTokenUserResponse.fromJson(decodeJwtPayload(loginTokenResponse.result?.token ?? "")),
        );

        return loginTokenResponse.result;
      } else if (result.containsKey('accountLockoutStatus')) {
        // OTP login required
        CaptchaLoginOtpResponse otpResponse = captchaLoginOtpResponseFromJson(jsonEncode(response?.data));
        return otpResponse.result;
      }
    } else if(response?.statusCode == HttpStatus.unauthorized) {
      LoginTokenFailureResponse loginTokenFailureResponse = loginTokenFailureResponseFromJson(jsonEncode(response?.data));

      return loginTokenFailureResponse.result;
    } else if(response?.statusCode == HttpStatus.badRequest) {
      CaptchaFailureResponse captchaFailureResponse = captchaFailureResponseFromJson(jsonEncode(response?.data));

      return captchaFailureResponse.result;
    } else{
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
    return null;
  }

  //api: Logins
  Future<Object?> apiGetCaptcha(Map requestParams, BuildContext context) async {

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathGetCaptcha,
      body: jsonEncode(requestParams),
      headers: headerContentTypeAndAcceptWithCredentials,
    );

    if (response?.statusCode == HttpStatus.ok) {
      GetCaptchaResponse getCaptchaResponse =
      getCaptchaResponseFromJson(jsonEncode(response?.data));


      return getCaptchaResponse; //Success message
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
          "An account activation link has been sent to your email address.\nPlease check your inbox and follow the instructions to activate your account.");
    } if (response?.statusCode == HttpStatus.badRequest) {

      RegisterResponse registerResponse =
      registerResponseFromJson(jsonEncode(response?.data));

      ToastHelper.showError(registerResponse.message ?? "");
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
    return null;
  }

  //api: Registration
  Future<Object?> apiResendOtp(ResendOtpRequest requestParams, BuildContext context) async {

    // final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathResendOTP,
      body: jsonEncode(requestParams),
      headers: headerContentTypeAndAccept,
    );

    if (response?.statusCode == HttpStatus.ok) {
      CaptchaLoginOtpResponse captchaLoginOtpResponse =
      captchaLoginOtpResponseFromJson(jsonEncode(response?.data));

      ToastHelper.showSuccess(context.readLang.translate(AppLanguageText.otpResentSuccessfully) ?? "");
    } else {
      ErrorResponse errorString = ErrorResponse.fromJson(response?.data ?? "");
      return errorString.title;
    }
    return null;
  }

  //api: Validate OTP
  Future<Object?> apiValidateOtp(ValidateOtpRequest requestParams, BuildContext context) async {

    // final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathValidateOTP,
      body: jsonEncode(requestParams),
      headers: headerContentTypeAndAccept,
    );

    if (response?.statusCode == HttpStatus.ok) {
      LoginTokenResponse loginTokenResponse =
      loginTokenResponseFromJson(jsonEncode(response?.data));

      await SecureStorageHelper.setToken(loginTokenResponse.result?.token ?? "");

      await SecureStorageHelper.setUser(
        loginTokenUserResponseToJson(
          LoginTokenUserResponse.fromJson(decodeJwtPayload(loginTokenResponse.result?.token ?? "")),
        ),
      );

      final commonNotifier = Provider.of<CommonNotifier>(context, listen: false);
      commonNotifier.updateUser(
        LoginTokenUserResponse.fromJson(decodeJwtPayload(loginTokenResponse.result?.token ?? "")),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.bottomBar);
    } else if (response?.statusCode == HttpStatus.badRequest) {
      ValidateOtpFailureRequest validateOtpFailureRequest =
      validateOtpFailureRequestFromJson(jsonEncode(response?.data));
      if(validateOtpFailureRequest.result?.isOtpExpired ?? false) {
        ToastHelper.showError(context.readLang.translate(AppLanguageText.invalidExpiredOtpTryAgain) ?? "");
      }
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
        commonPopup(context, LucideIcons.checkCircle2, context.readLang.translate(AppLanguageText.passwordResetRequested),
            "A password reset link has been sent to your email address.\nPlease check your inbox and follow the instructions to reset your password.");
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


      if (updateProfileResponse.statusCode == HttpStatus.ok) {
        ToastHelper.showSuccess(
          context.readLang.translate(AppLanguageText.profileUpdated) ?? "",
        );

        // Step 1: Convert update result to LoginTokenUserResponse
        final updatedUser = mapUpdateProfileToLoginTokenUser(updateProfileResponse.result);

        // Step 2: Save to secure storage
        await SecureStorageHelper.setUser(loginTokenUserResponseToJson(updatedUser));

        // Step 3: Update the notifier with updated user data
        final commonNotifier = Provider.of<CommonNotifier>(context, listen: false);
        commonNotifier.updateUser(updatedUser);
      }
    } else {
      ForgetPasswordResponse forgetPasswordResponse =
      forgetPasswordResponseFromJson(jsonEncode(response?.data));

      ToastHelper.showError(forgetPasswordResponse.message ?? "");
    }
    return null;
  }

  LoginTokenUserResponse mapUpdateProfileToLoginTokenUser(UpdateProfileResult? result) {
    return LoginTokenUserResponse(
      fullName: result?.sFullName ?? "",
      email: result?.sEmail ?? "",
      username: result?.sUserName ?? "",
      // All other fields will remain `null`
    );
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

  //api: Delete Account
  Future<Object?> apiDeleteAccount(ForgetPasswordRequest requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathDeleteAccount,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    if (response?.statusCode == HttpStatus.ok) {
      ForgetPasswordResponse deleteAccountResponse =
      forgetPasswordResponseFromJson(jsonEncode(response?.data));

      if (deleteAccountResponse.statusCode == HttpStatus.ok) {
        try {
          await SecureStorageHelper.clearExceptRememberMe();
        } catch (e, stack) {
          await ErrorHandler.recordError(e, stack, context: {
            'widget': 'Delete Account',
            'action': 'clearExceptRememberMe',
            'message': e.toString(),
          });
          print("SecureStorage deletion error: $e");
          // Optional: show a message to user if needed
        }

        Provider.of<CommonNotifier>(context, listen: false).clearUser();

        ToastHelper.showSuccess(
          context.readLang.translate(AppLanguageText.accountDeleted) ?? "",
        );

        Navigator.pushNamedAndRemoveUntil(
          context,
          AppRoutes.login,
              (Route<dynamic> route) => false,
        );
      }

      return deleteAccountResponse.result;
    }
    return null;
  }

  //api: Update Password
  Future<Object?> apiUpdatePassword(UpdatePasswordRequest requestParams, BuildContext context) async {

    final token = await SecureStorageHelper.getToken();

    Response? response = await networkProvider.call(
      method: Method.POST,
      pathUrl: AppUrl.pathUpdatePassword,
      body: jsonEncode(requestParams),
      headers: buildDefaultHeaderWithToken(token ?? ""),
    );

    ForgetPasswordResponse deleteAccountResponse =
    forgetPasswordResponseFromJson(jsonEncode(response?.data));

    if (response?.statusCode == HttpStatus.ok) {

      if(deleteAccountResponse.statusCode == HttpStatus.ok){
        ToastHelper.showSuccess(context.readLang.translate(AppLanguageText.passwordUpdated) ?? "");
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.bottomBar, (Route<dynamic> route) => false);
      }

      return deleteAccountResponse.result;
    } else {
      if(deleteAccountResponse.statusCode == HttpStatus.notFound){
        ToastHelper.showError(context.readLang.translate(AppLanguageText.incorrectCurrentPassword) ?? "");
      } else {
        ToastHelper.showError(deleteAccountResponse.message ?? "");
      }
    }
    return null;
  }
}
