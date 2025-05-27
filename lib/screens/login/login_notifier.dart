import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/login/login_request.dart';
import 'package:mofa/core/remote/service/auth_repository.dart';
import 'package:mofa/model/remember_me/remember_me_model.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/captcha_widget.dart';
import 'package:mofa/utils/encrypt.dart';
import 'package:mofa/utils/secure_storage.dart';
import 'package:mofa/utils/toast_helper.dart';

class LoginNotifier extends BaseChangeNotifier {
  // Data Controller
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordNameController = TextEditingController();
  TextEditingController _captchaController = TextEditingController();

  // bool
  bool _isChecked = false;

  // String
  String _userCaptcha = '';
  String _generatedCaptcha = '';
  String _captchaError = '';

  CaptchaRenderData? _renderData;

  // key
  final formKey = GlobalKey<FormState>();

  // Functions
  LoginNotifier() {
    generateCaptcha();
    rememberMeData();
  }

  // Load remember me data from storage
  void rememberMeData() async {
    String? data = await SecureStorageHelper.getRememberMe();
    if (data != null) {
      RememberMeModel rememberMeModel = RememberMeModel.fromJson(jsonDecode(data));
      userNameController.text = rememberMeModel.userName;
      passwordNameController.text = rememberMeModel.password;
      isChecked = true;
    }
  }

  // Update remember me checkbox state
  void rememberMeChecked(BuildContext context, bool? value) {
    isChecked = value!;
  }

  // Perform login action
  void performLogin(context, {required String email, required String password}) async {
    if (formKey.currentState!.validate()) {
      String encryptedPassword = encryptAES(password);

      // final loginRequest = LoginRequest(
      //     username: email, password: encryptedPassword);

      final loginRequest = LoginTokenRequest(
          email: email, password: encryptedPassword);

      loginApiCall(context, loginRequest);
    }
  }

  // API call for login
  void loginApiCall(BuildContext context, LoginTokenRequest loginRequest) async {
    await AuthRepository().apiUserLogin(
        loginRequest, context).then((value) async {
      if (value == "Success") {
        if (isChecked) {
          await SecureStorageHelper.setRememberMe(
            jsonEncode(
              RememberMeModel(
                userName: userNameController.text,
                password: passwordNameController.text,
              ),
            ),
          );
        }
        Navigator.pushReplacementNamed(context, AppRoutes.bottomBar);
      } else {
        ToastHelper.showError("Incorrect Email or Password");
      }
    });
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

  TextEditingController get passwordNameController => _passwordNameController;

  set passwordNameController(TextEditingController value) {
    if (_passwordNameController == value) return;
    _passwordNameController = value;
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

  String get captchaError => _captchaError;

  set captchaError(String value) {
    if (_captchaError == value) return;
    _captchaError = value;
    notifyListeners();
  }

  CaptchaRenderData? get renderData => _renderData;

  set renderData(CaptchaRenderData? value) {
    if (_renderData == value) return;
    _renderData = value;
    notifyListeners();
  }
}