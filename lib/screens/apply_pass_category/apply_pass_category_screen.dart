import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/country/country_response.dart';
import 'package:mofa/core/model/device_dropdown/device_dropdown_response.dart';
import 'package:mofa/core/model/location_dropdown/location_dropdown_response.dart';
import 'package:mofa/core/model/search_comment/search_comment_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_purpose_dropdown_response.dart';
import 'package:mofa/core/model/visit_dropdown/visit_request_dropdown_response.dart';
import 'package:mofa/core/notifier/language_notifier.dart';
import 'package:mofa/model/document/document_id_model.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/apply_pass_category/apply_pass_category_notifier.dart';
import 'package:mofa/screens/search_pass/search_pass_screen.dart';
import 'package:mofa/utils/common/widgets/loading_overlay.dart';
import 'package:mofa/utils/common_utils.dart';
import 'package:mofa/utils/common_validation.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:mofa/utils/extensions.dart';
import 'package:mofa/utils/common/widgets/bullet_list.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_dropdown_search.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:mofa/utils/toast_helper.dart';
import 'package:provider/provider.dart';

class ApplyPassCategoryScreen extends StatelessWidget {
  final ApplyPassCategory category;
  final VoidCallback onNext;
  final bool isUpdate;
  final int? id;

  const ApplyPassCategoryScreen({
    super.key,
    required this.onNext,
    required this.category,
    this.isUpdate = false,
    this.id,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplyPassCategoryNotifier(context, category, isUpdate, id),
      child: Consumer<ApplyPassCategoryNotifier>(
        builder: (context, applyPassCategoryNotifier, child) {
          return buildBody(context, applyPassCategoryNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    final lang = context.watchLang;

    int stepCounter = 1;
    List<Widget> children = [];

    String buildStepTitle(String title) => "${stepCounter++}. ${lang.translate(title)}";

    void addSection(Widget section, {bool addSpacing = true}) {
      if (children.isNotEmpty && addSpacing) {
        children.add(const SizedBox(height: 15));
      }
      children.add(section);
    }

    if (applyPassCategoryNotifier.isUpdate) {
      addSection(commentWidgetSection(context, applyPassCategoryNotifier), addSpacing: false);
    }

    // Step 1: Visitor Details
    addSection(
      buildExpansionTile(
        context,
        applyPassCategoryNotifier,
        title: buildStepTitle(AppLanguageText.visitorDetails),
        isVisitorDetails: true,
        children: visitorDetailsChildren(context, applyPassCategoryNotifier),
      ),
    );

    // Step 2 (if checked): Vehicle Info
    if (applyPassCategoryNotifier.isCheckedVehicle) {
      addSection(
        buildExpansionTile(
          context,
          applyPassCategoryNotifier,
          title: buildStepTitle(AppLanguageText.vehicleInformation),
          children: vehicleDetailsChildren(context, applyPassCategoryNotifier),
        ),
      );
    }

    // Step 3: Visit Details
    addSection(
      buildExpansionTile(
        context,
        applyPassCategoryNotifier,
        title: buildStepTitle(AppLanguageText.visitDetails),
        children: visitDetailsChildren(context, applyPassCategoryNotifier),
      ),
    );

    // Step 4 (if checked): Device Info
    if (applyPassCategoryNotifier.isCheckedDevice) {
      addSection(
        buildExpansionTile(
          context,
          applyPassCategoryNotifier,
          title: buildStepTitle(AppLanguageText.deviceDetails),
          children: deviceDetailsChildren(context, applyPassCategoryNotifier),
        ),
      );
    }

    // Step 5: Attachments
    addSection(
      buildExpansionTile(
        context,
        applyPassCategoryNotifier,
        title: buildStepTitle(AppLanguageText.attachments),
        children: attachmentsDetailsChildren(context, applyPassCategoryNotifier),
      ),
    );

    // Step 6 (conditionally): Resubmission
    if ((applyPassCategoryNotifier.getByIdResult?.user?.nIsHostRequiredMoreInfo ?? 0) == 1) {
      addSection(
        buildExpansionTile(
          context,
          applyPassCategoryNotifier,
          title: buildStepTitle(AppLanguageText.resubmissionComment),
          children: resubmissionCommentChildren(context, applyPassCategoryNotifier),
        ),
      );
    }

    // Final bullet list (not part of step count)
    addSection(buildBulletList(context, applyPassCategoryNotifier));

    // Final user action controls (checkbox + button)
    if (applyPassCategoryNotifier.isFormActionAllowed) {
      addSection(userVerifyCheckbox(context, applyPassCategoryNotifier));
      addSection(nextButton(context, applyPassCategoryNotifier));
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 25.h, right: 25.w, left: 25.w, top: 15.h),
      child: Form(key: applyPassCategoryNotifier.formKey, child: Column(children: children)),
    );
  }

  Widget commentWidgetSection(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return Align(
      alignment: Alignment.centerLeft,
      child: CustomButton(
        text: context.watchLang.translate(AppLanguageText.viewComments),
        smallWidth: true,
        height: 40,
        onPressed: () {
          _showCommentsBottomSheet(context, applyPassCategoryNotifier);
        },
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: AppColors.backgroundColor,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              commentsHeading(context, applyPassCategoryNotifier),
              10.verticalSpace,
              _buildSearchCommentDataTable(context, applyPassCategoryNotifier),
              10.verticalSpace,
              ...paginationDetails(context, applyPassCategoryNotifier),
            ],
          ),
        );
      },
    );
  }

  Widget commentsHeading(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(context.watchLang.translate(AppLanguageText.comments), style: AppFonts.textRegular20),
    );
  }

  Widget _buildSearchCommentDataTable(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    final visibleColumns = applyPassCategoryNotifier.columnConfigs.where((c) => c.isVisible).toList();
    final comments = applyPassCategoryNotifier.searchCommentData;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Scrollbar(
          controller: applyPassCategoryNotifier.scrollbarController,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          thumbVisibility: true,
          thickness: 5,
          interactive: true,
          radius: const Radius.circular(10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: applyPassCategoryNotifier.scrollbarController,
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith((_) => AppColors.buttonBgColor),
              headingTextStyle: AppFonts.textBoldWhite14,
              border: TableBorder(borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              columnSpacing: 20.w,
              dataRowMaxHeight: 65.h,
              columns: _buildColumns(visibleColumns),
              rows:
              comments.isEmpty
                  ? [_buildNoResultRow(visibleColumns.length)]
                  : _buildCommentRows(context, comments, visibleColumns),
            ),
          ),
        ),
      ),
    );
  }

  List<DataColumn> _buildColumns(List<TableColumnConfig> visibleColumns) {
    return visibleColumns.map((config) {
      return DataColumn(
        label: config.labelKey == "Status" ? Flexible(child: Center(child: Text(config.labelKey))) : Text(config.labelKey),
      );
    }).toList();
  }

  DataRow _buildNoResultRow(int columnCount) {
    return DataRow(
      cells: [
        DataCell(
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text('No result found', style: AppFonts.textRegularGrey16),
            ),
          ),
        ),
        ...List.generate(columnCount - 1, (_) => const DataCell(SizedBox())),
      ],
    );
  }

  List<DataRow> _buildCommentRows(BuildContext context,
      List<SearchCommentData> comments,
      List<TableColumnConfig> visibleColumns,) {
    return comments
        .asMap()
        .entries
        .map((entry) {
      final index = entry.key;
      final comment = entry.value;
      final isEvenRow = index.isEven;

      return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
              (_) => isEvenRow ? AppColors.buttonBgColor.withOpacity(0.05) : null,
        ),
        cells:
        visibleColumns.map((config) {
          return _buildDataCell(context, comment, config);
        }).toList(),
      );
    }).toList();
  }

  DataCell _buildDataCell(BuildContext context, SearchCommentData comment, TableColumnConfig config) {
    final isActionCell = config.labelKey == 'Action';
    final content = _buildCellContent(comment, config.labelKey);

    if (isActionCell) {
      return DataCell(content);
    } else {
      return DataCell(
        GestureDetector(
          onTap: () {
            // TODO: implement navigation or other action here
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: content),
        ),
      );
    }
  }

  Widget _buildCellContent(SearchCommentData comment, String label) {
    switch (label) {
      case 'Comment Type':
        return SizedBox(
          width: 120.w,
          child: Text(comment.sCommentTypeEn ?? "", maxLines: 2, overflow: TextOverflow.ellipsis),
        );
      case 'Comment By':
        return Text(comment.sRoleNameEn ?? "");
      case 'Comment':
        return SizedBox(
          width: 160.w,
          child: Text(comment.sComment ?? "", maxLines: 2, overflow: TextOverflow.ellipsis),
        );
      case 'Comment Date':
        return Text(comment.sCommentDate?.formatDateTime() ?? "");
      default:
        return const Text('');
    }
  }

  List<Widget> paginationDetails(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return [
      Text(
        "${context.watchLang.translate(AppLanguageText.totalRecords)} : ${applyPassCategoryNotifier.totalCount}",
        style: AppFonts.textMedium14,
      ),
      10.verticalSpace,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildPaginationButton(
            context,
            icon: context.watchLang.currentLang == "ar" ? LucideIcons.chevronRight : LucideIcons.chevronLeft,
            enabled: applyPassCategoryNotifier.currentPage > 1,
            onPressed: () => applyPassCategoryNotifier.goToPreviousPage(context, id),
          ),
          Text("${context.watchLang.translate(AppLanguageText.page)} ${applyPassCategoryNotifier.currentPage} ${context.watchLang.translate(AppLanguageText.of)} ${applyPassCategoryNotifier.totalPages}"),
          _buildPaginationButton(
            context,
            icon: context.watchLang.currentLang == "ar" ? LucideIcons.chevronLeft : LucideIcons.chevronRight,
            enabled: applyPassCategoryNotifier.currentPage < applyPassCategoryNotifier.totalPages,
            onPressed: () => applyPassCategoryNotifier.goToNextPage(context, id),
          ),
        ],
      ),
    ];
  }

  Widget _buildPaginationButton(BuildContext context, {
    required IconData icon,
    required bool enabled,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: enabled ? AppColors.buttonBgColor : Colors.grey,
        foregroundColor: Colors.white,
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.transparent, width: 1),
        ),
      ),
      onPressed: enabled ? onPressed : null,
      child: Icon(icon, size: 25, color: Colors.white),
    );
  }

  Widget buildExpansionTile(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier,{required String title, required List<Widget> children, isVisitorDetails = false}) {
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
          if (!applyPassCategoryNotifier.isUpdate) if (isVisitorDetails) Text("(${category.label(context)})", style: AppFonts.textMedium12),
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
          onPressed:
          !applyPassCategoryNotifier.isChecked
              ? null
              : () async {
            await applyPassCategoryNotifier.nextButton(context, onNext);
          },
        ),
      ],
    );
  }

  Widget userVerifyCheckbox(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return GestureDetector(
      onTap: () {
        applyPassCategoryNotifier.userVerifyChecked(context, !applyPassCategoryNotifier.isChecked);
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
                    color: applyPassCategoryNotifier.isChecked ? AppColors.primaryColor : AppColors.primaryColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  color: applyPassCategoryNotifier.isChecked ? AppColors.whiteColor : Colors.transparent,
                ),
                child: applyPassCategoryNotifier.isChecked ? Icon(Icons.check, size: 17, color: Colors.black) : null,
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

  Widget buildBulletList(BuildContext context, ApplyPassCategoryNotifier notifier) {
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


  List<Widget> visitorDetailsChildren(BuildContext context, ApplyPassCategoryNotifier notifier) {
    final idType = IdTypeExtension.fromString(notifier.selectedIdType);

    return [
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
      ..._buildIdSpecificFields(context, notifier, idType!),
      15.verticalSpace,
      expirationDateTextField(context, notifier),
      15.verticalSpace,
      // vehicleNumberTextField(context, notifier),
      vehicleDetailCheckbox(context, notifier),
    ];
  }

  List<Widget> _buildIdSpecificFields(BuildContext context, ApplyPassCategoryNotifier notifier, IdType idType) {
    switch (idType) {
      case IdType.nationalId:
        return [nationalIdTextField(context, notifier)];
      case IdType.passport:
        return [passportField(context, notifier)];
      case IdType.iqama:
        return [iqamaField(context, notifier)];
      case IdType.other:
        return [documentNameField(context, notifier), 15.verticalSpace, documentNumberField(context, notifier)];
      default:
        return [];
    }
  }

  Widget visitorNameTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.visitorNameController,
      fieldName: context.watchLang.translate(AppLanguageText.visitorName),
      isEnable: category == ApplyPassCategory.myself ? false : applyPassCategoryNotifier.isEnable,
      isSmallFieldFont: true,
      keyboardType: TextInputType.name,
      validator: (value) => CommonValidation().visitorNameValidator(context, value),
    );
  }

  Widget companyNameTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.companyNameController,
      fieldName: context.watchLang.translate(AppLanguageText.companyName),
      isSmallFieldFont: true,
      isEnable: category == ApplyPassCategory.myself ? false : applyPassCategoryNotifier.isEnable,
      validator: (value) => CommonValidation().companyValidator(context, value),
    );
  }

  Widget phoneNumberTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.phoneNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.phoneNumber),
      isSmallFieldFont: true,
      keyboardType: TextInputType.phone,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: (value) => CommonValidation().validateMobile(context, value),
    );
  }

  Widget emailTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.emailController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: (value) => CommonValidation().validateEmail(context, value),
    );
  }

  Widget nationalIdTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.nationalityIdController,
      fieldName: context.watchLang.translate(AppLanguageText.nationalID),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: (value) => CommonValidation().validateNationalId(context, value),
    );
  }

  Widget expirationDateTextField(BuildContext context, ApplyPassCategoryNotifier notifier) {
    final idType = IdTypeExtension.fromString(notifier.selectedIdType);

    return CustomTextField(
      controller: notifier.expiryDateController,
      fieldName: idType!.translatedLabel(context),
      isSmallFieldFont: true,
      keyboardType: TextInputType.datetime,
      startDate: DateTime.now(),
      initialDate:
      notifier.expiryDateController.text.isNotEmpty
          ? notifier.expiryDateController.text.toDateTime()
          : DateTime.now(),
      isEnable: notifier.isEnable,
      validator: (value) => idType.validator(context, value),
    );
  }

  Widget vehicleNumberTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.vehicleNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.vehicleNo),
      isSmallFieldFont: true,
      skipValidation: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: (value) => CommonValidation().vehicleNumberValidator(context, value),
    );
  }

  // nationalityField
  Widget nationalityField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<CountryData>(
      fieldName: context.watchLang.translate(AppLanguageText.nationality),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassCategoryNotifier.nationalityController,
      items: applyPassCategoryNotifier.nationalityMenu,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.nameAr,
        getEnglish: () => item.name,
      ),
      isSmallFieldFont: true,
      isEnable: category == ApplyPassCategory.myself ? false : applyPassCategoryNotifier.isEnable,
      onSelected: (country) {
        applyPassCategoryNotifier.selectedNationality = country?.iso3 ?? "";
      },
      validator: (value) => CommonValidation().nationalityValidator(context, value),
    );
  }

  // idTypeField
  Widget idTypeField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<DocumentIdModel>(
      fieldName: context.watchLang.translate(AppLanguageText.idType),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassCategoryNotifier.idTypeController,
      items: applyPassCategoryNotifier.idTypeMenu,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.labelAr,
        getEnglish: () => item.labelEn,
      ),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      onSelected: (DocumentIdModel? menu) {
        applyPassCategoryNotifier.selectedIdValue = menu?.value.toString() ?? "";
        applyPassCategoryNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: (value) => CommonValidation().iDTypeValidator(context, value),
    );
  }

  // iqamaField
  Widget iqamaField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.iqamaController,
      fieldName: context.watchLang.translate(AppLanguageText.iqama),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: (value) => CommonValidation().validateIqama(context, value),
    );
  }

  // passportField
  Widget passportField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.passportNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.passportNumber),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: (value) => CommonValidation().validatePassport(context, value),
    );
  }

  // documentNameField
  Widget documentNameField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.documentNameController,
      fieldName: context.watchLang.translate(AppLanguageText.documentNameOther),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: (value) => CommonValidation().documentNameValidator(context, value),
    );
  }

  // documentNumberField
  Widget documentNumberField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.documentNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.documentNumberOther),
      isEnable: applyPassCategoryNotifier.isEnable,
      isSmallFieldFont: true,
      validator: (value) => CommonValidation().documentNumberValidator(context, value),
    );
  }

  List<Widget> vehicleDetailsChildren(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return [
      plateTypeTextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      plateLetter1TextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      plateLetter2TextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      plateLetter3TextField(context, applyPassCategoryNotifier),
      15.verticalSpace,
      plateNumberTextField(context, applyPassCategoryNotifier),
    ];
  }

  Widget plateTypeTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.plateType),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassCategoryNotifier.plateTypeController,
      items: applyPassCategoryNotifier.plateTypeDropdownData,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.sDescA,
        getEnglish: () => item.sDescE,
      ),
      isSmallFieldFont: true,
      skipValidation: applyPassCategoryNotifier.isCheckedVehicle ? false : true,
      isEnable: applyPassCategoryNotifier.isEnable,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassCategoryNotifier.selectedPlateType = menu?.nDetailedCode ?? 0;
      },
      validator: (value) => CommonValidation().validatePlateType(context, value),
    );
  }

  Widget plateLetter1TextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.plateLetter1),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassCategoryNotifier.plateLetter1Controller,
      items: applyPassCategoryNotifier.plateLetterDropdownData,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.sDescA,
        getEnglish: () => item.sDescE,
      ),
      isSmallFieldFont: true,
      skipValidation: applyPassCategoryNotifier.isCheckedVehicle ? false : true,
      isEnable: applyPassCategoryNotifier.isEnable,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassCategoryNotifier.selectedPlateLetter1 = menu?.nDetailedCode ?? 0;
      },
      validator: (value) => CommonValidation().validatePlateLetter1(context, value),
    );
  }

  Widget plateLetter2TextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.plateLetter2),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassCategoryNotifier.plateLetter2Controller,
      items: applyPassCategoryNotifier.plateLetterDropdownData,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.sDescA,
        getEnglish: () => item.sDescE,
      ),
      isSmallFieldFont: true,
      skipValidation: applyPassCategoryNotifier.isCheckedVehicle ? false : true,
      isEnable: applyPassCategoryNotifier.isEnable,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassCategoryNotifier.selectedPlateLetter2 = menu?.nDetailedCode ?? 0;
      },
      validator: (value) => CommonValidation().validatePlateLetter2(context, value),
    );
  }

  Widget plateLetter3TextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.plateLetter3),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassCategoryNotifier.plateLetter3Controller,
      items: applyPassCategoryNotifier.plateLetterDropdownData,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.sDescA,
        getEnglish: () => item.sDescE,
      ),
      isSmallFieldFont: true,
      skipValidation: applyPassCategoryNotifier.isCheckedVehicle ? false : true,
      isEnable: applyPassCategoryNotifier.isEnable,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassCategoryNotifier.selectedPlateLetter3 = menu?.nDetailedCode ?? 0;
      },
      validator: (value) => CommonValidation().validatePlateLetter3(context, value),
    );
  }

  Widget plateNumberTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.plateNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.plateNumber),
      isSmallFieldFont: true,
      skipValidation: applyPassCategoryNotifier.isCheckedVehicle ? false : true,
      isEnable: applyPassCategoryNotifier.isEnable,
      keyboardType: TextInputType.number,
      validator: (value) => CommonValidation().validatePlateNumber(context, value),
    );
  }

  List<Widget> visitDetailsChildren(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
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
      deviceDetailCheckbox(context, applyPassCategoryNotifier),
    ];
  }

  Widget deviceDetailCheckbox(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return GestureDetector(
      onTap: !applyPassCategoryNotifier.isEnable ? null : () {
        applyPassCategoryNotifier.deviceDetailChecked(context, !applyPassCategoryNotifier.isCheckedDevice);
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
                  color: !applyPassCategoryNotifier.isEnable ? AppColors.greyColor : AppColors.primaryColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
                color: applyPassCategoryNotifier.isCheckedDevice ? AppColors.whiteColor : Colors.transparent,
              ),
              child:
              applyPassCategoryNotifier.isCheckedDevice ? Icon(Icons.check, size: 17, color: !applyPassCategoryNotifier.isEnable ? AppColors.greyColor : Colors.black) : null,
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                context.watchLang.translate(AppLanguageText.declareDevicesBroughtOnsite),
                style: !applyPassCategoryNotifier.isEnable ? AppFonts.textRegular14Grey :AppFonts.textRegular14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget vehicleDetailCheckbox(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return GestureDetector(
      onTap: !applyPassCategoryNotifier.isEnable ? null : () {
        applyPassCategoryNotifier.vehicleDetailChecked(!applyPassCategoryNotifier.isCheckedVehicle);
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
                  color: !applyPassCategoryNotifier.isEnable ? AppColors.greyColor : AppColors.primaryColor,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(6),
                color: applyPassCategoryNotifier.isCheckedVehicle ? AppColors.whiteColor : Colors.transparent,
              ),
              child:
              applyPassCategoryNotifier.isCheckedVehicle ? Icon(Icons.check, size: 17, color: !applyPassCategoryNotifier.isEnable ? AppColors.greyColor :Colors.black) : null,
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(context.watchLang.translate(AppLanguageText.vehicleDetails), style: !applyPassCategoryNotifier.isEnable ? AppFonts.textRegularGrey14 : AppFonts.textRegular14),
            ),
          ],
        ),
      ),
    );
  }

  Widget locationTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<LocationDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.location),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassCategoryNotifier.locationController,
      items: applyPassCategoryNotifier.locationDropdownData,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.sLocationNameAr,
        getEnglish: () => item.sLocationNameEn,
      ),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      onSelected: (LocationDropdownResult? menu) {
        applyPassCategoryNotifier.selectedLocationId = menu?.nLocationId ?? 0;
        // applyPassCategoryNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: (value) => CommonValidation().validateLocation(context, value),
    );
  }

  Widget visitRequestTypeTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<VisitRequestDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.visitRequestType),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassCategoryNotifier.visitRequestTypeController,
      items: applyPassCategoryNotifier.visitRequestTypesDropdownData,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.sDescA,
        getEnglish: () => item.sDescE,
      ),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      onSelected: (VisitRequestDropdownResult? menu) {
        applyPassCategoryNotifier.selectedVisitRequest = menu?.nDetailedCode.toString() ?? "";
        // applyPassCategoryNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: (value) => CommonValidation().validateVisitRequestType(context, value),
    );
  }

  Widget visitPurposeTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<VisitPurposeDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.visitPurpose),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassCategoryNotifier.visitPurposeController,
      items: applyPassCategoryNotifier.visitPurposeDropdownData,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.sPurposeAr,
        getEnglish: () => item.sPurposeEn,
      ),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      onSelected: (VisitPurposeDropdownResult? menu) {
        applyPassCategoryNotifier.selectedVisitPurpose = menu?.nPurposeId.toString() ?? "";
        // applyPassCategoryNotifier.selectedIdType = menu?.labelEn ?? "";
      },
      validator: (value) => CommonValidation().validateVisitPurpose(context, value),
    );
  }

  Widget mofaHostEmailTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.mofaHostEmailController,
      fieldName: context.watchLang.translate(AppLanguageText.hostEmailAddress),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: (value) => CommonValidation().validateMofaHostEmail(context, value),
    );
  }

  Widget visitStartDateTextField(
      BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier,
      ) {
    DateTime? selectedStart;
    if (applyPassCategoryNotifier.visitStartDateController.text.isNotEmpty) {
      final DateFormat formatter = DateFormat("dd/MM/yyyy, hh:mm a");
      final normalized = applyPassCategoryNotifier.visitStartDateController.text
          .replaceAll(RegExp(r'\s*,\s*'), ', ');
      selectedStart = formatter.parse(normalized);
    }

    return CustomTextField(
      controller: applyPassCategoryNotifier.visitStartDateController,
      fieldName: context.watchLang.translate(AppLanguageText.visitStartDate),
      isSmallFieldFont: true,
      startDate: DateTime.now(),
      initialDate: selectedStart ?? DateTime.now(),
      keyboardType: TextInputType.datetime,
      onChanged: (value) {
        try {
          final parseFormat = DateFormat("dd/MM/yyyy, hh:mm a");
          final normalized = value
              .replaceAll(RegExp(r'\s*,\s*'), ', ');
          final DateTime selectedStart = parseFormat.parse(normalized);
          final DateTime oneHourLater = selectedStart.add(Duration(hours: 1));

          final displayFormat = DateFormat("dd/MM/yyyy, hh:mm a");
          applyPassCategoryNotifier.visitEndDateController.text =
              displayFormat.format(oneHourLater);

          applyPassCategoryNotifier.notifyDataListeners();
        } catch (e) {
          debugPrint("Invalid date format: $e");
        }
      },
      isEnable: applyPassCategoryNotifier.isEnable,
      needTime: true,
      validator: (value) => CommonValidation().validateVisitStartDate(context, value),
    );
  }

  Widget visitEndDateTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    DateTime? parsedStartDate;
    if (applyPassCategoryNotifier.visitStartDateController.text.isNotEmpty) {
      try {
        parsedStartDate = DateFormat(
          "dd/MM/yyyy, hh:mm a",
        ).parse(applyPassCategoryNotifier.visitStartDateController.text);
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
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: (value) => CommonValidation().validateVisitEndDate(context, value),
      isEditable: applyPassCategoryNotifier.visitStartDateController.text.isEmpty,
    );
  }

  Widget noteTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return Column(
      children: [
        Text(
          "${context.watchLang.translate(AppLanguageText.note)}: ${context.watchLang.translate(
              AppLanguageText.visitRequestDelay)} ",
          style: AppFonts.textRegular14Red,
        ),
        10.verticalSpace,
        CustomTextField(
          controller: applyPassCategoryNotifier.noteController,
          fieldName: context.watchLang.translate(AppLanguageText.note),
          isSmallFieldFont: true,
          isEnable: applyPassCategoryNotifier.isEnable,
          skipValidation: true,
        ),
      ],
    );
  }

  List<Widget> deviceDetailsChildren(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return [
      deviceDetailsChipList(context, applyPassCategoryNotifier),
      15.verticalSpace,
      if (applyPassCategoryNotifier.showDeviceFields) ...[
        deviceTypeTextField(context, applyPassCategoryNotifier),
        15.verticalSpace,
        deviceModelTextField(context, applyPassCategoryNotifier),
        15.verticalSpace,
        serialNumberTextField(context, applyPassCategoryNotifier),
        15.verticalSpace,
        devicePurposeTextField(context, applyPassCategoryNotifier),
      ],
      15.verticalSpace,
      saveAndCancel(context, applyPassCategoryNotifier),
    ];
  }

  Widget deviceDetailsTable(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    final devices = applyPassCategoryNotifier.addedDevices;

    final headerDecoration = BoxDecoration(
      color: AppColors.buttonBgColor.withOpacity(0.5),
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), topRight: Radius.circular(8)),
    );

    final borderDecoration = BoxDecoration(
      border: Border.all(color: Colors.grey.shade300),
      borderRadius: BorderRadius.circular(8),
    );

    Widget header() {
      return Container(
        width: double.infinity,
        decoration: headerDecoration,
        padding: const EdgeInsets.all(12),
        child: const Text('Device Details', style: AppFonts.textBoldWhite14),
      );
    }

    Widget noData() {
      return const Padding(padding: EdgeInsets.all(16), child: Text('No result found'));
    }

    Widget actionButtons(int index) {
      return Row(
        children: [
          GestureDetector(
            onTap: () => applyPassCategoryNotifier.startEditingDevice(index),
            child: Container(
              height: 28,
              width: 48,
              decoration: BoxDecoration(color: AppColors.buttonBgColor, borderRadius: BorderRadius.circular(10)),
              child: const Icon(LucideIcons.pencil, color: AppColors.whiteColor, size: 20),
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () => applyPassCategoryNotifier.removeDevice(index),
            child: Container(
              height: 28,
              width: 48,
              decoration: BoxDecoration(color: AppColors.textRedColor, borderRadius: BorderRadius.circular(10)),
              child: const Icon(LucideIcons.trash, color: AppColors.whiteColor, size: 20),
            ),
          ),
        ],
      );
    }

    if (devices.isEmpty) {
      return Container(
        decoration: borderDecoration,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [header(), noData()]),
      );
    }

    return Container(
      decoration: borderDecoration,
      child: Column(
        children: [
          // header(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith((_) => AppColors.buttonBgColor.withOpacity(0.5)),
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
              devices
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key;
                final device = entry.value;

                return DataRow(
                  cells: [
                    DataCell(Text(device.deviceTypeString ?? "")),
                    DataCell(Text(device.deviceModel ?? "")),
                    DataCell(Text(device.serialNumber ?? "")),
                    DataCell(Text(device.devicePurposeString ?? "")),
                    DataCell(actionButtons(index)),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget deviceDetailsChipList(BuildContext context, ApplyPassCategoryNotifier notifier) {
    final devices = notifier.addedDevices;

    if (devices.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(context.watchLang.translate(AppLanguageText.noDeviceAdded)),
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
          onDeleted: !notifier.isEnable ? null : () => notifier.removeDevice(index),
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

  Widget addDeviceButton(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomButton(
      text: context.watchLang.translate(AppLanguageText.addDevice),
      onPressed:
      !(applyPassCategoryNotifier.isFormActionAllowed)
          ? null
          : () => applyPassCategoryNotifier.showDeviceFieldsAgain(),
    );
  }

  Widget saveAndCancel(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    final isEditing = applyPassCategoryNotifier.isEditingDevice;
    final showFields = applyPassCategoryNotifier.showDeviceFields;

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
              if (!applyPassCategoryNotifier.isFormActionAllowed) return;

              if (applyPassCategoryNotifier.isDevicePartiallyFilled()) {
                ToastHelper.showError(context.readLang.translate(AppLanguageText.fillDeviceDetails));
                return;
              }

              if (showFields) {
                applyPassCategoryNotifier.saveDevice(); // Save or update
              } else {
                applyPassCategoryNotifier.showDeviceFieldsAgain(); // Show fields to add
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
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: (value) => CommonValidation().validateDeviceModel(context, value),
    );
  }

  Widget serialNumberTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.serialNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.serialNumber),
      isSmallFieldFont: true,
      skipValidation: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: (value) => CommonValidation().validateSerialNumber(context, value),
    );
  }

  Widget deviceTypeTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.deviceType),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassCategoryNotifier.deviceTypeController,
      items: applyPassCategoryNotifier.deviceTypeDropdownData,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.sDescA,
        getEnglish: () => item.sDescE,
      ),
      isSmallFieldFont: true,
      skipValidation: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassCategoryNotifier.selectedDeviceType = menu?.nDetailedCode ?? 0;
      },
      validator: (value) => CommonValidation().validateDeviceType(context, value),
    );
  }

  Widget devicePurposeTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.devicePurpose),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: applyPassCategoryNotifier.devicePurposeController,
      items: applyPassCategoryNotifier.devicePurposeDropdownData,
      itemLabel: (item) => CommonUtils.getLocalizedString(
        currentLang: context.lang,
        getArabic: () => item.sDescA,
        getEnglish: () => item.sDescE,
      ),
      isSmallFieldFont: true,
      skipValidation: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      onSelected: (DeviceDropdownResult? menu) {
        applyPassCategoryNotifier.selectedDevicePurpose = menu?.nDetailedCode ?? 0;
      },
      validator: (value) => CommonValidation().validateDevicePurpose(context, value),
    );
  }

  List<Widget> attachmentsDetailsChildren(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return [
      buildUploadImageSection(context, applyPassCategoryNotifier),
      15.verticalSpace,
      buildUploadDocumentSection(context, applyPassCategoryNotifier),
      15.verticalSpace,
      buildUploadVehicleRegistrationSection(context, applyPassCategoryNotifier),
      15.verticalSpace,
      Align(
        alignment: Alignment.centerLeft,
        child: Text(
          "${context.watchLang.translate(AppLanguageText.note)}: ${context.watchLang.translate(
              AppLanguageText.latestPhoto)} ",
          style: AppFonts.textRegular14Red,
        ),
      ),
    ];
  }

  List<Widget> resubmissionCommentChildren(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return [resubmissionCommentTextField(context, applyPassCategoryNotifier)];
  }

  Widget resubmissionCommentTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return TextFormField(
      controller: applyPassCategoryNotifier.resubmissionCommentController,
      maxLines: 1,
      style: AppFonts.textRegular14,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        fillColor: AppColors.whiteColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.fieldBorderColor, width: 2.5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.fieldBorderColor, width: 2.5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.fieldBorderColor, width: 2.5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.fieldBorderColor, width: 2.5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.fieldBorderColor, width: 2.5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.fieldBorderColor, width: 2.5),
          borderRadius: BorderRadius.circular(15.0),
        ),
        hintStyle: AppFonts.textRegularGrey16,
        labelStyle: AppFonts.textRegular17,
        errorStyle: TextStyle(color: AppColors.underscoreColor),
      ),
      validator: (value) => CommonValidation().commonValidator(context, value),
    );
  }

  Widget buildUploadImageSection(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    final lang = context.watchLang;
    final uploadedFileName =
        applyPassCategoryNotifier.uploadedImageFile?.path
            .split('/')
            .last ??
            lang.translate(AppLanguageText.noFileSelected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelWithTooltip(context, lang),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(uploadedFileName, overflow: TextOverflow.ellipsis)),
            CustomUploadButton(
              text: lang.translate(AppLanguageText.uploadFile),
              onPressed:
              applyPassCategoryNotifier.isFormActionAllowed
                  ? () => _showUploadOptions(context, applyPassCategoryNotifier)
                  : null,
            ),
          ],
        ),
        const Divider(height: 10, thickness: 1),
        if (applyPassCategoryNotifier.photoUploadValidation)
          Text(context.readLang.translate(AppLanguageText.validationPhotoUploadRequired), style: AppFonts.errorTextRegular12),
        const SizedBox(height: 5),
        if ((applyPassCategoryNotifier.getByIdResult?.user?.havePhoto == 1 || applyPassCategoryNotifier.uploadedImageBytes != null) &&
            applyPassCategoryNotifier.uploadedImageFile == null)
          _buildViewAttachment(context, applyPassCategoryNotifier, lang),
      ],
    );
  }

  Widget _buildLabelWithTooltip(BuildContext context, LanguageNotifier lang) {
    final langContext = context.readLang;

    return Row(
      children: [
        Text(lang.translate(AppLanguageText.uploadPhoto), style: AppFonts.textRegular14),
        const SizedBox(width: 3),
        const Text("*", style: TextStyle(fontSize: 15, color: AppColors.textRedColor)),
        const SizedBox(width: 3),
        Tooltip(
          message:
          "${langContext.translate(AppLanguageText.uploadRecentPassport)}\n ${langContext.translate(AppLanguageText.photoJpgPng)}\n ${langContext.translate(AppLanguageText.ensureTheImage)}\n ${langContext.translate(AppLanguageText.officialGuidelines)}",
          textAlign: TextAlign.center,
          decoration: BoxDecoration(color: AppColors.primaryColor, borderRadius: BorderRadius.circular(5)),
          child: const Icon(Icons.info_outline, size: 20, color: AppColors.primaryColor),
        ),
      ],
    );
  }

  void _showUploadOptions(BuildContext context, ApplyPassCategoryNotifier notifier) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      backgroundColor: Colors.white,
      builder:
          (context) =>
          Padding(
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
                Text(context.watchLang.translate(AppLanguageText.uploadPhoto), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _uploadOptionCard(
                      icon: LucideIcons.camera,
                      label: context.readLang.translate(AppLanguageText.camera),
                      onTap: () async {
                        Navigator.pop(context);
                        await notifier.uploadImage(fromCamera: true, cropAfterPick: true);
                      },
                    ),
                    _uploadOptionCard(
                      icon: LucideIcons.image,
                      label: context.readLang.translate(AppLanguageText.device),
                      onTap: () async {
                        Navigator.pop(context);
                        await notifier.uploadImage(fromCamera: false, cropAfterPick: true);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
    );
  }

  Widget _uploadOptionCard({required IconData icon, required String label, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.buttonBgColor,
            child: Icon(icon, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 8),
          Text(label),
        ],
      ),
    );
  }

  Widget _buildViewAttachment(BuildContext context, ApplyPassCategoryNotifier notifier, LanguageNotifier lang) {
    return GestureDetector(
      onTap: () async {
        if (notifier.getByIdResult?.user?.havePhoto == 1) {
          await notifier.apiGetFile(context, type: 1);
        }
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (_) =>
              AlertDialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                content: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                              onTap: () => Navigator.pop(context),
                              child: Icon(LucideIcons.x))),
                      5.verticalSpace,
                      Image.memory(notifier.uploadedImageBytes!),
                    ],
                  ),
                ),
              ),
        );
      },
      child: Text(lang.translate(AppLanguageText.viewAttachment), style: AppFonts.textRegularAttachment14),
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

  Widget  buildUploadDocumentSection(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    final lang = context.watchLang;
    final selectedIdType = applyPassCategoryNotifier.selectedIdType;
    final uploadedFileName =
        applyPassCategoryNotifier.uploadedDocumentFile?.path
            .split('/')
            .last ??
            lang.translate(AppLanguageText.noFileSelected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocumentLabel(context, applyPassCategoryNotifier,selectedIdType ?? ""),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(uploadedFileName, overflow: TextOverflow.ellipsis)),
            CustomUploadButton(
              text: lang.translate(AppLanguageText.uploadFile),
              onPressed:
              applyPassCategoryNotifier.isFormActionAllowed
                  ? () async => await applyPassCategoryNotifier.uploadDocument()
                  : null,
            ),
          ],
        ),
        const Divider(height: 10, thickness: 1),
        if (applyPassCategoryNotifier.documentUploadValidation)
          Text("$selectedIdType ${context.readLang.translate(AppLanguageText.upload)} ${context.readLang.translate(AppLanguageText.validationRequired)}", style: AppFonts.errorTextRegular12),
        const SizedBox(height: 5),
        if (_hasValidDocument(applyPassCategoryNotifier))
          _buildViewAttachmentButton(context, applyPassCategoryNotifier, lang, selectedIdType ?? ""),
      ],
    );
  }

  Widget _buildDocumentLabel(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier, String selectedIdType) {
    return Row(
      children: [
        Text(_getFileHeader(context, selectedIdType), style: AppFonts.textRegular14),
        const SizedBox(width: 3),
        const Text("*", style: TextStyle(fontSize: 15, color: AppColors.textRedColor)),
      ],
    );
  }



  bool _hasValidDocument(ApplyPassCategoryNotifier notifier) {
    final user = notifier.getByIdResult?.user;

    final hasStoredBytes = notifier.uploadedDocumentBytes != null;
    print('hasStoredBytes: $hasStoredBytes');

    final isNotUploadingNewFile = notifier.uploadedDocumentFile == null;
    print('isNotUploadingNewFile: $isNotUploadingNewFile');

    // If user is null, rely only on uploaded bytes
    if (user == null) {
      print('No user data available. Checking based on uploaded bytes.');
      final result = hasStoredBytes && isNotUploadingNewFile;
      print('Final result of _hasValidDocument (user null case): $result');
      return result;
    }

    final hasApiDocument = user.haveEid == 1 ||
        user.haveIqama == 1 ||
        user.havePassport == 1 ||
        user.haveOthers == 1;
    print('hasApiDocument: $hasApiDocument');

    final result = (hasApiDocument || hasStoredBytes) && isNotUploadingNewFile;
    print('Final result of _hasValidDocument: $result');

    return result;
  }



  Widget _buildViewAttachmentButton(BuildContext context,
      ApplyPassCategoryNotifier notifier,
      LanguageNotifier lang,
      String selectedIdType,) {
    int type = _getFileType(selectedIdType);

    return GestureDetector(
      onTap: () async {
        final user = notifier.getByIdResult?.user;
        final hasAnyDocument = user?.havePassport == 1 ||
            user?.haveIqama == 1 ||
            user?.haveEid == 1 ||
            user?.haveOthers == 1;

        if (hasAnyDocument) {
          await notifier.apiGetFile(context, type: type);
        } else {
          await notifier.localGetFile(context, type: type);
        }
      },
      child: Text(lang.translate(AppLanguageText.viewAttachment), style: AppFonts.textRegularAttachment14),
    );
  }

  int _getFileType(String idType) {
    switch (idType) {
      case "National ID":
        return 2;
      case "Passport":
        return 3;
      case "Iqama":
        return 5;
      case "Other":
        return 6;
      default:
        return 1;
    }
  }

  String _getFileHeader(BuildContext context, String idType) {
    switch (idType) {
      case "National ID":
        return context.watchLang.translate(AppLanguageText.uploadNationalID);
      case "Passport":
        return context.watchLang.translate(AppLanguageText.uploadPassport);
      case "Iqama":
        return context.watchLang.translate(AppLanguageText.uploadIqama);
      case "Other":
        return context.watchLang.translate(AppLanguageText.uploadDocumentOther);
      default:
        return context.watchLang.translate(AppLanguageText.uploadNationalID);
    }
  }

  Widget buildUploadVehicleRegistrationSection(BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier,) {
    final lang = context.watchLang;
    final uploadedFileName =
        applyPassCategoryNotifier.uploadedVehicleRegistrationFile?.path
            .split('/')
            .last ??
            lang.translate(AppLanguageText.noFileSelected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(lang.translate(AppLanguageText.vehicleRegistrationLicense), style: AppFonts.textRegular14),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(uploadedFileName, overflow: TextOverflow.ellipsis)),
            CustomUploadButton(
              text: lang.translate(AppLanguageText.uploadFile),
              onPressed:
              applyPassCategoryNotifier.isFormActionAllowed
                  ? () async => await applyPassCategoryNotifier.uploadVehicleRegistrationImage()
                  : null,
            ),
          ],
        ),
        const Divider(height: 10, thickness: 1),
        const SizedBox(height: 5),
        if (_hasVehicleRegistration(applyPassCategoryNotifier))
          _buildViewAttachmentButton(context, applyPassCategoryNotifier, lang, "4"),
      ],
    );
  }

  bool _hasVehicleRegistration(ApplyPassCategoryNotifier notifier) {
    final user = notifier.getByIdResult?.user;
    return user?.haveVehicleRegistration == 1 || notifier.uploadedVehicleImageBytes != null;
  }
}
