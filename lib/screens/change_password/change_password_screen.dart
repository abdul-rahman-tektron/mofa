import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/change_password/change_password_notifier.dart';
import 'package:mofa/utils/common/widgets/common_app_bar.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_drawer.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:mofa/utils/common/widgets/password_strength.dart';
import 'package:mofa/utils/common_validation.dart';
import 'package:provider/provider.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ChangePasswordNotifier(context),
      child: Consumer<ChangePasswordNotifier>(
        builder: (context, changePasswordNotifier, child) {
          return buildBody(context, changePasswordNotifier);
        },
      ),
    );
  }

  Widget buildBody(
    BuildContext context,
    ChangePasswordNotifier changePasswordNotifier,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(),
      drawer: CommonDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.w),
          child: Container(
            padding: EdgeInsets.all(15.w),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Form(
              key: changePasswordNotifier.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  headerWidget(context, changePasswordNotifier),
                  15.verticalSpace,
                  emailAddressTextField(context, changePasswordNotifier),
                  15.verticalSpace,
                  currentPasswordTextField(context, changePasswordNotifier),
                  15.verticalSpace,
                  newPasswordTextField(context, changePasswordNotifier),
                  5.verticalSpace,
                  Align(
                    alignment: Alignment.centerRight,
                    child: PasswordStrengthStars(password: changePasswordNotifier.newPasswordController.text),
                  ),
                  15.verticalSpace,
                  confirmPasswordTextField(context, changePasswordNotifier),
                  15.verticalSpace,
                  saveButton(context, changePasswordNotifier),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget headerWidget(
    BuildContext context,
    ChangePasswordNotifier changePasswordNotifier,
  ) {
    return Text(
      context.watchLang.translate(AppLanguageText.changePassword),
      style: AppFonts.textRegular24,
    );
  }

  Widget emailAddressTextField(
    BuildContext context,
    ChangePasswordNotifier changePasswordNotifier,
  ) {
    return CustomTextField(
      controller: changePasswordNotifier.emailAddressController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      isSmallFieldFont: true,
      isEnable: false,
      validator: CommonValidation().validateEmail,
    );
  }

  Widget currentPasswordTextField(
    BuildContext context,
    ChangePasswordNotifier changePasswordNotifier,
  ) {
    return CustomTextField(
      controller: changePasswordNotifier.currentPasswordController,
      fieldName: context.watchLang.translate(AppLanguageText.currentPassword),
      isSmallFieldFont: true,
      isPassword: true,
      validator: CommonValidation().validatePassword,
    );
  }

  Widget newPasswordTextField(
    BuildContext context,
    ChangePasswordNotifier changePasswordNotifier,
  ) {
    return CustomTextField(
      controller: changePasswordNotifier.newPasswordController,
      fieldName: context.watchLang.translate(AppLanguageText.newPassword),
      isSmallFieldFont: true,
      isPassword: true,
      validator: CommonValidation().validatePassword,
    );
  }

  Widget confirmPasswordTextField(
    BuildContext context,
    ChangePasswordNotifier changePasswordNotifier,
  ) {
    return CustomTextField(
      controller: changePasswordNotifier.confirmPasswordController,
      fieldName: context.watchLang.translate(AppLanguageText.confirmPassword),
      isSmallFieldFont: true,
      isPassword: true,
      validator: (value) =>
          CommonValidation().validateConfirmPassword(
              changePasswordNotifier.newPasswordController.text,
              changePasswordNotifier.confirmPasswordController.text),
    );
  }

  Widget saveButton(
    BuildContext context,
    ChangePasswordNotifier changePasswordNotifier,
  ) {
    return CustomButton(
      onPressed: () => changePasswordNotifier.saveButtonFunctionality(context),
      height: 45,
      text: context.watchLang.translate(AppLanguageText.save),
    );
  }
}
