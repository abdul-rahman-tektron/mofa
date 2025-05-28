import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/notifier/common_notifier.dart';
import 'package:mofa/model/token_user_response.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/delete_account/delete_account_notifier.dart';
import 'package:mofa/utils/common/widgets/common_app_bar.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_drawer.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:mofa/utils/common_validation.dart';
import 'package:mofa/utils/toast_helper.dart';
import 'package:provider/provider.dart';

class DeleteAccountScreen extends StatelessWidget {
  const DeleteAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DeleteAccountNotifier(),
      child: Consumer<DeleteAccountNotifier>(
        builder: (context, deleteAccountNotifier, child) {
          final user = Provider
              .of<CommonNotifier>(context, listen: false)
              .user;
          return buildBody(context, deleteAccountNotifier, user);
        },
      ),
    );
  }

  Widget buildBody(
    BuildContext context,
    DeleteAccountNotifier deleteAccountNotifier,
      LoginTokenUserResponse? user,
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
              key: deleteAccountNotifier.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...contentWidget(context, user),
                  10.verticalSpace,
                  emailAddressTextField(context, deleteAccountNotifier),
                  15.verticalSpace,
                  deleteAndCancelButtons(context, deleteAccountNotifier, user),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> contentWidget(BuildContext context, LoginTokenUserResponse? user) {
    return [
      Text(
        context.watchLang.translate(AppLanguageText.deleteAccount),
        style: AppFonts.textRegular24,
      ),
      15.verticalSpace,
      Text(
        context.watchLang.translate(
          AppLanguageText.deleteAccountConfirmation,
        ),
        style: AppFonts.textRegular16,
      ),
      10.verticalSpace,
      Text(
        context.watchLang.translate(
          AppLanguageText.actionCannotBeUndone,
        ),
        style: AppFonts.textRegular16,
      ),
      Text(
        "${context.watchLang.translate(AppLanguageText.thisWillPermanentlyDelete)} ${user?.email ?? ""} ${context.watchLang.translate(AppLanguageText.account)}",
        style: AppFonts.textRegular16,
      ),
      Text(
        "${context.watchLang.translate(AppLanguageText.pleaseType)} ${user?.email ?? ""} ${context.watchLang.translate(AppLanguageText.toConfirm)}",
        style: AppFonts.textRegular16,
      ),
    ];
  }

  Widget emailAddressTextField(
    BuildContext context,
    DeleteAccountNotifier deleteAccountNotifier,
  ) {
    return CustomTextField(
      controller: deleteAccountNotifier.emailAddressController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      isSmallFieldFont: true,
      validator: CommonValidation().validateEmail,
    );
  }

  Widget deleteAndCancelButtons(BuildContext context,
      DeleteAccountNotifier deleteAccountNotifier,
      LoginTokenUserResponse? user,
      ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        CustomButton(
            text: context.watchLang.translate(AppLanguageText.deleteAccount),
            smallWidth: true,
            height: 45,
            backgroundColor: AppColors.redColor,
            onPressed: () {
              final formValid = deleteAccountNotifier.formKey.currentState!.validate();
              final enteredEmail = deleteAccountNotifier.emailAddressController.text;
              final userEmail = user?.email ?? "";

              if (!formValid) return;

              if (enteredEmail != userEmail) {
                ToastHelper.showError(
                  context.readLang.translate(AppLanguageText.incorrectEmailFormat),
                );
                return;
              }

              deleteAccountNotifier.apiDeleteAccount(context);
            },
        ),
        10.horizontalSpace,
        CustomButton(text: context.watchLang.translate(AppLanguageText.cancel),
          backgroundColor: Colors.white,
          borderColor: AppColors.buttonBgColor,
          textFont: AppFonts.textBold14,
          height: 45,
          smallWidth: true,
          onPressed: () {
            deleteAccountNotifier.emailAddressController.clear();
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
