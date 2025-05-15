import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_images.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/login/login_notifier.dart';
import 'package:mofa/utils/common/captcha_widget.dart';
import 'package:mofa/utils/common/common_validation.dart';
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
      create: (context) => LoginNotifier(),
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
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 25.h,
              right: 25.w,
              left: 25.w,
              top: 5.w,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                LanguageButton(),
                10.verticalSpace,
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 25.h,
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
                        20.verticalSpace,
                        passwordField(context, loginNotifier),
                        3.verticalSpace,
                        forgotPassword(context, loginNotifier),
                        15.verticalSpace,
                        captchaWidget(loginNotifier),
                        16.verticalSpace,
                        captchaField(context, loginNotifier),
                        15.verticalSpace,
                        rememberMeWidget(context, loginNotifier),
                        15.verticalSpace,
                        loginButton(context, loginNotifier),
                        10.verticalSpace,
                        createAccount(context, loginNotifier),
                      ],
                    ),
                  ),
                ),
              ],
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
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              text:
                  "${context.watchLang.translate(AppLanguageText.welcomeTo)} ",
              style: AppFonts.textMedium30with600,
              children: [
                TextSpan(
                  text: context.watchLang.translate(AppLanguageText.mofaShort),
                  style: AppFonts.textMedium30with600Red,
                ),
              ],
            ),
          ),
          5.verticalSpace,
          Text(
            context.watchLang.translate(AppLanguageText.visitorPortal),
            style: AppFonts.textMedium30with600,
          ),
          5.verticalSpace,
          Text(
            context.watchLang.translate(AppLanguageText.loginToContinue),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textColor, fontSize: 18),
          ),
        ],
      ),
    );
  }

  // Function to create the email field widget
  Widget emailField(BuildContext context, LoginNotifier loginNotifier) {
    return CustomTextField(
      controller: loginNotifier.userNameController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      validator: CommonValidation().validateEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }

  // Function to create the password field widget
  Widget passwordField(BuildContext context, LoginNotifier loginNotifier) {
    return CustomTextField(
      controller: loginNotifier.passwordNameController,
      isPassword: true,
      fieldName: context.watchLang.translate(AppLanguageText.password),
      validator: CommonValidation().validatePassword,
    );
  }

  // Function to create the captcha field widget
  Widget captchaField(BuildContext context, LoginNotifier loginNotifier) {
    return SizedBox(
      width: 220,
      child: TextFormField(
        controller: loginNotifier.captchaController,
        decoration: InputDecoration(
          fillColor: AppColors.whiteColor,
          filled: true,
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter the CAPTCHA';
          }
          if (value != loginNotifier.generatedCaptcha) {
            return 'Incorrect CAPTCHA';
          }
          return null;
        },
      ),
    );
  }

  Widget captchaWidget(LoginNotifier loginNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CaptchaWidget(renderData: loginNotifier.renderData),
        IconButton(
          icon: Icon(LucideIcons.refreshCcw),
          onPressed: loginNotifier.generateCaptcha,
        ),
      ],
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () {
            loginNotifier.rememberMeChecked(context, !loginNotifier.isChecked);
          },
          child: Container(
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
        ),
        12.horizontalSpace,
        Text(
          context.watchLang.translate(AppLanguageText.rememberMe),
          style: AppFonts.textRegular14,
        ),
      ],
    );
  }

  // Function to create the login button widget
  Widget loginButton(BuildContext context, LoginNotifier loginNotifier) {
    return Center(
      child: CustomButton(
        onPressed:
            () => loginNotifier.performLogin(
              context,
              email: loginNotifier.userNameController.text,
              password: loginNotifier.passwordNameController.text,
            ),
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
        ],
      ),
    );
  }
}