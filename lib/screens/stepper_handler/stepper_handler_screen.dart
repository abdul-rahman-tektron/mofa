import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/model/apply_pass/apply_pass_category.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/screens/apply_pass_category/apply_pass_category_screen.dart';
import 'package:mofa/screens/finish_apply_pass/finish_apply_pass_screen.dart';
import 'package:mofa/screens/health_and_safety/health_and_safety_screen.dart';
import 'package:mofa/screens/stepper_handler/stepper_handler_notifier.dart';
import 'package:mofa/utils/common/widgets/common_app_bar.dart';
import 'package:mofa/utils/common/widgets/common_drawer.dart';
import 'package:provider/provider.dart';

class StepperHandlerScreen extends StatelessWidget {
  final ApplyPassCategory category;

  const StepperHandlerScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => StepperHandlerNotifier(context, category),
      child: Consumer<StepperHandlerNotifier>(
        builder: (context, stepperHandlerNotifier, child) {
          return buildBody(context, stepperHandlerNotifier);
        },
      ),
    );
  }

  Widget buildBody(
    BuildContext context,
    StepperHandlerNotifier stepperHandlerNotifier,
  ) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CommonAppBar(),
      drawer: const CommonDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildStepper(
              context,
              stepperHandlerNotifier.stepTitles,
              stepperHandlerNotifier,
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                return FadeTransition(opacity: animation, child: child);
              },
              child: stepperHandlerNotifier.steps[stepperHandlerNotifier.currentStep],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepper(
      BuildContext context,
      List<String> titles,
      StepperHandlerNotifier stepperHandlerNotifier,
      ) {
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
                    padding: EdgeInsets.only(left: 15.w),
                    child: Text("Progress", style: AppFonts.textRegular16,),
                  ),
                  10.verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(titles.length * 2 - 1, (index) {
                      if (index.isEven) {
                        int stepIndex = index ~/ 2;
                        final isActive = stepIndex == stepperHandlerNotifier.currentStep;
                        final isCompleted = stepIndex < stepperHandlerNotifier.currentStep;
                        print("stepIndex");
                        print(stepIndex);
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
                              stepIndex == 0 ? LucideIcons.user : stepIndex == 1
                                  ? LucideIcons.heartPulse
                                  : LucideIcons.clipboardCheck,
                              color: isActive || isCompleted ? AppColors.whiteColor : AppColors.primaryColor,
                            ),
                          ),
                        );
                      } else {
                        final isCompleted = (index - 1) ~/ 2 < stepperHandlerNotifier.currentStep;

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: 5,
                          color: isCompleted ? AppColors.buttonBgColor.withOpacity(0.5) : AppColors.backgroundColor,
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
