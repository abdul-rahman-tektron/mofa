import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/model/apply_pass/apply_pass_category.dart';
import 'package:mofa/model/custom_args/custom_args.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/enum_values.dart';

class ApplyPassNotifier extends BaseChangeNotifier {

  //Function
  void navigateToMySelfScreen(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.stepper,
      arguments: StepperScreenArgs(category: ApplyPassCategory.myself),
    );
  }

  void navigateToMySomeoneElse(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.stepper,
      arguments: StepperScreenArgs(category: ApplyPassCategory.someoneElse),
    );
  }

  void navigateToMyGroup(BuildContext context) {
    Navigator.pushNamed(
      context,
      AppRoutes.stepper,
      arguments: StepperScreenArgs(category: ApplyPassCategory.group),
    );
  }
}