import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/model/document/document_id_model.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/edit_profile/edit_profile_notifier.dart';
import 'package:mofa/utils/common_validation.dart';
import 'package:mofa/utils/common/widgets/common_app_bar.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_drawer.dart';
import 'package:mofa/utils/common/widgets/common_dropdown_search.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:provider/provider.dart';

class EditProfileScreen extends StatelessWidget {
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
      validator: CommonValidation().nameValidator,
    );
  }

  Widget visitorCompanyNameTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.visitorCompanyController,
      fieldName: context.watchLang.translate(AppLanguageText.visitorCompanyName),
      isSmallFieldFont: true,
      validator: CommonValidation().visitorNameValidator,
    );
  }

// nationalityField
  Widget nationalityField(BuildContext
  context,EditProfileNotifier editProfileNotifier) {
    return CustomSearchDropdown<CountryData>(
      fieldName: context.watchLang.translate(AppLanguageText.nationality),
      hintText: 'Select Country',
      controller: editProfileNotifier.nationalityController,
      items: editProfileNotifier.nationalityMenu,
      itemLabel: (item) => item.name ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (country) {
        editProfileNotifier.selectedNationality = country?.iso3 ?? "";
      },
      validator: CommonValidation().nationalityValidator,
    );
  }

  Widget mobileNumberTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.mobileNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.mobileNumber),
      isSmallFieldFont: true,
      validator: CommonValidation().validateMobile,
    );
  }

  Widget emailAddressTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.emailAddressController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      isSmallFieldFont: true,
      isEnable: false,
      validator: CommonValidation().validateEmail,
    );
  }

  // idTypeField
  Widget idTypeField(BuildContext
  context,EditProfileNotifier editProfileNotifier) {
    return CustomSearchDropdown<DocumentIdModel>(
      fieldName: context.watchLang.translate(AppLanguageText.idType),
      hintText: 'Select Id type',
      controller: editProfileNotifier.idTypeController,
      items: editProfileNotifier.idTypeMenu,
      itemLabel: (item) => item.labelEn ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (DocumentIdModel? menu) {
        editProfileNotifier.selectedIdValue = menu?.value.toString() ?? "";
        editProfileNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: CommonValidation().iDTypeValidator,
    );
  }

  // iqamaField
  Widget iqamaField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.iqamaController,
      fieldName: context.watchLang.translate(AppLanguageText.iqama),
      keyboardType: TextInputType.phone,
      isSmallFieldFont: true,
      validator: CommonValidation().validateIqama,
    );
  }

  // passportField
  Widget passportField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.passportNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.passportNumber),
      isSmallFieldFont: true,
      validator: CommonValidation().validatePassport,
    );
  }

  // documentNameField
  Widget documentNameField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.documentNameController,
      fieldName: context.watchLang.translate(AppLanguageText.documentNameOther),
      isSmallFieldFont: true,
      validator: CommonValidation().documentNameValidator,
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
      validator: CommonValidation().documentNumberValidator,
    );
  }

  Widget nationalIdTextField(BuildContext context, EditProfileNotifier editProfileNotifier) {
    return CustomTextField(
      controller: editProfileNotifier.nationalityIdController,
      fieldName: context.watchLang.translate(AppLanguageText.nationalID),
      isSmallFieldFont: true,
      validator: CommonValidation().validateNationalId,
    );
  }

  List<Widget> _buildIdTypeFields(BuildContext context, EditProfileNotifier notifier) {
    switch (notifier.selectedIdType) {
      case "National ID":
        return [nationalIdTextField(context, notifier)];
      case "Passport":
        return [passportField(context, notifier)];
      case "Iqama":
        return [iqamaField(context, notifier)];
      case "Other":
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
