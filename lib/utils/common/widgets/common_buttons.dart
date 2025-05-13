import 'package:flutter/material.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? backgroundColor;
  final TextStyle? textFont;
  final String buttonImage;
  final double? radius;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textFont,
    this.radius,
    this.buttonImage = "",
  });

  // Creates a button with only text
  Widget buttonWithText(context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // textStyle: textFont ?? AppFonts.textSemiBold16,
        backgroundColor: backgroundColor ?? AppColors.buttonBgColor,
        foregroundColor: backgroundColor == AppColors.buttonBgColor
            ? Colors.white
            : AppColors.buttonBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius ?? 10),
            // Set custom radius here
          ),
          side: const BorderSide(
            color:  Colors.transparent,
            width: 1,
          ), // Border color and width
        ),
      ),
      child: Text(text, style: textFont ?? AppFonts.textButtonStyle),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      width: double.infinity,
      child: buttonWithText(context),
    );
  }
}