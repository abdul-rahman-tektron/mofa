/* <<<<<<<<<<<<<<  ✨ Windsurf Command 🌟 >>>>>>>>>>>>>>>> */
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/model/document/document_id_model.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_images.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/register/register_notifier.dart';
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
    return SafeArea(
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
      validator: CommonValidation().nameValidator,
    );
  }

  // visitorCompanyNameField
  Widget visitorCompanyNameField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.visitorCompanyNameController,
      fieldName: context.watchLang.translate(
        AppLanguageText.visitorCompanyName,
      ),
      validator: CommonValidation().companyValidator,
    );
  }

  // mobileNumberField
  Widget mobileNumberField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.mobileNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.mobileNumber),
      keyboardType: TextInputType.phone,
      validator: CommonValidation().validateMobile,
      toolTipContent: "Enter phone number in \ninternational format, e.g., \n00966XXXXXXXXX",
    );
  }

  // emailAddressField
  Widget emailAddressField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.emailAddressController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      validator: CommonValidation().validateEmail,
    );
  }

  // nationalIdField
  Widget nationalIdField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.nationalIdController,
      fieldName: context.watchLang.translate(AppLanguageText.nationalID),
      keyboardType: TextInputType.phone,
      validator: CommonValidation().validateNationalId,
      toolTipContent: "Enter 10-digit national \nID as per official records",
    );
  }

  // iqamaField
  Widget iqamaField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.iqamaController,
      fieldName: context.watchLang.translate(AppLanguageText.iqama),
      keyboardType: TextInputType.phone,
      validator: CommonValidation().validateIqama,
    );
  }

  // passportField
  Widget passportField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.passportNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.passportNumber),
      validator: CommonValidation().validatePassport,
    );
  }

  // documentNameField
  Widget documentNameField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.documentNameController,
      fieldName: context.watchLang.translate(AppLanguageText.documentNameOther),
      validator: CommonValidation().documentNameValidator,
    );
  }

  // documentNumberField
  Widget documentNumberField(RegisterNotifier registerNotifier) {
    return CustomTextField(
      controller: registerNotifier.documentNumberController,
      fieldName: context.watchLang.translate(
        AppLanguageText.documentNumberOther,
      ),
      validator: CommonValidation().documentNumberValidator,
    );
  }

  // nationalityField
  Widget nationalityField(RegisterNotifier registerNotifier) {
    return CustomSearchDropdown<CountryData>(
      fieldName: context.watchLang.translate(AppLanguageText.nationality),
      hintText: 'Select Country',
      controller: registerNotifier.nationalityController,
      items: registerNotifier.nationalityMenu,
      itemLabel: (item) => item.name ?? 'Unknown',
      onSelected: (country) {
        registerNotifier.selectedNationality = country?.iso3 ?? "";
      },
      validator: CommonValidation().iDTypeValidator,
    );
  }

  // idTypeField
  Widget idTypeField(RegisterNotifier registerNotifier) {
    return CustomSearchDropdown<DocumentIdModel>(
      fieldName: context.watchLang.translate(AppLanguageText.idType),
      hintText: 'Select Id type',
      controller: registerNotifier.idTypeController,
      items: registerNotifier.idTypeMenu,
      itemLabel: (item) => item.labelEn ?? 'Unknown',
      onSelected: (DocumentIdModel? menu) {
        registerNotifier.selectedIdValue = menu?.value.toString() ?? "";
        registerNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: CommonValidation().nationalityValidator,
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