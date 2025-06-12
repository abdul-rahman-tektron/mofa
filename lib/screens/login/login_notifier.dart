import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/base/loading_state.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/captcha/captcha_login_response.dart';
import 'package:mofa/core/model/captcha/get_captcha_response.dart';
import 'package:mofa/core/model/captcha/captcha_login_request.dart';
import 'package:mofa/core/model/login/login_request.dart';
import 'package:mofa/core/remote/service/auth_repository.dart';
import 'package:mofa/model/captcha_data_model.dart';
import 'package:mofa/model/remember_me/remember_me_model.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/res/app_strings.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/captcha_widget.dart';
import 'package:mofa/utils/common/widgets/common_popup.dart';
import 'package:mofa/utils/common_utils.dart';
import 'package:mofa/utils/encrypt.dart';
import 'package:mofa/utils/secure_storage.dart';
import 'package:mofa/utils/toast_helper.dart';

class LoginNotifier extends BaseChangeNotifier with CommonFunctions {
  // Data Controller
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _captchaController = TextEditingController();

  String? _captchaImage;

  // bool
  bool _isChecked = false;

  // String
  String _userCaptcha = '';
  String _generatedCaptcha = '';
  String _captchaError = '';
  String _loginError = '';

  CaptchaRenderData? _renderData;

  // key
  final formKey = GlobalKey<FormState>();

  // Functions
  LoginNotifier(BuildContext context) {
    // generateCaptcha();;
    _init(context);
  }

  void _init(BuildContext context) async {
    await rememberMeData();
    await apiGetCaptcha(context);
  }

  // Load remember me data from storage
  Future<void> rememberMeData() async {
    String? data = await SecureStorageHelper.getRememberMe();
    if (data != null) {
      RememberMeModel rememberMeModel = RememberMeModel.fromJson(jsonDecode(data));
      userNameController.text = rememberMeModel.userName;
      passwordController.text = rememberMeModel.password;
      isChecked = true;
    }
  }

  // Update remember me checkbox state
  void rememberMeChecked(BuildContext context, bool? value) {
    isChecked = value!;
  }

  // Perform login action
  void performLogin(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      // String encryptedPassword = encryptAES(password);

      // final loginRequest = LoginRequest(
      //     username: email, password: encryptedPassword);

      // final loginRequest = LoginTokenRequest(
      //     email: email, password: encryptedPassword);

      runWithLoadingVoid(loginApiCall(context));
    }
  }

  // API call for login
  Future<void> loginApiCall(BuildContext context) async {
    try {
      final captchaData = await _getValidCaptchaData(context);
      if (captchaData == null) return;

      final loginRequest = _buildLoginRequest(captchaData);

      final result = await AuthRepository().apiUserCaptchaLogin(loginRequest, context);

      await _handleLoginResult(result, context);
    } catch (e) {
      debugPrint("Login error: $e");
      ToastHelper.showError("An error occurred. Please try again.");
    }
  }

  Future<CaptchaDataModel?> _getValidCaptchaData(BuildContext context) async {
    final captchaJson = await SecureStorageHelper.getCaptchaData();
    if (captchaJson == null) {
      ToastHelper.showError("Captcha data is missing.");
      return null;
    }

    final captchaData = CaptchaDataModel.fromJson(jsonDecode(captchaJson));
    if ((captchaData.captchaTokenValue?.isEmpty ?? true) ||
        (captchaData.captchaTextValue?.isEmpty ?? true)) {
      ToastHelper.showError("Invalid captcha. Please reload.");
      await apiGetCaptcha(context);
      return null;
    }

    return captchaData;
  }

  CaptchaLoginRequest _buildLoginRequest(CaptchaDataModel captchaData) {
    return CaptchaLoginRequest(
      email: userNameController.text.trim(),
      password: passwordController.text.trim(),
      dntCaptchaInputText: captchaController.text.trim(),
      dntCaptchaText: captchaData.captchaTextValue ?? '',
      dntCaptchaToken: captchaData.captchaTokenValue ?? '',
    );
  }

  Future<void> _handleLoginResult(dynamic result, BuildContext context) async {
    if (result is TokenResult) {
      await _handleRememberMe();
      Navigator.pushReplacementNamed(context, AppRoutes.bottomBar);
    } else if (result is LoginOTPResult) {
      Navigator.pushNamed(
        context,
        AppRoutes.otpVerification,
        arguments: (userNameController.text.trim(), passwordController.text.trim()),
      );
    } else if (result is CaptchaFailureResult) {
      await apiGetCaptcha(context);
      captchaController.clear();
      ToastHelper.showError("Captcha code is not valid");
    } else if (result is LoginFailureResult) {
      await _handleFailedLogin(result, context);
    } else {
      ToastHelper.showError("Incorrect Email or Password");
    }
  }

  Future<void> _handleRememberMe() async {
    if (isChecked) {
      final rememberData = RememberMeModel(
        userName: userNameController.text,
        password: passwordController.text,
      );
      await SecureStorageHelper.setRememberMe(jsonEncode(rememberData));
    } else {
      await SecureStorageHelper.removeParticularKey(AppStrings.rememberMeKey);
    }
  }

  Future<void> _handleFailedLogin(LoginFailureResult result, BuildContext context) async {
    await apiGetCaptcha(context);

    if (result.remainingFailedLoginAttempts == 0) {
      accountLockedPopup(context);
      loginError =
      "${context.readLang.translate(AppLanguageText.yourAccountWillUnlockAt)} ${CommonUtils.formatIsoToReadable(result.accountLockoutEndTime) ?? ""}";
    } else {
      passwordController.clear();
      ToastHelper.showError("Incorrect Email or Password");
      loginError =
      "${context.readLang.translate(AppLanguageText.youHave)} ${result.remainingFailedLoginAttempts ?? 0} ${context.readLang.translate(AppLanguageText.attempts)} ${context.readLang.translate(AppLanguageText.remaining)}";
    }
  }

  Future<void> apiGetCaptcha(BuildContext context) async {
    try {
      final result = await AuthRepository().apiGetCaptcha({}, context);

      if (result is GetCaptchaResponse) {
        captchaImage = result.dntCaptchaImgUrl ?? "";

        final captchaData = CaptchaDataModel(
          captchaTextValue: result.dntCaptchaTextValue ?? "",
          captchaTokenValue: result.dntCaptchaTokenValue ?? "",
        );

        await SecureStorageHelper.setCaptchaData(jsonEncode(captchaData));
      } else {
        debugPrint("Unexpected result type from apiGetCaptcha: $result");
        ToastHelper.showError("Failed to retrieve captcha. Please try again.");
      }
    } catch (e, stackTrace) {
      debugPrint("Error in apiGetCaptcha: $e");
      debugPrintStack(stackTrace: stackTrace);
      ToastHelper.showError("Failed to load captcha. Please check your connection.");
    }
  }

  // Generate CAPTCHA
  void generateCaptcha() {
    final captcha = randomDigits(6);
    final renderedData = CaptchaRenderData.generate(captcha);
    generatedCaptcha = captcha;
    renderData = renderedData;
    captchaController.clear();
  }

  // Generate random digits for CAPTCHA
  String randomDigits(int length) {
    final rand = Random();
    return List.generate(length, (_) => rand.nextInt(10)).join();
  }

  // Navigate to register screen
  void navigateToRegisterScreen(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  // Getter and Setter
  TextEditingController get userNameController => _userNameController;

  set userNameController(TextEditingController value) {
    if (_userNameController == value) return;
    _userNameController = value;
    notifyListeners();
  }

  TextEditingController get passwordController => _passwordController;

  set passwordController(TextEditingController value) {
    if (_passwordController == value) return;
    _passwordController = value;
    notifyListeners();
  }

  TextEditingController get captchaController => _captchaController;

  set captchaController(TextEditingController value) {
    if (_captchaController == value) return;
    _captchaController = value;
    notifyListeners();
  }

  bool get isChecked => _isChecked;

  set isChecked(bool value) {
    if (_isChecked == value) return;
    _isChecked = value;
    notifyListeners();
  }

  String get userCaptcha => _userCaptcha;

  set userCaptcha(String value) {
    if (_userCaptcha == value) return;
    _userCaptcha = value;
    notifyListeners();
  }

  String get generatedCaptcha => _generatedCaptcha;

  set generatedCaptcha(String value) {
    if (_generatedCaptcha == value) return;
    _generatedCaptcha = value;
    notifyListeners();
  }

  String? get captchaImage => _captchaImage;

  set captchaImage(String? value) {
    if (_captchaImage == value) return;
    _captchaImage = value;
    notifyListeners();
  }

  String get captchaError => _captchaError;

  set captchaError(String value) {
    if (_captchaError == value) return;
    _captchaError = value;
    notifyListeners();
  }

  String get loginError => _loginError;

  set loginError(String value) {
    if (_loginError == value) return;
    _loginError = value;
    notifyListeners();
  }

  CaptchaRenderData? get renderData => _renderData;

  set renderData(CaptchaRenderData? value) {
    if (_renderData == value) return;
    _renderData = value;
    notifyListeners();
  }
}