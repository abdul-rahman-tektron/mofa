import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:mofa/res/app_colors.dart';

class PasswordStrengthStars extends StatelessWidget {
  final String password;

  const PasswordStrengthStars({super.key, required this.password});

  bool get hasMinLength => password.length >= 8;
  bool get hasUppercase => password.contains(RegExp(r'[A-Z]'));
  bool get hasLowercase => password.contains(RegExp(r'[a-z]'));
  bool get hasSpecialChar => password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  bool get hasNumber => password.contains(RegExp(r'[0-9]'));

  @override
  Widget build(BuildContext context) {
    final conditions = [
      hasMinLength,
      hasUppercase,
      hasLowercase,
      hasSpecialChar,
      hasNumber,
    ];

    int passedCount = conditions.where((c) => c).length;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          Icons.star,
          size: 20,
          color: index < passedCount ? AppColors.buttonBgColor : Colors.grey.shade300,
        );
      }),
    );
  }
}
