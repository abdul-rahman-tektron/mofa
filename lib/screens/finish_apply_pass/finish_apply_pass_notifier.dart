import 'package:flutter/cupertino.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/utils/common/app_routes.dart';

class FinishApplyPassNotifier extends BaseChangeNotifier{


  //Functions
  void closeScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.applyPass, (Route<dynamic> route) => false);
  }
}