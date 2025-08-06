
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/base/loading_state.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/core/model/device_dropdown/device_dropdown_response.dart';
import 'package:mofa/core/model/location_dropdown/location_dropdown_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_purpose_dropdown_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_request_dropdown_response.dart';
import 'package:mofa/core/notifier/language_notifier.dart';
import 'package:mofa/model/document/document_id_model.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/res/app_strings.dart';
import 'package:mofa/screens/apply_pass_group/apply_pass_group_notifier.dart';
import 'package:mofa/screens/stepper_handler/stepper_handler_notifier.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/common/widgets/bullet_list.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_dropdown_search.dart';
import 'package:mofa/utils/common/widgets/common_mobile_number.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:mofa/utils/common/widgets/loading_overlay.dart';
import 'package:mofa/utils/common_utils.dart';
import 'package:mofa/utils/common_validation.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:mofa/utils/extensions.dart';
import 'package:mofa/utils/toast_helper.dart';
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
      create: (context) {
        final notifier = ApplyPassGroupNotifier();

        // Delay initialization to avoid build-phase issues
        Future.microtask(() async {
          final stepperHandler = Provider.of<StepperHandlerNotifier>(context, listen: false);
          await stepperHandler.runWithLoadingVoid(() async {
            await notifier.initialize(context, category);
          });
        });

        return notifier;
      },
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

    String stepTitle(String label, {bool numbered = true}) =>
        numbered ? "${stepCounter++}. ${lang.translate(label)}" : lang.translate(label);

    List<Widget> children = [];

    children.add(
      buildExpansionTile(
        title: stepTitle(AppLanguageText.visitDetails),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...visitDetailsChildren(context, applyPassGroupNotifier),
            ],
          ),
        ],
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
        children: [
          Form(
            key: applyPassGroupNotifier.visitorFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...groupVisitorDetailsChildren(context, applyPassGroupNotifier),
              ],
            ),
          ),
        ],
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
      child: Form(key: applyPassGroupNotifier.visitFormKey, child: Column(children: children)),
    );
  }

  Widget buildExpansionTile({required String title, required List<Widget> children, isVisitorDetails = false,  bool initiallyExpanded = true,}) {
    return ExpansionTile(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      collapsedBackgroundColor: AppColors.whiteColor,
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      childrenPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      initiallyExpanded: initiallyExpanded,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(title, style: AppFonts.textRegular20)),
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
          isLoading: applyPassGroupNotifier.loadingState == LoadingState.Busy,
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
    return GestureDetector(
      onTap: () {
        applyPassGroupNotifier.userVerifyChecked(context, !applyPassGroupNotifier.isChecked);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
        decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(8)),
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
                    color: applyPassGroupNotifier.isChecked ? AppColors.primaryColor : AppColors.primaryColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  color: applyPassGroupNotifier.isChecked ? AppColors.whiteColor : Colors.transparent,
                ),
                child: applyPassGroupNotifier.isChecked ? Icon(Icons.check, size: 17, color: Colors.black) : null,
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
      ),
    );
  }

  Widget buildBulletList(BuildContext context, ApplyPassGroupNotifier notifier) {
    final points = [
      context.watchLang.translate(AppLanguageText.personalDataNotice),
      context.watchLang.translate(AppLanguageText.submitDataConsent),
      "${context.watchLang.translate(AppLanguageText.dataProcessingNotice)} ${context.watchLang.translate(AppLanguageText.privacyPolicyHere)}",
      context.watchLang.translate(AppLanguageText.acknowledgementStatement),
    ];

    return BulletList(
      points,
      onPrivacyPolicyTap: () => notifier.launchPrivacyUrl(),
      initiallyVisibleIndices: [2, 3], // Last 2 points
    );
  }

  Widget searchVisitorVisibilityButton(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return Align(
      alignment: Alignment.centerRight,
      child: CustomButton(
          height: 40,
          iconData: LucideIcons.search,
          leftIcon: true,
          text: context.watchLang.translate(AppLanguageText.searchVisitor),
          onPressed: () => applyPassGroupNotifier.showSearchFields()),
    );
  }

  List<Widget> searchUserSection( BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return [
      iqamaSearchField(context, applyPassGroupNotifier),
      15.verticalSpace,
      nationalityIdSearchField(context, applyPassGroupNotifier),
      15.verticalSpace,
      passportSearchField(context, applyPassGroupNotifier),
      15.verticalSpace,
      emailSearchField(context, applyPassGroupNotifier),
      15.verticalSpace,
      phoneNumberSearchField(context, applyPassGroupNotifier),
      15.verticalSpace,
      searchAndClearExistingVisitor(context, applyPassGroupNotifier),
    ];
  }

  Widget iqamaSearchField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.iqamaSearchController,
      fieldName: context.watchLang.translate(AppLanguageText.iqamaNumber),
      toolTipContent: "${context.readLang.translate(AppLanguageText.entre10digitIqama)}\n${context.readLang.translate(AppLanguageText.numberAsPerRecords)}",
      isSmallFieldFont: true,
      skipValidation: true,
      keyboardType: TextInputType.number,
    );
  }

  Widget nationalityIdSearchField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.nationalityIdSearchController,
      fieldName: context.watchLang.translate(AppLanguageText.nationalID),
      toolTipContent: "${context.readLang.translate(AppLanguageText.entre10digit)}\n${context.readLang.translate(AppLanguageText.idAsPerRecords)}",
      isSmallFieldFont: true,
      skipValidation: true,
    );
  }

  Widget passportSearchField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.passportSearchController,
      fieldName: context.watchLang.translate(AppLanguageText.passportNumber),
      isSmallFieldFont: true,
      skipValidation: true,
    );
  }

  Widget emailSearchField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.emailSearchController,
      fieldName: context.watchLang.translate(AppLanguageText.email),
      isSmallFieldFont: true,
      skipValidation: true,
    );
  }

  Widget phoneNumberSearchField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.phoneNumberSearchController,
      fieldName: context.watchLang.translate(AppLanguageText.phoneNumber),
      isSmallFieldFont: true,
      keyboardType: TextInputType.phone,
      skipValidation: true,
    );
  }

  Widget searchAndClearExistingVisitor(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(AppLanguageText.search),
            height: 45,
            smallWidth: true,
            onPressed: () {
              applyPassGroupNotifier.apiSearchVisitor(context);
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(AppLanguageText.clear),
            backgroundColor: Colors.white,
            height: 45,
            smallWidth: true,
            borderColor: AppColors.buttonBgColor,
            textFont: AppFonts.textBold14,
            onPressed: () => applyPassGroupNotifier.clearSearchField(),
          ),
        ),
      ],
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
      if(applyPassGroupNotifier.selectedVisitPurpose == "60") visitPurposeOtherTextField(context, applyPassGroupNotifier),
      if(applyPassGroupNotifier.selectedVisitPurpose == "60") 15.verticalSpace,
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
    return GestureDetector(
      onTap: () {
        applyPassGroupNotifier.vehicleDetailChecked(!applyPassGroupNotifier.isCheckedVehicle);
      },
      child: Container(
        decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
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
            10.horizontalSpace,
            Expanded(
              child: Text(context.watchLang.translate(AppLanguageText.vehicleDetails), style: AppFonts.textRegular14),
            ),
          ],
        ),
      ),
    );
  }

  Widget deviceDetailCheckbox(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return GestureDetector(
      onTap: () {
        applyPassGroupNotifier.deviceDetailChecked(context, !applyPassGroupNotifier.isCheckedDevice);
      },
      child: Container(
        decoration: BoxDecoration(color: AppColors.whiteColor, borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
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
            10.horizontalSpace,
            Expanded(
              child: Text(
                context.watchLang.translate(AppLanguageText.declareDevicesBroughtOnsite),
                style: AppFonts.textRegular14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget locationTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<LocationDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.location),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassGroupNotifier.locationController,
      items: applyPassGroupNotifier.locationDropdownData,
      currentLang: context.lang,
      itemLabel: (item, lang) => CommonUtils.getLocalizedString(
          currentLang: lang,
          getArabic: () => item.sLocationNameAr,
          getEnglish: () => item.sLocationNameEn,
        ),
      isSmallFieldFont: true,
      onSelected: (LocationDropdownResult? menu) {
        applyPassGroupNotifier.selectedLocationId = menu?.nLocationId ?? 0;
        // applyPassGroupNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: (value) => CommonValidation().validateLocation(context, value),
    );
  }

  Widget visitRequestTypeTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<VisitRequestDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.visitRequestType),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassGroupNotifier.visitRequestTypeController,
      items: applyPassGroupNotifier.visitRequestTypesDropdownData,
      currentLang: context.lang,
      itemLabel: (item, lang) => CommonUtils.getLocalizedString(
          currentLang: lang,
          getArabic: () => item.sDescA,
          getEnglish: () => item.sDescE,
        ),
      isSmallFieldFont: true,
      onSelected: (VisitRequestDropdownResult? menu) {
        applyPassGroupNotifier.selectedVisitRequest = menu?.nDetailedCode.toString() ?? "";
        // applyPassGroupNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: (value) => CommonValidation().validateVisitRequestType(context, value),
    );
  }

  Widget visitPurposeTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<VisitPurposeDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.visitPurpose),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassGroupNotifier.visitPurposeController,
      items: applyPassGroupNotifier.visitPurposeDropdownData,
      currentLang: context.lang,
      itemLabel: (item, lang) => CommonUtils.getLocalizedString(
          currentLang: lang,
          getArabic: () => item.sPurposeAr,
          getEnglish: () => item.sPurposeEn,
        ),
      isSmallFieldFont: true,
      onSelected: (VisitPurposeDropdownResult? menu) {
        applyPassGroupNotifier.selectedVisitPurpose = menu?.nPurposeId.toString() ?? "";
        // applyPassGroupNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: (value) => CommonValidation().validateVisitPurpose(context, value),
    );
  }

  Widget visitPurposeOtherTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.visitPurposeOtherController,
      fieldName: context.watchLang.translate(AppLanguageText.visitPurposeOther),
      isSmallFieldFont: true,
    );
  }

  Widget mofaHostEmailTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.mofaHostEmailController,
      fieldName: context.watchLang.translate(AppLanguageText.hostEmailAddress),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().validateMofaHostEmail(context, value),
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
          final DateFormat formatter = DateFormat("dd/MM/yyyy, hh:mm a");
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
      validator: (value) => CommonValidation().validateVisitStartDate(context, value),
    );
  }

  Widget visitEndDateTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    DateTime? parsedStartDate;
    if (applyPassGroupNotifier.visitStartDateController.text.isNotEmpty) {
      try {
        parsedStartDate = DateFormat("dd/MM/yyyy, hh:mm a").parse(applyPassGroupNotifier.visitStartDateController.text);
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
      validator: (value) => CommonValidation().validateVisitEndDate(context, value),
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
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassGroupNotifier.plateTypeController,
      items: applyPassGroupNotifier.plateTypeDropdownData,
      currentLang: context.lang,
      itemLabel: (item, lang) => CommonUtils.getLocalizedString(
          currentLang: lang,
          getArabic: () => item.sDescA,
          getEnglish: () => item.sDescE,
        ),
      isSmallFieldFont: true,
      skipValidation: applyPassGroupNotifier.isCheckedVehicle ? false : true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassGroupNotifier.selectedPlateType = menu?.nDetailedCode ?? 0;
      },
      validator: (value) => CommonValidation().validatePlateType(context, value),
    );
  }

  Widget plateLetter1TextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.plateLetter1),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassGroupNotifier.plateLetter1Controller,
      items: applyPassGroupNotifier.plateLetterDropdownData,
      currentLang: context.lang,
      itemLabel: (item, lang) => CommonUtils.getLocalizedString(
          currentLang: lang,
          getArabic: () => item.sDescA,
          getEnglish: () => item.sDescE,
        ),
      isSmallFieldFont: true,
      skipValidation: applyPassGroupNotifier.isCheckedVehicle ? false : true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassGroupNotifier.selectedPlateLetter1 = menu?.nDetailedCode ?? 0;
      },
      validator: (value) => CommonValidation().validatePlateLetter1(context, value),
    );
  }

  Widget plateLetter2TextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.plateLetter2),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassGroupNotifier.plateLetter2Controller,
      items: applyPassGroupNotifier.plateLetterDropdownData,
      currentLang: context.lang,
      itemLabel: (item, lang) => CommonUtils.getLocalizedString(
          currentLang: lang,
          getArabic: () => item.sDescA,
          getEnglish: () => item.sDescE,
        ),
      isSmallFieldFont: true,
      skipValidation: applyPassGroupNotifier.isCheckedVehicle ? false : true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassGroupNotifier.selectedPlateLetter2 = menu?.nDetailedCode ?? 0;
      },
      validator: (value) => CommonValidation().validatePlateLetter2(context, value),
    );
  }

  Widget plateLetter3TextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.plateLetter3),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassGroupNotifier.plateLetter3Controller,
      items: applyPassGroupNotifier.plateLetterDropdownData,
      currentLang: context.lang,
      itemLabel: (item, lang) => CommonUtils.getLocalizedString(
          currentLang: lang,
          getArabic: () => item.sDescA,
          getEnglish: () => item.sDescE,
        ),
      isSmallFieldFont: true,
      skipValidation: applyPassGroupNotifier.isCheckedVehicle ? false : true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassGroupNotifier.selectedPlateLetter3 = menu?.nDetailedCode ?? 0;
      },
      validator: (value) => CommonValidation().validatePlateLetter3(context, value),
    );
  }

  Widget plateNumberTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.plateNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.plateNumber),
      isSmallFieldFont: true,
      skipValidation: applyPassGroupNotifier.isCheckedVehicle ? false : true,
      keyboardType: TextInputType.number,
      validator: (value) => CommonValidation().validatePlateNumber(context, value),
    );
  }

  List<Widget> deviceDetailsChildren(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return [
      deviceDetailsChipList(context, applyPassGroupNotifier),
      15.verticalSpace,
      if (applyPassGroupNotifier.showDeviceFields) ...[
        deviceTypeTextField(context, applyPassGroupNotifier),
        if(applyPassGroupNotifier.selectedDeviceType == 2250) 15.verticalSpace,
        if(applyPassGroupNotifier.selectedDeviceType == 2250) deviceTypeOtherTextField(context, applyPassGroupNotifier),
        15.verticalSpace,
        deviceModelTextField(context, applyPassGroupNotifier),
        15.verticalSpace,
        serialNumberTextField(context, applyPassGroupNotifier),
        15.verticalSpace,
        devicePurposeTextField(context, applyPassGroupNotifier),
        if(applyPassGroupNotifier.selectedDevicePurpose == 2254) 15.verticalSpace,
        if(applyPassGroupNotifier.selectedDevicePurpose == 2254) devicePurposeOtherTextField(context, applyPassGroupNotifier),
      ],
      15.verticalSpace,
      saveAndCancel(context, applyPassGroupNotifier),
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
        child:  Text('Device Details', style: AppFonts.textBoldWhite14),
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
        child: Text(context.readLang.translate(AppLanguageText.noDeviceAdded)),
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

  Widget saveAndCancel(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    final isEditing = applyPassGroupNotifier.isEditingDevice;
    final showFields = applyPassGroupNotifier.showDeviceFields;

    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(
              isEditing ? AppLanguageText.updateDevice : AppLanguageText.addDevice,
            ),
            height: 45,
            smallWidth: true,
            onPressed: () {

              if (applyPassGroupNotifier.isDevicePartiallyFilled()) {
                ToastHelper.showError(context.readLang.translate(AppLanguageText.fillDeviceDetails));
                return;
              }

              if (showFields) {
                applyPassGroupNotifier.saveDevice(); // Save or update
              } else {
                applyPassGroupNotifier.showDeviceFieldsAgain(); // Show fields to add
              }
            },
          ),
        ),
        SizedBox(width: 10),
        if (showFields)
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
    final showFields = applyPassGroupNotifier.showVisitorsFields;
    final isEditing = applyPassGroupNotifier.isEditingVisitors;
    return Row(
      children: [
        Expanded(
          child: CustomButton(
            text: context.watchLang.translate(isEditing ? AppLanguageText.updateVisitor : AppLanguageText.addVisitor,),
            height: 45,
            onPressed: () {
              if (!showFields) {
                applyPassGroupNotifier.showVisitorsFieldsAgain();
              } else {
                applyPassGroupNotifier.saveVisitors(context);
              }
            },
          ),
        ),
        SizedBox(width: 10),
        if (showFields) Expanded(
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
      validator: (value) => CommonValidation().validateDeviceModel(context, value),
    );
  }

  Widget deviceTypeOtherTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.deviceTypeOtherController,
      fieldName: context.watchLang.translate(AppLanguageText.deviceTypeOther),
      isSmallFieldFont: true,
      skipValidation: true,
    );
  }

  Widget devicePurposeOtherTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.devicePurposeOtherController,
      fieldName: context.watchLang.translate(AppLanguageText.devicePurposeOther),
      isSmallFieldFont: true,
      skipValidation: true,
    );
  }

  Widget serialNumberTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.serialNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.serialNumber),
      isSmallFieldFont: true,
      skipValidation: true,
      validator: (value) => CommonValidation().validateSerialNumber(context, value),
    );
  }

  Widget deviceTypeTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.deviceType),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassGroupNotifier.deviceTypeController,
      items: applyPassGroupNotifier.deviceTypeDropdownData,
      currentLang: context.lang,
      itemLabel: (item, lang) => CommonUtils.getLocalizedString(
          currentLang: lang,
          getArabic: () => item.sDescA,
          getEnglish: () => item.sDescE,
        ),
      isSmallFieldFont: true,
      skipValidation: true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassGroupNotifier.selectedDeviceType = menu?.nDetailedCode ?? 0;
      },
      validator: (value) => CommonValidation().validateDeviceType(context, value),
    );
  }

  Widget devicePurposeTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.devicePurpose),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassGroupNotifier.devicePurposeController,
      items: applyPassGroupNotifier.devicePurposeDropdownData,
      currentLang: context.lang,
      itemLabel: (item, lang) => CommonUtils.getLocalizedString(
          currentLang: lang,
          getArabic: () => item.sDescA,
          getEnglish: () => item.sDescE,
        ),
      isSmallFieldFont: true,
      skipValidation: true,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassGroupNotifier.selectedDevicePurpose = menu?.nDetailedCode ?? 0;
      },
      validator: (value) => CommonValidation().validateDevicePurpose(context, value),
    );
  }

  List<Widget> groupVisitorDetailsChildren(BuildContext context, ApplyPassGroupNotifier notifier) {
    List<Widget> children = [
      searchVisitorVisibilityButton(context, notifier),
      15.verticalSpace,
      if(notifier.isCheckedSearch) ...searchUserSection(context, notifier),
      if(notifier.isCheckedSearch) 15.verticalSpace,
      visitorTable(context, notifier),
      15.verticalSpace,
    ];

    if (notifier.showVisitorsFields) {
      children.addAll([
        visitorNameTextField(context, notifier),
        15.verticalSpace,
        companyNameTextField(context, notifier),
        15.verticalSpace,
        nationalityField(context, notifier),
        15.verticalSpace,
        phoneNumberTextField(context, notifier),
        15.verticalSpace,
        emailTextField(context, notifier),
        15.verticalSpace,
        idTypeField(context, notifier),
        15.verticalSpace,
        ..._buildIdTypeFields(context, notifier),
        expirationDateTextField(context, notifier),
        15.verticalSpace,
        buildUploadImageSection(context, notifier),
        15.verticalSpace,
        buildUploadDocumentSection(context, notifier),
        15.verticalSpace,
        buildUploadVehicleRegistrationSection(context, notifier),
        15.verticalSpace,
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "${context.watchLang.translate(AppLanguageText.note)}: ${context.watchLang.translate(
                AppLanguageText.latestPhoto)} ",
            style: AppFonts.textRegular14Red,
          ),
        ),
      ]);
    }

    children.addAll([
      20.verticalSpace,
      saveAndCancelVisitors(context, notifier),
    ]);

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

  Widget visitorTable(BuildContext context, ApplyPassGroupNotifier notifier) {
    final visitors = notifier.addedVisitors;

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child:
            visitors.isEmpty
                ? _buildEmptyTableHeader(context, title: context.watchLang.translate(AppLanguageText.visitorDetails))
                : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: MaterialStateColor.resolveWith((states) => AppColors.buttonBgColor.withOpacity(0.5)),
                    headingTextStyle: AppFonts.textBoldWhite14,
                    border: TableBorder(borderRadius: BorderRadius.circular(8)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    columnSpacing: 40,
                    columns: [
                      DataColumn(label: Text(context.watchLang.translate(AppLanguageText.visitorName))),
                      DataColumn(label: Text(context.watchLang.translate(AppLanguageText.companyName))),
                      DataColumn(label: Text(context.watchLang.translate(AppLanguageText.email))),
                      DataColumn(label: Text(context.watchLang.translate(AppLanguageText.mobileNumber))),
                      DataColumn(label: Text(context.watchLang.translate(AppLanguageText.idType))),
                      DataColumn(label: Text(context.watchLang.translate(AppLanguageText.idNumber))),
                      DataColumn(label: Text(context.watchLang.translate(AppLanguageText.idExpiryDate))),
                      DataColumn(label: Text(context.watchLang.translate(AppLanguageText.nationality))),
                      DataColumn(label: Text(context.watchLang.translate(AppLanguageText.action))),
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
                              DataCell(
                                _buildActionButtons(
                                  onEdit: () => notifier.startEditingVisitors(context, index),
                                  onDelete: () => notifier.removeVisitors(index),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                  ),
                ),
      ),
    );
  }

  Widget _buildEmptyTableHeader(BuildContext context, {required String title}) {
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
        Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: Text(context.watchLang.translate(AppLanguageText.noResults),),),),
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
    required ApplyPassGroupNotifier applyPassGroupNotifier,
    required String title,
    required String? fileName,
    required VoidCallback onUploadTap,
    required Function runLoading,
    required bool loader,
    bool showTooltip = false,
    String? tooltipMessage,
    bool isRequired = false,
    bool showError = false,
    Uint8List? viewAttachmentData,
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
        if(viewAttachmentData != null) _buildViewAttachment(context, applyPassGroupNotifier, viewAttachmentData, runLoading, loader),
        if (showError && errorText != null) Text(errorText, style: AppFonts.errorTextRegular12),
      ],
    );
  }

  Widget _buildViewAttachment(BuildContext context, ApplyPassGroupNotifier notifier, Uint8List? imageData, Function runLoading,
      bool loader,) {
    return GestureDetector(
      onTap: () async {
        runLoading (() async {
          if (isPdf(imageData!)) {
            Navigator.pushNamed(context, AppRoutes.pdfViewer, arguments: imageData);
          } else {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder:
                  (_) =>
                  AlertDialog(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: Icon(LucideIcons.x),
                          ),
                        ),
                        5.verticalSpace,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: Image.memory(imageData!),
                        ),
                      ],
                    ),
                  ),
            );
          }
        });
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(context.watchLang.translate(AppLanguageText.viewAttachment), style: AppFonts.textRegularAttachment14),
          if (loader) ...[
            8.horizontalSpace,
            SizedBox(
              width: 14,
              height: 14,
              child: DotCircleSpinner(
                color: AppColors.primaryColor,
                dotSize: 1,
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool isPdf(Uint8List data) {
    if (data.length < 5) return false;

    // Compare the first 5 bytes to the PDF signature
    return data[0] == 0x25 && // %
        data[1] == 0x50 && // P
        data[2] == 0x44 && // D
        data[3] == 0x46 && // F
        data[4] == 0x2D;   // -
  }


  Widget buildUploadImageSection(BuildContext context, ApplyPassGroupNotifier notifier) {
    final langContext = context.readLang;

    return buildUploadSection(
      context: context,
      applyPassGroupNotifier: notifier,
      title: context.watchLang.translate(AppLanguageText.uploadPhoto),
      fileName: notifier.uploadedImageFile?.path
          .split('/')
          .last,
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
      viewAttachmentData: notifier.uploadedImageBytes,
      tooltipMessage:
      "${langContext.translate(AppLanguageText.uploadRecentPassport)}\n ${langContext.translate(
          AppLanguageText.photoJpgPng)}\n ${langContext.translate(AppLanguageText.ensureTheImage)}\n ${langContext
          .translate(AppLanguageText.officialGuidelines)}",
      showError: notifier.photoUploadValidation,
      runLoading: notifier.runWithViewAttachmentPhotoLoader,
      loader: notifier.isPhotoLoading,
      errorText: context.readLang.translate(AppLanguageText.validationPhotoUploadRequired),
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
                    label: context.readLang.translate(AppLanguageText.camera),
                    onTap: () {
                      Navigator.pop(context);
                      onCameraTap();
                    },
                  ),
                  uploadOptionCard(
                    icon: LucideIcons.image,
                    label: context.readLang.translate(AppLanguageText.device),
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
      applyPassGroupNotifier: notifier,
      title: 'Upload ${notifier.selectedIdType}',
      fileName: notifier.uploadedDocumentFile?.path.split('/').last,
      onUploadTap: () async => await notifier.uploadDocument(),
      isRequired: true,
      viewAttachmentData: notifier.uploadedDocumentBytes,
      showError: notifier.documentUploadValidation,
      runLoading: notifier.runWithViewAttachmentDocumentLoader,
      loader: notifier.isDocumentLoading,
      errorText: "${notifier.selectedIdType} ${context.readLang.translate(AppLanguageText.upload)} ${context.readLang.translate(AppLanguageText.validationRequired)}",
    );
  }

  Widget buildUploadVehicleRegistrationSection(BuildContext context, ApplyPassGroupNotifier notifier) {
    return buildUploadSection(
      context: context,
      applyPassGroupNotifier: notifier,
      title: context.watchLang.translate(AppLanguageText.vehicleRegistrationLicense),
      fileName: notifier.uploadedVehicleRegistrationFile?.path.split('/').last,
      viewAttachmentData: notifier.uploadedVehicleImageBytes,
      runLoading: notifier.runWithViewAttachmentTransportLoader,
      loader: notifier.isTransportDocumentLoading,
      onUploadTap: () async => await notifier.uploadVehicleRegistrationImage(),
    );
  }

  Widget visitorNameTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.visitorNameController,
      fieldName: context.watchLang.translate(AppLanguageText.visitorName),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().visitorNameValidator(context, value),
    );
  }

  Widget companyNameTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.companyNameController,
      fieldName: context.watchLang.translate(AppLanguageText.companyName),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().companyValidator(context, value),
    );
  }

  Widget phoneNumberTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return MobileNumberField(
      mobileController: applyPassGroupNotifier.phoneNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.phoneNumber),
      isSmallFieldFont: true,
      countryCode: "+${applyPassGroupNotifier.selectedNationalityCodes ?? "966"}" ,
    );
  }

  Widget emailTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.emailController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().validateEmail(context, value),
    );
  }

  Widget nationalIdTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.nationalityIdController,
      fieldName: context.watchLang.translate(AppLanguageText.nationalID),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().validateNationalId(context, value),
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
      validator: (value) => idType.validator(context, value),
    );
  }

  Widget vehicleNumberTextField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.vehicleNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.vehicleNo),
      isSmallFieldFont: true,
      skipValidation: true,
      validator: (value) => CommonValidation().vehicleNumberValidator(context, value),
    );
  }

  // nationalityField
  Widget nationalityField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<CountryData>(
      fieldName: context.watchLang.translate(AppLanguageText.nationality),
      hintText: context.readLang.translate(AppLanguageText.select),
      controller: applyPassGroupNotifier.nationalityController,
      items: applyPassGroupNotifier.nationalityMenu,
      currentLang: context.lang,
      itemLabel: (item, lang) => CommonUtils.getLocalizedString(
          currentLang: lang,
          getArabic: () => item.nameAr,
          getEnglish: () => item.name,
        ),
      isSmallFieldFont: true,
      onSelected: (country) {
        applyPassGroupNotifier.selectedNationality = country?.iso3 ?? "";
        applyPassGroupNotifier.selectedNationalityCodes = country?.phonecode.toString() ?? "";
      },
      validator: (value) => CommonValidation().nationalityValidator(context, value),
    );
  }

  // idTypeField
  Widget idTypeField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomSearchDropdown<DocumentIdModel>(
      fieldName: context.watchLang.translate(AppLanguageText.idType),
      hintText: context.readLang.translate(AppLanguageText.select),
      controller: applyPassGroupNotifier.idTypeController,
      items: applyPassGroupNotifier.idTypeMenu,
      currentLang: context.lang,
      itemLabel: (item, lang) => CommonUtils.getLocalizedString(
          currentLang: lang,
          getArabic: () => item.labelAr,
          getEnglish: () => item.labelEn,
        ),
      isSmallFieldFont: true,
      onSelected: (DocumentIdModel? menu) {
        applyPassGroupNotifier.selectedIdValue = menu?.value.toString() ?? "";
        applyPassGroupNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator:(value) =>  CommonValidation().iDTypeValidator(context, value),
    );
  }

  // iqamaField
  Widget iqamaField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.iqamaController,
      fieldName: context.watchLang.translate(AppLanguageText.iqama),
      isSmallFieldFont: true,
      keyboardType: TextInputType.number,
      validator: (value) => CommonValidation().validateIqama(context, value),
    );
  }

  // passportField
  Widget passportField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.passportNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.passportNumber),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().validatePassport(context, value),
    );
  }

  // documentNameField
  Widget documentNameField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.documentNameController,
      fieldName: context.watchLang.translate(AppLanguageText.documentNameOther),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().documentNameValidator(context, value),
    );
  }

  // documentNumberField
  Widget documentNumberField(BuildContext context, ApplyPassGroupNotifier applyPassGroupNotifier) {
    return CustomTextField(
      controller: applyPassGroupNotifier.documentNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.documentNumberOther),
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().documentNumberValidator(context, value),
    );
  }
}
