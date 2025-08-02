import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_snackbar.dart';
import 'package:quick_pass/src/app/core/common/widgets/loading_widget.dart';
import 'package:quick_pass/src/app/features/profile/providers/offline_profile_provider.dart';
import 'package:quick_pass/src/app/service/connectivity_service.dart';
import 'package:quick_pass/src/app/service/user_sync_service.dart';

class ChangePassController {
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  final UserSyncService _userSyncService = UserSyncService.instance;
  final ConnectivityService _connectivity = ConnectivityService.instance;

  Future<void> changePassword({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      if (!_connectivity.isConnected) {
        CustomToast.showError(
          context,
          title: 'Offline Mode',
          message: "You need internet connection to change your password",
        );
        return;
      }

      LoadingWidget.showLoading(context);

      final success = await _userSyncService.changePassword(
        currentPassword: currentPassword.text.trim(),
        newPassword: confirmPassword.text.trim(),
      );

      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);

      if (success) {
        CustomToast.showSuccess(
          // ignore: use_build_context_synchronously
          context,
          title: "Success!",
          message: "Password changed successfully",
        );
        ref.read(offlineProfileProvider.notifier).refreshProfile();
        // ignore: use_build_context_synchronously
        context.pop();
      } else {
        CustomToast.showError(
          // ignore: use_build_context_synchronously
          context,
          title: "Failed!",
          message: "Failed to change password. Please check your credentials.",
        );
      }
    } catch (error, stackTrace) {
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      CustomToast.showError(
        // ignore: use_build_context_synchronously
        context,
        title: "Error!",
        message: "Something went wrong. Please try again.",
      );
      log(error.toString() + stackTrace.toString());
    }
  }

  bool validateConfirmPassword() => newPassword.text == confirmPassword.text;

  void dispose() {
    currentPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
  }
}

final changePassController = Provider.autoDispose((ref) {
  final controllers = ChangePassController();
  ref.onDispose(controllers.dispose);
  return controllers;
});
