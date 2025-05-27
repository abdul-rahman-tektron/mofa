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
import 'package:mofa/utils/common_validation.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:mofa/utils/extensions.dart';
import 'package:mofa/utils/common/widgets/bullet_list.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_dropdown_search.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:provider/provider.dart';

class ApplyPassCategoryScreen extends StatelessWidget {
  final ApplyPassCategory category;
  final VoidCallback onNext;
  final bool isUpdate;
  final int? id;

  const ApplyPassCategoryScreen({super.key,required this.onNext, required this.category, this.isUpdate = false, this.id});

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

    String buildStepTitle(int step, String title) => "$step. ${lang.translate(title)}";

    // Collect children with spacing, skipping nulls easily
    List<Widget> children = [];

    void addSection(Widget section, {bool addSpacing = true}) {
      if (children.isNotEmpty && addSpacing) {
        children.add(const SizedBox(height: 15));
      }
      children.add(section);
    }

    addSection(commentWidgetSection(context, applyPassCategoryNotifier));

    addSection(
      buildExpansionTile(
        title: buildStepTitle(1, AppLanguageText.visitorDetails),
        isVisitorDetails: true,
        children: visitorDetailsChildren(context, applyPassCategoryNotifier),
      ),
    );

    if(applyPassCategoryNotifier.isUpdate) {
      addSection(
        buildExpansionTile(
          title: buildStepTitle(2, AppLanguageText.visitDetails),
          children: visitDetailsChildren(context, applyPassCategoryNotifier),
        ),
      );
    }

    if (applyPassCategoryNotifier.isCheckedDevice) {
      addSection(
        buildExpansionTile(
          title: buildStepTitle(3, AppLanguageText.deviceDetails),
          children: deviceDetailsChildren(context, applyPassCategoryNotifier),
        ),
      );
    }

    final attachmentsStep = applyPassCategoryNotifier.isCheckedDevice ? 4 : 3;
    addSection(
      buildExpansionTile(
        title: "$attachmentsStep. ${lang.translate(AppLanguageText.attachments)}",
        children: attachmentsDetailsChildren(context, applyPassCategoryNotifier),
      ),
    );

    if ((applyPassCategoryNotifier.getByIdResult?.user?.nIsHostRequiredMoreInfo ?? 0) == 1) {
      final resubmissionStep = applyPassCategoryNotifier.isCheckedDevice ? 5 : 4;
      addSection(
        buildExpansionTile(
          title: "$resubmissionStep. ${lang.translate(AppLanguageText.resubmissionComment)}",
          children: resubmissionCommentChildren(context, applyPassCategoryNotifier),
        ),
      );
    }

    addSection(buildBulletList(context, applyPassCategoryNotifier));

    if (applyPassCategoryNotifier.isFormActionAllowed) {
      addSection(userVerifyCheckbox(context, applyPassCategoryNotifier));
      addSection(nextButton(context, applyPassCategoryNotifier));
    }

    return Padding(
      padding: EdgeInsets.only(
        bottom: 25.h,
        right: 25.w,
        left: 25.w,
        top: 15.h,
      ),
      child: Form(
        key: applyPassCategoryNotifier.formKey,
        child: Column(children: children),
      ),
    );
  }


  Widget commentWidgetSection(
      BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier,
      ) {
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

  void _showCommentsBottomSheet(
      BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier,
      ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
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

  Widget commentsHeading(
      BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier,
      ) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        context.watchLang.translate(AppLanguageText.comments),
        style: AppFonts.textRegular20,
      ),
    );
  }

  Widget _buildSearchCommentDataTable(
      BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier,
      ) {
    final visibleColumns =
    applyPassCategoryNotifier.columnConfigs.where((c) => c.isVisible).toList();
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
              headingRowColor: MaterialStateColor.resolveWith(
                    (_) => AppColors.buttonBgColor,
              ),
              headingTextStyle: AppFonts.textBoldWhite14,
              border: TableBorder(borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              columnSpacing: 20.w,
              dataRowMaxHeight: 55.h,
              columns: _buildColumns(visibleColumns),
              rows: comments.isEmpty
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
        label: config.label == "Status"
            ? Flexible(child: Center(child: Text(config.label)))
            : Text(config.label),
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
              child: Text(
                'No result found',
                style: AppFonts.textRegularGrey16,
              ),
            ),
          ),
        ),
        ...List.generate(columnCount - 1, (_) => const DataCell(SizedBox())),
      ],
    );
  }

  List<DataRow> _buildCommentRows(
      BuildContext context,
      List<SearchCommentData> comments,
      List<TableColumnConfig> visibleColumns,
      ) {
    return comments.asMap().entries.map((entry) {
      final index = entry.key;
      final comment = entry.value;
      final isEvenRow = index.isEven;

      return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
              (_) => isEvenRow ? AppColors.buttonBgColor.withOpacity(0.05) : null,
        ),
        cells: visibleColumns.map((config) {
          return _buildDataCell(context, comment, config);
        }).toList(),
      );
    }).toList();
  }

  DataCell _buildDataCell(
      BuildContext context,
      SearchCommentData comment,
      TableColumnConfig config,
      ) {
    final isActionCell = config.label == 'Action';
    final content = _buildCellContent(comment, config.label);

    if (isActionCell) {
      return DataCell(content);
    } else {
      return DataCell(
        GestureDetector(
          onTap: () {
            // TODO: implement navigation or other action here
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: content,
          ),
        ),
      );
    }
  }

  Widget _buildCellContent(SearchCommentData comment, String label) {
    switch (label) {
      case 'Comment Type':
        return SizedBox(
          width: 120.w,
          child: Text(
            comment.sCommentTypeEn ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      case 'Comment By':
        return Text(comment.sRoleNameEn ?? "");
      case 'Comment':
        return SizedBox(
          width: 160.w,
          child: Text(
            comment.sComment ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
      case 'Comment Date':
        return Text(comment.sCommentDate?.formatDateTime() ?? "");
      default:
        return const Text('');
    }
  }

  List<Widget> paginationDetails(
      BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier,
      ) {
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
            icon: LucideIcons.chevronLeft,
            enabled: applyPassCategoryNotifier.currentPage > 1,
            onPressed: () => applyPassCategoryNotifier.goToPreviousPage(context, id),
          ),
          Text("Page ${applyPassCategoryNotifier.currentPage} of ${applyPassCategoryNotifier.totalPages}"),
          _buildPaginationButton(
            context,
            icon: LucideIcons.chevronRight,
            enabled: applyPassCategoryNotifier.currentPage < applyPassCategoryNotifier.totalPages,
            onPressed: () => applyPassCategoryNotifier.goToNextPage(context, id),
          ),
        ],
      ),
    ];
  }

  Widget _buildPaginationButton(
      BuildContext context, {
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
          onPressed: !applyPassCategoryNotifier.isChecked  ? null : () async {
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
        onTap: () {
          applyPassCategoryNotifier.userVerifyChecked(
            context,
            !applyPassCategoryNotifier.isChecked,
          );
        },
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
      ApplyPassCategoryNotifier notifier,) {
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
      vehicleNumberTextField(context, notifier),
    ];
  }


  List<Widget> _buildIdSpecificFields(BuildContext context,
      ApplyPassCategoryNotifier notifier,
      IdType idType,) {
    switch (idType) {
      case IdType.nationalId:
        return [nationalIdTextField(context, notifier)];
      case IdType.passport:
        return [passportField(context, notifier)];
      case IdType.iqama:
        return [iqamaField(context, notifier)];
      case IdType.other:
        return [
          documentNameField(context, notifier),
          15.verticalSpace,
          documentNumberField(context, notifier),
        ];
      default:
        return [];
    }
  }


  Widget visitorNameTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.visitorNameController,
      fieldName: context.watchLang.translate(AppLanguageText.visitorName),
      isEnable: applyPassCategoryNotifier.isEnable,
      isSmallFieldFont: true,
      validator: CommonValidation().visitorNameValidator,
    );
  }

  Widget companyNameTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.companyNameController,
      fieldName: context.watchLang.translate(AppLanguageText.companyName),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: CommonValidation().companyValidator,
    );
  }

  Widget phoneNumberTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.phoneNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.phoneNumber),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: CommonValidation().validateMobile,
    );
  }

  Widget emailTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.emailController,
      fieldName: context.watchLang.translate(AppLanguageText.emailAddress),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: CommonValidation().validateEmail,
    );
  }

  Widget nationalIdTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.nationalityIdController,
      fieldName: context.watchLang.translate(AppLanguageText.nationalID),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: CommonValidation().validateNationalId,
    );
  }

  Widget expirationDateTextField(
      BuildContext context,
      ApplyPassCategoryNotifier notifier,
      ) {
    final idType = IdTypeExtension.fromString(notifier.selectedIdType);

    return CustomTextField(
      controller: notifier.expiryDateController,
      fieldName: idType!.translatedLabel(context),
      isSmallFieldFont: true,
      keyboardType: TextInputType.datetime,
      startDate: DateTime.now(),
      initialDate: notifier.expiryDateController.text.isNotEmpty
          ? notifier.expiryDateController.text.toDateTime()
          : DateTime.now(),
      isEnable: notifier.isEnable,
      validator: idType.validator,
    );
  }

  Widget vehicleNumberTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.vehicleNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.vehicleNo),
      isSmallFieldFont: true,
      skipValidation: true,
      isEnable: applyPassCategoryNotifier.isEnable,
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
      isEnable: applyPassCategoryNotifier.isEnable,
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
      isEnable: applyPassCategoryNotifier.isEnable,
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
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: CommonValidation().validateIqama,
    );
  }

  // passportField
  Widget passportField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.passportNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.passportNumber),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: CommonValidation().validatePassport,
    );
  }

  // documentNameField
  Widget documentNameField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.documentNameController,
      fieldName: context.watchLang.translate(AppLanguageText.documentNameOther),
      isSmallFieldFont: true,
      isEnable: applyPassCategoryNotifier.isEnable,
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
      isEnable: applyPassCategoryNotifier.isEnable,
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
      isEnable: applyPassCategoryNotifier.isEnable,
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
      isEnable: applyPassCategoryNotifier.isEnable,
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
      isEnable: applyPassCategoryNotifier.isEnable,
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
      isEnable: applyPassCategoryNotifier.isEnable,
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
      isEnable: applyPassCategoryNotifier.isEnable,
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
      isEnable: applyPassCategoryNotifier.isEnable,
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
          isEnable: applyPassCategoryNotifier.isEnable,
          skipValidation: true,
        ),
      ],
    );
  }


  List<Widget> deviceDetailsChildren(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return [
      addDeviceButton(context, applyPassCategoryNotifier),
      15.verticalSpace,
      deviceDetailsTable(context,applyPassCategoryNotifier),
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

Widget deviceDetailsTable(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    final devices = applyPassCategoryNotifier.addedDevices;

    final headerDecoration = BoxDecoration(
      color: AppColors.buttonBgColor.withOpacity(0.5),
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
      ),
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
        child: const Text(
          'Device Details',
          style: AppFonts.textBoldWhite14,
        ),
      );
    }

    Widget noData() {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No result found'),
      );
    }

    Widget actionButtons(int index) {
      return Row(
        children: [
          GestureDetector(
            onTap: () => applyPassCategoryNotifier.startEditingDevice(index),
            child: Container(
              height: 28,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.buttonBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.pencil, color: AppColors.whiteColor, size: 20),
            ),
          ),
          const SizedBox(width: 5),
          GestureDetector(
            onTap: () => applyPassCategoryNotifier.removeDevice(index),
            child: Container(
              height: 28,
              width: 48,
              decoration: BoxDecoration(
                color: AppColors.textRedColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(LucideIcons.trash, color: AppColors.whiteColor, size: 20),
            ),
          ),
        ],
      );
    }

    if (devices.isEmpty) {
      return Container(
        decoration: borderDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            noData(),
          ],
        ),
      );
    }

    return Container(
      decoration: borderDecoration,
      child: Column(
        children: [
          header(),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith(
                      (_) => AppColors.buttonBgColor.withOpacity(0.5)),
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
              rows: devices.asMap().entries.map((entry) {
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

  Widget addDeviceButton(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return  CustomButton(
      text: context.watchLang.translate(AppLanguageText.addDevice),
      onPressed: !(applyPassCategoryNotifier.isFormActionAllowed)  ? null : () => applyPassCategoryNotifier.showDeviceFieldsAgain()
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
      isEnable: applyPassCategoryNotifier.isEnable,
      validator: CommonValidation().validateDeviceModel,
    );
  }

  Widget serialNumberTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return CustomTextField(
      controller: applyPassCategoryNotifier.serialNumberController,
      fieldName: context.watchLang.translate(AppLanguageText.serialNumber),
      isSmallFieldFont: true,
      skipValidation: true,
      isEnable: applyPassCategoryNotifier.isEnable,
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
      isEnable: applyPassCategoryNotifier.isEnable,
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
      isEnable: applyPassCategoryNotifier.isEnable,
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

  List<Widget> resubmissionCommentChildren(BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return [
      resubmissionCommentTextField(context, applyPassCategoryNotifier),
    ];
  }

  Widget resubmissionCommentTextField(BuildContext context, ApplyPassCategoryNotifier applyPassCategoryNotifier) {
    return TextFormField(
      controller: applyPassCategoryNotifier.resubmissionCommentController,
      maxLines:  1,
      style: AppFonts.textRegular14 ,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        fillColor: AppColors.whiteColor,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color:  AppColors.fieldBorderColor,
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
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.fieldBorderColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.fieldBorderColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.fieldBorderColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: AppColors.fieldBorderColor,
            width: 2.5,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        hintStyle: AppFonts.textRegularGrey16,
        labelStyle:  AppFonts.textRegular17,
        errorStyle: TextStyle(color: AppColors.underscoreColor),
      ),
      validator: CommonValidation().commonValidator,
    );
  }

  Widget buildUploadImageSection(
      BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier,
      ) {
    final lang = context.watchLang;
    final uploadedFileName = applyPassCategoryNotifier.uploadedImageFile?.path.split('/').last
        ?? lang.translate(AppLanguageText.noFileSelected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabelWithTooltip(lang),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                uploadedFileName,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            CustomUploadButton(
              text: lang.translate(AppLanguageText.uploadFile),
              onPressed: applyPassCategoryNotifier.isFormActionAllowed
                  ? () => _showUploadOptions(context, applyPassCategoryNotifier)
                  : null,
            ),
          ],
        ),
        const Divider(height: 10, thickness: 1),
        if (applyPassCategoryNotifier.photoUploadValidation)
          Text("Photo upload is required.", style: AppFonts.errorTextRegular12),
        const SizedBox(height: 5),
        if (applyPassCategoryNotifier.getByIdResult?.user?.havePhoto == 1)
          _buildViewAttachment(context, applyPassCategoryNotifier, lang),
      ],
    );
  }

  Widget _buildLabelWithTooltip(LanguageNotifier lang) {
    return Row(
      children: [
        Text(lang.translate(AppLanguageText.uploadPhoto), style: AppFonts.textRegular14),
        const SizedBox(width: 3),
        const Text("*", style: TextStyle(fontSize: 15, color: AppColors.textRedColor)),
        const SizedBox(width: 3),
        Tooltip(
          message: "Upload a recent passport-sized\n photo (JPG, PNG, or JPEG).\n Ensure the image is clear and meets\n official guidelines.",
          textAlign: TextAlign.center,
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(5),
          ),
          child: const Icon(Icons.info_outline, size: 20, color: AppColors.primaryColor),
        ),
      ],
    );
  }

  void _showUploadOptions(BuildContext context, ApplyPassCategoryNotifier notifier) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      backgroundColor: Colors.white,
      builder: (context) => Padding(
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
            const Text("Upload Image", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _uploadOptionCard(
                  icon: LucideIcons.camera,
                  label: "Camera",
                  onTap: () async {
                    Navigator.pop(context);
                    await notifier.uploadImage(fromCamera: true, cropAfterPick: true);
                  },
                ),
                _uploadOptionCard(
                  icon: LucideIcons.image,
                  label: "Device",
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
        await notifier.apiGetFile(context, type: 1);
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            content: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.memory(notifier.uploadedImageBytes!),
            ),
          ),
        );
      },
      child: Text(
        lang.translate(AppLanguageText.viewAttachment),
        style: AppFonts.textRegularAttachment14,
      ),
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
      ApplyPassCategoryNotifier applyPassCategoryNotifier,
      ) {
    final lang = context.watchLang;
    final selectedIdType = applyPassCategoryNotifier.selectedIdType;
    final uploadedFileName = applyPassCategoryNotifier.uploadedDocumentFile?.path.split('/').last
        ?? lang.translate(AppLanguageText.noFileSelected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDocumentLabel(selectedIdType ?? ""),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(uploadedFileName, overflow: TextOverflow.ellipsis),
            ),
            CustomUploadButton(
              text: lang.translate(AppLanguageText.uploadFile),
              onPressed: applyPassCategoryNotifier.isFormActionAllowed
                  ? () async => await applyPassCategoryNotifier.uploadDocument()
                  : null,
            ),
          ],
        ),
        const Divider(height: 10, thickness: 1),
        if (applyPassCategoryNotifier.documentUploadValidation)
          Text(
            "$selectedIdType upload is required.",
            style: AppFonts.errorTextRegular12,
          ),
        const SizedBox(height: 5),
        if (_hasValidDocument(applyPassCategoryNotifier))
          _buildViewAttachmentButton(context, applyPassCategoryNotifier, lang, selectedIdType ?? ""),
      ],
    );
  }

  Widget _buildDocumentLabel(String selectedIdType) {
    return Row(
      children: [
        Text('Upload $selectedIdType', style: AppFonts.textRegular14),
        const SizedBox(width: 3),
        const Text("*", style: TextStyle(fontSize: 15, color: AppColors.textRedColor)),
      ],
    );
  }

  bool _hasValidDocument(ApplyPassCategoryNotifier notifier) {
    final user = notifier.getByIdResult?.user;
    if (user == null) return false;

    return user.haveEid == 1 ||
        user.haveIqama == 1 ||
        user.havePassport == 1 ||
        user.haveOthers == 1;
  }

  Widget _buildViewAttachmentButton(
      BuildContext context,
      ApplyPassCategoryNotifier notifier,
      LanguageNotifier lang,
      String selectedIdType,
      ) {
    int type = _getFileType(selectedIdType);

    return GestureDetector(
      onTap: () async {
        await notifier.apiGetFile(context, type: type);
      },
      child: Text(
        lang.translate(AppLanguageText.viewAttachment),
        style: AppFonts.textRegularAttachment14,
      ),
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

  Widget buildUploadVehicleRegistrationSection(
      BuildContext context,
      ApplyPassCategoryNotifier applyPassCategoryNotifier,
      ) {
    final lang = context.watchLang;
    final uploadedFileName = applyPassCategoryNotifier.uploadedVehicleRegistrationFile?.path.split('/').last
        ?? lang.translate(AppLanguageText.noFileSelected);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          lang.translate(AppLanguageText.vehicleRegistrationLicense),
          style: AppFonts.textRegular14,
        ),
        const SizedBox(height: 5),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(uploadedFileName, overflow: TextOverflow.ellipsis),
            ),
            CustomUploadButton(
              text: lang.translate(AppLanguageText.uploadFile),
              onPressed: applyPassCategoryNotifier.isFormActionAllowed
                  ? () async => await applyPassCategoryNotifier.uploadVehicleRegistrationImage()
                  : null,
            ),
          ],
        ),
        const Divider(height: 10, thickness: 1),
        const SizedBox(height: 5),
        if (_hasVehicleRegistration(applyPassCategoryNotifier))
          _buildViewAttachmentButton(
            context,
            applyPassCategoryNotifier,
            lang,
            "4",
          ),
      ],
    );
  }

  bool _hasVehicleRegistration(ApplyPassCategoryNotifier notifier) {
    final user = notifier.getByIdResult?.user;
    return user?.haveVehicleRegistration == 1;
  }
}
