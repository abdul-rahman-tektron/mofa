import 'package:flutter/material.dart';
import 'package:mofa/core/base/base_change_notifier.dart';
import 'package:mofa/model/apply_pass/apply_pass_category.dart';
import 'package:mofa/screens/apply_pass_category/apply_pass_category_screen.dart';
import 'package:mofa/screens/apply_pass_group/apply_pass_group_screen.dart';
import 'package:mofa/screens/finish_apply_pass/finish_apply_pass_screen.dart';
import 'package:mofa/screens/health_and_safety/health_and_safety_screen.dart';

class StepperHandlerNotifier extends BaseChangeNotifier {
  int _currentStep = 0;

  List<Widget> _steps = [];

  final stepTitles = ['Category', 'Health', 'Finish'];

StepperHandlerNotifier(BuildContext context, ApplyPassCategory category) {
  steps = [
      category == ApplyPassCategory.group
          ? ApplyPassGroupScreen(onNext: goToNextStep, category: category)
          : ApplyPassCategoryScreen(onNext: goToNextStep, category: category),
      HealthAndSafetyScreen(onNext: goToNextStep, onPrevious: goToPreviousStep),
    FinishApplyPassScreen(onPrevious: goToPreviousStep),
  ];
}

  void goToNextStep() {
    if (currentStep < steps.length - 1) {
       currentStep++;
    }
  }

  void goToPreviousStep() {
    if (currentStep > 0) {
      currentStep--;
    }
  }

  //Getter and Setter
  int get currentStep => _currentStep;

  set currentStep(int value) {
    if (_currentStep == value) return;
    _currentStep = value;
    notifyListeners();
  }

  List<Widget> get steps => _steps;

  set steps(List<Widget> value) {
    if (_steps == value) return;
    _steps = value;
    notifyListeners();
  }
}