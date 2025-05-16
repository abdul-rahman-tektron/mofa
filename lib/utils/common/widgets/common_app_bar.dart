import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_images.dart';
import 'package:mofa/utils/common/widgets/language_button.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CommonAppBar({super.key});

  @override
  Widget build(BuildContext context) {


    return AppBar(
      backgroundColor: AppColors.whiteColor,
      scrolledUnderElevation: 0.0,
      leading: Builder(
        builder: (context) => Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: GestureDetector(
              onTap: () => Scaffold.of(context).openDrawer(),
              child: Icon(LucideIcons.menu, color: Colors.black, size: 25.r,)),
        ),
      ),
      centerTitle: true,
      title: Image.asset(AppImages.logo, height: 50,),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24.0),
      actions: [
        LanguageButton(),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(65.0);
}
