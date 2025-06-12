import 'package:flutter/cupertino.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/res/app_strings.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/secure_storage.dart';

class FinishApplyPassNotifier extends BaseChangeNotifier{

  //Functions
  void closeScreen(BuildContext context) async {
    await SecureStorageHelper.removeParticularKey(AppStrings.appointmentData);
    await SecureStorageHelper.removeParticularKey(AppStrings.uploadedImageCode);
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.bottomBar, (Route<dynamic> route) => false);
  }
}