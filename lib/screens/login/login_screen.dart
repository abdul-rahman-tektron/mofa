import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/base/loading_state.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/notifier/language_notifier.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_images.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/login/login_notifier.dart';
import 'package:mofa/utils/captcha_widget.dart';
import 'package:mofa/utils/common_validation.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_popup.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:mofa/utils/common/widgets/language_button.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginNotifier(context),
      child: Consumer<LoginNotifier>(
        builder: (context, loginNotifier, child) {
          return buildBody(context, loginNotifier);
        },
      ),
    );
  }

  // Function to build the body of the login screen
  Widget buildBody(BuildContext context, LoginNotifier loginNotifier) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: 10.h,
                right: 25.w,
                left: 25.w,
                top: 10.h,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 20.h,
                  horizontal: 20.w,
                ),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: loginNotifier.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      logoImage(),
                      20.verticalSpace,
                      welcomeHeading(context),
                      20.verticalSpace,
                      emailField(context, loginNotifier),
                      15.verticalSpace,
                      passwordField(context, loginNotifier),
                      3.verticalSpace,
                      if(loginNotifier.loginError.isNotEmpty) loginErrorText(context, loginNotifier),
                      3.verticalSpace,
                      forgotPassword(context, loginNotifier),
                      15.verticalSpace,
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          captchaField(context, loginNotifier),
                          10.horizontalSpace,
                          captchaWidget(context, loginNotifier),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(top: 15.h),
                            child: rememberMeWidget(context, loginNotifier),
                          ),
                          IconButton(
                            icon: Icon(LucideIcons.refreshCcw),
                            onPressed: ()=> loginNotifier.apiGetCaptcha(context),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      loginButton(context, loginNotifier),
                      10.verticalSpace,
                      createAccount(context, loginNotifier),
                    ],
                  ),
                ),
              ),
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
      child: Center(child: Image.asset(AppImages.logo, width: 150.h,)),
    );
  }

  // Function to create the welcome heading widget
  Widget welcomeHeading(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              text:
                  "${context.watchLang.translate(AppLanguageText.welcomeTo)} ",
              style: AppFonts.textMedium26with600,
              children: [
                TextSpan(
                  text: context.watchLang.translate(AppLanguageText.mofaShort),
                  style: AppFonts.textMedium26with600Red.copyWith(color: AppColors.mofaColor),
                ),
              ],
            ),
          ),
          5.verticalSpace,
          Text(
            context.watchLang.translate(AppLanguageText.visitorPortal),
            style: AppFonts.textMedium26with600,
          ),
          // 5.verticalSpace,
          // Text(
          //   context.watchLang.translate(AppLanguageText.loginToContinue),
          //   textAlign: TextAlign.center,
          //   style: TextStyle(color: AppColors.textColor, fontSize: 18),
          // ),
        ],
      ),
    );
  }

  // Function to create the email field widget
  Widget emailField(BuildContext context, LoginNotifier loginNotifier) {
    return CustomTextField(
      controller: loginNotifier.userNameController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      validator: (value) => CommonValidation().validateEmail(context, value),
      showAsterisk: false,
      keyboardType: TextInputType.emailAddress,
    );
  }

  // Function to create the password field widget
  Widget passwordField(BuildContext context, LoginNotifier loginNotifier) {
    return CustomTextField(
      controller: loginNotifier.passwordController,
      isPassword: true,
      isAutoValidate: false,
      showAsterisk: false,
      fieldName: context.watchLang.translate(AppLanguageText.password),
      onChanged: (value) {
        loginNotifier.loginError = '';
      },
      validator: (value) => CommonValidation().validatePassword(context, value),
    );
  }

  Widget loginErrorText(BuildContext context, LoginNotifier loginNotifier) {
    return Text(
      loginNotifier.loginError,
      style: AppFonts.textRegular14ErrorRed,
    );
  }

  // Function to create the captcha field widget
  Widget captchaField(BuildContext context, LoginNotifier loginNotifier) {
    return Expanded(
      child: TextFormField(
        controller: loginNotifier.captchaController,
        decoration: InputDecoration(
          fillColor: AppColors.whiteColor,
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
          hintText: context.watchLang.translate(AppLanguageText.enterCaptcha),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.fieldBorderColor, width: 2.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.fieldBorderColor, width: 2.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.fieldBorderColor, width: 2.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.fieldBorderColor, width: 2.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.fieldBorderColor, width: 2.5),
            borderRadius: BorderRadius.circular(15.0),
          ),
          hintStyle: AppFonts.textRegularGrey16,
          labelStyle: AppFonts.textRegular17,
          errorStyle: TextStyle(color: AppColors.underscoreColor),
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
        ],
        validator: (value) {
          if (value == null || value.isEmpty) {
            return context.readLang.translate(AppLanguageText.pleaseEnterCaptcha);
          }
          return null;
        },
      ),
    );
  }

  Widget captchaWidget(BuildContext context, LoginNotifier loginNotifier) {
    if (loginNotifier.captchaImage == null) {
      return Container(
        height: 55,
        width: 100,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.greyColor),
          color: AppColors.fieldBorderColor,
        ),
        child: Center(
          child: Text(
            context.watchLang.translate(AppLanguageText.refreshCaptcha),
            textAlign: TextAlign.center,
          ),
        ),
      ); // or placeholder if you want
    }
    return Image.network(
      loginNotifier.captchaImage!,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 55,
          width: 100,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.greyColor),
            color: AppColors.fieldBorderColor,
          ),
          child: Center(
            child: Text(
              context.watchLang.translate(AppLanguageText.refreshCaptcha),
              textAlign: TextAlign.center,
            ),
          ),
        );
      },
      height: 55,
      fit: BoxFit.fill,
    );
  }

  // Function to create the forgot password widget
  Widget forgotPassword(BuildContext context, LoginNotifier loginNotifier) {
    return GestureDetector(
      onTap: () {
        showForgotPasswordPopup(context);
      },
      child: Text(
        context.watchLang.translate(AppLanguageText.forgotPassword),
        style: AppFonts.textRegular16withUnderline,
      ),
    );
  }

  // Function to create the remember me widget
  Widget rememberMeWidget(BuildContext context, LoginNotifier loginNotifier) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        loginNotifier.rememberMeChecked(context, !loginNotifier.isChecked);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 5.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      loginNotifier.isChecked
                          ? AppColors.primaryColor
                          : AppColors.primaryColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
                color:
                    loginNotifier.isChecked
                        ? AppColors.whiteColor
                        : Colors.transparent,
              ),
              child:
                  loginNotifier.isChecked
                      ? Icon(Icons.check, size: 17, color: Colors.black)
                      : null,
            ),
            12.horizontalSpace,
            Text(
              context.watchLang.translate(AppLanguageText.rememberMe),
              style: AppFonts.textRegular14,
            ),
          ],
        ),
      ),
    );
  }

  // Function to create the login button widget
  Widget loginButton(BuildContext context, LoginNotifier loginNotifier) {
    return Center(
      child: CustomButton(
        onPressed: () => loginNotifier.performLogin(context),
        isLoading: loginNotifier.loadingState == LoadingState.Busy,
        text: context.watchLang.translate(AppLanguageText.login),
        backgroundColor: AppColors.buttonBgColor,
      ),
    );
  }

  // Function to create the create account widget
  Widget createAccount(BuildContext context, LoginNotifier loginNotifier) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.watchLang.translate(AppLanguageText.dontHaveAccount),
            style: AppFonts.textRegular18,
          ),
          5.verticalSpace,
          InkWell(
            onTap: () => loginNotifier.navigateToRegisterScreen(context),
            child: Text(
              context.watchLang.translate(AppLanguageText.createAccount),
              style: AppFonts.textRegular18withUnderline,
            ),
          ),
          15.verticalSpace,
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              text:
              context.watchLang.translate(AppLanguageText.changeLanguage),
              style: AppFonts.textRegular16,
              children: [
                TextSpan(
                    text: " ",
                    style: AppFonts.textRegular16Red,
                ),
                TextSpan(
                  text: context.watchLang.translate(AppLanguageText.switchLng),
                  style: FontResolver.resolve(context.watchLang.translate(AppLanguageText.switchLng), AppFonts.textRegular16Red),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        final provider = context.read<LanguageNotifier>();
                        final nextLang = provider.currentLang == 'en' ? 'ar' : 'en';
                        context.switchLang(nextLang);
                      }
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}