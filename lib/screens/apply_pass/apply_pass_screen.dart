import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/apply_pass/apply_pass_notifier.dart';
import 'package:mofa/utils/common/widgets/common_app_bar.dart';
import 'package:mofa/utils/common/widgets/common_drawer.dart';
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
        appBar: CommonAppBar(),
        drawer: const CommonDrawer(),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 25.h,
              right: 25.w,
              left: 25.w,
              top: 15.h,
            ),
            child: Column(
              children: [
                welcomeHeading(context),
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
              text:
                  "${context.watchLang.translate(AppLanguageText.welcomeTo)} ",
              style: AppFonts.textMedium16,
              children: [
                TextSpan(
                  text: context.watchLang.translate(AppLanguageText.mofa),
                  style: AppFonts.textBold16,
                ),
                TextSpan(
                  text:
                      " ${context.watchLang.translate(AppLanguageText.visitorAccessRequest)}",
                  style: AppFonts.textMedium16,
                ),
              ],
            ),
          ),
          5.verticalSpace,
          Text(
            context.watchLang.translate(AppLanguageText.completeQuestions),
            textAlign: TextAlign.center,
            style: AppFonts.textMedium16,
          ),
        ],
      ),
    );
  }

  Widget categoryList(
    BuildContext context,
    ApplyPassNotifier applyPassNotifier,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.watchLang.translate(AppLanguageText.applyingVisitFor),
            style: AppFonts.textMedium18,
          ),
          categoryWidget(
            context,
            () {
              applyPassNotifier.navigateToMySelfScreen(context);
            },
            LucideIcons.user,
            context.watchLang.translate(AppLanguageText.myself),
          ),
          10.verticalSpace,
          categoryWidget(
            context,
            () {
              applyPassNotifier.navigateToMySomeoneElse(context);
            },
            LucideIcons.userSquare,
            context.watchLang.translate(AppLanguageText.someoneElse),
          ),
          10.verticalSpace,
          categoryWidget(
            context,
            () {
              applyPassNotifier.navigateToMyGroup(context);
            },
            LucideIcons.users,
            context.watchLang.translate(AppLanguageText.group),
          ),
        ],
      ),
    );
  }

  Widget categoryWidget(
    BuildContext context,
    VoidCallback onTap,
    IconData icons,
    String title,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 200.w,
            margin: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.purpleOpacityColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icons, size: 100, color: AppColors.whiteColor),
          ),
          Text(title, style: AppFonts.textMedium18),
        ],
      ),
    );
  }
}
