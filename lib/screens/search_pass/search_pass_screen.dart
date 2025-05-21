import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/search_pass/search_pass_notifier.dart';
import 'package:mofa/utils/common/extensions.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
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

  Widget buildBody(
    BuildContext context,
    SearchPassNotifier searchPassNotifier,
  ) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          children: [
            _buildDataTable(context, searchPassNotifier),
            10.verticalSpace,
            ...paginationDetails(context, searchPassNotifier),
          ],
        ),
      ),
    );
  }

  List<Widget> paginationDetails(BuildContext context,
      SearchPassNotifier searchPassNotifier) {
    return [
      Text("${context.watchLang.translate(
          AppLanguageText.totalRecords)} ${searchPassNotifier.totalCount}",
          style: AppFonts.textMedium14),
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
                side: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ), // Border color and width
              ),
            ),
            onPressed: searchPassNotifier.currentPage > 1
                ? () => searchPassNotifier.goToPreviousPage(context)
                : null,
            child: Icon(LucideIcons.chevronLeft, size: 25,
              color: AppColors.whiteColor,),
          ),
          Text("Page ${searchPassNotifier.currentPage} of ${searchPassNotifier
              .totalPages}"),
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
                side: BorderSide(
                  color: Colors.transparent,
                  width: 1,
                ), // Border color and width
              ),
            ),
            onPressed: searchPassNotifier.currentPage <
                searchPassNotifier.totalPages
                ? () => searchPassNotifier.goToNextPage(context)
                : null,
            child: Icon(LucideIcons.chevronRight, size: 25,
              color: AppColors.whiteColor,),
          ),
        ],
      ),
    ];
  }

  Widget _buildDataTable(BuildContext context, SearchPassNotifier notifier) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor: MaterialStateColor.resolveWith(
                (states) => AppColors.buttonBgColor.withOpacity(0.5),
          ),
          headingTextStyle: AppFonts.textBoldWhite14,
          border: TableBorder(borderRadius: BorderRadius.circular(8)),
          clipBehavior: Clip.antiAliasWithSaveLayer,

          columnSpacing: 20.w,
          dataRowMaxHeight: 50.h,
          columns: [
            DataColumn(label: Text('Ref No')),
            DataColumn(label: Text('Name'), columnWidth: FixedColumnWidth(140.w)),
            DataColumn(label: Flexible(child: Center(child: Text('Status')))),
            // DataColumn(label: Text('Company Name')),
            DataColumn(label: Text('Start & End Date')),
            // DataColumn(label: Text('Visit End Date')),
            // DataColumn(label: Text('Email')),
            DataColumn(label: Text('Host Name')),
            // DataColumn(label: Text('Location')),
            // DataColumn(label: Text('Vehicle Permit')),
            DataColumn(label: Text('Action')),
          ],
          rows: notifier.getAllDetailData.asMap().entries.map((entry) {
            final index = entry.key;
            final appointment = entry.value;

            final endTime = DateFormat("M/d/yyyy h:mm:ss a").parse(appointment.dtAppointmentEndTime.toString());
            final now = DateTime.now();
            final isExpired = endTime.isBefore(now);

            final isEvenRow = index % 2 == 0;

            return DataRow(
              color: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                  return isEvenRow ? Colors.grey.shade200 : null; // Alternating background
                },
              ),
              cells: [
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(appointment.sAppointmentCode ?? ""),
                    FittedBox(child: Text(appointment.dtAppointmentStartTime?.formatDateTime() ?? "", style: TextStyle(fontSize: 10),)),
                  ],
                )),
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(appointment.sVisitorName ?? "", maxLines: 2,),
                    FittedBox(child: Text(appointment.dtAppointmentEndTime?.formatDateTime() ?? "", style: TextStyle(fontSize: 10),)),
                  ],
                )),
                DataCell(buildStatusChip(appointment.sApprovalStatusEn ?? ""),),
                // DataCell(Text(appointment.sSponsor ?? "")),
                DataCell(Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(appointment.dtAppointmentStartTime?.formatDateTime().toString() ?? ""),
                    Center(
                      child: SizedBox(
                          width: 7,
                          height: 5,
                          child: Divider(
                            thickness: 1,
                            color: AppColors.buttonBgColor,
                          )),
                    ),
                    Text(appointment.dtAppointmentEndTime?.formatDateTime() ?? "")
                  ],
                )),
                // DataCell(Text(appointment.dtAppointmentEndTime ?? "")),
                // DataCell(Text(appointment.sEmail ?? "")),
                DataCell(Text(appointment.sHostName ?? "")),
                // DataCell(Text(appointment.sLocationNameEn ?? "")),
                // DataCell(Text(appointment.sVehicleRegistrationFile ?? "")),
                DataCell(
                  Center(
                    child: GestureDetector(
                      onTap: isExpired ? null : () {
                        // Only allow action for future dates
                        // notifier.handleBanAction(appointment);
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          color: isExpired ? Colors.grey : AppColors.redColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          LucideIcons.ban,
                          color: AppColors.whiteColor,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
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
        backgroundColor = Colors.blue.shade400;
        break;
      default:
        backgroundColor = Colors.black26;
    }

    return Container(
      width: 105,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

}
