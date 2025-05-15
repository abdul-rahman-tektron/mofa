import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/notifier/common_notifier.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_images.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/res/app_strings.dart';
import 'package:mofa/utils/common/app_routes.dart';
import 'package:mofa/utils/common/secure_storage.dart';
import 'package:provider/provider.dart';

class CommonDrawer extends StatelessWidget {
  final Function(int)? onItemSelected;

  const CommonDrawer({Key? key, this.onItemSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CommonNotifier>(context, listen: false).user;

    return Drawer(
      width: 250,
      backgroundColor: AppColors.whiteColor,
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: AppColors.fieldBorderColor),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(AppImages.logo, height: 80,),
                  15 .verticalSpace,
                  Text(
                    "${context.watchLang.translate(AppLanguageText.hello)}${user?.sFullName ?? ""}",
                    style: AppFonts.textMedium18,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(context, LucideIcons.creditCard, context.watchLang.translate(AppLanguageText.applyPass), 0),
                _buildDrawerItem(context, LucideIcons.search, context.watchLang.translate(AppLanguageText.searchPass), 1),
                _buildDrawerItem(context, LucideIcons.user, context.watchLang.translate(AppLanguageText.editProfile), 2),
                _buildDrawerItem(context, LucideIcons.lock, context.watchLang.translate(AppLanguageText.changePassword), 3),
                _buildDrawerItem(context, LucideIcons.trash, context.watchLang.translate(AppLanguageText.deleteAccount), 4),
                _buildDrawerItem(context, LucideIcons.layoutDashboard, "Dashboard", 5),
              ],
            ),
          ),
          _buildDrawerItem(context, LucideIcons.logOut, 'Logout', 6),
          15.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, int value) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        switch (value) {
          case 0:
          // Navigate to Apply Pass
            break;
          case 1:
          // Navigate to Search Pass
            break;
          case 2:
          // Navigate to Edit Profile
            break;
          case 3:
          // Navigate to Change Password
            break;
          case 4:
          // Delete Account
            break;
          case 5:
          // Navigate to Dashboard
            break;
          case 6:
            logoutFunctionality(context);
            break;
        }
      },
    );
  }

  void logoutFunctionality(BuildContext context) async {
    await SecureStorageHelper.clear();
    Provider.of<CommonNotifier>(context, listen: false).clearUser();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
          (Route<dynamic> route) => false,
    );
  }

}
