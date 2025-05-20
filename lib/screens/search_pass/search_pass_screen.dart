import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/search_pass/search_pass_notifier.dart';
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
        body: Padding(
          padding: EdgeInsets.only(
            bottom: 25.h,
            right: 25.w,
            left: 25.w,
            top: 15.h,
          ),
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor:
                  MaterialStateColor.resolveWith((states) => AppColors.buttonBgColor.withOpacity(0.5)),
                  headingTextStyle: AppFonts.textBoldWhite14,
                  border: TableBorder(borderRadius: BorderRadius.circular(8                                                                                                                                                     )),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  columnSpacing: 40,
                  columns: const [
                    DataColumn(label: Text('Ref No')),
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Company Name')),
                    DataColumn(label: Text('Visit Start Date')),
                    DataColumn(label: Text('Visit End Date')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Host Name')),
                    DataColumn(label: Text('Location')),
                    DataColumn(label: Text('Vehicle Permit')),
                    DataColumn(label: Text('Action')),
                  ],
                  rows: searchPassNotifier.getAllDetailData.asMap().entries.map((entry) {
                    final index = entry.key;
                    final appointment = entry.value;
      
                    return DataRow(
                      cells: [
                        DataCell(Text(appointment.sAppointmentCode ?? "")),
                        DataCell(Text(appointment.sFullName ?? "")),
                        DataCell(Text(appointment.sCompanyName ?? "")),
                        DataCell(Text(appointment.dtAppointmentStartTime ?? "")),
                        DataCell(Text(appointment.dtAppointmentEndTime ?? "")),
                        DataCell(Text(appointment.sApprovalStatusEn ?? "")),
                        DataCell(Text(appointment.sEmail ?? "")),
                        DataCell(Text(appointment.sHostName ?? "")),
                        DataCell(Text(appointment.sLocationNameEn ?? "")),
                        DataCell(Text(appointment.sVehicleRegistrationFile ?? "")),
                        DataCell(
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () => null,
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
                                onTap: () => null,
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
            )
          ]),
        ),
      ),
    );
  }
}
