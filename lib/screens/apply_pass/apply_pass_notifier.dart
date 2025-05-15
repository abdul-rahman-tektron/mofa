import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/model/apply_pass/apply_pass_category.dart';
import 'package:mofa/utils/common/app_routes.dart';

class ApplyPassNotifier extends BaseChangeNotifier {

  //Function
  void navigateToMySelfScreen(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.applyPassCategory,
      arguments: ApplyPassCategory.myself,
    );
  }

  void navigateToMySomeoneElse(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.applyPassCategory,
      arguments: ApplyPassCategory.someoneElse,
    );
  }

  void navigateToMyGroup(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.applyPassCategory,
      arguments: ApplyPassCategory.group,
    );
  }
}