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
import 'package:mofa/model/document/document_id_model.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/apply_pass_group/apply_pass_group_notifier.dart';
import 'package:mofa/utils/common/widgets/bullet_list.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_dropdown_search.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:mofa/utils/common_validation.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:provider/provider.dart';

class ApplyPassGroupScreen extends StatelessWidget {
  final ApplyPassCategory category;
  final VoidCallback onNext;
  final bool isUpdate;
  final int? id;

  const ApplyPassGroupScreen({
    super.key,
    required this.onNext,
    required this.category,
    this.isUpdate = false,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplyPassGroupNotifier(context, category),
      child: Consumer<ApplyPassGroupNotifier>(
        builder: (context, applyPassGroupNotifier, child) {
          return buildBody(context, applyPassGroupNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context,
      ApplyPassGroupNotifier applyPassGroupNotifier,) {
    return Column(children: [mainBody(context, applyPassGroupNotifier)]);
  }

  Widget mainBody(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 25.h,
        right: 25.w,
        left: 25.w,
        top: 15.h,
      ),
      child: Form(
        key: applyPassGroupNotifier.formKey,
        child: Column(
          children: [
            buildExpansionTile(
              title:
                  "${context.watchLang.translate(AppLanguageText.one)}. ${context.watchLang.translate(AppLanguageText.visitDetails)}",
              children: visitDetailsChildren(context, applyPassGroupNotifier),
            ),
            if (applyPassGroupNotifier.isCheckedDevice) 15.verticalSpace,
            if (applyPassGroupNotifier.isCheckedDevice)
              buildExpansionTile(
                title:
                    "${context.watchLang.translate(AppLanguageText.two)}. ${context.watchLang.translate(AppLanguageText.deviceDetails)}",
                children: deviceDetailsChildren(
                  context,
                  applyPassGroupNotifier,
                ),
              ),
            15.verticalSpace,
            buildExpansionTile(
              title:
                  "${applyPassGroupNotifier.isCheckedDevice ? context.watchLang.translate(AppLanguageText.three) : context.watchLang.translate(AppLanguageText.two)}. ${context.watchLang.translate(AppLanguageText.visitorDetails)}",
              children: groupVisitorDetailsChildren(
                context,
                applyPassGroupNotifier,
              ),
            ),
            15.verticalSpace,
            buildBulletList(context, applyPassGroupNotifier),
            15.verticalSpace,
            userVerifyCheckbox(context, applyPassGroupNotifier),
            15.verticalSpace,
            nextButton(context, applyPassGroupNotifier),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      collapsedBackgroundColor: AppColors.whiteColor,
      collapsedShape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      childrenPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      initiallyExpanded: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppFonts.textRegular20),
          if (isVisitorDetails)
            Text("(${category.name})", style: AppFonts.textMedium12),
        ],
      ),
      children: children,
    );
  }

  Widget nextButton(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButton(
          text: context.watchLang.translate(AppLanguageText.next),
          iconData: LucideIcons.chevronRight,
          smallWidth: true,
          onPressed:
              !applyPassGroupNotifier.isChecked
                  ? null
                  : () async {
                    await applyPassGroupNotifier.nextButton(context, onNext);
                  },
        ),
      ],
    );
  }

  Widget userVerifyCheckbox(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: GestureDetector(
              onTap: () {
                applyPassGroupNotifier.userVerifyChecked(
                  context,
                  !applyPassGroupNotifier.isChecked,
                );
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        applyPassGroupNotifier.isChecked
                            ? AppColors.primaryColor
                            : AppColors.primaryColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  color:
                      applyPassGroupNotifier.isChecked
                          ? AppColors.whiteColor
                          : Colors.transparent,
                ),
                child:
                    applyPassGroupNotifier.isChecked
                        ? Icon(Icons.check, size: 17, color: Colors.black)
                        : null,
              ),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(
              context.watchLang.translate(
                AppLanguageText.formSubmissionCertification,
              ),
              style: AppFonts.textRegular14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBulletList(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return BulletList(
      [
        context.watchLang.translate(AppLanguageText.personalDataNotice),
        context.watchLang.translate(AppLanguageText.submitDataConsent),
        "${context.watchLang.translate(AppLanguageText.dataProcessingNotice)} ${context.watchLang.translate(AppLanguageText.privacyPolicyHere)}",
        context.watchLang.translate(AppLanguageText.acknowledgementStatement),
      ],
      onPrivacyPolicyTap: () {
        // Navigate or open link here
        applyPassGroupNotifier.launchPrivacyUrl();
      },
    );
  }

  List<Widget> visitDetailsChildren(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return [
      locationTextField(context, applyPassGroupNotifier),
      15.verticalSpace,
      visitRequestTypeTextField(context, applyPassGroupNotifier),
      15.verticalSpace,
      visitPurposeTextField(context, applyPassGroupNotifier),
      15.verticalSpace,
      mofaHostEmailTextField(context, applyPassGroupNotifier),
      15.verticalSpace,
      visitStartDateTextField(context, applyPassGroupNotifier),
      15.verticalSpace,
      visitEndDateTextField(context, applyPassGroupNotifier),
      15.verticalSpace,
      noteTextField(context, applyPassGroupNotifier),
      15.verticalSpace,
      deviceDetailCheckbox(context, applyPassGroupNotifier),
    ];
  }

  Widget deviceDetailCheckbox(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
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
              applyPassGroupNotifier.deviceDetailChecked(
                context,
                !applyPassGroupNotifier.isCheckedDevice,
              );
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color:
                      applyPassGroupNotifier.isCheckedDevice
                          ? AppColors.primaryColor
                          : AppColors.primaryColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
                color:
                    applyPassGroupNotifier.isCheckedDevice
                        ? AppColors.whiteColor
                        : Colors.transparent,
              ),
              child:
                  applyPassGroupNotifier.isCheckedDevice
                      ? Icon(Icons.check, size: 17, color: Colors.black)
                      : null,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(
              context.watchLang.translate(
                AppLanguageText.declareDevicesBroughtOnsite,
              ),
              style: AppFonts.textRegular14,
            ),
          ),
        ],
      ),
    );
  }

  Widget locationTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomSearchDropdown<LocationDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.location),
      hintText: 'Select...',
      controller: applyPassGroupNotifier.locationController,
      items: applyPassGroupNotifier.locationDropdownData,
      itemLabel: (item) => item.sLocationNameEn ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (LocationDropdownResult? menu) {
        applyPassGroupNotifier.selectedLocationId = menu?.nLocationId ?? 0;
        // applyPassGroupNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: CommonValidation().validateLocation,
    );
  }

  Widget visitRequestTypeTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomSearchDropdown<VisitRequestDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.visitRequestType),
      hintText: 'Select...',
      controller: applyPassGroupNotifier.visitRequestTypeController,
      items: applyPassGroupNotifier.visitRequestTypesDropdownData,
      itemLabel: (item) => item.sDescE ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (VisitRequestDropdownResult? menu) {
        applyPassGroupNotifier.selectedVisitRequest =
            menu?.nDetailedCode.toString() ?? "";
        // applyPassGroupNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: CommonValidation().validateVisitRequestType,
    );
  }

  Widget visitPurposeTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomSearchDropdown<VisitPurposeDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.visitPurpose),
      hintText: 'Select...',
      controller: applyPassGroupNotifier.visitPurposeController,
      items: applyPassGroupNotifier.visitPurposeDropdownData,
      itemLabel: (item) => item.sPurposeEn ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (VisitPurposeDropdownResult? menu) {
        applyPassGroupNotifier.selectedVisitPurpose =
            menu?.nPurposeId.toString() ?? "";
        // applyPassGroupNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: CommonValidation().validateVisitPurpose,
    );
  }

  Widget mofaHostEmailTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.mofaHostEmailController,
      fieldName: context.watchLang.translate(AppLanguageText.hostEmailAddress),
      isSmallFieldFont: true,
      validator: CommonValidation().validateMofaHostEmail,
    );
  }

  Widget visitStartDateTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.visitStartDateController,
      fieldName: context.watchLang.translate(AppLanguageText.visitStartDate),
      isSmallFieldFont: true,
      keyboardType: TextInputType.datetime,
      startDate: DateTime.now(),
      onChanged: (value) {
        try {
          final DateFormat formatter = DateFormat("dd/MM/yyyy ،hh:mm a");
          final DateTime selectedStart = formatter.parse(value);
          final DateTime oneHourLater = selectedStart.add(Duration(hours: 1));
          applyPassGroupNotifier.visitEndDateController.text = formatter.format(oneHourLater);
          applyPassGroupNotifier.notifyDataListeners();
        } catch (e) {
          // Handle parse error if needed
          debugPrint("Invalid date format: $e");
        }
      },
      needTime: true,
      validator: CommonValidation().validateVisitStartDate,
    );
  }

  Widget visitEndDateTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    DateTime? parsedStartDate;
    if (applyPassGroupNotifier.visitStartDateController.text.isNotEmpty) {
      try {
        parsedStartDate = DateFormat("dd/MM/yyyy ،hh:mm a").parse(applyPassGroupNotifier.visitStartDateController.text);
      } catch (e) {
        parsedStartDate = null;
        debugPrint("Failed to parse start date: $e");
      }
    }
    return CustomTextField(
      controller: applyPassGroupNotifier.visitEndDateController,
      fieldName: context.watchLang.translate(AppLanguageText.visitEndDate),
      isSmallFieldFont: true,
      keyboardType: TextInputType.datetime,
      needTime: true,
      startDate: parsedStartDate,
      validator: CommonValidation().validateVisitEndDate,
    );
  }

  Widget noteTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.noteController,
      fieldName: context.watchLang.translate(AppLanguageText.note),
      isSmallFieldFont: true,
      skipValidation: true,
    );
  }

  List<Widget> deviceDetailsChildren(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return [
      addDeviceButton(context, applyPassGroupNotifier),
      15.verticalSpace,
      deviceTable(applyPassGroupNotifier),
      15.verticalSpace,
      if (applyPassGroupNotifier.showDeviceFields) ...[
        deviceTypeTextField(context, applyPassGroupNotifier),
        15.verticalSpace,
        deviceModelTextField(context, applyPassGroupNotifier),
        15.verticalSpace,
        serialNumberTextField(context, applyPassGroupNotifier),
        15.verticalSpace,
        devicePurposeTextField(context, applyPassGroupNotifier),
        15.verticalSpace,
        saveAndCancel(context, applyPassGroupNotifier),
      ],
    ];
  }

  Widget deviceTable(ApplyPassGroupNotifier applyPassGroupNotifier) {
    final devices = applyPassGroupNotifier.addedDevices;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          devices.isEmpty
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
                      ),
                    ),
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
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => AppColors.buttonBgColor.withOpacity(0.5),
                  ),
                  headingTextStyle: AppFonts.textBoldWhite14,
                  border: TableBorder(borderRadius: BorderRadius.circular(8)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  columnSpacing: 40,
                  columns: const [
                    DataColumn(label: Text('Device Type')),
                    DataColumn(label: Text('Model')),
                    DataColumn(label: Text('Serial No.')),
                    DataColumn(label: Text('Purpose')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows:
                      devices.asMap().entries.map((entry) {
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
                                    onTap:
                                        () => applyPassGroupNotifier
                                            .startEditingDevice(index),
                                    child: Container(
                                      height: 28,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.buttonBgColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        LucideIcons.pencil,
                                        color: AppColors.whiteColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  5.horizontalSpace,
                                  GestureDetector(
                                    onTap:
                                        () => applyPassGroupNotifier
                                            .removeDevice(index),
                                    child: Container(
                                      height: 28,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.textRedColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        LucideIcons.trash,
                                        color: AppColors.whiteColor,
                                        size: 20,
                                      ),
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

  Widget addDeviceButton(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomButton(
      text: context.watchLang.translate(AppLanguageText.addDevice),
      onPressed: () => applyPassGroupNotifier.showDeviceFieldsAgain(),
    );
  }

  Widget addVisitorsButton(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomButton(
      text: context.watchLang.translate(AppLanguageText.addVisitor),
      onPressed: () => applyPassGroupNotifier.showVisitorsFieldsAgain(),
    );
  }

  Widget saveAndCancel(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(AppLanguageText.save),
            onPressed: () => applyPassGroupNotifier.saveDevice(),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(AppLanguageText.cancel),
            backgroundColor: Colors.white,
            borderColor: AppColors.buttonBgColor,
            textFont: AppFonts.textBold14,
            onPressed: () => applyPassGroupNotifier.cancelDeviceEditing(),
          ),
        ),
      ],
    );
  }

  Widget saveAndCancelVisitors(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(AppLanguageText.save),
            onPressed: () => applyPassGroupNotifier.saveVisitors(context),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(AppLanguageText.cancel),
            backgroundColor: Colors.white,
            borderColor: AppColors.buttonBgColor,
            textFont: AppFonts.textBold14,
            onPressed: () => applyPassGroupNotifier.cancelVisitorsEditing(),
          ),
        ),
      ],
    );
  }

  Widget deviceModelTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.deviceModelController,
      fieldName: context.watchLang.translate(AppLanguageText.deviceModel),
      isSmallFieldFont: true,
      skipValidation: true,
      validator: CommonValidation().validateDeviceModel,
    );
  }

  Widget serialNumberTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.serialNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.serialNumber),
      isSmallFieldFont: true,
      skipValidation: true,
      validator: CommonValidation().validateSerialNumber,
    );
  }

  Widget deviceTypeTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.deviceType),
      hintText: 'Select...',
      controller: applyPassGroupNotifier.deviceTypeController,
      items: applyPassGroupNotifier.deviceTypeDropdownData,
      itemLabel: (item) => item.sDescE ?? 'Unknown',
      isSmallFieldFont: true,
      skipValidation: true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassGroupNotifier.selectedDeviceType = menu?.nDetailedCode ?? 0;
      },
      validator: CommonValidation().validateDeviceType,
    );
  }

  Widget devicePurposeTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.devicePurpose),
      hintText: 'Select...',
      controller: applyPassGroupNotifier.devicePurposeController,
      items: applyPassGroupNotifier.devicePurposeDropdownData,
      itemLabel: (item) => item.sDescE ?? 'Unknown',
      isSmallFieldFont: true,
      skipValidation: true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassGroupNotifier.selectedDevicePurpose = menu?.nDetailedCode ?? 0;
      },
      validator: CommonValidation().validateDevicePurpose,
    );
  }

  List<Widget> groupVisitorDetailsChildren(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return [
      addVisitorsButton(context, applyPassGroupNotifier),
      15.verticalSpace,
      visitorTable(applyPassGroupNotifier),
      15.verticalSpace,
      if (applyPassGroupNotifier.showVisitorsFields) ...[
        visitorNameTextField(context, applyPassGroupNotifier),
        15.verticalSpace,
        companyNameTextField(context, applyPassGroupNotifier),
        15.verticalSpace,
        phoneNumberTextField(context, applyPassGroupNotifier),
        15.verticalSpace,
        emailTextField(context, applyPassGroupNotifier),
        15.verticalSpace,
        nationalityField(context, applyPassGroupNotifier),
        15.verticalSpace,
        idTypeField(context, applyPassGroupNotifier),
        15.verticalSpace,
        if (applyPassGroupNotifier.selectedIdType == "National ID")
          nationalIdTextField(context, applyPassGroupNotifier),
        if (applyPassGroupNotifier.selectedIdType == "Passport")
          passportField(context, applyPassGroupNotifier),
        if (applyPassGroupNotifier.selectedIdType == "Iqama")
          iqamaField(context, applyPassGroupNotifier),
        if (applyPassGroupNotifier.selectedIdType == "Other")
          documentNameField(context, applyPassGroupNotifier),
        if (applyPassGroupNotifier.selectedIdType == "Other") 15.verticalSpace,
        if (applyPassGroupNotifier.selectedIdType == "Other")
          documentNumberField(context, applyPassGroupNotifier),
        15.verticalSpace,
        expirationDateTextField(context, applyPassGroupNotifier),
        15.verticalSpace,
        vehicleNumberTextField(context, applyPassGroupNotifier),
        15.verticalSpace,
        buildUploadImageSection(context, applyPassGroupNotifier),
        15.verticalSpace,
        buildUploadDocumentSection(context, applyPassGroupNotifier),
        15.verticalSpace,
        buildUploadVehicleRegistrationSection(context, applyPassGroupNotifier),
        15.verticalSpace,
        saveAndCancelVisitors(context, applyPassGroupNotifier),
      ],
    ];
  }

  Widget visitorTable(ApplyPassGroupNotifier applyPassGroupNotifier) {
    final visitors = applyPassGroupNotifier.addedVisitors;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          visitors.isEmpty
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
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: const Text(
                      'Visitors Details',
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
                  headingRowColor: MaterialStateColor.resolveWith(
                    (states) => AppColors.buttonBgColor.withOpacity(0.5),
                  ),
                  headingTextStyle: AppFonts.textBoldWhite14,
                  border: TableBorder(borderRadius: BorderRadius.circular(8)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  columnSpacing: 40,
                  columns: const [
                    DataColumn(label: Text('Visitor Name')),
                    DataColumn(label: Text('Company Name')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Contact Number')),
                    DataColumn(label: Text('ID Type')),
                    DataColumn(label: Text('ID Number')),
                    DataColumn(label: Text('ID Expiry Date')),
                    DataColumn(label: Text('Nationality')),
                    DataColumn(label: Text('Vehicle No.')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows:
                      visitors.asMap().entries.map((entry) {
                        final index = entry.key;
                        final visitor = entry.value;

                        return DataRow(
                          cells: [
                            DataCell(Text(visitor.visitorName)),
                            DataCell(Text(visitor.companyName)),
                            DataCell(Text(visitor.email)),
                            DataCell(Text(visitor.mobileNumber)),
                            DataCell(Text(visitor.idType)),
                            DataCell(Text(visitor.documentId)),
                            DataCell(Text(visitor.expiryDate)),
                            DataCell(Text(visitor.nationality)),
                            DataCell(Text(visitor.vehicleNumber)),
                            DataCell(
                              Row(
                                children: [
                                  GestureDetector(
                                    onTap:
                                        () => applyPassGroupNotifier
                                            .startEditingVisitors(index),
                                    child: Container(
                                      height: 28,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.buttonBgColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        LucideIcons.pencil,
                                        color: AppColors.whiteColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                  5.horizontalSpace,
                                  GestureDetector(
                                    onTap:
                                        () => applyPassGroupNotifier
                                            .removeVisitors(index),
                                    child: Container(
                                      height: 28,
                                      width: 48,
                                      decoration: BoxDecoration(
                                        color: AppColors.textRedColor,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Icon(
                                        LucideIcons.trash,
                                        color: AppColors.whiteColor,
                                        size: 20,
                                      ),
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

  Widget buildUploadImageSection(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              context.watchLang.translate(AppLanguageText.uploadPhoto),
              style: AppFonts.textRegular14,
            ),
            3.horizontalSpace,
            Text(
              "*",
              style: TextStyle(fontSize: 15, color: AppColors.textRedColor),
            ),
            3.horizontalSpace,
            Tooltip(
              message:
                  "Upload a recent passport-sized\n photo (JPG, PNG, or JPEG).\n Ensure the image is clear and meets\n official guidelines.",
              textAlign: TextAlign.center,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Icon(
                Icons.info_outline,
                size: 20,
                color: AppColors.primaryColor,
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
                applyPassGroupNotifier.uploadedImageFile?.path
                        .split('/')
                        .last ??
                    context.watchLang.translate(AppLanguageText.noFileSelected),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: CustomUploadButton(
                text: context.watchLang.translate(AppLanguageText.uploadFile),
                onPressed: () async {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
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
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
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
                                    await applyPassGroupNotifier.uploadImage(
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
                                    await applyPassGroupNotifier.uploadImage(
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
                },
              ),
            ),
          ],
        ),
        Divider(height: 10, indent: 0, thickness: 1),
        if(applyPassGroupNotifier.photoUploadValidation)
          Text("Photo upload is required.", style: AppFonts.errorTextRegular12),
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

  Widget buildUploadDocumentSection(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Upload ${applyPassGroupNotifier.selectedIdType}',
              style: AppFonts.textRegular14,
            ),
            3.horizontalSpace,
            Text(
              "*",
              style: TextStyle(fontSize: 15, color: AppColors.textRedColor),
            ),
          ],
        ),
        5.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                applyPassGroupNotifier.uploadedDocumentFile?.path
                        .split('/')
                        .last ??
                    context.watchLang.translate(AppLanguageText.noFileSelected),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: CustomUploadButton(
                text: context.watchLang.translate(AppLanguageText.uploadFile),
                onPressed: () async {
                  await applyPassGroupNotifier.uploadDocument();
                },
              ),
            ),
          ],
        ),
        Divider(height: 10, indent: 0, thickness: 1),
        if(applyPassGroupNotifier.documentUploadValidation)
          Text("${applyPassGroupNotifier.selectedIdType} upload is required.", style: AppFonts.errorTextRegular12),
      ],
    );
  }

  Widget buildUploadVehicleRegistrationSection(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.watchLang.translate(
            AppLanguageText.vehicleRegistrationLicense,
          ),
          style: AppFonts.textRegular14,
        ),
        5.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                applyPassGroupNotifier.uploadedVehicleRegistrationFile?.path
                        .split('/')
                        .last ??
                    context.watchLang.translate(AppLanguageText.noFileSelected),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: CustomUploadButton(
                text: context.watchLang.translate(AppLanguageText.uploadFile),
                onPressed: () async {
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
                              "Upload Vehicle Registration Image",
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
                                    await applyPassGroupNotifier.uploadVehicleRegistrationImage(
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
                                    await applyPassGroupNotifier.uploadVehicleRegistrationImage(
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
                },
              ),
            ),
          ],
        ),
        Divider(height: 10, indent: 0, thickness: 1),
      ],
    );
  }

  Widget visitorNameTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.visitorNameController,
      fieldName: context.watchLang.translate(AppLanguageText.visitorName),
      isSmallFieldFont: true,
      validator: CommonValidation().visitorNameValidator,
    );
  }

  Widget companyNameTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.companyNameController,
      fieldName: context.watchLang.translate(AppLanguageText.companyName),
      isSmallFieldFont: true,
      validator: CommonValidation().companyValidator,
    );
  }

  Widget phoneNumberTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.phoneNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.phoneNumber),
      isSmallFieldFont: true,
      validator: CommonValidation().validateMobile,
    );
  }

  Widget emailTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.emailController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      isSmallFieldFont: true,
      validator: CommonValidation().validateEmail,
    );
  }

  Widget nationalIdTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.nationalityIdController,
      fieldName: context.watchLang.translate(AppLanguageText.nationalID),
      isSmallFieldFont: true,
      validator: CommonValidation().validateNationalId,
    );
  }

  Widget expirationDateTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.expiryDateController,
      fieldName:
          applyPassGroupNotifier.selectedIdType == "National ID"
              ? context.watchLang.translate(
                AppLanguageText.nationalIDExpiryDate,
              )
              : applyPassGroupNotifier.selectedIdType == "Iqama"
              ? context.watchLang.translate(AppLanguageText.iqamaExpiryDate)
              : applyPassGroupNotifier.selectedIdType == "Passport"
              ? context.watchLang.translate(AppLanguageText.passportExpiryDate)
              : applyPassGroupNotifier.selectedIdType == "Other"
              ? context.watchLang.translate(
                AppLanguageText.documentExpiryDateOther,
              )
              : context.watchLang.translate(
                AppLanguageText.nationalIDExpiryDate,
              ),
      isSmallFieldFont: true,
      keyboardType: TextInputType.datetime,
      startDate: DateTime.now(),
      validator:
          applyPassGroupNotifier.selectedIdType == "National ID"
              ? CommonValidation().validateNationalIdExpiryDate
              : applyPassGroupNotifier.selectedIdType == "Iqama"
              ? CommonValidation().validateIqamaExpiryDate
              : applyPassGroupNotifier.selectedIdType == "Passport"
              ? CommonValidation().validatePassportExpiryDate
              : applyPassGroupNotifier.selectedIdType == "Other"
              ? CommonValidation().validateDocumentExpiryDate
              : CommonValidation().validateNationalIdExpiryDate,
    );
  }

  Widget vehicleNumberTextField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.vehicleNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.vehicleNo),
      isSmallFieldFont: true,
      skipValidation: true,
      validator: CommonValidation().vehicleNumberValidator,
    );
  }

  // nationalityField
  Widget nationalityField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomSearchDropdown<CountryData>(
      fieldName: context.watchLang.translate(AppLanguageText.nationality),
      hintText: 'Select Country',
      controller: applyPassGroupNotifier.nationalityController,
      items: applyPassGroupNotifier.nationalityMenu,
      itemLabel: (item) => item.name ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (country) {
        applyPassGroupNotifier.selectedNationality = country?.iso3 ?? "";
      },
      validator: CommonValidation().nationalityValidator,
    );
  }

  // idTypeField
  Widget idTypeField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomSearchDropdown<DocumentIdModel>(
      fieldName: context.watchLang.translate(AppLanguageText.idType),
      hintText: 'Select Id type',
      controller: applyPassGroupNotifier.idTypeController,
      items: applyPassGroupNotifier.idTypeMenu,
      itemLabel: (item) => item.labelEn ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (DocumentIdModel? menu) {
        applyPassGroupNotifier.selectedIdValue = menu?.value.toString() ?? "";
        applyPassGroupNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: CommonValidation().iDTypeValidator,
    );
  }

  // iqamaField
  Widget iqamaField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.iqamaController,
      fieldName: context.watchLang.translate(AppLanguageText.iqama),
      keyboardType: TextInputType.phone,
      isSmallFieldFont: true,
      validator: CommonValidation().validateIqama,
    );
  }

  // passportField
  Widget passportField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.passportNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.passportNumber),
      isSmallFieldFont: true,
      validator: CommonValidation().validatePassport,
    );
  }

  // documentNameField
  Widget documentNameField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.documentNameController,
      fieldName: context.watchLang.translate(AppLanguageText.documentNameOther),
      isSmallFieldFont: true,
      validator: CommonValidation().documentNameValidator,
    );
  }

  // documentNumberField
  Widget documentNumberField(
    BuildContext context,
    ApplyPassGroupNotifier applyPassGroupNotifier,
  ) {
    return CustomTextField(
      controller: applyPassGroupNotifier.documentNumberController,
      fieldName: context.watchLang.translate(
        AppLanguageText.documentNumberOther,
      ),
      isSmallFieldFont: true,
      validator: CommonValidation().documentNumberValidator,
    );
  }
}
