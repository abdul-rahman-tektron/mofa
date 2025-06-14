import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/model/document/document_id_model.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/edit_profile/edit_profile_notifier.dart';
import 'package:mofa/utils/common_utils.dart';
import 'package:mofa/utils/common_validation.dart';
import 'package:mofa/utils/common/widgets/common_app_bar.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_drawer.dart';
import 'package:mofa/utils/common/widgets/common_dropdown_search.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget with CommonUtils {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EditProfileNotifier(context),
      child: Consumer<EditProfileNotifier>(
        builder: (context, editProfileNotifier, child) {
          return buildBody(context, editProfileNotifier);
        },
      ),
    );
  }

  buildBody(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(),
      drawer: CommonDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(25.w),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 25.h,
              horizontal: 20.w,
            ),
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                titleWidget(context, editProfileNotifier),
                15.verticalSpace,
                fullNameTextField(context, editProfileNotifier),
                15.verticalSpace,
                visitorCompanyNameTextField(context, editProfileNotifier),
                15.verticalSpace,
                nationalityField(context, editProfileNotifier),
                15.verticalSpace,
                mobileNumberTextField(context, editProfileNotifier),
                15.verticalSpace,
                emailAddressTextField(context, editProfileNotifier),
                15.verticalSpace,
                idTypeField(context, editProfileNotifier),
                15.verticalSpace,
                ..._buildIdTypeFields(context, editProfileNotifier),
                15.verticalSpace,
                saveButton(context, editProfileNotifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleWidget(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return Text(
      context.watchLang.translate(AppLanguageText.editProfile),
      style: AppFonts.textRegular20,
    );
  }

  Widget fullNameTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.fullNameController,
      fieldName: context.watchLang.translate(AppLanguageText.fullName),
      isSmallFieldFont: true,
      keyboardType: TextInputType.name,
      validator: (value) => CommonValidation().nameValidator(context, value),
    );
  }

  Widget visitorCompanyNameTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.visitorCompanyController,
      fieldName: context.watchLang.translate(AppLanguageText.visitorCompanyName),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().visitorNameValidator(context, value),
    );
  }

// nationalityField
  Widget nationalityField(BuildContext
  context,EditProfileNotifier editProfileNotifier) {
    return CustomSearchDropdown<CountryData>(
      fieldName: context.watchLang.translate(AppLanguageText.nationality),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: editProfileNotifier.nationalityController,
      items: editProfileNotifier.nationalityMenu,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.nameAr,
        getEnglish: () => item.name,
      ),
      isSmallFieldFont: true,
      onSelected: (country) {
        editProfileNotifier.selectedNationality = country?.iso3 ?? "";
      },
      validator: (value) => CommonValidation().nationalityValidator(context, value),
    );
  }

  Widget mobileNumberTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.mobileNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.mobileNumber),
      isSmallFieldFont: true,
      keyboardType: TextInputType.phone,
      validator: (value) => CommonValidation().validateMobile(context, value),
    );
  }

  Widget emailAddressTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.emailAddressController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      isSmallFieldFont: true,
      isEnable: false,
      keyboardType: TextInputType.emailAddress,
      validator: (value) => CommonValidation().validateEmail(context, value),
    );
  }

  // idTypeField
  Widget idTypeField(BuildContext
  context,EditProfileNotifier editProfileNotifier) {
    return CustomSearchDropdown<DocumentIdModel>(
      fieldName: context.watchLang.translate(AppLanguageText.idType),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: editProfileNotifier.idTypeController,
      items: editProfileNotifier.idTypeMenu,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.labelAr,
        getEnglish: () => item.labelEn,
      ),
      isSmallFieldFont: true,
      onSelected: (DocumentIdModel? menu) {
        editProfileNotifier.selectedIdValue = menu?.value.toString() ?? "";
        editProfileNotifier.selectedIdType = getLocalizedText(
          currentLang: context.lang,
          english: menu?.labelEn ?? "",
          arabic: menu?.labelAr ?? "",
        );
      },
      validator: (value) => CommonValidation().iDTypeValidator(context, value),
    );
  }

  // iqamaField
  Widget iqamaField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.iqamaController,
      fieldName: context.watchLang.translate(AppLanguageText.iqama),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().validateIqama(context, value),
    );
  }

  // passportField
  Widget passportField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.passportNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.passportNumber),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().validatePassport(context, value),
    );
  }

  // documentNameField
  Widget documentNameField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.documentNameController,
      fieldName: context.watchLang.translate(AppLanguageText.documentNameOther),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().documentNameValidator(context, value),
    );
  }

  // documentNumberField
  Widget documentNumberField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.documentNumberController,
      fieldName: context.watchLang.translate(
        AppLanguageText.documentNumberOther,
      ),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().documentNumberValidator(context, value),
    );
  }

  Widget nationalIdTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.nationalityIdController,
      fieldName: context.watchLang.translate(AppLanguageText.nationalID),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().validateNationalId(context, value),
    );
  }

  List<Widget> _buildIdTypeFields(BuildContext context, EditProfileNotifier notifier) {
    switch (notifier.selectedIdValue) {
      case "24": // National ID
        return [nationalIdTextField(context, notifier)];
      case "26": // Passport
        return [passportField(context, notifier)];
      case "2244": // Iqama
        return [iqamaField(context, notifier)];
      case "2245": // Other
        return [
          documentNameField(context, notifier),
          15.verticalSpace,
          documentNumberField(context, notifier),
        ];
      default:
        return [];
    }
  }


  Widget saveButton(BuildContext context,
      EditProfileNotifier editProfileNotifier) {
    return CustomButton(text: context.watchLang.translate(AppLanguageText.save),
      onPressed: () => editProfileNotifier.saveData(context),);
  }
}
