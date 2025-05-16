import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';

class BulletList extends StatelessWidget {
  final List<String> strings;
  final VoidCallback? onPrivacyPolicyTap;

  const BulletList(this.strings, {this.onPrivacyPolicyTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(strings.length, (index) {
          final isLast = index == strings.length - 1;
          final text = strings[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12), // vertical spacing between items
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '\u2022',
                  style: TextStyle(fontSize: 16, height: 1.55),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text.rich(
                    textAlign: TextAlign.left,
                    TextSpan(
                      children: _buildTextSpans(context, text, isLast),
                      style: AppFonts.textRegularBullet14,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  List<TextSpan> _buildTextSpans(BuildContext context, String text, bool isLast) {
    // Check if 'Privacy Policy' exists in the text
    final keyword = context.watchLang.translate(AppLanguageText.privacyPolicyHere);
    if (text.contains(keyword)) {
      final parts = text.split(keyword);
      return [
        TextSpan(text: parts[0]),
        TextSpan(
          text: keyword,
          style: TextStyle(
            color: Colors.blueAccent,
            decoration: TextDecoration.underline,
            decorationColor: Colors.blueAccent,
          ),
          recognizer: TapGestureRecognizer()..onTap = onPrivacyPolicyTap,
        ),
        if (parts.length > 1) TextSpan(text: parts[1]),
      ];
    }

    // Last point should be bold
    return [
      TextSpan(
        text: text,
        style: isLast
            ? AppFonts.textBoldBullet14
            : null,
      ),
    ];
  }
}
