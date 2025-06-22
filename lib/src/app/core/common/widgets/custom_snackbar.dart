import 'package:flutter/material.dart';

class CustomToast {
  static void showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      context,
      title: title,
      message: message,
      backgroundColor: Color(0xFF10B981),
      duration: duration,
    );
  }

  static void showError(
    BuildContext context, {
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showToast(
      context,
      title: title,
      message: message,
      backgroundColor: Colors.black,
      duration: duration,
    );
  }

  static void _showToast(
    BuildContext context, {
    required String title,
    required String message,
    required Color backgroundColor,
    required Duration duration,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ],
          ),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.symmetric(vertical: 16),
        //  / shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: duration,
      ),
    );
  }
}
