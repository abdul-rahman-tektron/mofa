import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  static void showError(String message) {
    _showToast(message, backgroundColor: Colors.red);
  }

  static void showSuccess(String message) {
    _showToast(message, backgroundColor: Colors.green);
  }

  static void show(String message, {Color backgroundColor = Colors.black}) {
    _showToast(message, backgroundColor: backgroundColor);
  }

  static void _showToast(String message, {required Color backgroundColor}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
