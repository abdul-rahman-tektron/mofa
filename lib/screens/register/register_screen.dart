/* <<<<<<<<<<<<<<  ✨ Windsurf Command 🌟 >>>>>>>>>>>>>>>> */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/base/loading_state.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/model/document/document_id_model.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_images.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/register/register_notifier.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/common_utils.dart';
import 'package:mofa/utils/common_validation.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_dropdown_search.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:mofa/utils/common/widgets/language_button.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // build
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => RegisterNotifier(context),
      child: Consumer<RegisterNotifier>(
        builder: (context, registerNotifier, child) {
          return buildBody(context, registerNotifier);
        },
      ),
    );
  }

  // buildBody
  Widget buildBody(BuildContext context, RegisterNotifier registerNotifier) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
          Navigator.pushReplacementNamed(context, AppRoutes.login);
      },
      canPop: false,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: AppColors.backgroundColor,
          appBar: AppBar(
            backgroundColor: AppColors.whiteColor,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.only(left: 24.0),
              child: Image.asset(AppImages.logo),
            ),
            leadingWidth: 120,
            actionsPadding: const EdgeInsets.symmetric(horizontal: 24.0),
            actions: [LanguageButton()],
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 25.w),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
                decoration: BoxDecoration(
                  color: AppColors.whiteColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: registerNotifier.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      logoImage(),
                      20.verticalSpace,
                      welcomeHeading(),
                      20.verticalSpace,
                      fullNameField(registerNotifier),
                      15.verticalSpace,
                      visitorCompanyNameField(registerNotifier),
                      15.verticalSpace,
                      mobileNumberField(registerNotifier),
                      15.verticalSpace,
                      emailAddressField(registerNotifier),
                      15.verticalSpace,
                      nationalityField(registerNotifier),
                      15.verticalSpace,
                      idTypeField(registerNotifier),
                      15.verticalSpace,
                      if (registerNotifier.selectedIdType == "National ID")
                        nationalIdField(registerNotifier),
                      if (registerNotifier.selectedIdType == "Passport")
                        passportField(registerNotifier),
                      if (registerNotifier.selectedIdType == "Iqama")
                        iqamaField(registerNotifier),
                      if (registerNotifier.selectedIdType == "Other")
                        documentNameField(registerNotifier),
                      if (registerNotifier.selectedIdType == "Other")
                        15.verticalSpace,
                      if (registerNotifier.selectedIdType == "Other")
                        documentNumberField(registerNotifier),
                      20.verticalSpace,
                      registerButton(context, registerNotifier),
                      15.verticalSpace,
                      alreadyHaveAccount(context, registerNotifier),
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

  // logoImage
  Widget logoImage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 45.0),
      child: Center(child: Image.asset(AppImages.logo)),
    );
  }

  // welcomeHeading
  Widget welcomeHeading() {
    return Center(
      child: Text(
        context.watchLang.translate(AppLanguageText.createAccount),
        style: AppFonts.textBold24,
      ),
    );
  }

  // fullNameField
  Widget fullNameField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.fullNameController,
      fieldName: context.watchLang.translate(AppLanguageText.fullName),
      validator: (value) => CommonValidation().nameValidator(context, value),
    );
  }

  // visitorCompanyNameField
  Widget visitorCompanyNameField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.visitorCompanyNameController,
      fieldName: context.watchLang.translate(
        AppLanguageText.visitorCompanyName,
      ),
      validator: (value) => CommonValidation().companyValidator(context, value),
    );
  }

  // mobileNumberField
  Widget mobileNumberField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.mobileNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.mobileNumber),
      keyboardType: TextInputType.phone,
      validator: (value) => CommonValidation().validateMobile(context, value),
      toolTipContent: "${context.readLang.translate(AppLanguageText.phoneNumberIn)}\n${context.readLang.translate(AppLanguageText.internationalFormat)}\n00966XXXXXXXXX",
    );
  }

  // emailAddressField
  Widget emailAddressField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.emailAddressController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      validator: (value) => CommonValidation().validateEmail(context, value),
    );
  }

  // nationalIdField
  Widget nationalIdField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.nationalIdController,
      fieldName: context.watchLang.translate(AppLanguageText.nationalID),
      keyboardType: TextInputType.phone,
      validator: (value) => CommonValidation().validateNationalId(context, value),
      toolTipContent: "${context.readLang.translate(AppLanguageText.entre10digit)}\n${context.readLang.translate(AppLanguageText.idAsPerRecords)}",
    );
  }

  // iqamaField
  Widget iqamaField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.iqamaController,
      fieldName: context.watchLang.translate(AppLanguageText.iqama),
      keyboardType: TextInputType.phone,
      validator: (value) => CommonValidation().validateIqama(context, value),
    );
  }

  // passportField
  Widget passportField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.passportNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.passportNumber),
      validator: (value) => CommonValidation().validatePassport(context, value),
    );
  }

  // documentNameField
  Widget documentNameField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.documentNameController,
      fieldName: context.watchLang.translate(AppLanguageText.documentNameOther),
      validator: (value) => CommonValidation().documentNameValidator(context, value),
    );
  }

  // documentNumberField
  Widget documentNumberField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.documentNumberController,
      fieldName: context.watchLang.translate(
        AppLanguageText.documentNumberOther,
      ),
      validator: (value) => CommonValidation().documentNumberValidator(context, value),
    );
  }

  // nationalityField
  Widget nationalityField(RegisterNotifier registerNotifier) {
    return CustomSearchDropdown<CountryData>(
      fieldName: context.watchLang.translate(AppLanguageText.nationality),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: registerNotifier.nationalityController,
      items: registerNotifier.nationalityMenu,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.nameAr,
        getEnglish: () => item.name,
      ),
      onSelected: (country) {
        registerNotifier.selectedNationality = country?.iso3 ?? "";
      },
      validator: (value) => CommonValidation().iDTypeValidator(context, value),
    );
  }

  // idTypeField
  Widget idTypeField(RegisterNotifier registerNotifier) {
    return CustomSearchDropdown<DocumentIdModel>(
      fieldName: context.watchLang.translate(AppLanguageText.idType),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: registerNotifier.idTypeController,
      items: registerNotifier.idTypeMenu,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.labelAr,
        getEnglish: () => item.labelEn,
      ),
      onSelected: (DocumentIdModel? menu) {
        registerNotifier.selectedIdValue = menu?.value.toString() ?? "";
        registerNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: (value) => CommonValidation().nationalityValidator(context, value),
    );
  }

  Widget registerButton(
    BuildContext context,
    RegisterNotifier registerNotifier,
  ) {
    return Center(
      child: CustomButton(
        onPressed: () => registerNotifier.performRegister(context),
        text: context.watchLang.translate(AppLanguageText.create),
        isLoading: registerNotifier.loadingState == LoadingState.Busy,
        backgroundColor: AppColors.buttonBgColor,
      ),
    );
  }

  Widget alreadyHaveAccount(
    BuildContext context,
    RegisterNotifier registerNotifier,
  ) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.watchLang.translate(AppLanguageText.alreadyHaveAccount),
            style: AppFonts.textRegular18,
          ),
          5.verticalSpace,
          InkWell(
            onTap: () => registerNotifier.navigateToLoginScreen(context),
            child: Text(
              context.watchLang.translate(AppLanguageText.login),
              style: AppFonts.textRegular18withUnderline,
            ),
          ),
        ],
      ),
    );
  }
}