import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  static void showError(String message) {
    print("Error called");
    _show(
      message,
      type: ToastificationType.error,
      icon: LucideIcons.xCircle,
    );
  }

  static void showSuccess(String message) {
    _show(
      message,
      type: ToastificationType.success,
      icon: LucideIcons.checkCircle,
    );
  }

  static void show(
      String message, {
        ToastificationType type = ToastificationType.info,
        IconData icon = Icons.info,
        Color? backgroundColor,
      }) {
    _show(
      message,
      type: type,
      icon: icon,
      backgroundColor: backgroundColor,
    );
  }

  static void _show(
      String message, {
        required ToastificationType type,
        required IconData icon,
        Color? backgroundColor,
      }) {
    toastification.show(
      type: type,
      style: ToastificationStyle.flat,
      title: Text(message),
      autoCloseDuration: const Duration(milliseconds: 2500),
      alignment: Alignment.topRight,
      icon: Icon(icon, color: backgroundColor),
      backgroundColor: backgroundColor,
      borderRadius: BorderRadius.circular(8),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      showProgressBar: true,
    );
  }
}
