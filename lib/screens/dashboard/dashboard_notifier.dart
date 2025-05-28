import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/model/get_all_detail/get_all_detail_request.dart';
import 'package:mofa/core/model/get_all_detail/get_all_detail_response.dart';
import 'package:mofa/core/model/kpi/kpi_response.dart';
import 'package:mofa/core/remote/service/dashboard_repository.dart';
import 'package:mofa/core/remote/service/search_pass_repository.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/dashboard/dashboard_screen.dart';

class DashboardNotifier extends BaseChangeNotifier {
  KpiResult? _kpiData;

  List<GetExternalAppointmentData> _upcomingAppointments = [];
  List<GetExternalAppointmentData> _pastAppointments = [];

  List<DashboardCardData>? _cardData;

  bool _isUpcoming = true;
  int _selectedIndex = 0;

  DashboardNotifier(BuildContext context) {
    _init(context);
  }

  void _init(BuildContext context) async {
    await apiDashboardKpi(context);
    await apiGetAllExternalAppointment(context, true);
  }

  //Dashboard Kpi Api call
  Future apiDashboardKpi(BuildContext context) async {
    await DashboardRepository().apiDashboardKpi({}, context).then((value) {
      kpiData = value as KpiResult;

      // ⬇ Move cardData assignment here
      cardData = [
        DashboardCardData(
          icon: LucideIcons.calendar,
          // title: context.readLang.translate(AppLanguageText.totalPassesToday),
          title: "Total Visits (Today)",
          count: kpiData?.totalPassToday ?? 0,
        ),
        DashboardCardData(
          icon: LucideIcons.calendarDays,
          // title: context.readLang.translate(AppLanguageText.totalPassesMonth),
          title: "Total Visits (Month)",
          count: kpiData?.totalPassMonth ?? 0,
        ),
        DashboardCardData(
          icon: LucideIcons.calendarCheck,
          // title: context.readLang.translate(AppLanguageText.totalPassesYear),
          title: "Total Visits (Year)",
          count: kpiData?.totalPassYear ?? 0,
        ),
        DashboardCardData(
          icon: LucideIcons.ticket,
          // title: context.readLang.translate(AppLanguageText.totalPasses),
          title: "Total Visits",
          count: kpiData?.totalPasses ?? 0,
        ),
      ];
    });
  }

  Future<void> apiGetAllExternalAppointment(BuildContext context, bool isUpcoming, {int? page}) async {

    final today = DateTime.now();

    final response = await SearchPassRepository().apiGetExternalAppointment(
      GetExternalAppointmentRequest(
        dFromDate: isUpcoming ? today.toString() : DateTime(today.year, today.month - 1, today.day).toString(),
        dToDate: isUpcoming ? null : today.toString(),
        nApprovalStatus: isUpcoming ? 49 : null,
        nPageNumber: 1,
        nPageSize: 100,
        sSearch: "",
      ),
      context,
    );

    final result = response as GetExternalAppointmentResult;
    if (isUpcoming) {
      upcomingAppointments = List<GetExternalAppointmentData>.from(
        (result.data ?? []).where((item) => item.sQRCodeValue != null),
      );
    } else {
      pastAppointments = List<GetExternalAppointmentData>.from(result.data ?? []);
    }
    notifyListeners();
  }


  //Getter and Setter
  KpiResult? get kpiData => _kpiData;

  set kpiData(KpiResult? value) {
    if (_kpiData == value) return;
    _kpiData = value;
    notifyListeners();
  }

  List<DashboardCardData>? get cardData => _cardData;

  set cardData(List<DashboardCardData>? value) {
    if (_cardData == value) return;
    _cardData = value;
    notifyListeners();
  }

  List<GetExternalAppointmentData> get upcomingAppointments => _upcomingAppointments;

  set upcomingAppointments(List<GetExternalAppointmentData> value) {
    if (_upcomingAppointments == value) return;
    _upcomingAppointments = value;
    notifyListeners();
  }

  List<GetExternalAppointmentData> get pastAppointments => _pastAppointments;

  set pastAppointments(List<GetExternalAppointmentData> value) {
    if (_pastAppointments == value) return;
    _pastAppointments = value;
    notifyListeners();
  }

  bool get isUpcoming => _isUpcoming;

  set isUpcoming(bool value) {
    if (_isUpcoming == value) return;
    _isUpcoming = value;
    notifyListeners();
  }

  int get selectedIndex => _selectedIndex;

  set selectedIndex(int value) {
    if (_selectedIndex == value) return;
    _selectedIndex = value;
    notifyListeners();
  }
}
