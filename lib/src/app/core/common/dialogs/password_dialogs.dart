import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/common/widgets/delete_confirmation_dialog.dart';
import 'package:quick_pass/src/app/features/details&upgrade/controller/update_pass_controller.dart';
import 'package:quick_pass/src/app/features/home/data/home_pass_data_mode.dart';

class PasswordDialogs {
  /// Show delete confirmation dialog for a password
  static Future<void> showDeleteConfirmation({
    required BuildContext context,
    required WidgetRef ref,
    required PasswordModel passwordData,
  }) {
    return DeleteConfirmationDialog.show(
      context: context,
      title: 'Delete Password',
      content: 'Are you sure you want to delete this password?',
      itemName: 'Password: ${passwordData.name}',
      onConfirm: () {
        ref.read(updateControllers).deletePass(
          context: context,
          password: passwordData,
          ref: ref,
        );
      },
    );
  }

  /// Show delete confirmation dialog for multiple passwords
  static Future<void> showBulkDeleteConfirmation({
    required BuildContext context,
    required VoidCallback onConfirm,
    required int count,
  }) {
    return DeleteConfirmationDialog.show(
      context: context,
      title: 'Delete Multiple Passwords',
      content: 'Are you sure you want to delete these passwords?',
      itemName: '$count passwords selected',
      onConfirm: onConfirm,
      confirmButtonText: 'Delete All',
    );
  }
}
