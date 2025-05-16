import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/finish_apply_pass/finish_apply_pass_notifier.dart';
import 'package:mofa/utils/common/widgets/common_app_bar.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_drawer.dart';
import 'package:provider/provider.dart';

class FinishApplyPassScreen extends StatelessWidget {
  final VoidCallback onPrevious;
  const FinishApplyPassScreen({super.key, required this.onPrevious});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => FinishApplyPassNotifier(),
      child: Consumer<FinishApplyPassNotifier>(
        builder: (context, finishApplyPassNotifier, child) {
          return buildBody(context, finishApplyPassNotifier);
        },
      ),
    );
  }

  Widget buildBody(
    BuildContext context,
    FinishApplyPassNotifier finishApplyPassNotifier,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: 25.h,
        right: 25.w,
        left: 25.w,
        top: 15.h,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          thanksAndConfirmation(context, finishApplyPassNotifier),
          15.verticalSpace,
          closeButton(context, finishApplyPassNotifier),
        ],
      ),
    );
  }

  Widget thanksAndConfirmation(
    BuildContext context,
    FinishApplyPassNotifier finishApplyPassNotifier,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${context.watchLang.translate(AppLanguageText.finish)}:",
              style: AppFonts.textSemiBold24,
            ),
          ),
          20.verticalSpace,
          Icon(LucideIcons.checkCircle2, size: 110),
          20.verticalSpace,
          Text(
            "${context.watchLang.translate(AppLanguageText.thankYou)}!",
            style: AppFonts.textBold24,
          ),
          20.verticalSpace,
          Text(
            context.watchLang.translate(AppLanguageText.visitRequestSubmitted),
            style: AppFonts.textMedium16,
            textAlign: TextAlign.center,
          ),
          30.verticalSpace,
          Text(
            context.watchLang.translate(AppLanguageText.checkJunkEmail),
            style: AppFonts.textMedium12,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget closeButton(
    BuildContext context,
    FinishApplyPassNotifier finishApplyPassNotifier,
  ) {
    return CustomButton(
      text: context.watchLang.translate(AppLanguageText.close),
      smallWidth: true ,
      onPressed: () => finishApplyPassNotifier.closeScreen(context),
    );
  }
}
