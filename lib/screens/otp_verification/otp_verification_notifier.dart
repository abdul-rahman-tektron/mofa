import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/captcha/resend_otp_request.dart';
import 'package:mofa/core/remote/service/auth_repository.dart';
import 'package:mofa/utils/toast_helper.dart';

class OTPVerificationNotifier extends BaseChangeNotifier {
  String? _email;
  String? _password;

  bool _canResend = true;

  int _resendSeconds = 0;

  Timer? _timer;


  TextEditingController otpController = TextEditingController();

  OTPVerificationNotifier(String? email, String? password) {
    this.email = email;
    this.password = password;
    otpController.addListener(() {

    },);
  }

  Future<void> resendOtp(BuildContext context) async {
    if (!_canResend) return;

    try {
      _canResend = false;
      _resendSeconds = 30;
      notifyListeners();

      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_resendSeconds > 0) {
          _resendSeconds--;
          notifyListeners();
        } else {
          _canResend = true;
          timer.cancel();
          notifyListeners();
        }
      });

      await apiVisitRequestDropdown(context);
    } catch (e) {
      debugPrint("Error in apiResendOtp: $e");
      ToastHelper.showError("Failed to resend OTP.");
      _canResend = true;
      _resendSeconds = 0;
      _timer?.cancel();
      notifyListeners();
    }
  }

  // Visit Request dropdown
  Future<void> apiValidateOTP(BuildContext context) async {
    try {
      final result = await AuthRepository().apiValidateOtp(ValidateOtpRequest(
        email: email,
        password: password,
        otpCode: otpController.text,
      ), context);
    } catch (e) {
      debugPrint("Error in apiResendOtp: $e");
      ToastHelper.showError("Failed to Resend OTP.");
    }
  }


  // Visit Request dropdown
  Future<void> apiVisitRequestDropdown(BuildContext context) async {
    try {
      final result = await AuthRepository().apiResendOtp(ResendOtpRequest(
        email: email,
        password: password,
      ), context);
    } catch (e) {
      debugPrint("Error in apiResendOtp: $e");
      ToastHelper.showError("Failed to Resend OTP.");
    }
  }

  // Clean up timer
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  //Getter and Setter
  String? get email => _email;

  set email(String? value) {
    if (_email == value) return;
    _email = value;
    notifyListeners();
  }

  String? get password => _password;

  set password(String? value) {
    if (_password == value) return;
    _password = value;
    notifyListeners();
  }

  bool get canResend => _canResend;
  int get resendSeconds => _resendSeconds;
}