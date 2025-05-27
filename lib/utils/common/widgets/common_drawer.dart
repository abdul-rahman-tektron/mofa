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
import 'package:mofa/utils/common/widgets/language_button.dart';
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
                    "${context.watchLang.translate(AppLanguageText.hello)} ${user?.fullName ?? ""}",
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
                _buildDrawerItem(context, LucideIcons.user, context.watchLang.translate(AppLanguageText.editProfile), 0),
                _buildDrawerItem(context, LucideIcons.lock, context.watchLang.translate(AppLanguageText.changePassword), 1),
                _buildDrawerItem(context, LucideIcons.trash, context.watchLang.translate(AppLanguageText.deleteAccount), 2),
                LanguageChange(),
              ],
            ),
          ),
          _buildDrawerItem(context, LucideIcons.logOut, 'Logout', 4),
          15.verticalSpace,
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, int value) {
    return ListTile(
      leading: Icon(icon, size: 25,),
      title: Text(title, style: AppFonts.textMedium16,),
      onTap: () {
        Navigator.pop(context); // Close the drawer
        switch (value) {
          case 0:
            Navigator.pushNamed(context, AppRoutes.editProfile);
            break;
          case 1:
          // Navigate to Change Password
            break;
          case 2:
          // Navigate to Delete Account
            break;
          case 3:
          // Language Change
            break;
          case 4:
            logoutFunctionality(context);
            break;
        }
      },
    );
  }

  void logoutFunctionality(BuildContext context) async {
    await SecureStorageHelper.clearExceptRememberMe();
    Provider.of<CommonNotifier>(context, listen: false).clearUser();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
          (Route<dynamic> route) => false,
    );
  }

}
