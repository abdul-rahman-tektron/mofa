import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/device_dropdown/device_dropdown_response.dart';
import 'package:mofa/core/model/location_dropdown/location_dropdown_response.dart';
import 'package:mofa/model/apply_pass/apply_pass_category.dart';
import 'package:mofa/model/custom_args/custom_args.dart';
import 'package:mofa/model/device/device_model.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/search_pass/search_pass_notifier.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/common_validation.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:mofa/utils/extensions.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_dropdown_search.dart';
import 'package:mofa/utils/common/widgets/common_popup.dart';
import 'package:mofa/utils/common/widgets/common_textfield.dart';
import 'package:provider/provider.dart';

class SearchPassScreen extends StatelessWidget {
  const SearchPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => SearchPassNotifier(context),
      child: Consumer<SearchPassNotifier>(
        builder: (context, searchPassNotifier, child) {
          return buildBody(context, searchPassNotifier);
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
            searchPassNotifier.currentPage = 1;
            searchPassNotifier.filtersCleared = false; // Allow API to work again
            searchPassNotifier.apiGetAllExternalAppointment(context);
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
      hintText: 'Select...',
      controller: searchPassNotifier.locationController,
      items: searchPassNotifier.locationDropdownData,
      itemLabel: (item) => item.sLocationNameEn ?? 'Unknown',
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
      hintText: 'Select...',
      controller: searchPassNotifier.statusController,
      items: searchPassNotifier.statusDropdownData,
      skipValidation: true,
      itemLabel: (item) => item.sDescE ?? 'Unknown',
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
    return SizedBox(
      height: 30.h,
      child: Row(
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
      ),
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
            child: Icon(LucideIcons.chevronLeft, size: 25, color: AppColors.whiteColor),
          ),
          Text("Page ${searchPassNotifier.currentPage} of ${searchPassNotifier.totalPages}"),
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
            child: Icon(LucideIcons.chevronRight, size: 25, color: AppColors.whiteColor),
          ),
        ],
      ),
    ];
  }

  Widget _buildDataTable(BuildContext context, SearchPassNotifier searchPassNotifier) {
    final visibleColumns = searchPassNotifier.columnConfigs.where((c) => c.isVisible).toList();
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
          radius: Radius.circular(10),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: searchPassNotifier.scrollbarController,
            child: DataTable(
              headingRowColor: MaterialStateColor.resolveWith((states) => AppColors.buttonBgColor),
              headingTextStyle: AppFonts.textBoldWhite14,
              border: TableBorder(borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.antiAliasWithSaveLayer,
              columnSpacing: 20.w,
              dataRowMaxHeight: 55.h,
              columns:
                  visibleColumns.map((config) {
                    return DataColumn(
                      label:
                          config.label == "Status"
                              ? Flexible(child: Center(child: Text(config.label)))
                              : Text(config.label),
                    );
                  }).toList(),
              rows:
                  searchPassNotifier.getAllDetailData.isEmpty
                      ? [
                        DataRow(
                          cells: [
                            DataCell(
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                  child: Text('No result found', style: AppFonts.textRegularGrey16),
                                ),
                              ),
                            ),
                            // Fill remaining columns with empty cells
                            ...List.generate(visibleColumns.length - 1, (_) => const DataCell(SizedBox())),
                          ],
                        ),
                      ]
                      : searchPassNotifier.getAllDetailData.asMap().entries.map((entry) {
                        final index = entry.key;
                        final appointment = entry.value;

                        final endTime = DateFormat(
                          "M/d/yyyy h:mm:ss a",
                        ).parse(appointment.dtAppointmentEndTime.toString());
                        final now = DateTime.now();
                        final isExpired =
                            endTime.isBefore(now) ||
                            appointment.sApprovalStatusEn == "Rejected" ||
                            appointment.sApprovalStatusEn == "Cancelled" ||
                            appointment.sApprovalStatusEn == "Expired";

                        final isEvenRow = index % 2 == 0;

                        return DataRow(
                          color: MaterialStateProperty.resolveWith<Color?>(
                            (states) => isEvenRow ? AppColors.buttonBgColor.withOpacity(0.05) : null,
                          ),
                          cells:
                              visibleColumns.map((config) {
                                Widget cellContent;

                                // Check if this is the "Action" column, which already has its own tap
                                final isActionCell = config.label == 'Action';

                                // Build the base content for each cell
                                switch (config.label) {
                                  case 'Ref No':
                                    cellContent = Text(appointment.sAppointmentCode ?? "");
                                    break;
                                  case 'Name':
                                    cellContent = SizedBox(
                                      width: 140.w,
                                      child: Text(
                                        appointment.sVisitorName ?? "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    );
                                    break;
                                  case 'Status':
                                    cellContent = buildStatusChip(appointment.sApprovalStatusEn ?? "");
                                    break;
                                  case 'Company Name':
                                    cellContent = Text(appointment.sSponsor ?? "");
                                    break;
                                  case 'Start & End Date':
                                    cellContent = Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          appointment.dtAppointmentStartTime?.formatDateTime() ?? "",
                                          style: AppFonts.textMediumBlueGrey12,
                                        ),
                                        SizedBox(height: 5),
                                        Text(
                                          appointment.dtAppointmentEndTime?.formatDateTime() ?? "",
                                          style: AppFonts.textMediumBlueGrey12,
                                        ),
                                      ],
                                    );
                                    break;
                                  case 'Email':
                                    cellContent = Text(appointment.sEmail ?? "");
                                    break;
                                  case 'Host Name':
                                    cellContent = Text(appointment.sHostName ?? "");
                                    break;
                                  case 'Location':
                                    cellContent = Text(appointment.sLocationNameEn ?? "");
                                    break;
                                  case 'Vehicle Permit':
                                    cellContent = buildVehicleChip(
                                      appointment.nIsVehicleAllowed ?? -1,
                                      appointment.sVehicleNo ?? "",
                                    );
                                    break;
                                  case 'Action':
                                    cellContent = Center(
                                      child: GestureDetector(
                                        onTap:
                                            isExpired
                                                ? null
                                                : () {
                                                  cancelAppointmentPopup(context, searchPassNotifier, appointment);
                                                },
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
                                    cellContent = Text('');
                                }

                                // Wrap all except "Action" cell with a tap handler to navigate
                                return DataCell(
                                  isActionCell
                                      ? cellContent
                                      : GestureDetector(
                                        onTap: () {
                                          // Navigate to Apply Pass screen with selected appointment
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
                                        behavior: HitTestBehavior.opaque,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 8),
                                          child: cellContent,
                                        ),
                                      ),
                                );
                              }).toList(),
                        );
                      }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildStatusChip(String status) {
    Color backgroundColor;

    switch (status.toLowerCase()) {
      case 'approved':
        backgroundColor = Colors.green;
        break;
      case 'pending':
        backgroundColor = Colors.yellow.shade700;
        break;
      case 'rejected':
        backgroundColor = Colors.red.shade600;
        break;
      case 'cancelled':
        backgroundColor = Colors.orange;
        break;
      case 'expired':
        backgroundColor = Colors.grey;
        break;
      case 'request info':
        backgroundColor = Colors.teal.shade400;
        break;
      default:
        backgroundColor = Colors.black26;
    }

    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(color: backgroundColor, borderRadius: BorderRadius.circular(8)),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget buildVehicleChip(int vehicleAllowed, String? vehicleNumber) {
    if (vehicleNumber == null || vehicleNumber.trim().isEmpty) {
      return Center(child: const Text("-"));
    }

    String label;
    Color backgroundColor;

    switch (vehicleAllowed) {
      case -1:
        label = "Pending";
        backgroundColor = Colors.yellow.shade700;
        break;
      case 0:
        label = "Not Allowed";
        backgroundColor = Colors.red.shade600;
        break;
      case 1:
        label = "Allowed";
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
  final String label;
  final bool isMandatory;
  bool isVisible;

  TableColumnConfig({required this.label, this.isMandatory = false, this.isVisible = true});
}
