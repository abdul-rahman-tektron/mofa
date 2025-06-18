import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/base/loading_state.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/notifier/language_notifier.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/health_and_safety/health_and_safety_notifier.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/info_section_widget.dart';
import 'package:provider/provider.dart';

class HealthAndSafetyScreen extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final bool isUpdate;
  const HealthAndSafetyScreen({super.key, required this.onNext, required this.onPrevious, this.isUpdate = false});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HealthAndSafetyNotifier(isUpdate),
      child: Consumer<HealthAndSafetyNotifier>(
        builder: (context, healthAndSafetyNotifier, child) {
          return buildBody(context, healthAndSafetyNotifier);
        },
      ),
    );
  }

  Widget buildBody(
    BuildContext context,
    HealthAndSafetyNotifier healthAndSafetyNotifier,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 25.h,
        right: 25.w,
        left: 25.w,
        top: 15.h,
      ),
      child: Column(
        children: [
          guidelinesAndDeclaration(context, healthAndSafetyNotifier),
          15.verticalSpace,
          previousAndSubmitButtons(context, healthAndSafetyNotifier),
        ],
      ),
    );
  }

  Widget guidelinesAndDeclaration(
    BuildContext context,
    HealthAndSafetyNotifier healthAndSafetyNotifier,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.watchLang.translate(AppLanguageText.healthDeclaration),
            style: AppFonts.textBold24,
          ),
          5.verticalSpace,
          Text(
            context.watchLang.translate(
              AppLanguageText.guidelinesAcknowledgement,
            ),
            style: AppFonts.textRegular16,
          ),
          15.verticalSpace,
          HealthDeclarationList(
            sections:
                context.watch<LanguageNotifier>().currentLang == 'ar'
                    ? healthAndSafetyNotifier.arabicDeclarations
                    : healthAndSafetyNotifier.englishDeclarations,
            isRtl: context.watch<LanguageNotifier>().currentLang == 'ar',
          ),
          Text(
            context.watchLang.translate(AppLanguageText.acknowledgement),
            style: AppFonts.textBold20,
          ),
          8.verticalSpace,
          userAcceptDeclarationCheckbox(context, healthAndSafetyNotifier),
        ],
      ),
    );
  }

  Widget userAcceptDeclarationCheckbox(
    BuildContext context,
    HealthAndSafetyNotifier healthAndSafetyNotifier,
  ) {
    return GestureDetector(
      onTap: () {
        healthAndSafetyNotifier.userAcceptDeclarationChecked(
          context,
          !healthAndSafetyNotifier.isChecked,
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(
                    color:
                        healthAndSafetyNotifier.isChecked
                            ? AppColors.primaryColor
                            : AppColors.primaryColor,
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(6),
                  color:
                      healthAndSafetyNotifier.isChecked
                          ? AppColors.whiteColor
                          : Colors.transparent,
                ),
                child:
                    healthAndSafetyNotifier.isChecked
                        ? Icon(Icons.check, size: 17, color: Colors.black)
                        : null,
              ),
            ),
            10.horizontalSpace,
            Expanded(
              child: Text(
                context.watchLang.translate(
                  AppLanguageText.acceptDeclarationAndGuidelines,
                ),
                style: AppFonts.textRegular14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget previousAndSubmitButtons(
    BuildContext context,
    HealthAndSafetyNotifier healthAndSafetyNotifier,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CustomButton(
          text: context.watchLang.translate(AppLanguageText.previous),
          smallWidth: true,
          onPressed: () {
            onPrevious();
          },
        ),
        CustomButton(
          text: context.watchLang.translate(AppLanguageText.submit),
          smallWidth: true,
          isLoading: healthAndSafetyNotifier.loadingState == LoadingState.Busy,
          onPressed: !healthAndSafetyNotifier.isChecked ? null :() {
            healthAndSafetyNotifier.submitButtonPressed(context, onNext);
          },
        ),
      ],
    );
  }
}
