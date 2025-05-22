import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/core/model/device_dropdown/device_dropdown_response.dart';
import 'package:mofa/core/model/location_dropdown/location_dropdown_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_purpose_dropdown_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_request_dropdown_response.dart';
import 'package:mofa/model/apply_pass/apply_pass_category.dart';
import 'package:mofa/model/document/document_id_model.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/apply_pass_category/apply_pass_category_notifier.dart';
import 'package:mofa/utils/common/common_validation.dart';
import 'package:mofa/utils/common/extensions.dart';
import 'package:mofa/utils/common/widgets/bullet_list.dart';
import 'package:mofa/utils/common/widgets/common_app_bar.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_drawer.dart';
import 'package:mofa/utils/common/widgets/common_dropdown_search.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:provider/provider.dart';

class ApplyPassCategoryScreen extends StatelessWidget {
  final ApplyPassCategory category;
  final VoidCallback onNext;

  const ApplyPassCategoryScreen({super.key,required this.onNext, required this.category});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplyPassCategoryNotifier(context, category),
      child: Consumer<ApplyPassCategoryNotifier>(
        builder: (context, applyPassCategoryNotifier, child) {
          return buildBody(context, applyPassCategoryNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return Column(
      children: [
        mainBody(context, applyPassCategoryNotifier),
      ],
    );
  }

  Widget mainBody(BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 25.h,
        right: 25.w,
        left: 25.w,
        top: 15.h,
      ),
      child: Form(
        key: applyPassCategoryNotifier.formKey,
        child: Column(
          children: [
            buildExpansionTile(
              title: "${context.watchLang.translate(AppLanguageText.one)}. ${context.watchLang.translate(AppLanguageText.visitorDetails)}",
              isVisitorDetails: true,
              children: visitorDetailsChildren(context, applyPassCategoryNotifier),
            ),
            15.verticalSpace,
            buildExpansionTile(
              title: "${context.watchLang.translate(AppLanguageText.two)}. ${context.watchLang.translate(AppLanguageText.visitDetails)}",
              children: visitDetailsChildren(context, applyPassCategoryNotifier),
            ),
            if(applyPassCategoryNotifier.isCheckedDevice) 15.verticalSpace,
            if(applyPassCategoryNotifier.isCheckedDevice) buildExpansionTile(
              title: "${context.watchLang.translate(AppLanguageText.three)}. ${context.watchLang.translate(AppLanguageText.deviceDetails)}",
              children: deviceDetailsChildren(context, applyPassCategoryNotifier),
            ),
            15.verticalSpace,
            buildExpansionTile(
              title: "${applyPassCategoryNotifier.isCheckedDevice ? context
                  .watchLang.translate(AppLanguageText.four) : context.watchLang
                  .translate(AppLanguageText.three)}. ${context.watchLang
                  .translate(AppLanguageText.attachments)}",
              children: attachmentsDetailsChildren(context, applyPassCategoryNotifier),
            ),
            15.verticalSpace,
            buildBulletList(context, applyPassCategoryNotifier),
            15.verticalSpace,
            userVerifyCheckbox(context, applyPassCategoryNotifier),
            15.verticalSpace,
            nextButton(context, applyPassCategoryNotifier),
          ],
        ),
      ),
    );
  }

  Widget buildExpansionTile({
    required String title,
    required List<Widget> children,
    isVisitorDetails = false,
  }) {
    return ExpansionTile(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      collapsedBackgroundColor: AppColors.whiteColor,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      childrenPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      initiallyExpanded: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppFonts.textRegular20,),
          if(isVisitorDetails) Text("(${category.name})", style: AppFonts.textMedium12,),
        ],
      ),
      children: children,
    );
  }

  Widget nextButton(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButton(
          text: context.watchLang.translate(AppLanguageText.next),
          iconData: LucideIcons.chevronRight,
          smallWidth: true,
          onPressed: !applyPassCategoryNotifier.isChecked ? null : () async {
            await applyPassCategoryNotifier.nextButton(context, onNext);
          },
        ),
      ],
    );
  }

  Widget userVerifyCheckbox(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                    applyPassCategoryNotifier.isChecked
                        ? AppColors.primaryColor
                        : AppColors.primaryColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  color:
                  applyPassCategoryNotifier.isChecked
                      ? AppColors.whiteColor
                      : Colors.transparent,
                ),
                child:
                applyPassCategoryNotifier.isChecked
                    ? Icon(Icons.check, size: 17, color: Colors.black)
                    : null,
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                context.watchLang.translate(
                    AppLanguageText.formSubmissionCertification),
                style: AppFonts.textRegular14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildBulletList(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return BulletList(
      [
        context.watchLang.translate(AppLanguageText.personalDataNotice),
        context.watchLang.translate(AppLanguageText.submitDataConsent),
        "${context.watchLang.translate(AppLanguageText.dataProcessingNotice)} ${context.watchLang.translate(AppLanguageText.privacyPolicyHere)}",
        context.watchLang.translate(AppLanguageText.acknowledgementStatement),
      ],
      onPrivacyPolicyTap: () {
        // Navigate or open link here
        applyPassCategoryNotifier.launchPrivacyUrl();
      },
    );
  }


  List<Widget> visitorDetailsChildren(BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return [
      visitorNameTextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      companyNameTextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      nationalityField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      phoneNumberTextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      emailTextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      idTypeField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      if (applyPassCategoryNotifier.selectedIdType == "National ID")
        nationalIdTextField(context, applyPassCategoryNotifier),
      if (applyPassCategoryNotifier.selectedIdType == "Passport")
        passportField(context, applyPassCategoryNotifier),
      if (applyPassCategoryNotifier.selectedIdType == "Iqama")
        iqamaField(context, applyPassCategoryNotifier),
      if (applyPassCategoryNotifier.selectedIdType == "Other")
        documentNameField(context, applyPassCategoryNotifier),
      if (applyPassCategoryNotifier.selectedIdType == "Other")
        15.verticalSpace,
      if (applyPassCategoryNotifier.selectedIdType == "Other")
        documentNumberField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      expirationDateTextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      vehicleNumberTextField(context, applyPassCategoryNotifier),
    ];
  }

  Widget visitorNameTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.visitorNameController,
      fieldName: context.watchLang.translate(AppLanguageText.visitorName),
      isSmallFieldFont: true,
      validator: CommonValidation().visitorNameValidator,
    );
  }

  Widget companyNameTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.companyNameController,
      fieldName: context.watchLang.translate(AppLanguageText.companyName),
      isSmallFieldFont: true,
      validator: CommonValidation().companyValidator,
    );
  }

  Widget phoneNumberTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.phoneNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.phoneNumber),
      isSmallFieldFont: true,
      validator: CommonValidation().validateMobile,
    );
  }

  Widget emailTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.emailController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      isSmallFieldFont: true,
      validator: CommonValidation().validateEmail,
    );
  }

  Widget nationalIdTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.nationalityIdController,
      fieldName: context.watchLang.translate(AppLanguageText.nationalID),
      isSmallFieldFont: true,
      validator: CommonValidation().validateNationalId,
    );
  }

  Widget expirationDateTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.expiryDateController,
      fieldName: applyPassCategoryNotifier.selectedIdType == "National ID"
          ? context.watchLang.translate(AppLanguageText.nationalIDExpiryDate)
          :
      applyPassCategoryNotifier.selectedIdType == "Iqama" ? context.watchLang
          .translate(AppLanguageText.iqamaExpiryDate) :
      applyPassCategoryNotifier.selectedIdType == "Passport" ? context.watchLang
          .translate(AppLanguageText.passportExpiryDate) :
      applyPassCategoryNotifier.selectedIdType == "Other"
          ? context.watchLang.translate(AppLanguageText.documentExpiryDateOther)
          : context.watchLang.translate(AppLanguageText.nationalIDExpiryDate),
      isSmallFieldFont: true,
      keyboardType: TextInputType.datetime,
      startDate: DateTime.now(),
      initialDate: applyPassCategoryNotifier.expiryDateController.text
          .isNotEmpty ? applyPassCategoryNotifier.expiryDateController.text
          .toDateTime() : DateTime.now(),
      validator: applyPassCategoryNotifier.selectedIdType == "National ID"
          ? CommonValidation().validateNationalIdExpiryDate
          : applyPassCategoryNotifier.selectedIdType == "Iqama"
          ? CommonValidation().validateIqamaExpiryDate
          : applyPassCategoryNotifier.selectedIdType == "Passport" ?
      CommonValidation().validatePassportExpiryDate :
      applyPassCategoryNotifier.selectedIdType == "Other" ? CommonValidation()
          .validateDocumentExpiryDate : CommonValidation()
          .validateNationalIdExpiryDate,
    );
  }

  Widget vehicleNumberTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.vehicleNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.vehicleNo),
      isSmallFieldFont: true,
      skipValidation: true,
      validator: CommonValidation().vehicleNumberValidator,
    );
  }

  // nationalityField
  Widget nationalityField(BuildContext
   context,ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<CountryData>(
      fieldName: context.watchLang.translate(AppLanguageText.nationality),
      hintText: 'Select Country',
      controller: applyPassCategoryNotifier.nationalityController,
      items: applyPassCategoryNotifier.nationalityMenu,
      itemLabel: (item) => item.name ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (country) {
        applyPassCategoryNotifier.selectedNationality = country?.iso3 ?? "";
      },
      validator: CommonValidation().nationalityValidator,
    );
  }

  // idTypeField
  Widget idTypeField(BuildContext
  context,ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<DocumentIdModel>(
      fieldName: context.watchLang.translate(AppLanguageText.idType),
      hintText: 'Select Id type',
      controller: applyPassCategoryNotifier.idTypeController,
      items: applyPassCategoryNotifier.idTypeMenu,
      itemLabel: (item) => item.labelEn ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (DocumentIdModel? menu) {
        applyPassCategoryNotifier.selectedIdValue = menu?.value.toString() ?? "";
        applyPassCategoryNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: CommonValidation().iDTypeValidator,
    );
  }

  // iqamaField
  Widget iqamaField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.iqamaController,
      fieldName: context.watchLang.translate(AppLanguageText.iqama),
      keyboardType: TextInputType.phone,
      isSmallFieldFont: true,
      validator: CommonValidation().validateIqama,
    );
  }

  // passportField
  Widget passportField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.passportNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.passportNumber),
      isSmallFieldFont: true,
      validator: CommonValidation().validatePassport,
    );
  }

  // documentNameField
  Widget documentNameField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.documentNameController,
      fieldName: context.watchLang.translate(AppLanguageText.documentNameOther),
      isSmallFieldFont: true,
      validator: CommonValidation().documentNameValidator,
    );
  }

  // documentNumberField
  Widget documentNumberField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.documentNumberController,
      fieldName: context.watchLang.translate(
        AppLanguageText.documentNumberOther,
      ),
      isSmallFieldFont: true,
      validator: CommonValidation().documentNumberValidator,
    );
  }

  List<Widget> visitDetailsChildren(BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return [
      locationTextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      visitRequestTypeTextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      visitPurposeTextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      mofaHostEmailTextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      visitStartDateTextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      visitEndDateTextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      noteTextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      deviceDetailCheckbox(context, applyPassCategoryNotifier)
    ];
  }

  Widget deviceDetailCheckbox(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              applyPassCategoryNotifier.deviceDetailChecked(context, !applyPassCategoryNotifier.isCheckedDevice);
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                  applyPassCategoryNotifier.isCheckedDevice
                      ? AppColors.primaryColor
                      : AppColors.primaryColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
                color:
                applyPassCategoryNotifier.isCheckedDevice
                    ? AppColors.whiteColor
                    : Colors.transparent,
              ),
              child:
              applyPassCategoryNotifier.isCheckedDevice
                  ? Icon(Icons.check, size: 17, color: Colors.black)
                  : null,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(
              context.watchLang.translate(
                  AppLanguageText.declareDevicesBroughtOnsite),
              style: AppFonts.textRegular14,
            ),
          ),
        ],
      ),
    );
  }


  Widget locationTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<LocationDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.location),
      hintText: 'Select...',
      controller: applyPassCategoryNotifier.locationController,
      items: applyPassCategoryNotifier.locationDropdownData,
      itemLabel: (item) => item.sLocationNameEn ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (LocationDropdownResult? menu) {
        applyPassCategoryNotifier.selectedLocationId = menu?.nLocationId ?? 0;
        // applyPassCategoryNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: CommonValidation().validateLocation,
    );
  }

  Widget visitRequestTypeTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<VisitRequestDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.visitRequestType),
      hintText: 'Select...',
      controller: applyPassCategoryNotifier.visitRequestTypeController,
      items: applyPassCategoryNotifier.visitRequestTypesDropdownData,
      itemLabel: (item) => item.sDescE ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (VisitRequestDropdownResult? menu) {
        applyPassCategoryNotifier.selectedVisitRequest = menu?.nDetailedCode.toString() ?? "";
        // applyPassCategoryNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: CommonValidation().validateVisitRequestType,
    );
  }

  Widget visitPurposeTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<VisitPurposeDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.visitPurpose),
      hintText: 'Select...',
      controller: applyPassCategoryNotifier.visitPurposeController,
      items: applyPassCategoryNotifier.visitPurposeDropdownData,
      itemLabel: (item) => item.sPurposeEn ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (VisitPurposeDropdownResult? menu) {
        applyPassCategoryNotifier.selectedVisitPurpose = menu?.nPurposeId.toString() ?? "";
        // applyPassCategoryNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: CommonValidation().validateVisitPurpose,
    );
  }

  Widget mofaHostEmailTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.mofaHostEmailController,
      fieldName: context.watchLang.translate(AppLanguageText.hostEmailAddress),
      isSmallFieldFont: true,
      validator: CommonValidation().validateMofaHostEmail,
    );
  }

  Widget visitStartDateTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.visitStartDateController,
      fieldName: context.watchLang.translate(AppLanguageText.visitStartDate),
      isSmallFieldFont: true,
      startDate: DateTime.now(),
      keyboardType: TextInputType.datetime,
      onChanged: (value) {
        try {
          final DateFormat formatter = DateFormat("dd/MM/yyyy ،hh:mm a");
          final DateTime selectedStart = formatter.parse(value);
          final DateTime oneHourLater = selectedStart.add(Duration(hours: 1));
          applyPassCategoryNotifier.visitEndDateController.text = formatter.format(oneHourLater);
          applyPassCategoryNotifier.notifyDataListeners();
        } catch (e) {
          // Handle parse error if needed
          debugPrint("Invalid date format: $e");
        }
      },
      needTime: true,
      validator: CommonValidation().validateVisitStartDate,
    );
  }

  Widget visitEndDateTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    DateTime? parsedStartDate;
    if (applyPassCategoryNotifier.visitStartDateController.text.isNotEmpty) {
      try {
        parsedStartDate = DateFormat("dd/MM/yyyy ،hh:mm a").parse(applyPassCategoryNotifier.visitStartDateController.text);
      } catch (e) {
        parsedStartDate = null;
        debugPrint("Failed to parse start date: $e");
      }
    }
    return CustomTextField(
      controller: applyPassCategoryNotifier.visitEndDateController,
      fieldName: context.watchLang.translate(AppLanguageText.visitEndDate),
      isSmallFieldFont: true,
      keyboardType: TextInputType.datetime,
      startDate: parsedStartDate,
      needTime: true,
      validator: CommonValidation().validateVisitEndDate,
      isEditable: applyPassCategoryNotifier.visitStartDateController.text.isEmpty,
    );
  }

  Widget noteTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return Column(
      children: [
        Text("${context.watchLang.translate(AppLanguageText.note)}: ${context
            .watchLang.translate(AppLanguageText.visitRequestDelay)} ",
            style: AppFonts.textRegular14Red),
        10.verticalSpace,
        CustomTextField(
          controller: applyPassCategoryNotifier.noteController,
          fieldName: context.watchLang.translate(AppLanguageText.note),
          isSmallFieldFont: true,
          skipValidation: true,
        ),
      ],
    );
  }


  List<Widget> deviceDetailsChildren(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return [
      addDeviceButton(context, applyPassCategoryNotifier),
      15.verticalSpace,
        deviceTable(applyPassCategoryNotifier),
      15.verticalSpace,
      if (applyPassCategoryNotifier.showDeviceFields) ...[
        deviceTypeTextField(context, applyPassCategoryNotifier),
        15.verticalSpace,
        deviceModelTextField(context, applyPassCategoryNotifier),
        15.verticalSpace,
        serialNumberTextField(context, applyPassCategoryNotifier),
        15.verticalSpace,
        devicePurposeTextField(context, applyPassCategoryNotifier),
        15.verticalSpace,
        saveAndCancel(context, applyPassCategoryNotifier),
      ],
    ];
  }

  Widget deviceTable(ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    final devices = applyPassCategoryNotifier.addedDevices;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: devices.isEmpty
          ? Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.buttonBgColor.withOpacity(0.5),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
            )),
            padding: const EdgeInsets.all(12),
            child: const Text(
              'Device Details',
              style: AppFonts.textBoldWhite14,
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No result found'),
          ),
        ],
      )
          : SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor:
          MaterialStateColor.resolveWith((states) => AppColors.buttonBgColor.withOpacity(0.5)),
          headingTextStyle: AppFonts.textBoldWhite14,
          border: TableBorder(borderRadius: BorderRadius.circular(8                                                                                                                                                     )),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          columnSpacing: 40,
          columns: const [
            DataColumn(label: Text('Device Type')),
            DataColumn(label: Text('Model')),
            DataColumn(label: Text('Serial No.')),
            DataColumn(label: Text('Purpose')),
            DataColumn(label: Text('Action')),
          ],
          rows: devices.asMap().entries.map((entry) {
            final index = entry.key;
            final device = entry.value;

            return DataRow(
              cells: [
                DataCell(Text(device.deviceTypeString ?? "")),
                DataCell(Text(device.deviceModel ?? "")),
                DataCell(Text(device.serialNumber ?? "")),
                DataCell(Text(device.devicePurposeString ?? "")),
                DataCell(
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => applyPassCategoryNotifier.startEditingDevice(index),
                        child: Container(
                          height: 28,
                          width: 48,
                          decoration: BoxDecoration(
                            color: AppColors.buttonBgColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Icon(LucideIcons.pencil, color: AppColors.whiteColor, size: 20,),
                        ),
                      ),
                      5.horizontalSpace,
                      GestureDetector(
                        onTap: () => applyPassCategoryNotifier.removeDevice(index),
                        child: Container(
                          height: 28,
                          width: 48,
                          decoration: BoxDecoration(
                            color: AppColors.textRedColor,
                            borderRadius: BorderRadius.circular(10)
                          ),
                          child: const Icon(LucideIcons.trash, color: AppColors.whiteColor, size: 20,),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget addDeviceButton(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return  CustomButton(
      text: context.watchLang.translate(AppLanguageText.addDevice),
      onPressed: () => applyPassCategoryNotifier.showDeviceFieldsAgain()
    );
  }

  Widget saveAndCancel(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(AppLanguageText.save),
            onPressed: () => applyPassCategoryNotifier.saveDevice(),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(AppLanguageText.cancel),
            backgroundColor: Colors.white,
            borderColor: AppColors.buttonBgColor,
            textFont: AppFonts.textBold14,
            onPressed: () => applyPassCategoryNotifier.cancelEditing(),
          ),
        ),
      ],
    );
  }

  Widget deviceModelTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.deviceModelController,
      fieldName: context.watchLang.translate(AppLanguageText.deviceModel),
      isSmallFieldFont: true,
      skipValidation: true,
      validator: CommonValidation().validateDeviceModel,
    );
  }

  Widget serialNumberTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.serialNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.serialNumber),
      isSmallFieldFont: true,
      skipValidation: true,
      validator: CommonValidation().validateSerialNumber,
    );
  }

  Widget deviceTypeTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.deviceType),
      hintText: 'Select...',
      controller: applyPassCategoryNotifier.deviceTypeController,
      items: applyPassCategoryNotifier.deviceTypeDropdownData,
      itemLabel: (item) => item.sDescE ?? 'Unknown',
      isSmallFieldFont: true,
      skipValidation: true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassCategoryNotifier.selectedDeviceType = menu?.nDetailedCode ?? 0;
      },
      validator: CommonValidation().validateDeviceType,
    );
  }

  Widget devicePurposeTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.devicePurpose),
      hintText: 'Select...',
      controller: applyPassCategoryNotifier.devicePurposeController,
      items: applyPassCategoryNotifier.devicePurposeDropdownData,
      itemLabel: (item) => item.sDescE ?? 'Unknown',
      isSmallFieldFont: true,
      skipValidation: true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassCategoryNotifier.selectedDevicePurpose = menu?.nDetailedCode ?? 0;
      },
      validator: CommonValidation().validateDevicePurpose,
    );
  }

  List<Widget> attachmentsDetailsChildren(BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return [
      buildUploadImageSection(context, applyPassCategoryNotifier),
      15.verticalSpace,
      buildUploadDocumentSection(context, applyPassCategoryNotifier),
      15.verticalSpace,
      buildUploadVehicleRegistrationSection(context, applyPassCategoryNotifier),
      15.verticalSpace,
      Align(
        alignment: Alignment.centerLeft,
        child: Text("${context.watchLang.translate(AppLanguageText.note)}: ${context
            .watchLang.translate(AppLanguageText.latestPhoto)} ",
            style: AppFonts.textRegular14Red),
      ),
    ];
  }

  Widget buildUploadImageSection(BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(context.watchLang.translate(AppLanguageText.uploadPhoto), style: AppFonts.textRegular14),
            3.horizontalSpace,
            Text("*",
              style: TextStyle(
                fontSize: 15, color: AppColors.textRedColor,
              ),
            ),
            3.horizontalSpace,
            Tooltip(
              message: "Upload a recent passport-sized\n photo (JPG, PNG, or JPEG).\n Ensure the image is clear and meets\n official guidelines.",
              textAlign: TextAlign.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(Icons.info_outline, size: 20,
                color: AppColors.primaryColor,),
            ),
          ],
        ),
        5.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                applyPassCategoryNotifier.uploadedImageFile?.path
                    .split('/')
                    .last ?? context.watchLang.translate(AppLanguageText.noFileSelected),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: CustomUploadButton(
                text: context.watchLang.translate(AppLanguageText.uploadFile), onPressed: () async {
                showModalBottomSheet(
                  context: context,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  backgroundColor: Colors.white,
                  builder: (context) {
                    return Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Upload Image",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              uploadOptionCard(
                                icon: LucideIcons.camera,
                                label: "Camera",
                                onTap: () async {
                                  Navigator.pop(context);
                                  await applyPassCategoryNotifier.uploadImage(
                                    fromCamera: true,
                                    cropAfterPick: true,
                                  );
                                },
                              ),
                              uploadOptionCard(
                                icon: LucideIcons.image,
                                label: "Device",
                                onTap: () async {
                                  Navigator.pop(context);
                                  await applyPassCategoryNotifier.uploadImage(
                                    fromCamera: false,
                                    cropAfterPick: true,
                                  );
                                },
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    );
                  },
                );
              },),
            )
          ],
        ),
        Divider(
          height: 10,
          indent: 0,
          thickness: 1,
        ),
        if(applyPassCategoryNotifier.photoUploadValidation)
          Text("Photo upload is required.", style: AppFonts.errorTextRegular12),
        5.verticalSpace,
        if (applyPassCategoryNotifier.getByIdResult?.user?.havePhoto == 1)
          GestureDetector(
            onTap: () async {
              await applyPassCategoryNotifier.apiGetFile(context, type: 1);
              showDialog(
                context: context,
                builder: (_) =>
                    AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 5.w, vertical: 5.h),
                      content: ClipRRect(
                        borderRadius: BorderRadius.circular(6.0),
                        child: Image.memory(
                            applyPassCategoryNotifier.uploadedImageBytes!),
                      ),
                    ),
              );
            },
            child: Text(
              context.watchLang.translate(AppLanguageText.viewAttachment),
              style: AppFonts.textRegularAttachment14,),)
      ],
    );
  }

  Widget uploadOptionCard({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.buttonBgColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: AppColors.buttonBgColor),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget buildUploadDocumentSection(BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('Upload ${applyPassCategoryNotifier.selectedIdType}', style: AppFonts.textRegular14),
            3.horizontalSpace,
            Text("*",
              style: TextStyle(
                fontSize: 15, color: AppColors.textRedColor,
              ),
            ),
          ],
        ),
        5.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                applyPassCategoryNotifier.uploadedDocumentFile?.path
                    .split('/')
                    .last ?? context.watchLang.translate(AppLanguageText.noFileSelected),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: CustomUploadButton(
                text: context.watchLang.translate(AppLanguageText.uploadFile), onPressed: () async {
                await applyPassCategoryNotifier.uploadDocument();
              },),
            )
          ],
        ),
        Divider(
          height: 10,
          indent: 0,
          thickness: 1,
        ),
        if(applyPassCategoryNotifier.documentUploadValidation)
          Text("${applyPassCategoryNotifier.selectedIdType} upload is required.", style: AppFonts.errorTextRegular12),
        5.verticalSpace,
        if (applyPassCategoryNotifier.getByIdResult?.user?.haveEid == 1
            || applyPassCategoryNotifier.getByIdResult?.user?.haveIqama == 1 || applyPassCategoryNotifier.getByIdResult?.user?.havePassport == 1
            || applyPassCategoryNotifier.getByIdResult?.user?.haveOthers == 1)
          GestureDetector(
            onTap: () async {
              int type = 1;
              if(applyPassCategoryNotifier.selectedIdType == "National ID") type = 2;
              if(applyPassCategoryNotifier.selectedIdType == "Passport") type = 3;
              if(applyPassCategoryNotifier.selectedIdType == "Iqama") type = 5;
              if(applyPassCategoryNotifier.selectedIdType == "Other") type = 6;
              await applyPassCategoryNotifier.apiGetFile(context, type: type);
            },
            child: Text(
              context.watchLang.translate(AppLanguageText.viewAttachment), style: AppFonts.textRegularAttachment14,),)
      ],
    );
  }

  Widget buildUploadVehicleRegistrationSection(BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.watchLang.translate(AppLanguageText.vehicleRegistrationLicense), style: AppFonts.textRegular14),
        5.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                applyPassCategoryNotifier.uploadedVehicleRegistrationFile?.path
                    .split('/')
                    .last ?? context.watchLang.translate(AppLanguageText.noFileSelected),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: CustomUploadButton(
                text: context.watchLang.translate(AppLanguageText.uploadFile),
                onPressed: () async {
                  await applyPassCategoryNotifier.uploadVehicleRegistrationImage();
                },),
            )
          ],
        ),
        Divider(
          height: 10,
          indent: 0,
          thickness: 1,
        ),
        5.verticalSpace,
        if (applyPassCategoryNotifier.getByIdResult?.user?.haveVehicleRegistration == 1)
          GestureDetector(
            onTap: () async {
              await applyPassCategoryNotifier.apiGetFile(context, type: 4);
            },
            child: Text(
              context.watchLang.translate(AppLanguageText.viewAttachment), style: AppFonts.textRegularAttachment14,),)
      ],
    );
  }
}
