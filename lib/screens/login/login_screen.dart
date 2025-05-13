import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_images.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/login/login_notifier.dart';
import 'package:mofa/utils/common/captcha_widget.dart';
import 'package:mofa/utils/common/common_validation.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
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
                SizedBox(height: 10),
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
                        SizedBox(height: 20),
                        welcomeHeading(context),
                        SizedBox(height: 20),
                        emailField(context, loginNotifier),
                        SizedBox(height: 20),
                        passwordField(context, loginNotifier),
                        SizedBox(height: 3),
                        forgotPassword(context, loginNotifier),
                        SizedBox(height: 15),
                        CaptchaWidget(
                          userCaptchaInput: loginNotifier.userCaptcha,
                          recaptchaError: loginNotifier.captchaError,
                          setUserCaptchaInput:
                              (val) => loginNotifier.userCaptcha = val,
                          setCaptchaText:
                              (val) => loginNotifier.generatedCaptcha = val,
                        ),
                        SizedBox(height: 15),
                        rememberMeWidget(context, loginNotifier),
                        SizedBox(height: 10),
                        loginButton(context, loginNotifier),
                        SizedBox(height: 10),
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

  Widget logoImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0),
      child: Image.asset(AppImages.logo),
    );
  }

  Widget welcomeHeading(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: "${context.watchLang.translate(AppLanguageText.welcomeTo)} ",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textColor,
                fontSize: 30,
              ),
              children: [
                TextSpan(
                  text: context.watchLang.translate(AppLanguageText.mofaShort),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textRedColor,
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          Text(
            context.watchLang.translate(AppLanguageText.visitorPortal),
            style: TextStyle(color: AppColors.textColor, fontSize: 30),
          ),
          SizedBox(height: 5),
          Text(
            context.watchLang.translate(AppLanguageText.loginToContinue),
            textAlign: TextAlign.center,
            style: TextStyle(color: AppColors.textColor, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget emailField(BuildContext context, LoginNotifier loginNotifier) {
    return CustomTextField(
      controller: loginNotifier.userNameController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      validator: CommonValidation().validateEmail,
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget passwordField(BuildContext context, LoginNotifier loginNotifier) {
    return CustomTextField(
      controller: loginNotifier.passwordNameController,
      isPassword: true,
      fieldName: context.watchLang.translate(AppLanguageText.password),
      validator: CommonValidation().validatePassword,
    );
  }

  Widget forgotPassword(BuildContext context, LoginNotifier loginNotifier) {
    return Text(context.watchLang.translate(AppLanguageText.forgotPassword), style: AppFonts.textRegular16withUnderline);
  }

  Widget rememberMeWidget(BuildContext context, LoginNotifier loginNotifier) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      // Align the children at the top
      children: [
        SizedBox(
          height: 20, // Adjust the height for larger checkbox
          width: 20, // Adjust the width for larger checkbox
          child: Checkbox(
            value: loginNotifier.isChecked,
            onChanged: (value) {
              loginNotifier.rememberMeChecked(context, value);
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
              side: BorderSide(width: 1.2, color: AppColors.primaryColor),
            ),
            side: BorderSide(width: 1.2, color: AppColors.primaryColor),
            activeColor: AppColors.whiteColor,
            checkColor: Colors.black,
          ),
        ),
        const SizedBox(width: 12.0),
        Text(context.watchLang.translate(AppLanguageText.rememberMe), style: AppFonts.textRegular14),
      ],
    );
  }

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

  Widget createAccount(BuildContext context, LoginNotifier loginNotifier) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(context.watchLang.translate(AppLanguageText.dontHaveAccount), style: AppFonts.textRegular18),
          SizedBox(height: 5),
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
