import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/res/app_colors.dart';
import 'package:mofa/res/app_fonts.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final TextStyle? textFont;
  final IconData? iconData;
  final double? radius;
  final double? height;
  final bool isLoading;
  final EdgeInsets? padding;
  final Color? borderColor;
  final bool smallWidth;

  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textFont,
    this.radius,
    this.height,
    this.iconData,
    this.padding,
    this.borderColor,
    this.isLoading = false,
    this.smallWidth = false,
  });

  // Creates a button with only text
  Widget buttonWithText(context) {
    return ElevatedButton(
      onPressed: onPressed ?? () {},
      style: ElevatedButton.styleFrom(
        // textStyle: textFont ?? AppFonts.textSemiBold16,
        backgroundColor: onPressed == null ? AppColors.buttonBgColor.withOpacity(0.5) : backgroundColor ?? AppColors.buttonBgColor,
        foregroundColor: onPressed == null ? AppColors.buttonBgColor.withOpacity(0.5) :backgroundColor == AppColors.buttonBgColor
            ? Colors.white
            : AppColors.buttonBgColor,
        padding: padding ?? null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius ?? 10),
            // Set custom radius here
          ),
          side: BorderSide(
            color:  borderColor ?? Colors.transparent,
            width: 1,
          ), // Border color and width
        ),
      ),
      child: isLoading ? const CircularProgressIndicator(color: Colors.white,) : Text(text, style: textFont ?? AppFonts.textButtonStyle),
    );
  }

  // Creates a button with only text
  Widget buttonWithIcon(context) {
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
      child: isLoading ? const CircularProgressIndicator(color: Colors.white,) : Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text, style: textFont ?? AppFonts.textButtonStyle),
          3.horizontalSpace,
          Icon(iconData ?? LucideIcons.arrowRight, size: 25, color: AppColors.whiteColor,),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? 52,
      width: smallWidth ? null : double.infinity,
      child: iconData != null ? buttonWithIcon(context) : buttonWithText(context),
    );
  }
}

class CustomUploadButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final TextStyle? textFont;
  final IconData? buttonIcon;
  final double? radius;

  const CustomUploadButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textFont,
    this.radius,
    this.buttonIcon,
  });

  // Creates a button with only text
  Widget button(context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 12),
        backgroundColor: backgroundColor ?? AppColors.whiteColor,
        foregroundColor: backgroundColor == AppColors.buttonBgColor
            ? Colors.white
            : AppColors.buttonBgColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(radius ?? 50),
            // Set custom radius here
          ),
          side: const BorderSide(
            color:  AppColors.buttonBgColor,
            width: 1,
          ), // Border color and width
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(buttonIcon ?? LucideIcons.paperclip, color: AppColors.primaryColor,),
          5.horizontalSpace,
          Text(text, style: textFont ?? AppFonts.textRegular14),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return button(context);
  }
}