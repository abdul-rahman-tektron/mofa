import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/core/notifier/language_notifier.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';
import 'package:provider/provider.dart';

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) {
      return ElevatedButton(
        onPressed: () {
          final provider = context.read<LanguageNotifier>();
          final nextLang = provider.currentLang == 'en' ? 'ar' : 'en';
          context.switchLang(nextLang);
        },
        style: ElevatedButton.styleFrom(
          textStyle: AppFonts.textSemiBold16,
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
              // Set custom radius here
            ),
            side: BorderSide(
              color:  AppColors.buttonBgColor,
              width: 2,
            ), // Border color and width
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.translate, color: AppColors.textColor,),
            SizedBox(width: 2,),
            Text(context.watchLang.translate(AppLanguageText.switchLng), style: AppFonts.textSemiBold16),
          ],
        ),
      );
  }
}

class LanguageChange extends StatelessWidget {
  const LanguageChange({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(LucideIcons.languages, size: 25,),
      title: Text(context.watchLang.translate(AppLanguageText.switchLng), style: FontResolver.resolve(context.watchLang.translate(AppLanguageText.switchLng), AppFonts.textMedium16),),
      onTap: () {
        final provider = context.read<LanguageNotifier>();
        final nextLang = provider.currentLang == 'en' ? 'ar' : 'en';
        context.switchLang(nextLang);
      },
    );
  }
}
