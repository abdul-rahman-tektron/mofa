import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/screens/bottom_bar/bottom_bar_notifier.dart';
import 'package:mofa/utils/common/widgets/common_app_bar.dart';
import 'package:mofa/utils/common/widgets/common_bottom_bar.dart';
import 'package:mofa/utils/common/widgets/common_drawer.dart';
import 'package:provider/provider.dart';

class BottomBarScreen extends StatelessWidget {
  final int? currentIndex;
  const BottomBarScreen({super.key, this.currentIndex = 0});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BottomBarNotifier(currentIndex),
      child: Consumer<BottomBarNotifier>(
        builder: (context, bottomBarNotifier, child) {
          return buildBody(context, bottomBarNotifier);
        },
      ),
    );
  }

  Widget buildBody(BuildContext context, BottomBarNotifier bottomBarNotifier) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        bottomBarNotifier.changeTab(0);
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        appBar: CommonAppBar(),
        drawer: CommonDrawer(),
        body: bottomBarNotifier.currentScreen,
        bottomNavigationBar: CustomBottomNavBar(
          currentIndex: bottomBarNotifier.currentIndex,
          onTap: bottomBarNotifier.changeTab,
        ),
      ),
    );
  }
}
