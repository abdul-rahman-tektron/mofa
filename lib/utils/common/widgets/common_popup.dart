import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/forget_password/forget_password_request.dart';
import 'package:mofa/core/model/get_all_detail/get_all_detail_response.dart';
import 'package:mofa/core/remote/service/auth_repository.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/login/login_screen.dart';
import 'package:mofa/screens/search_pass/search_pass_notifier.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:mofa/utils/common_validation.dart';
import 'package:mofa/utils/regex.dart';
import 'package:mofa/utils/toast_helper.dart';

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
                      Navigator.pushReplacementNamed(context, AppRoutes.login);
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
                  Expanded(child: Text(heading, style: AppFonts.textBold20)),
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
  final ValueNotifier<bool> isLoading = ValueNotifier(false);

  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.primaryColor.withOpacity(0.4),
    builder: (popupContext) => Dialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: ValueListenableBuilder<bool>(
        valueListenable: isLoading,
        builder: (_, loading, __) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.readLang.translate(AppLanguageText.forgotPassword),
                      style: AppFonts.textBold22,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(popupContext),
                      child: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  controller: emailController,
                  fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: context.watchLang.translate(AppLanguageText.submit),
                  isLoading: loading,
                  onPressed: () async {
                    if (emailController.text.trim().isEmpty) {
                      ToastHelper.show(context.readLang.translate(AppLanguageText.emailRequired));
                      return;
                    }

                    if (!RegExp(LocalInputRegex.email).hasMatch(emailController.text)) {
                      ToastHelper.show(context.readLang.translate(AppLanguageText.emailInvalid));
                      return;
                    }

                    isLoading.value = true;
                    await AuthRepository()
                        .apiForgetPassword(
                      ForgetPasswordRequest(sEmail: emailController.text),
                      context,
                    )
                        .whenComplete(() {
                      isLoading.value = false;
                    });
                  },
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}



void columnVisibilityPopup(BuildContext context, SearchPassNotifier searchPassNotifier) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.primaryColor.withOpacity(0.4),
    builder: (_) => Dialog(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: StatefulBuilder(
        builder: (context, setState) {
          // Filter out mandatory columns
          final editableColumns = searchPassNotifier.columnConfigs
              .where((config) => !config.isMandatory)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(context.readLang.translate(AppLanguageText.customizeColumns), style: AppFonts.textBold20),
                10.verticalSpace,
                ...editableColumns.map((config) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(context.readLang.translate(config.labelKey), style: AppFonts.textRegular14),
                      Transform.scale(
                        scale: 0.8,
                        child: Switch(
                          value: config.isVisible,
                          onChanged: (val) {
                            searchPassNotifier.updateColumnVisibility(config.labelKey, val);
                            setState(() {});
                          },
                          activeColor: AppColors.whiteColor,
                          activeTrackColor: AppColors.buttonBgColor,
                          inactiveThumbColor: AppColors.whiteColor,
                          inactiveTrackColor: AppColors.greyColor,
                          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                          thumbIcon: WidgetStateProperty.all(
                            Icon(LucideIcons.toggleLeft, size: 0),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
                10.verticalSpace,
                SizedBox(
                  height: 35.h,
                  child: CustomButton(
                    text: context.watchLang.translate(AppLanguageText.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    ),
  );
}

void cancelAppointmentPopup(BuildContext context, SearchPassNotifier searchPassNotifier, GetExternalAppointmentData appointmentData) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.primaryColor.withOpacity(0.4),
    builder: (_) =>
        Dialog(
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
                  Text(context.readLang.translate(
                      AppLanguageText.sureToCancelAppointment),
                    style: AppFonts.textRegular20,
                    textAlign: TextAlign.center,
                  ),
                  20.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomButton(
                        text: context.watchLang.translate(
                            AppLanguageText.yesCancel),
                        smallWidth: true,
                        height: 40,
                        onPressed: () {
                          searchPassNotifier.apiCancelAppointment(
                              context, appointmentData);
                        },
                      ),
                      10.horizontalSpace,
                      CustomButton(
                        text: context.watchLang.translate(
                            AppLanguageText.noClose),
                        backgroundColor: AppColors.backgroundColor,
                        borderColor: AppColors.buttonBgColor,
                        smallWidth: true,
                        height: 40,
                        textFont: AppFonts.textBold14,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )
                ]
            ),
          ),
        ),
  );


}void accountLockedPopup(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: AppColors.primaryColor.withOpacity(0.4),
    builder: (_) =>
        Dialog(
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
                  Icon(LucideIcons.lock, size: 60, color: AppColors.textRedColor),
                  20.verticalSpace,
                  Text(context.readLang.translate(
                      AppLanguageText.accountIsLocked),
                    style: AppFonts.textRegular20,
                    textAlign: TextAlign.center,
                  ),
                  20.verticalSpace,
                  CustomButton(
                    text: context.watchLang.translate(
                        AppLanguageText.ok),
                    smallWidth: true,
                    height: 40,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ]
            ),
          ),
        ),
  );
}
