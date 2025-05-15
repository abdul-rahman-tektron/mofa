import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/forget_password/forget_password_request.dart';
import 'package:mofa/core/remote/service/auth_repository.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/login/login_screen.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';

registerSuccessPopup(BuildContext context, String heading, String subHeading) {
  return showDialog(
    context: context,
    barrierColor: AppColors.primaryColor.withOpacity(0.4),
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);

                    // Then navigate to the login screen
                    Future.delayed(Duration.zero, () {
                      Navigator.pop(context);
                    });
                  },
                  child: const Icon(Icons.close),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_box, color: Colors.green, size: 30),
                  SizedBox(width: 10),
                  Text(heading, style: AppFonts.textBold24),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                subHeading,
                style: AppFonts.textMedium18,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      );
    },
  );
}

commonPopup(BuildContext context,IconData icon, String heading, String subHeading) {
  return showDialog(
    context: context,
    barrierColor: AppColors.primaryColor.withOpacity(0.4),
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: AppColors.whiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.green, size: 30),
                  SizedBox(width: 15),
                  Text(heading, style: AppFonts.textBold20),
                ],
              ),
              const SizedBox(height: 15),
              Text(
                subHeading,
                style: AppFonts.textMedium18,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      );
    },
  );
}

void showNoInternetPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.primaryColor.withOpacity(0.4),
    builder:
        (popupContext) => Dialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () async {
                      Navigator.pop(popupContext);

                      // Check connectivity again after closing
                      final connectivityResult =
                          await Connectivity().checkConnectivity();
                      if (connectivityResult.contains(
                        ConnectivityResult.none,
                      )) {
                        // Still offline — optionally show a snackbar
                        showNoInternetPopup(context);
                      }
                    },
                    child: Icon(LucideIcons.x),
                  ),
                ),
                const SizedBox(height: 10),
                Icon(
                  LucideIcons.wifiOff,
                  size: 40,
                  color: AppColors.textRedColor,
                ),
                const SizedBox(height: 15),
                Text(
                  'No Internet Connection',
                  style: AppFonts.textBold24,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Your internet connection appears to be offline.\nPlease check your connectivity.',
                  style: AppFonts.textMedium18,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
  );
}

void showForgotPasswordPopup(BuildContext context) {
  final TextEditingController emailController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.primaryColor.withOpacity(0.4),
    builder:
        (popupContext) => Dialog(
          backgroundColor: AppColors.whiteColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Forgot Password',
                      style: AppFonts.textBold24,
                      textAlign: TextAlign.center,
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pop(popupContext);
                        },
                        child: const Icon(Icons.close),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: emailController,
                  fieldName: context.watchLang.translate(
                    AppLanguageText.emailAddress,
                  ),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: context.watchLang.translate(AppLanguageText.submit),
                  onPressed: () {
                    AuthRepository().apiForgetPassword(
                        ForgetPasswordRequest(sEmail: emailController.text),
                        context);
                  },
                ),
              ],
            ),
          ),
        ),
  );
}
