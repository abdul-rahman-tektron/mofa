import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/device_dropdown/device_dropdown_response.dart';
import 'package:mofa/core/model/get_all_detail/get_all_detail_response.dart';
import 'package:mofa/core/model/location_dropdown/location_dropdown_response.dart';
import 'package:mofa/model/appointment_response.dart';
import 'package:mofa/model/custom_args/custom_args.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/search_pass/search_pass_notifier.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_dropdown_search.dart';
import 'package:mofa/utils/common/widgets/common_popup.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:mofa/utils/common/widgets/loading_overlay.dart';
import 'package:mofa/utils/common_utils.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:mofa/utils/extensions.dart';
import 'package:provider/provider.dart';

class SearchPassScreen extends StatelessWidget with CommonUtils{
  const SearchPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchPassNotifier(context),
      child: Consumer<SearchPassNotifier>(
        builder: (context, searchPassNotifier, child) {
          return LoadingOverlay<SearchPassNotifier>(child: buildBody(context, searchPassNotifier));
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, SearchPassNotifier searchPassNotifier) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          children: [
            buildExpansionTile(
              title: context.watchLang.translate(AppLanguageText.searchPass),
              children: expandableSearchChildren(context, searchPassNotifier),
            ),
            15.verticalSpace,
            Row(
              children: [
                searchTableDataField(context, searchPassNotifier),
                10.horizontalSpace,
                columnNameVisibility(context, searchPassNotifier),
              ],
            ),
            10.verticalSpace,
            _buildDataTable(context, searchPassNotifier),
            10.verticalSpace,
            ...paginationDetails(context, searchPassNotifier),
          ],
        ),
      ),
    );
  }

  List<Widget> expandableSearchChildren(BuildContext context, SearchPassNotifier searchPassNotifier) {
    return [
      visitStartDateTextField(context, searchPassNotifier),
      15.verticalSpace,
      visitEndDateTextField(context, searchPassNotifier),
      15.verticalSpace,
      statusTextField(context, searchPassNotifier),
      15.verticalSpace,
      locationTextField(context, searchPassNotifier),
      15.verticalSpace,
      saveAndClearButton(context, searchPassNotifier),
    ];
  }

  Widget saveAndClearButton(BuildContext context, SearchPassNotifier searchPassNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButton(
          text: context.watchLang.translate(AppLanguageText.search),
          smallWidth: true,
          height: 45,
          onPressed: () {
            searchPassNotifier.runWithLoadingVoid(() {
              searchPassNotifier.currentPage = 1;
              searchPassNotifier.filtersCleared = false; // Allow API to work again
              return searchPassNotifier.apiGetAllExternalAppointment(context);
            },);
          },
        ),
        15.horizontalSpace,
        CustomButton(
          text: context.watchLang.translate(AppLanguageText.clear),
          smallWidth: true,
          height: 45,
          backgroundColor: AppColors.whiteColor,
          borderColor: AppColors.buttonBgColor,
          textFont: AppFonts.textBold14,
          onPressed: () {
            searchPassNotifier.clearFiltersAndData(context);
          },
        ),
      ],
    );
  }

  Widget visitStartDateTextField(BuildContext context, SearchPassNotifier searchPassNotifier) {
    final now = DateTime.now();
    return CustomTextField(
      controller: searchPassNotifier.visitStartDateController,
      fieldName: context.watchLang.translate(AppLanguageText.visitStartDate),
      isSmallFieldFont: true,
      initialDate: DateTime(now.year, now.month - 1, now.day),
      keyboardType: TextInputType.datetime,
      skipValidation: true,
    );
  }

  Widget visitEndDateTextField(BuildContext context, SearchPassNotifier searchPassNotifier) {
    return CustomTextField(
      controller: searchPassNotifier.visitEndDateController,
      fieldName: context.watchLang.translate(AppLanguageText.visitEndDate),
      isSmallFieldFont: true,
      keyboardType: TextInputType.datetime,
      skipValidation: true,
    );
  }

  Widget locationTextField(BuildContext context, SearchPassNotifier searchPassNotifier) {
    return CustomSearchDropdown<LocationDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.location),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: searchPassNotifier.locationController,
      items: searchPassNotifier.locationDropdownData,
      currentLang: context.lang,
      itemLabel: (item, lang) => CommonUtils.getLocalizedString(
          currentLang: lang,
          getArabic: () => item.sLocationNameAr,
          getEnglish: () => item.sLocationNameEn,
        ),
      skipValidation: true,
      isSmallFieldFont: true,
      onSelected: (LocationDropdownResult? menu) {
        searchPassNotifier.selectedLocationId = menu?.nLocationId ?? 0;
        // applyPassCategoryNotifier.selectedIdType = menu?.labelEn ?? "";
      },
    );
  }

  Widget statusTextField(BuildContext context, SearchPassNotifier searchPassNotifier) {
    return CustomSearchDropdown<DeviceDropdownResult>(
      fieldName: context.watchLang.translate(AppLanguageText.status),
      hintText: context.watchLang.translate(AppLanguageText.select),
      controller: searchPassNotifier.statusController,
      items: searchPassNotifier.statusDropdownData,
      skipValidation: true,
      currentLang: context.lang,
      itemLabel: (item, lang) => CommonUtils.getLocalizedString(
          currentLang: lang,
          getArabic: () => item.sDescA,
          getEnglish: () => item.sDescE,
        ),
      isSmallFieldFont: true,
      onSelected: (DeviceDropdownResult? menu) {
        searchPassNotifier.selectedStatusId = menu?.nDetailedCode ?? 0;
      },
    );
  }

  Widget buildExpansionTile({required String title, required List<Widget> children, isVisitorDetails = false}) {
    return ExpansionTile(
      backgroundColor: AppColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      collapsedBackgroundColor: AppColors.whiteColor,
      collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      childrenPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      initiallyExpanded: false,
      title: Text(title, style: AppFonts.textRegular20),
      children: children,
    );
  }

  Widget searchTableDataField(BuildContext context, SearchPassNotifier searchPassNotifier) {
    return Expanded(
      child: TextFormField(
        controller: searchPassNotifier.searchController,
        style: AppFonts.textRegular14,
        decoration: InputDecoration(
          filled: true,
          isDense: true,
          fillColor: AppColors.backgroundColor,
          hintText: context.watchLang.translate(AppLanguageText.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.buttonBgColor, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.buttonBgColor, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.buttonBgColor, width: 1.5),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }

  Widget columnNameVisibility(BuildContext context, SearchPassNotifier searchPassNotifier) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        CustomButton(
          text: context.watchLang.translate(AppLanguageText.columnChooser),
          smallWidth: true,
          backgroundColor: AppColors.backgroundColor,
          borderColor: AppColors.buttonBgColor,
          textFont: AppFonts.textBold14,
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          onPressed: () => columnVisibilityPopup(context, searchPassNotifier),
        ),
      ],
    );
  }

  List<Widget> paginationDetails(BuildContext context, SearchPassNotifier searchPassNotifier) {
    return [
      Text(
        "${context.watchLang.translate(AppLanguageText.totalRecords)} : ${searchPassNotifier.totalCount}",
        style: AppFonts.textMedium14,
      ),
      10.verticalSpace,
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonBgColor,
              foregroundColor: Colors.white,
              padding: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                  // Set custom radius here
                ),
                side: BorderSide(color: Colors.transparent, width: 1), // Border color and width
              ),
            ),
            onPressed: searchPassNotifier.currentPage > 1 ? () => searchPassNotifier.goToPreviousPage(context) : null,
            child: Icon(context.watchLang.currentLang == "ar" ? LucideIcons.chevronRight : LucideIcons.chevronLeft, size: 25, color: AppColors.whiteColor),
          ),
          Text("${context.watchLang.translate(AppLanguageText.page)} ${searchPassNotifier.currentPage} ${context.watchLang.translate(AppLanguageText.of)} ${searchPassNotifier.totalPages}"),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.zero,
              backgroundColor: AppColors.buttonBgColor,
              foregroundColor: Colors.white,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                  // Set custom radius here
                ),
                side: BorderSide(color: Colors.transparent, width: 1), // Border color and width
              ),
            ),
            onPressed:
                searchPassNotifier.currentPage < searchPassNotifier.totalPages
                    ? () => searchPassNotifier.goToNextPage(context)
                    : null,
            child: Icon(context.watchLang.currentLang == "ar" ? LucideIcons.chevronLeft :LucideIcons.chevronRight, size: 25, color: AppColors.whiteColor),
          ),
        ],
      ),
    ];
  }

  Widget _buildDataTable(BuildContext context, SearchPassNotifier searchPassNotifier) {
    final visibleColumns = searchPassNotifier.columnConfigs.where((c) => c.isVisible).toList();
    final actionLabel = context.watchLang.translate(AppLanguageText.action);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Scrollbar(
          controller: searchPassNotifier.scrollbarController,
          scrollbarOrientation: ScrollbarOrientation.bottom,
          thumbVisibility: true,
          thickness: 5,
          interactive: true,
          radius: const Radius.circular(10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: searchPassNotifier.scrollbarController,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: MediaQuery.of(context).size.width - 30.88.w),
              child: DataTable(
                headingRowColor: MaterialStateColor.resolveWith((states) => AppColors.buttonBgColor),
                headingTextStyle: AppFonts.textBoldWhite14,
                border: TableBorder(borderRadius: BorderRadius.circular(8)),
                clipBehavior: Clip.antiAliasWithSaveLayer,
                columnSpacing: 20.w,
                dataRowMaxHeight: 65.h,
                columns: _buildColumns(context, visibleColumns),
                rows: _buildRows(context, searchPassNotifier, visibleColumns, actionLabel),
              ),
            ),
          ),
        ),
      ),
    );
  }


  List<DataColumn> _buildColumns(BuildContext context, List<TableColumnConfig> visibleColumns) {
    return visibleColumns.map((config) {
      final translatedLabel = context.watchLang.translate(config.labelKey);

      return DataColumn(
        label: config.labelKey == AppLanguageText.status
            ? Flexible(child: Center(child: Text(translatedLabel)))
            : Text(translatedLabel),
      );
    }).toList();
  }

  List<DataRow> _buildRows(
      BuildContext context,
      SearchPassNotifier searchPassNotifier,
      List<TableColumnConfig> visibleColumns,
      String actionLabel,
      ) {
    final allData = searchPassNotifier.getAllDetailData;
    if (allData.isEmpty) {
      return [
        DataRow(
          cells: [
            DataCell(
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(context.watchLang.translate(AppLanguageText.noResultFound), style: AppFonts.textRegularGrey16),
                ),
              ),
            ),
            ...List.generate(visibleColumns.length - 1, (_) => const DataCell(SizedBox())),
          ],
        ),
      ];
    }

    return allData.asMap().entries.map((entry) {
      final index = entry.key;
      final appointment = entry.value;

      final isExpired = _isAppointmentExpired(appointment);

      final isEvenRow = index % 2 == 0;

      return DataRow(
        color: MaterialStateProperty.resolveWith<Color?>(
              (states) => isEvenRow ? AppColors.buttonBgColor.withOpacity(0.05) : null,
        ),
        cells: visibleColumns.map((config) {
          return _buildDataCell(context, appointment, config, actionLabel, isExpired, searchPassNotifier);
        }).toList(),
      );
    }).toList();
  }


  bool _isAppointmentExpired(GetExternalAppointmentData appointment) {
    final endTime = DateFormat("M/d/yyyy h:mm:ss a").parse(appointment.dtAppointmentEndTime.toString());
    final now = DateTime.now();

    return endTime.isBefore(now) ||
        appointment.sApprovalStatusEn == "Rejected" ||
        appointment.sApprovalStatusEn == "Cancelled" ||
        appointment.sApprovalStatusEn == "Expired";
  }

  DataCell _buildDataCell(
      BuildContext context,
      GetExternalAppointmentData appointment,
      TableColumnConfig config,
      String actionLabel,
      bool isExpired,
      SearchPassNotifier searchPassNotifier,
      ) {
    final isActionCell = config.labelKey == actionLabel;
    Widget cellContent;

    switch (config.labelKey) {
      case 'applyFor':
        cellContent = Text(appointment.sApplyForEn ?? "");
        break;
        case 'refNo':
        cellContent = Text(appointment.sAppointmentCode ?? "");
        break;
      case 'name':
        cellContent = SizedBox(
          width: 140.w,
          child: Text(
            appointment.sVisitorName ?? "",
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        );
        break;
      case 'status':
        cellContent = buildStatusChip(context, appointment.sApprovalStatusEn ?? "");
        break;
      case 'companyName':
        cellContent = Text(appointment.sSponsor ?? "");
        break;
      case 'startAndEndDate':
        cellContent = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              appointment.dtAppointmentStartTime?.formatDateTime() ?? "",
              style: AppFonts.textMediumBlueGrey12,
            ),
            5.verticalSpace,
            Text(
              appointment.dtAppointmentEndTime?.formatDateTime() ?? "",
              style: AppFonts.textMediumBlueGrey12,
            ),
          ],
        );
        break;
      case 'email':
        cellContent = Text(appointment.sEmail ?? "");
        break;
      case 'nationality':
        cellContent = Text(CommonUtils.getLocalizedString(
          currentLang: context.lang,
          getArabic: () => appointment.sNationalityAr,
          getEnglish: () => appointment.sNationalityEn,
        ) ?? "");
        break;
      case 'hostName':
        cellContent = Text(appointment.sHostName ?? "");
        break;
      case 'location':
        cellContent = Text(CommonUtils.getLocalizedString(
          currentLang: context.lang,
          getArabic: () => appointment.sLocationNameAr,
          getEnglish: () => appointment.sLocationNameEn,
        ) ?? "");
        break;
      case 'building':
        cellContent = Text(CommonUtils.getLocalizedString(
          currentLang: context.lang,
          getArabic: () => appointment.sBuildingNameAr,
          getEnglish: () => appointment.sBuildingNameEn,
        ) ?? "");
        break;
      case 'vehiclePermit':
        cellContent = buildVehicleChip(
          context,
          appointment.nIsVehicleAllowed ?? -1,
          appointment.sVehicleNo ?? "",
        );
        break;
      case 'action':
        cellContent = Center(
          child: InkWell(
            onTap: isExpired
                ? () {}
                : () {
              cancelAppointmentPopup(context, searchPassNotifier, appointment);
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 35,
              width: 35,
              decoration: BoxDecoration(
                color: isExpired ? Colors.grey : AppColors.buttonBgColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(LucideIcons.x, color: AppColors.whiteColor, size: 20),
            ),
          ),
        );
        break;
      default:
        cellContent = const Text('Hello');
    }

    return DataCell(
      isActionCell
          ? cellContent
          : InkWell(
        onTap: () {
          print("Appointment ID: ${appointment.nAppointmentId}");
          Navigator.pushNamed(
            context,
            AppRoutes.stepper,
            arguments: StepperScreenArgs(
              category: ApplyPassCategory.someoneElse,
              isUpdate: true,
              id: appointment.nAppointmentId ?? 0,
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: cellContent,
        ),
      ),
    );
  }

  Widget buildStatusChip(BuildContext context, String rawStatus) {
    final statusColor = CommonUtils.getStatusColor(rawStatus);
    final translatedStatus = CommonUtils.getTranslatedStatus(context, rawStatus);

    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        translatedStatus,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget buildVehicleChip(BuildContext context, int vehicleAllowed, String? vehicleNumber) {
    if (vehicleNumber == null || vehicleNumber.trim().isEmpty) {
      return Center(child: const Text("-"));
    }

    String label;
    Color backgroundColor;

    switch (vehicleAllowed) {
      case -1:
        label = context.watchLang.translate(AppLanguageText.pending);
        backgroundColor = Color(0xffefb100);
        break;
      case 0:
        label = context.watchLang.translate(AppLanguageText.notAllowed);
        backgroundColor = Colors.red;
        break;
      case 1:
        label = context.watchLang.translate(AppLanguageText.allowed);
        backgroundColor = Colors.green;
        break;
      default:
        label = "Unknown";
        backgroundColor = Colors.black26;
    }

    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8)),
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class TableColumnConfig {
  final String labelKey;
  final String? labelAr;
  final bool isMandatory;
  bool isVisible;

  TableColumnConfig({
    required this.labelKey,
    this.labelAr,
    this.isMandatory = false,
    this.isVisible = true,
  });
}
