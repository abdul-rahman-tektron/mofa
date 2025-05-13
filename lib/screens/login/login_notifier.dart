import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/login/login_request.dart';
import 'package:mofa/core/remote/service/auth_provider.dart';
import 'package:mofa/utils/common/app_routes.dart';
import 'package:mofa/utils/common/encrypt.dart';
import 'package:mofa/utils/common/toast_helper.dart';

class LoginNotifier extends BaseChangeNotifier {

  //Data Controller
  TextEditingController _userNameController = TextEditingController();
  TextEditingController _passwordNameController = TextEditingController();

  //bool
  bool _isChecked = false;

  //String
  String _userCaptcha = '';
  String _generatedCaptcha = '';
  String _captchaError = '';

  //key
  final formKey = GlobalKey<FormState>();

  //Functions
  void rememberMeChecked(BuildContext context, bool? value) {
    isChecked = value!;
  }

  void performLogin(context, {required String email, required String password}) async {
    if (formKey.currentState!.validate() && !verifyCaptcha()) {
      String encryptedPassword = encryptAES(password);

      final loginRequest = LoginRequest(
          username: email, password: encryptedPassword);

      loginApiCall(context, loginRequest);
    }
  }

  void loginApiCall(BuildContext context, LoginRequest loginRequest) async {
    await AuthRepository().apiUserLogin(
        loginRequest, context).then((value) {
      if (value == "Not Found") {
        ToastHelper.showError("Incorrect Email or Password");
      }
    });
  }

  void navigateToRegisterScreen(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  bool verifyCaptcha() {
    if (userCaptcha.isEmpty) {
        captchaError = 'Captcha is required';
        return true;
    }else if (userCaptcha != generatedCaptcha) {
        captchaError = 'Captcha does not match. Please try again.';
        return true;
    } else {
        captchaError = '';
        return false;
    }
  }

  //Getter and Setter
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
}