import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/get_all_detail/get_all_detail_request.dart';
import 'package:mofa/core/model/get_all_detail/get_all_detail_response.dart';
import 'package:mofa/core/remote/service/search_pass_repository.dart';

class SearchPassNotifier extends BaseChangeNotifier {
  List<GetExternalAppointmentData> _getAllDetailData = [];

  int _currentPage = 1;
  int _totalPages = 1;
  int _totalCount = 0;
  final int _pageSize = 10;

  SearchPassNotifier(BuildContext context) {
    apiGetAllExternalAppointment(context);
  }

  Future<void> apiGetAllExternalAppointment(BuildContext context, {int? page}) async {
    _currentPage = page ?? _currentPage;

    final now = DateTime.now();
    final fromDate = DateTime(now.year, now.month - 1, now.day); // 1 month before today

    final response = await SearchPassRepository().apiGetExternalAppointment(
      GetExternalAppointmentRequest(
        dFromDate: fromDate,
        dToDate: "",
        nPageNumber: _currentPage,
        nPageSize: _pageSize,
        sSearch: "",
      ),
      context,
    );

    final result = response as GetExternalAppointmentResult;
    getAllDetailData = List<GetExternalAppointmentData>.from(result.data ?? []);
    _totalPages = result.pagination?.pages ?? 1;
    _totalCount = result.pagination?.count ?? 0;
    notifyListeners();
  }

  void goToPreviousPage(BuildContext context) {
    if (_currentPage > 1) {
      _currentPage--;
      apiGetAllExternalAppointment(context, page: _currentPage);
    }
  }

  void goToNextPage(BuildContext context) {
    if (_currentPage < _totalPages) {
      _currentPage++;
      apiGetAllExternalAppointment(context, page: _currentPage);
    }
  }

  List<GetExternalAppointmentData> get getAllDetailData => _getAllDetailData;

  set getAllDetailData(List<GetExternalAppointmentData> value) {
    _getAllDetailData = value;
    notifyListeners();
  }

  int get currentPage => _currentPage;
  int get totalPages => _totalPages;
  int get totalCount => _totalCount;
}
