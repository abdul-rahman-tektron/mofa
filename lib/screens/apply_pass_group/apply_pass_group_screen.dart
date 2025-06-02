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
import 'package:mofa/utils/extensions.dart';
import 'package:provider/provider.dart';

class ApplyPassGroupScreen extends StatelessWidget {
  final ApplyPassCategory category;
  final VoidCallback onNext;
  final bool isUpdate;
  final int? id;

  const ApplyPassGroupScreen({super.key, required this.onNext, required this.category, this.isUpdate = false, this.id});

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

  Widget buildBody(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    final lang = context.watchLang;
    int stepCounter = 1;

    String stepTitle(String label) => "${stepCounter++}. ${lang.translate(label)}";

    List<Widget> children = [];

    children.add(
      buildExpansionTile(
        title: stepTitle(AppLanguageText.visitDetails),
        children: visitDetailsChildren(context, applyPassGroupNotifier),
      ),
    );

    children.add(15.verticalSpace);

    if (applyPassGroupNotifier.isCheckedVehicle) {
      children.add(
        buildExpansionTile(
          title: stepTitle(AppLanguageText.vehicleInformation),
          children: vehicleDetailsChildren(context, applyPassGroupNotifier),
        ),
      );
    }

    if (applyPassGroupNotifier.isCheckedDevice) {
      children.add(15.verticalSpace);
      children.add(
        buildExpansionTile(
          title: stepTitle(AppLanguageText.deviceDetails),
          children: deviceDetailsChildren(context, applyPassGroupNotifier),
        ),
      );
    }

    children.add(15.verticalSpace);

    children.add(
      buildExpansionTile(
        title: stepTitle(AppLanguageText.visitorDetails),
        children: groupVisitorDetailsChildren(context, applyPassGroupNotifier),
      ),
    );

    children.add(15.verticalSpace);
    children.add(buildBulletList(context, applyPassGroupNotifier));
    children.add(15.verticalSpace);
    children.add(userVerifyCheckbox(context, applyPassGroupNotifier));
    children.add(15.verticalSpace);
    children.add(nextButton(context, applyPassGroupNotifier));

    return Padding(
      padding: EdgeInsets.only(bottom: 25.h, right: 25.w, left: 25.w, top: 15.h),
      child: Form(key: applyPassGroupNotifier.formKey, child: Column(children: children)),
    );
  }

  Widget buildExpansionTile({required String title, required List<Widget> children, isVisitorDetails = false}) {
    return ExpansionTile(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      collapsedBackgroundColor: AppColors.whiteColor,
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      childrenPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      initiallyExpanded: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppFonts.textRegular20),
          if (isVisitorDetails) Text("(${category.name})", style: AppFonts.textMedium12),
        ],
      ),
      children: children,
    );
  }

  Widget nextButton(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
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

  Widget userVerifyCheckbox(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 5.0),
            child: GestureDetector(
              onTap: () {
                applyPassGroupNotifier.userVerifyChecked(context, !applyPassGroupNotifier.isChecked);
              },
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: applyPassGroupNotifier.isChecked ? AppColors.primaryColor : AppColors.primaryColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  color: applyPassGroupNotifier.isChecked ? AppColors.whiteColor : Colors.transparent,
                ),
                child: applyPassGroupNotifier.isChecked ? Icon(Icons.check, size: 17, color: Colors.black) : null,
              ),
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(
              context.watchLang.translate(AppLanguageText.formSubmissionCertification),
              style: AppFonts.textRegular14,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBulletList(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
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

  List<Widget> visitDetailsChildren(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
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
      vehicleDetailCheckbox(context, applyPassGroupNotifier),
      15.verticalSpace,
      deviceDetailCheckbox(context, applyPassGroupNotifier),
    ];
  }

  Widget vehicleDetailCheckbox(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return Container(
      decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              applyPassGroupNotifier.vehicleDetailChecked(!applyPassGroupNotifier.isCheckedVehicle);
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: applyPassGroupNotifier.isCheckedVehicle ? AppColors.primaryColor : AppColors.primaryColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
                color: applyPassGroupNotifier.isCheckedVehicle ? AppColors.whiteColor : Colors.transparent,
              ),
              child: applyPassGroupNotifier.isCheckedVehicle ? Icon(Icons.check, size: 17, color: Colors.black) : null,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(context.watchLang.translate(AppLanguageText.vehicleDetails), style: AppFonts.textRegular14),
          ),
        ],
      ),
    );
  }

  Widget deviceDetailCheckbox(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return Container(
      decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(8)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              applyPassGroupNotifier.deviceDetailChecked(context, !applyPassGroupNotifier.isCheckedDevice);
            },
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                border: Border.all(
                  color: applyPassGroupNotifier.isCheckedDevice ? AppColors.primaryColor : AppColors.primaryColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
                color: applyPassGroupNotifier.isCheckedDevice ? AppColors.whiteColor : Colors.transparent,
              ),
              child: applyPassGroupNotifier.isCheckedDevice ? Icon(Icons.check, size: 17, color: Colors.black) : null,
            ),
          ),
          10.horizontalSpace,
          Expanded(
            child: Text(
              context.watchLang.translate(AppLanguageText.declareDevicesBroughtOnsite),
              style: AppFonts.textRegular14,
            ),
          ),
        ],
      ),
    );
  }

  Widget locationTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
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

  Widget visitRequestTypeTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<VisitRequestDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.visitRequestType),
      hintText: 'Select...',
      controller: applyPassGroupNotifier.visitRequestTypeController,
      items: applyPassGroupNotifier.visitRequestTypesDropdownData,
      itemLabel: (item) => item.sDescE ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (VisitRequestDropdownResult? menu) {
        applyPassGroupNotifier.selectedVisitRequest = menu?.nDetailedCode.toString() ?? "";
        // applyPassGroupNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: CommonValidation().validateVisitRequestType,
    );
  }

  Widget visitPurposeTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<VisitPurposeDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.visitPurpose),
      hintText: 'Select...',
      controller: applyPassGroupNotifier.visitPurposeController,
      items: applyPassGroupNotifier.visitPurposeDropdownData,
      itemLabel: (item) => item.sPurposeEn ?? 'Unknown',
      isSmallFieldFont: true,
      onSelected: (VisitPurposeDropdownResult? menu) {
        applyPassGroupNotifier.selectedVisitPurpose = menu?.nPurposeId.toString() ?? "";
        // applyPassGroupNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: CommonValidation().validateVisitPurpose,
    );
  }

  Widget mofaHostEmailTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.mofaHostEmailController,
      fieldName: context.watchLang.translate(AppLanguageText.hostEmailAddress),
      isSmallFieldFont: true,
      validator: CommonValidation().validateMofaHostEmail,
    );
  }

  Widget visitStartDateTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
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

  Widget visitEndDateTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
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

  Widget noteTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.noteController,
      fieldName: context.watchLang.translate(AppLanguageText.note),
      isSmallFieldFont: true,
      skipValidation: true,
    );
  }

  List<Widget> vehicleDetailsChildren(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return [
      plateTypeTextField(context, applyPassGroupNotifier),
      15.verticalSpace,
      plateLetter1TextField(context, applyPassGroupNotifier),
      15.verticalSpace,
      plateLetter2TextField(context, applyPassGroupNotifier),
      15.verticalSpace,
      plateLetter3TextField(context, applyPassGroupNotifier),
      15.verticalSpace,
      plateNumberTextField(context, applyPassGroupNotifier),
    ];
  }

  Widget plateTypeTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.plateType),
      hintText: 'Select...',
      controller: applyPassGroupNotifier.plateTypeController,
      items: applyPassGroupNotifier.plateTypeDropdownData,
      itemLabel: (item) => item.sDescE ?? 'Unknown',
      isSmallFieldFont: true,
      skipValidation: true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassGroupNotifier.selectedPlateType = menu?.nDetailedCode ?? 0;
      },
      validator: CommonValidation().validateDeviceType,
    );
  }

  Widget plateLetter1TextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.plateLetter1),
      hintText: 'Select...',
      controller: applyPassGroupNotifier.plateLetter1Controller,
      items: applyPassGroupNotifier.plateLetterDropdownData,
      itemLabel: (item) => item.sDescE ?? 'Unknown',
      isSmallFieldFont: true,
      skipValidation: true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassGroupNotifier.selectedPlateLetter1 = menu?.nDetailedCode ?? 0;
      },
      validator: CommonValidation().validateDeviceType,
    );
  }

  Widget plateLetter2TextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.plateLetter2),
      hintText: 'Select...',
      controller: applyPassGroupNotifier.plateLetter2Controller,
      items: applyPassGroupNotifier.plateLetterDropdownData,
      itemLabel: (item) => item.sDescE ?? 'Unknown',
      isSmallFieldFont: true,
      skipValidation: true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassGroupNotifier.selectedPlateLetter2 = menu?.nDetailedCode ?? 0;
      },
      validator: CommonValidation().validateDeviceType,
    );
  }

  Widget plateLetter3TextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.plateLetter3),
      hintText: 'Select...',
      controller: applyPassGroupNotifier.plateLetter3Controller,
      items: applyPassGroupNotifier.plateLetterDropdownData,
      itemLabel: (item) => item.sDescE ?? 'Unknown',
      isSmallFieldFont: true,
      skipValidation: true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassGroupNotifier.selectedPlateLetter3 = menu?.nDetailedCode ?? 0;
      },
      validator: CommonValidation().validateDeviceType,
    );
  }

  Widget plateNumberTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.plateNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.plateNumber),
      isSmallFieldFont: true,
      keyboardType: TextInputType.number,
      validator: CommonValidation().validateIqama,
    );
  }

  List<Widget> deviceDetailsChildren(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return [
      deviceDetailsChipList(context, applyPassGroupNotifier),
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

    Widget buildHeader() {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.buttonBgColor.withOpacity(0.5),
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
        ),
        padding: const EdgeInsets.all(12),
        child: const Text('Device Details', style: AppFonts.textBoldWhite14),
      );
    }

    Widget buildActionButton({required IconData icon, required Color color, required VoidCallback onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          height: 28,
          width: 48,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.whiteColor, size: 20),
        ),
      );
    }

    if (devices.isEmpty) {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [buildHeader(), const Padding(padding: EdgeInsets.all(16), child: Text('No result found'))],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateProperty.all(AppColors.buttonBgColor.withOpacity(0.5)),
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
                          buildActionButton(
                            icon: LucideIcons.pencil,
                            color: AppColors.buttonBgColor,
                            onTap: () => applyPassGroupNotifier.startEditingDevice(index),
                          ),
                          5.horizontalSpace,
                          buildActionButton(
                            icon: LucideIcons.trash,
                            color: AppColors.textRedColor,
                            onTap: () => applyPassGroupNotifier.removeDevice(index),
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

  Widget deviceDetailsChipList(BuildContext context, ApplyPassGroupNotifier notifier) {
    final devices = notifier.addedDevices;

    if (devices.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text('No devices added'),
      );
    }

    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: devices
          .asMap()
          .entries
          .map((entry) {
        final index = entry.key;
        final device = entry.value;

        return InputChip(
          label: Text(device.deviceTypeString ?? 'Unknown'),
          avatar: Icon(getDeviceIcon(device.deviceTypeString ?? ""), size: 18),
          onPressed: () => notifier.startEditingDevice(index),
          onDeleted: () => notifier.removeDevice(index),
          deleteIcon: const Icon(Icons.close),
          deleteIconColor: Colors.red,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
            side: const BorderSide(color: AppColors.buttonBgColor, width: 1),
          ),
          backgroundColor: AppColors.whiteColor,
          labelStyle: AppFonts.textRegular14,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        );
      }).toList(),
    );
  }

  IconData getDeviceIcon(String deviceType) {
    switch (deviceType.toLowerCase()) {
      case 'phone':
        return LucideIcons.smartphone;
      case 'laptop':
        return LucideIcons.laptop;
      case 'tablet':
        return LucideIcons.tablet;
      case 'usb drive':
      case 'usb':
        return LucideIcons.usb;
      case 'other':
      default:
        return LucideIcons.monitorSmartphone;
    }
  }

  Widget addDeviceButton(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomButton(
      text: context.watchLang.translate(AppLanguageText.addDevice),
      onPressed: () => applyPassGroupNotifier.showDeviceFieldsAgain(),
    );
  }

  Widget addVisitorsButton(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomButton(
      text: context.watchLang.translate(AppLanguageText.addVisitor),
      onPressed: () => applyPassGroupNotifier.showVisitorsFieldsAgain(),
    );
  }

  Widget saveAndCancel(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(AppLanguageText.addDevice),
            height: 45,
            smallWidth: true,
            onPressed: () {
              if (applyPassGroupNotifier.showDeviceFields) {
                applyPassGroupNotifier.saveDevice(); // Save or update
              } else {
                applyPassGroupNotifier.showDeviceFieldsAgain(); // Show fields to add
              }
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(AppLanguageText.cancel),
            backgroundColor: Colors.white,
            height: 45,
            smallWidth: true,
            borderColor: AppColors.buttonBgColor,
            textFont: AppFonts.textBold14,
            onPressed: () => applyPassGroupNotifier.cancelEditing(),
          ),
        ),
      ],
    );
  }

  Widget saveAndCancelVisitors(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(AppLanguageText.addVisitor),
            height: 45,
            onPressed: () {
              if (!applyPassGroupNotifier.showVisitorsFields) {
                applyPassGroupNotifier.showVisitorsFieldsAgain();
              } else {
                applyPassGroupNotifier.saveVisitors(context);
              }
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(AppLanguageText.cancel),
            height: 45,
            backgroundColor: Colors.white,
            borderColor: AppColors.buttonBgColor,
            textFont: AppFonts.textBold14,
            onPressed: () => applyPassGroupNotifier.cancelVisitorsEditing(),
          ),
        ),
      ],
    );
  }

  Widget deviceModelTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.deviceModelController,
      fieldName: context.watchLang.translate(AppLanguageText.deviceModel),
      isSmallFieldFont: true,
      skipValidation: true,
      validator: CommonValidation().validateDeviceModel,
    );
  }

  Widget serialNumberTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.serialNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.serialNumber),
      isSmallFieldFont: true,
      skipValidation: true,
      validator: CommonValidation().validateSerialNumber,
    );
  }

  Widget deviceTypeTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
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

  Widget devicePurposeTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
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

  List<Widget> groupVisitorDetailsChildren(BuildContext context, ApplyPassGroupNotifier notifier) {
    List<Widget> children = [
      // addVisitorsButton(context, notifier),
      // 15.verticalSpace,
      visitorTable(notifier),
      15.verticalSpace,
    ];

    if (notifier.showVisitorsFields) {
      children.addAll([
        visitorNameTextField(context, notifier),
        15.verticalSpace,
        companyNameTextField(context, notifier),
        15.verticalSpace,
        phoneNumberTextField(context, notifier),
        15.verticalSpace,
        emailTextField(context, notifier),
        15.verticalSpace,
        nationalityField(context, notifier),
        15.verticalSpace,
        idTypeField(context, notifier),
        15.verticalSpace,
        ..._buildIdTypeFields(context, notifier),
        expirationDateTextField(context, notifier),
        15.verticalSpace,
        vehicleNumberTextField(context, notifier),
        15.verticalSpace,
        buildUploadImageSection(context, notifier),
        15.verticalSpace,
        buildUploadDocumentSection(context, notifier),
        15.verticalSpace,
        buildUploadVehicleRegistrationSection(context, notifier),
        15.verticalSpace,
        saveAndCancelVisitors(context, notifier),
      ]);
    }

    return children;
  }

  List<Widget> _buildIdTypeFields(BuildContext context, ApplyPassGroupNotifier notifier) {
    final type = notifier.selectedIdType;
    List<Widget> idWidgets = [];

    switch (type) {
      case "National ID":
        idWidgets.add(nationalIdTextField(context, notifier));
        break;
      case "Passport":
        idWidgets.add(passportField(context, notifier));
        break;
      case "Iqama":
        idWidgets.add(iqamaField(context, notifier));
        break;
      case "Other":
        idWidgets.addAll([
          documentNameField(context, notifier),
          15.verticalSpace,
          documentNumberField(context, notifier),
        ]);
        break;
    }

    if (idWidgets.isNotEmpty) {
      idWidgets.add(15.verticalSpace);
    }

    return idWidgets;
  }

  Widget visitorTable(ApplyPassGroupNotifier notifier) {
    final visitors = notifier.addedVisitors;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child:
          visitors.isEmpty
              ? _buildEmptyTableHeader(title: 'Visitors Details')
              : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateColor.resolveWith((states) => AppColors.buttonBgColor.withOpacity(0.5)),
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
                              _buildActionButtons(
                                onEdit: () => notifier.startEditingVisitors(index),
                                onDelete: () => notifier.removeVisitors(index),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                ),
              ),
    );
  }

  Widget _buildEmptyTableHeader({required String title}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.buttonBgColor.withOpacity(0.5),
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
          ),
          padding: const EdgeInsets.all(12),
          child: Text(title, style: AppFonts.textBoldWhite14),
        ),
        const Padding(padding: EdgeInsets.all(16), child: Text('No result found')),
      ],
    );
  }

  Widget _buildActionButtons({required VoidCallback onEdit, required VoidCallback onDelete}) {
    return Row(
      children: [
        _buildIconButton(icon: LucideIcons.pencil, color: AppColors.buttonBgColor, onTap: onEdit),
        5.horizontalSpace,
        _buildIconButton(icon: LucideIcons.trash, color: AppColors.textRedColor, onTap: onDelete),
      ],
    );
  }

  Widget _buildIconButton({required IconData icon, required Color color, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 28,
        width: 48,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Icon(icon, color: AppColors.whiteColor, size: 20),
      ),
    );
  }

  Widget buildUploadSection({
    required BuildContext context,
    required String title,
    required String? fileName,
    required VoidCallback onUploadTap,
    bool showTooltip = false,
    String? tooltipMessage,
    bool isRequired = false,
    bool showError = false,
    String? errorText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: AppFonts.textRegular14),
            if (isRequired) ...[
              3.horizontalSpace,
              const Text("*", style: TextStyle(fontSize: 15, color: AppColors.textRedColor)),
            ],
            if (showTooltip && tooltipMessage != null) ...[
              3.horizontalSpace,
              Tooltip(
                message: tooltipMessage,
                textAlign: TextAlign.center,
                decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(5)),
                child: Icon(Icons.info_outline, size: 20, color: AppColors.primaryColor),
              ),
            ],
          ],
        ),
        5.verticalSpace,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                fileName ?? context.watchLang.translate(AppLanguageText.noFileSelected),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Flexible(
              child: CustomUploadButton(
                text: context.watchLang.translate(AppLanguageText.uploadFile),
                onPressed: onUploadTap,
              ),
            ),
          ],
        ),
        const Divider(height: 10, indent: 0, thickness: 1),
        if (showError && errorText != null) Text(errorText, style: AppFonts.errorTextRegular12),
      ],
    );
  }

  Widget buildUploadImageSection(BuildContext context, ApplyPassGroupNotifier notifier) {
    return buildUploadSection(
      context: context,
      title: context.watchLang.translate(AppLanguageText.uploadPhoto),
      fileName: notifier.uploadedImageFile?.path.split('/').last,
      onUploadTap: () {
        showImageUploadBottomSheet(
          context: context,
          onCameraTap: () async {
            await notifier.uploadImage(fromCamera: true, cropAfterPick: true);
          },
          onGalleryTap: () async {
            await notifier.uploadImage(fromCamera: false, cropAfterPick: true);
          },
        );
      },
      isRequired: true,
      showTooltip: true,
      tooltipMessage:
          "Upload a recent passport-sized\n photo (JPG, PNG, or JPEG).\n Ensure the image is clear and meets\n official guidelines.",
      showError: notifier.photoUploadValidation,
      errorText: "Photo upload is required.",
    );
  }

  Future<void> showImageUploadBottomSheet({
    required BuildContext context,
    required VoidCallback onCameraTap,
    required VoidCallback onGalleryTap,
  }) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
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
                decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 16),
              const Text("Upload Image", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  uploadOptionCard(
                    icon: LucideIcons.camera,
                    label: "Camera",
                    onTap: () {
                      Navigator.pop(context);
                      onCameraTap();
                    },
                  ),
                  uploadOptionCard(
                    icon: LucideIcons.image,
                    label: "Device",
                    onTap: () {
                      Navigator.pop(context);
                      onGalleryTap();
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
  }

  Widget uploadOptionCard({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.buttonBgColor.withOpacity(0.2), shape: BoxShape.circle),
            child: Icon(icon, size: 28, color: AppColors.buttonBgColor),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget buildUploadDocumentSection(BuildContext context, ApplyPassGroupNotifier notifier) {
    return buildUploadSection(
      context: context,
      title: 'Upload ${notifier.selectedIdType}',
      fileName: notifier.uploadedDocumentFile?.path.split('/').last,
      onUploadTap: () async => await notifier.uploadDocument(),
      isRequired: true,
      showError: notifier.documentUploadValidation,
      errorText: "${notifier.selectedIdType} upload is required.",
    );
  }

  Widget buildUploadVehicleRegistrationSection(BuildContext context, ApplyPassGroupNotifier notifier) {
    return buildUploadSection(
      context: context,
      title: context.watchLang.translate(AppLanguageText.vehicleRegistrationLicense),
      fileName: notifier.uploadedVehicleRegistrationFile?.path.split('/').last,
      onUploadTap: () async => await notifier.uploadVehicleRegistrationImage(),
    );
  }

  Widget visitorNameTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.visitorNameController,
      fieldName: context.watchLang.translate(AppLanguageText.visitorName),
      isSmallFieldFont: true,
      validator: CommonValidation().visitorNameValidator,
    );
  }

  Widget companyNameTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.companyNameController,
      fieldName: context.watchLang.translate(AppLanguageText.companyName),
      isSmallFieldFont: true,
      validator: CommonValidation().companyValidator,
    );
  }

  Widget phoneNumberTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.phoneNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.phoneNumber),
      isSmallFieldFont: true,
      validator: CommonValidation().validateMobile,
    );
  }

  Widget emailTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.emailController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      isSmallFieldFont: true,
      validator: CommonValidation().validateEmail,
    );
  }

  Widget nationalIdTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.nationalityIdController,
      fieldName: context.watchLang.translate(AppLanguageText.nationalID),
      isSmallFieldFont: true,
      validator: CommonValidation().validateNationalId,
    );
  }

  Widget expirationDateTextField(BuildContext context, ApplyPassGroupNotifier notifier) {
    final idType = notifier.selectedIdTypeEnum;

    return CustomTextField(
      controller: notifier.expiryDateController,
      fieldName: idType.translatedLabel(context),
      isSmallFieldFont: true,
      keyboardType: TextInputType.datetime,
      startDate: DateTime.now(),
      validator: idType.validator,
    );
  }

  Widget vehicleNumberTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.vehicleNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.vehicleNo),
      isSmallFieldFont: true,
      skipValidation: true,
      validator: CommonValidation().vehicleNumberValidator,
    );
  }

  // nationalityField
  Widget nationalityField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
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
  Widget idTypeField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
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
  Widget iqamaField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.iqamaController,
      fieldName: context.watchLang.translate(AppLanguageText.iqama),
      keyboardType: TextInputType.phone,
      isSmallFieldFont: true,
      validator: CommonValidation().validateIqama,
    );
  }

  // passportField
  Widget passportField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.passportNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.passportNumber),
      isSmallFieldFont: true,
      validator: CommonValidation().validatePassport,
    );
  }

  // documentNameField
  Widget documentNameField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.documentNameController,
      fieldName: context.watchLang.translate(AppLanguageText.documentNameOther),
      isSmallFieldFont: true,
      validator: CommonValidation().documentNameValidator,
    );
  }

  // documentNumberField
  Widget documentNumberField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.documentNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.documentNumberOther),
      isSmallFieldFont: true,
      validator: CommonValidation().documentNumberValidator,
    );
  }
}
