import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/model/custom_args/custom_args.dart';
import 'package:mofa/utils/app_routes.dart';
import 'package:mofa/utils/enum_values.dart';

class ApplyPassNotifier extends BaseChangeNotifier {
  ApplyPassCategory? selectedCategory;

  void selectCategory(ApplyPassCategory category) {
    selectedCategory = category;
    notifyListeners();
  }

  void navigateToSelectedCategory(BuildContext context) {
    if (selectedCategory != null) {
      Navigator.pushNamed(
        context,
        AppRoutes.stepper,
        arguments: StepperScreenArgs(category: selectedCategory!),
      );
    }
  }
}
