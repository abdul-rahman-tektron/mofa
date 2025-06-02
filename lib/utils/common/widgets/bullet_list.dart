import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mofa/core/localization/context_extensions.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';
import 'package:mofa/res/app_language_text.dart';

class BulletList extends StatefulWidget {
  final List<String> strings;
  final VoidCallback? onPrivacyPolicyTap;
  final List<int> initiallyVisibleIndices;

  const BulletList(
      this.strings, {
        this.onPrivacyPolicyTap,
        this.initiallyVisibleIndices = const [],
        super.key,
      });

  @override
  State<BulletList> createState() => _BulletListState();
}

class _BulletListState extends State<BulletList> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final allItems = widget.strings;
    final visibleItems = _expanded
        ? List.generate(allItems.length, (index) => MapEntry(index, allItems[index]))
        : widget.initiallyVisibleIndices.map((i) => MapEntry(i, allItems[i])).toList();

    final isExpandable = widget.initiallyVisibleIndices.length < allItems.length;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...visibleItems.map((entry) {
            final index = entry.key;
            final text = entry.value;
            final isLastVisible = index == visibleItems.last.key;
            final isBold = isLastVisible;

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('\u2022', style: TextStyle(fontSize: 16, height: 1.55)),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text.rich(
                      TextSpan(
                        children: _buildTextSpans(context, text, isBold),
                        style: AppFonts.textRegularBullet14,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ],
              ),
            );
          }),
          if (isExpandable)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  _expanded
                      ? "Show less"
                      : "Show more",
                  style: AppFonts.textRegular14.copyWith(
                    color: Colors.blueAccent,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<TextSpan> _buildTextSpans(BuildContext context, String text, bool isBold) {
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
          ),
          recognizer: TapGestureRecognizer()..onTap = widget.onPrivacyPolicyTap,
        ),
        if (parts.length > 1) TextSpan(text: parts[1]),
      ];
    }

    return [
      TextSpan(
        text: text,
        style: isBold ? AppFonts.textBoldBullet14 : null,
      ),
    ];
  }
}

