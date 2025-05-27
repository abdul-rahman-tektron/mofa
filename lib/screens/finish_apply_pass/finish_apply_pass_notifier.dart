import 'package:flutter/cupertino.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/utils/app_routes.dart';

class FinishApplyPassNotifier extends BaseChangeNotifier{

  //Functions
  void closeScreen(BuildContext context) {
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.bottomBar, (Route<dynamic> route) => false);
  }
}