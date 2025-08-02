import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_snackbar.dart';
import 'package:quick_pass/src/app/core/common/widgets/loading_widget.dart';
import 'package:quick_pass/src/app/features/home/data/home_pass_data_mode.dart';
import 'package:quick_pass/src/app/features/home/providers/home_provider.dart';
import 'package:quick_pass/src/app/service/connectivity_service.dart';
import 'package:quick_pass/src/app/service/sync_service.dart';

class UpdatePassController {
  final nameTEController = TextEditingController();
  final urlTEController = TextEditingController();
  final emailTEController = TextEditingController();
  final passwordTEController = TextEditingController();
  String createdAtValue = "";
  int passwordID = 0;
  final SyncService _syncService = SyncService.instance;
  final ConnectivityService _connectivity = ConnectivityService.instance;

  void assignValue({required PasswordModel password}) {
    passwordID = password.id;
    nameTEController.text = password.name;
    urlTEController.text = password.url;
    emailTEController.text = password.email;
    passwordTEController.text = password.password;
    createdAtValue = password.createdAt;
  }

  void dispose() {
    nameTEController.dispose();
    urlTEController.dispose();
    emailTEController.dispose();
    passwordTEController.dispose();
    passwordID = 0;
  }

  Future<void> updatePassword({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      if (passwordID == 0) {
        return;
      }
      
      if (!_connectivity.isConnected) {
        CustomToast.showError(
          context,
          title: 'Offline Mode',
          message: "You need internet connection to update passwords",
        );
        return;
      }
      
      LoadingWidget.showLoading(context);
      final success = await _syncService.updatePassword(
        id: passwordID,
        name: nameTEController.text.trim(),
        url: urlTEController.text.trim(),
        email: emailTEController.text.trim(),
        password: passwordTEController.text.trim(),
      );
      
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      
      if (success) {
        CustomToast.showSuccess(
          // ignore: use_build_context_synchronously
          context,
          title: 'Success',
          message: "Password updated successfully",
        );
        ref.read(allPasswordProvider.notifier).refreshPasswords();
        // ignore: use_build_context_synchronously
        context.pop();
      } else {
        CustomToast.showError(
          // ignore: use_build_context_synchronously
          context,
          title: 'Failed!',
          message: "Failed to update password. Please try again.",
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      log(error.toString());
      CustomToast.showError(
        // ignore: use_build_context_synchronously
        context,
        title: 'Error',
        message: "Something went wrong. Please try again.",
      );
    }
  }

  Future<void> deletePass({
    required BuildContext context,
    required PasswordModel password,
    required WidgetRef ref,
  }) async {
    try {
      if (!_connectivity.isConnected) {
        CustomToast.showError(
          context,
          title: 'Offline Mode',
          message: "You need internet connection to delete passwords",
        );
        return;
      }
      
      LoadingWidget.showLoading(context);
      final success = await _syncService.deletePassword(password.id);
      
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      
      if (success) {
        CustomToast.showSuccess(
          // ignore: use_build_context_synchronously
          context,
          title: 'Success',
          message: "Password deleted successfully",
        );
        ref.read(allPasswordProvider.notifier).refreshPasswords();
        // ignore: use_build_context_synchronously
        context.pop();
      } else {
        CustomToast.showError(
          // ignore: use_build_context_synchronously
          context,
          title: 'Failed!',
          message: "Failed to delete password. Please try again.",
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      log(error.toString());
      CustomToast.showError(
        // ignore: use_build_context_synchronously
        context,
        title: 'Error',
        message: "Something went wrong. Please try again.",
      );
    }
  }
}

final updateControllers = Provider.autoDispose((ref) {
  final controllers = UpdatePassController();
  ref.onDispose(controllers.dispose);
  return controllers;
});
