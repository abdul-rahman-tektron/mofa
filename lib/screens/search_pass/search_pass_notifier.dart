import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/add_appointment/cancel_appointment_request.dart';
import 'package:mofa/core/model/device_dropdown/device_dropdown_response.dart';
import 'package:mofa/core/model/get_all_detail/get_all_detail_request.dart';
import 'package:mofa/core/model/get_all_detail/get_all_detail_response.dart';
import 'package:mofa/core/model/location_dropdown/location_dropdown_response.dart';
import 'package:mofa/core/remote/service/apply_pass_repository.dart';
import 'package:mofa/core/remote/service/search_pass_repository.dart';
import 'package:mofa/screens/search_pass/search_pass_screen.dart';
import 'package:mofa/utils/extensions.dart';

class SearchPassNotifier extends BaseChangeNotifier {
  List<GetExternalAppointmentData> _visibleAppointments = [];

  final TextEditingController searchController = TextEditingController();
  final TextEditingController visitStartDateController = TextEditingController();
  final TextEditingController visitEndDateController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final ScrollController scrollbarController = ScrollController();

  List<LocationDropdownResult> _locationDropdownData = [];
  List<DeviceDropdownResult> _statusDropdownData = [];

  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  final int _pageSize = 10;
  int? _selectedLocationId;
  int? _selectedStatusId;
  String _searchText = "";

  bool _filtersCleared = false;

  Timer? _debounceTimer;

  List<TableColumnConfig> columnConfigs = [
    TableColumnConfig(label: 'Ref No', isMandatory: true),
    TableColumnConfig(label: 'Name', isMandatory: true),
    TableColumnConfig(label: 'Status', isMandatory: true),
    TableColumnConfig(label: 'Company Name', isVisible: false),
    TableColumnConfig(label: 'Start & End Date', isMandatory: true),
    TableColumnConfig(label: 'Email', isVisible: false),
    TableColumnConfig(label: 'Host Name', isVisible: false),
    TableColumnConfig(label: 'Location', isVisible: false),
    TableColumnConfig(label: 'Vehicle Permit', isVisible: false),
    TableColumnConfig(label: 'Action', isMandatory: true),
  ];

  SearchPassNotifier(BuildContext context) {
    visitStartDateController.text = _getDefaultStartDate();
    searchController.addListener(() => _onSearchChanged(context));
    allApiCall(context);
  }

  Future<void> allApiCall(BuildContext context) async {
    try {
      await Future.wait([
        apiLocationDropdown(context),
        apiStatusDropdown(context),
        apiGetAllExternalAppointment(context),
      ]);
    } catch (e) {
      // Handle exceptions if needed
      debugPrint('Dropdown fetch error: $e');
    }
  }

  void _onSearchChanged(BuildContext context) {
    if (_filtersCleared) return; // Skip if filters were cleared

    if (_debounceTimer?.isActive ?? false) _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      _searchText = searchController.text.trim();
      _currentPage = 1;
      apiGetAllExternalAppointment(context);
    });
  }

  Future<void> apiGetAllExternalAppointment(BuildContext context, {int? page}) async {
    _currentPage = page ?? _currentPage;

    final response = await SearchPassRepository().apiGetExternalAppointment(
      GetExternalAppointmentRequest(
        dFromDate: visitStartDateController.text.apiDateFormat(),
        dToDate: visitEndDateController.text.isEmpty ? null : visitEndDateController.text.apiDateFormat(),
        nApprovalStatus: _selectedStatusId,
        nLocationId: _selectedLocationId,
        nPageNumber: _currentPage,
        nPageSize: _pageSize,
        sSearch: _searchText,
      ),
      context,
    );

    final result = response as GetExternalAppointmentResult;
    _visibleAppointments = List<GetExternalAppointmentData>.from(result.data ?? []);
    _totalPages = result.pagination?.pages ?? 1;
    _totalCount = result.pagination?.count ?? 0;

    notifyListeners();
  }

  void clearFiltersAndData(BuildContext context) {
    _filtersCleared = true; //Block search API after clear

    visitStartDateController.clear();
    visitEndDateController.clear();
    statusController.clear();
    locationController.clear();
    selectedStatusId = null;
    selectedLocationId = null;
    _searchText = "";
    searchController.clear();
    _currentPage = 1;

    _visibleAppointments.clear();
    _totalCount = 0;
    _totalPages = 1;

    notifyListeners();
  }

  String _getDefaultStartDate() {
    final now = DateTime.now();
    final fromDate = DateTime(now.year, now.month - 1, now.day);
    return "${fromDate.day.toString().padLeft(2, '0')}/${fromDate.month.toString().padLeft(2, '0')}/${fromDate.year.toString().padLeft(4, '0')}";
  }

  // Location dropdown API call
  Future<void> apiLocationDropdown(BuildContext context) async {
    try {
      final value = await ApplyPassRepository().apiLocationDropDown({}, context);
      final locationData = value as List<LocationDropdownResult>;
      locationDropdownData = List<LocationDropdownResult>.from(locationData);
    } catch (e) {
      print("Failed to load location dropdown: $e");
    }
  }

  // Status dropdown API call
  Future<void> apiStatusDropdown(BuildContext context) async {
    try {
      final value = await SearchPassRepository().apiStatusDropDown({}, context);
      final statusData = value as List<DeviceDropdownResult>;
      statusDropdownData = List<DeviceDropdownResult>.from(statusData);
    } catch (e) {
      print("Failed to load status dropdown: $e");
    }
  }

  // Cancel appointment API call
  Future<void> apiCancelAppointment(BuildContext context, GetExternalAppointmentData appointmentData) async {
    try {
      await SearchPassRepository().apiCancelAppointment(
        CancelAppointmentRequest(
          nLocationId: appointmentData.nLocationId,
          nExternalRegistrationId: appointmentData.nExternalRegistrationId,
          nAppointmentId: appointmentData.nAppointmentId,
          nUpdatedByExternal: appointmentData.nExternalRegistrationId,
          nUserId: appointmentData.userId,
        ),
        context,
      );
      Navigator.pop(context);
      await apiGetAllExternalAppointment(context);
    } catch (e) {
      print("Failed to cancel appointment: $e");
    }
  }

  void goToPreviousPage(BuildContext context) {
    if (_currentPage > 1) {
      _currentPage--;
      apiGetAllExternalAppointment(context);
    }
  }

  void goToNextPage(BuildContext context) {
    if (_currentPage < _totalPages) {
      _currentPage++;
      apiGetAllExternalAppointment(context);
    }
  }

  void updateColumnVisibility(String label, bool isVisible) {
    final index = columnConfigs.indexWhere((c) => c.label == label);
    if (index != -1 && !columnConfigs[index].isMandatory) {
      columnConfigs[index].isVisible = isVisible;
      notifyListeners();
    }
  }

  // Getters
  List<GetExternalAppointmentData> get getAllDetailData => _visibleAppointments;

  int get currentPage => _currentPage;

  set currentPage(int value) {
    if (_currentPage == value) return;
    _currentPage = value;
    notifyListeners();
  }

  int get totalPages => _totalPages;

  int get totalCount => _totalCount;

  List<LocationDropdownResult> get locationDropdownData => _locationDropdownData;

  set locationDropdownData(List<LocationDropdownResult> value) {
    if (_locationDropdownData == value) return;
    _locationDropdownData = value;
    notifyListeners();
  }

  int? get selectedLocationId => _selectedLocationId;

  set selectedLocationId(int? value) {
    if (_selectedLocationId == value) return;
    _selectedLocationId = value;
    notifyListeners();
  }

  List<DeviceDropdownResult> get statusDropdownData => _statusDropdownData;

  set statusDropdownData(List<DeviceDropdownResult> value) {
    if (_statusDropdownData == value) return;
    _statusDropdownData = value;
    notifyListeners();
  }

  int? get selectedStatusId => _selectedStatusId;

  set selectedStatusId(int? value) {
    if (_selectedStatusId == value) return;
    _selectedStatusId = value;
    notifyListeners();
  }

  bool get filtersCleared => _filtersCleared;

  set filtersCleared(bool value) {
    if (_filtersCleared == value) return;
    _filtersCleared = value;
    notifyListeners();
  }
}
