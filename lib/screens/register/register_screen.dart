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
import 'package:mofa/utils/common/common_validation.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
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
                    SizedBox(height: 20),
                    welcomeHeading(),
                    SizedBox(height: 20),
                    fullNameField(registerNotifier),
                    SizedBox(height: 15),
                    visitorCompanyNameField(registerNotifier),
                    SizedBox(height: 15),
                    mobileNumberField(registerNotifier),
                    SizedBox(height: 15),
                    emailAddressField(registerNotifier),
                    SizedBox(height: 15),
                    nationalityField(registerNotifier),
                    SizedBox(height: 15),
                    idTypeField(registerNotifier),
                    SizedBox(height: 15),
                    if (registerNotifier.selectedIdType == "National ID")
                      nationalIdField(registerNotifier),
                    if (registerNotifier.selectedIdType == "Passport")
                      passportField(registerNotifier),
                    if (registerNotifier.selectedIdType == "Iqama")
                      iqamaField(registerNotifier),
                    if (registerNotifier.selectedIdType == "Other")
                      documentNameField(registerNotifier),
                    if (registerNotifier.selectedIdType == "Other")
                      SizedBox(height: 15),
                    if (registerNotifier.selectedIdType == "Other")
                      documentNumberField(registerNotifier),
                    SizedBox(height: 20),
                    registerButton(context, registerNotifier),
                    SizedBox(height: 10),
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
      child: Image.asset(AppImages.logo),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.watchLang.translate(AppLanguageText.nationality),
              style: AppFonts.textRegular18,
            ),
            SizedBox(width: 3),
            Text(
              "*",
              style: TextStyle(fontSize: 15, color: AppColors.textRedColor),
            ),
          ],
        ),
        SizedBox(height: 5),
        DropdownMenu<CountryData>(
          controller: registerNotifier.nationalityController,
          width: double.infinity,
          requestFocusOnTap: true,
          enableFilter: true,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 13),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.fieldBorderColor,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.fieldBorderColor,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          hintText: 'Select Country',
          onSelected: (CountryData? country) {
            registerNotifier.selectedNationality = country?.iso3 ?? "";
            print("Selected: ${country?.name}");
          },
          dropdownMenuEntries:
              registerNotifier.nationalityMenu.map((CountryData item) {
                return DropdownMenuEntry<CountryData>(
                  value: item,
                  label: item.name ?? 'Unknown',
                );
              }).toList(),
        ),
      ],
    );
  }

  // idTypeField
  Widget idTypeField(RegisterNotifier registerNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.watchLang.translate(AppLanguageText.idType),
              style: AppFonts.textRegular18,
            ),
            SizedBox(width: 3),
            Text(
              "*",
              style: TextStyle(fontSize: 15, color: AppColors.textRedColor),
            ),
          ],
        ),
        SizedBox(height: 5),
        DropdownMenu<DocumentIdModel>(
          //initialSelection: menuItems.first,
          controller: registerNotifier.idTypeController,
          width: double.infinity,
          requestFocusOnTap: true,
          enableFilter: true,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 13),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.fieldBorderColor,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.fieldBorderColor,
                width: 2.5,
              ),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          hintText: 'Select Id type',
          onSelected: (DocumentIdModel? menu) {
            registerNotifier.selectedIdValue = menu?.value.toString() ?? "";
            registerNotifier.selectedIdType = menu?.labelEn ?? "";
          },
          dropdownMenuEntries:
              registerNotifier.idTypeMenu.map((DocumentIdModel item) {
                return DropdownMenuEntry<DocumentIdModel>(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      AppColors.whiteColor,
                    ),
                  ),
                  value: item,
                  label: item.labelEn,
                );
              }).toList(),
        ),
      ],
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
          SizedBox(height: 5),
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