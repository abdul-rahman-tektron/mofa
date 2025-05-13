import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/notifier/common_notifier.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_images.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:mofa/utils/common/app_routes.dart';
import 'package:mofa/utils/common/secure_storage.dart';
import 'package:mofa/utils/common/widgets/language_button.dart';
import 'package:provider/provider.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<CommonNotifier>(context, listen: false).user;

    return AppBar(
      backgroundColor: AppColors.whiteColor,
      leading: Padding(
        padding: const EdgeInsets.only(left: 24.0),
        child: Image.asset(AppImages.logo),
      ),
      leadingWidth: 120,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      actions: [
        Text(context.watchLang.translate(AppLanguageText.hello), style: AppFonts.textMedium14),
        PopupMenuButton<int>(
          color: Colors.white,
          offset: Offset(-10, 50),
          onSelected: (value) async {
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
                await SecureStorageHelper.clear();
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  AppRoutes.login,
                  (Route<dynamic> route) => false,
                );
                break;
            }
          },
          icon: Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              color: AppColors.purpleColor,
              borderRadius: BorderRadius.circular(7),
            ),
            child: Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.whiteColor,
              size: 20,
            ),
          ),
          itemBuilder:
              (context) => [
                _buildMenuItem(LucideIcons.creditCard, 'Apply Pass', 0),
                _buildMenuItem(LucideIcons.search, 'Search Pass', 1),
                _buildMenuItem(LucideIcons.user, 'Edit Profile', 2),
                _buildMenuItem(LucideIcons.lock, 'Change Password', 3),
                _buildMenuItem(LucideIcons.trash, 'Delete Account', 4),
                _buildMenuItem(LucideIcons.layoutDashboard, 'Dashboard', 5),
                const PopupMenuDivider(), // <-- Divider before logout
                _buildMenuItem(Icons.logout, 'Logout', 6),
              ],
        ),
        LanguageButton(),
      ],
    );
  }

  PopupMenuItem<int> _buildMenuItem(IconData icon, String text, int value) {
    return PopupMenuItem<int>(
      value: value,
      child: Row(
        children: [Icon(icon, size: 20), const SizedBox(width: 10), Text(text)],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(65.0);
}
