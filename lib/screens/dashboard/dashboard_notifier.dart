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
    runWithLoadingVoid(() => _init(context));
  }

  Future<void> _init(BuildContext context) async {
    await apiDashboardKpi(context);
    await apiGetAllExternalAppointment(context, true);
  }

  Future<void> apiDashboardKpi(BuildContext context) async {
    try {
      final value = await DashboardRepository().apiDashboardKpi({}, context);
      kpiData = value as KpiResult;

      cardData = [
        DashboardCardData(
          icon: LucideIcons.calendar,
          titleKey: AppLanguageText.totalVisitsToday,
          count: kpiData?.totalPassToday ?? 0,
        ),
        DashboardCardData(
          icon: LucideIcons.calendarDays,
          titleKey: AppLanguageText.totalVisitsMonthly,
          count: kpiData?.totalPassMonth ?? 0,
        ),
        DashboardCardData(
          icon: LucideIcons.calendarCheck,
          titleKey: AppLanguageText.totalVisitsYearly,
          count: kpiData?.totalPassYear ?? 0,
        ),
        DashboardCardData(
          icon: LucideIcons.ticket,
          titleKey: AppLanguageText.totalVisits,
          count: kpiData?.totalPasses ?? 0,
        ),
      ];


      notifyListeners();  // Important to update UI
    } catch (e) {
      debugPrint('Error fetching dashboard KPI: $e');
      // Optionally show error Toast or handle gracefully
    }
  }

  Future<void> apiGetAllExternalAppointment(BuildContext context, bool isUpcoming, {int? page}) async {
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final todayPast = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day -1);

    // Calculate fromDate for past appointments safely
    final fromDate = isUpcoming
        ? today
        : DateTime(today.year, today.month - 1, today.day); // Last month same day

    try {
      final response = await SearchPassRepository().apiGetExternalAppointment(
        GetExternalAppointmentRequest(
          dFromDate: fromDate.toIso8601String(),
          dToDate: isUpcoming ? null : todayPast.toIso8601String(),
          nApprovalStatus: isUpcoming ? 49 : null,
          nPageNumber: page ?? 1,
          nPageSize: 40,
          sSearch: "",
        ),
        context,
      );

      final result = response as GetExternalAppointmentResult;

      if (isUpcoming) {
        upcomingAppointments = (result.data ?? [])
            .where((item) => item.sQRCodeValue != null)
            .toList();
      } else {
        pastAppointments = List<GetExternalAppointmentData>.from(result.data ?? []);
      }

      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching external appointments: $e');
      // Optionally show toast or error handling here
    }
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
