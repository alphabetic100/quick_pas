import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomSnackbar {
  static void showSuccess({
    required String message,
    Toast length = Toast.LENGTH_SHORT
  }) {
    _showToast(
      message: message,
      backgroundColor: Color(0xFF10B981),
      length: length,
    );
  }

  static void showError({
    required String message,
    Toast length = Toast.LENGTH_SHORT
  }) {
    _showToast(
      message: message,
      backgroundColor: Colors.red,
      length: length,
    );
  }

  static void _showToast({
    required String message,
    required Color backgroundColor,
    required Toast length,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: ToastGravity.TOP,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
