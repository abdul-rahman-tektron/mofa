import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/bottom_bar/bottom_bar_notifier.dart';
import 'package:provider/provider.dart';

class BottomBarScreen extends StatelessWidget {
  const BottomBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomBarNotifier(),
      child: Consumer<BottomBarNotifier>(
        builder: (context, bottomBarNotifier, child) {
          return buildBody(context, bottomBarNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, BottomBarNotifier bottomBarNotifier) {
    return Scaffold(
      body: bottomBarNotifier.currentScreen,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.whiteColor,
        currentIndex: bottomBarNotifier.currentIndex,
        onTap: bottomBarNotifier.changeTab,
        selectedItemColor: AppColors.buttonBgColor,
        selectedLabelStyle: AppFonts.textRegular12,
        unselectedLabelStyle: AppFonts.textRegular12,
        unselectedItemColor: AppColors.buttonBgColor.withOpacity(0.5),
        items: [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.creditCard),
            label: context.watchLang.translate(AppLanguageText.applyPass,),
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.search),
            label: 'Search Pass',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.layoutDashboard),
            label: 'Dashboard',
          ),
        ],
      ),
    );
  }
}
