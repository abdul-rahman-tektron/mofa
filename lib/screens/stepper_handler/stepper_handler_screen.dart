import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/model/apply_pass/apply_pass_category.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/res/app_strings.dart';
import 'package:mofa/screens/stepper_handler/stepper_handler_notifier.dart';
import 'package:mofa/utils/common/widgets/loading_overlay.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:mofa/utils/common/widgets/common_app_bar.dart';
import 'package:mofa/utils/common/widgets/common_drawer.dart';
import 'package:mofa/utils/secure_storage.dart';
import 'package:provider/provider.dart';

class StepperHandlerScreen extends StatelessWidget {
  final ApplyPassCategory category;
  final bool isUpdate;
  final int? id;

  const StepperHandlerScreen({super.key, required this.category, this.isUpdate = false, this.id});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StepperHandlerNotifier(context, category, isUpdate, id),
      child: Consumer<StepperHandlerNotifier>(
        builder: (context, stepperHandlerNotifier, child) {
          return PopScope(
            onPopInvokedWithResult: (didPop, result) async {
              await SecureStorageHelper.removeParticularKey(AppStrings.appointmentData);
              await SecureStorageHelper.removeParticularKey(AppStrings.uploadedImageCode);
            },
            child: SafeArea(
              child: LoadingOverlay<StepperHandlerNotifier>(
                child: Scaffold(
                  backgroundColor: AppColors.backgroundColor,
                  appBar: CommonAppBar(),
                  drawer: CommonDrawer(),
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        // Extract stepper to a separate widget to prevent rebuilds
                        _StepperIndicator(notifier: stepperHandlerNotifier),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: stepperHandlerNotifier.steps[stepperHandlerNotifier.currentStep],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// Separate widget for the stepper indicator to prevent unnecessary rebuilds
class _StepperIndicator extends StatelessWidget {
  final StepperHandlerNotifier notifier;

  const _StepperIndicator({required this.notifier});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        right: 25.w,
        left: 25.w,
        top: 15.h,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.85,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 15.w, right: 15.w),
                    child: Text(context.watchLang.translate(AppLanguageText.progress), style: AppFonts.textRegular16),
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(notifier.stepTitles.length * 2 - 1, (index) {
                      if (index.isEven) {
                        int stepIndex = index ~/ 2;
                        final isActive = stepIndex == notifier.currentStep;
                        final isCompleted = stepIndex < notifier.currentStep;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: isActive || isCompleted
                                ? AppColors.buttonBgColor.withOpacity(0.5)
                                : AppColors.backgroundColor,
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              stepIndex == 0
                                  ? LucideIcons.user
                                  : stepIndex == 1
                                  ? LucideIcons.heartPulse
                                  : LucideIcons.clipboardCheck,
                              color: isActive || isCompleted
                                  ? AppColors.whiteColor
                                  : AppColors.primaryColor,
                            ),
                          ),
                        );
                      } else {
                        final isCompleted = (index - 1) ~/ 2 < notifier.currentStep;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 5,
                          color: isCompleted
                              ? AppColors.buttonBgColor.withOpacity(0.5)
                              : AppColors.backgroundColor,
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
