import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/core/model/get_all_detail/get_all_detail_request.dart';
import 'package:mofa/core/model/get_all_detail/get_all_detail_response.dart';
import 'package:mofa/core/remote/service/search_pass_repository.dart';

class SearchPassNotifier extends BaseChangeNotifier{

  List<GetExternalAppointmentData> _getAllDetailData = [];


  SearchPassNotifier(BuildContext context){
    apiGetAllExternalAppointment(context);
  }

  //GetById Api Call
  Future apiGetAllExternalAppointment(BuildContext context) async {
    await SearchPassRepository().apiGetExternalAppointment(
        GetExternalAppointmentRequest(dFromDate: DateTime.now(), nPageNumber: 1, nPageSize: 10, sSearch: "", dToDate: ""), context).then((value) {
      getAllDetailData = List<GetExternalAppointmentData>.from((value as GetExternalAppointmentResult).data as List<GetExternalAppointmentData>);
    },);
  }


  //Getter Setter
  List<GetExternalAppointmentData> get getAllDetailData => _getAllDetailData;

  set getAllDetailData(List<GetExternalAppointmentData> value) {
    if (_getAllDetailData == value) return;
    _getAllDetailData = value;
    notifyListeners();
  }
}