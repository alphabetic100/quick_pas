import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_snackbar.dart';
import 'package:quick_pass/src/app/core/common/widgets/loading_widget.dart';
import 'package:quick_pass/src/app/features/home/providers/home_provider.dart';
import 'package:quick_pass/src/app/service/connectivity_service.dart';
import 'package:quick_pass/src/app/service/sync_service.dart';

class AddPasswordController {
  AddPasswordController(this.ref);
  final Ref ref;
  final name = TextEditingController();
  final url = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  final SyncService _syncService = SyncService.instance;
  final ConnectivityService _connectivity = ConnectivityService.instance;

  Future<bool> addPaasord({required BuildContext context}) async {
    try {
      if (!_connectivity.isConnected) {
        CustomSnackbar.showError(
          message: "You need internet connection to add new passwords",
        );
        return false;
      }

      LoadingWidget.showLoading(context);
      final success = await _syncService.addPassword(
        name: name.text,
        url: url.text,
        email: email.text,
        password: password.text,
      );
      
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);

      if (success) {
        CustomSnackbar.showSuccess(
          message: "Password has been stored successfully",
        );
        // Refresh the home provider to show the new password
        ref.read(allPasswordProvider.notifier).refreshPasswords();
        
        // ignore: use_build_context_synchronously
        context.pop();
        clearControllers();
        return true;
      } else {
        CustomSnackbar.showError(
          message: "Failed to add password. Please try again.",
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      log(error.toString());
      CustomSnackbar.showError(
        message: "Something went wrong, please try again.",
      );
    }
    return false;
  }

  void dispose() {
    name.dispose();
    url.dispose();
    email.dispose();
    password.dispose();
  }

  void clearControllers() {
    name.clear();
    url.clear();
    email.clear();
    password.clear();
  }
}

final addPassControlers = Provider.autoDispose((ref) {
  final controller = AddPasswordController(ref);
  ref.onDispose(controller.dispose);
  return controller;
});
