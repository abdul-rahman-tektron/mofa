import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/apply_pass/apply_pass_notifier.dart';
import 'package:mofa/utils/common/widgets/common_app_bar.dart';
import 'package:mofa/utils/common/widgets/common_buttons.dart';
import 'package:mofa/utils/common/widgets/common_drawer.dart';
import 'package:mofa/utils/enum_values.dart';
import 'package:provider/provider.dart';

class ApplyPassScreen extends StatelessWidget {
  const ApplyPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => ApplyPassNotifier(),
      child: Consumer<ApplyPassNotifier>(
        builder: (context, applyPassNotifier, child) {
          return buildBody(context, applyPassNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, ApplyPassNotifier applyPassNotifier) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: 25.h, right: 25.w, left: 25.w, top: 15.h),
            child: Column(
              children: [
                welcomeHeading(context),
                35.verticalSpace,
                Text(context.watchLang.translate(AppLanguageText.applyingVisitFor), style: AppFonts.textBold16),
                15.verticalSpace,
                categoryList(context, applyPassNotifier),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget welcomeHeading(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text.rich(
            textAlign: TextAlign.center,
            TextSpan(
              text: "${context.watchLang.translate(AppLanguageText.welcomeTo)} ",
              style: AppFonts.textMedium16,
              children: [
                TextSpan(text: context.watchLang.translate(AppLanguageText.mofa), style: AppFonts.textBold16),
                TextSpan(
                  text: " ${context.watchLang.translate(AppLanguageText.visitorAccessRequest)}",
                  style: AppFonts.textMedium16,
                ),
              ],
            ),
          ),
          // 5.verticalSpace,
          // Text(
          //   context.watchLang.translate(AppLanguageText.completeQuestions),
          //   textAlign: TextAlign.center,
          //   style: AppFonts.textMedium16,
          // ),
        ],
      ),
    );
  }

  Widget categoryList(BuildContext context, ApplyPassNotifier notifier) {
    return Wrap(
      spacing: 10.w,
      runSpacing: 20.h,
      alignment: WrapAlignment.center,
      children: [
        categoryWidget(
          context,
          notifier,
          LucideIcons.user,
          context.watchLang.translate(AppLanguageText.myself),
          ApplyPassCategory.myself,
        ),
        15.verticalSpace,
        categoryWidget(
          context,
          notifier,
          LucideIcons.userSquare,
          context.watchLang.translate(AppLanguageText.someoneElse),
          ApplyPassCategory.someoneElse,
        ),
        15.verticalSpace,
        categoryWidget(
          context,
          notifier,
          LucideIcons.users,
          context.watchLang.translate(AppLanguageText.group),
          ApplyPassCategory.group,
        ),
      ],
    );
  }

  Widget categoryWidget(
    BuildContext context,
    ApplyPassNotifier notifier,
    IconData icon,
    String title,
    ApplyPassCategory category,
  ) {
    return InkWell(
      onTap: () {
        notifier.selectedCategory = category;
        notifier.navigateToSelectedCategory(context);
      },
      child: Container(
        height: 150.h,
        width: 150.w,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.buttonBgColor),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4, offset: const Offset(0, 4))],
        ),
        child: Column(
          children: [
            Expanded(child: Icon(icon, size: 45, color: AppColors.buttonBgColor)),
            Text(title, style: AppFonts.textMedium16,textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
}
