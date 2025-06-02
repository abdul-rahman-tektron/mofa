import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_images.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/otp_verification/otp_verification_notifier.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

class OtpVerificationScreen extends StatelessWidget {
  final String? email;
  final String? password;
  const OtpVerificationScreen({super.key, this.email, this.password});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => OTPVerificationNotifier(email, password),
      child: Consumer<OTPVerificationNotifier>(
        builder: (context, otpVerificationNotifier, child) {
          return buildBody(context, otpVerificationNotifier);
        },
      ),
    );
  }

  buildBody(BuildContext context, OTPVerificationNotifier otpVerificationNotifier) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(bottom: 25.h, right: 25.w, left: 25.w, top: 15.h),
              child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 25.h,
                    horizontal: 20.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    logoImage(),
                    15.verticalSpace,
                    welcomeHeading(context),
                    20.verticalSpace,
                    buildOtpFields(context, otpVerificationNotifier),
                    30.verticalSpace,
                    verifyAndLoginButtons(context, otpVerificationNotifier),
                    10.verticalSpace,
                    resendOTP(context, otpVerificationNotifier),
                  ],
                ),
              )
            ),
          ),
        ),
      ),
    );
  }

  // Function to create the logo image widget
  Widget logoImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0),
      child: Center(child: Image.asset(AppImages.logo)),
    );
  }

  // Function to create the welcome heading widget
  Widget welcomeHeading(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.watchLang.translate(AppLanguageText.otpVerification),
            style: AppFonts.textMedium30with600,
          ),
          5.verticalSpace,
          Text(
            context.watchLang.translate(AppLanguageText.enterOTP),
            textAlign: TextAlign.center,
            style: AppFonts.textMedium18
          ),
        ],
      ),
    );
  }

  Widget buildOtpFields(BuildContext context, OTPVerificationNotifier otpVerificationNotifier) {
    final defaultPinTheme = PinTheme(
      width: 50,
      height: 50,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.greyColor),
        borderRadius: BorderRadius.circular(10),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: AppColors.buttonBgColor),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
          color: AppColors.buttonBgColor.withOpacity(0.1),
          border: Border.all(color: AppColors.buttonBgColor),
      ),
    );

    return Pinput(
      controller: otpVerificationNotifier.otpController,
      defaultPinTheme: defaultPinTheme,
      focusedPinTheme: focusedPinTheme,
      submittedPinTheme: submittedPinTheme,
      onChanged: (value) {
        otpVerificationNotifier.notifyListeners();
      },
      keyboardType: TextInputType.text,
      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
      showCursor: true,
      length: 6,
      onCompleted: (pin) => print(pin),
    );
  }

  Widget verifyAndLoginButtons(BuildContext context, OTPVerificationNotifier otpVerificationNotifier) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            height: 50,
            onPressed: otpVerificationNotifier.otpController.text.length <= 5 ? null : () {
              otpVerificationNotifier.apiValidateOTP(context);
            },
            text: context.watchLang.translate(AppLanguageText.verify),
          ),
        ),
        15.horizontalSpace,
        Expanded(
          child: CustomButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (Route<dynamic> route) => false);
            },
            height: 50,
            backgroundColor: AppColors.whiteColor,
            borderColor: AppColors.buttonBgColor,
            textFont: AppFonts.textBold14,
            text: context.watchLang.translate(AppLanguageText.backToLogin),
          ),
        ),
      ],
    );
  }

  Widget resendOTP(BuildContext context, OTPVerificationNotifier otpVerificationNotifier) {
    return Text.rich(
      textAlign: TextAlign.center,
      TextSpan(
        text:
        "${context.watchLang.translate(AppLanguageText.didntGetCode)} ",
        style: AppFonts.textRegular16,
        children: [
          TextSpan(
            text: "${context.watchLang.translate(AppLanguageText.resend)} ${!otpVerificationNotifier.canResend ? "(${otpVerificationNotifier.resendSeconds}s)" : ""}",
            recognizer: TapGestureRecognizer()..onTap = !otpVerificationNotifier.canResend ? null : () {
              print("On Tapped");
              otpVerificationNotifier.resendOtp(context);
            },
            style: !otpVerificationNotifier.canResend ? AppFonts.textBoldGrey16: AppFonts.textBold16,
          ),
        ],
      ),
    );
  }
}
