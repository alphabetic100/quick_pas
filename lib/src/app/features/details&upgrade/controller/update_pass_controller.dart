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
  
  // Store original values to check for changes
  String _originalName = "";
  String _originalUrl = "";
  String _originalEmail = "";
  String _originalPassword = "";

  void assignValue({required PasswordModel password}) {
    passwordID = password.id;
    nameTEController.text = password.name;
    urlTEController.text = password.url;
    emailTEController.text = password.email;
    passwordTEController.text = password.password;
    createdAtValue = password.createdAt;
    
    // Store original values for change detection
    _originalName = password.name;
    _originalUrl = password.url;
    _originalEmail = password.email;
    _originalPassword = password.password;
  }

  void dispose() {
    nameTEController.dispose();
    urlTEController.dispose();
    emailTEController.dispose();
    passwordTEController.dispose();
    passwordID = 0;
    _originalName = "";
    _originalUrl = "";
    _originalEmail = "";
    _originalPassword = "";
  }
  
  // Check if any field has been changed
  bool _hasChanges() {
    return nameTEController.text.trim() != _originalName ||
           urlTEController.text.trim() != _originalUrl ||
           emailTEController.text.trim() != _originalEmail ||
           passwordTEController.text.trim() != _originalPassword;
  }

  Future<void> updatePassword({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      if (passwordID == 0) {
        return;
      }
      
      // Check if any changes were made
      if (!_hasChanges()) {
        // No changes detected, just go back
        context.pop();
        return;
      }
      
      if (!_connectivity.isConnected) {
        CustomSnackbar.showError(
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
        CustomSnackbar.showSuccess(
          message: "Password updated successfully",
        );
        ref.read(allPasswordProvider.notifier).refreshPasswords();
        // ignore: use_build_context_synchronously
        context.pop();
      } else {
        CustomSnackbar.showError(
          message: "Failed to update password. Please try again.",
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      log(error.toString());
      CustomSnackbar.showError(
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
        CustomSnackbar.showError(
          message: "You need internet connection to delete passwords",
        );
        return;
      }
      
      LoadingWidget.showLoading(context);
      final success = await _syncService.deletePassword(password.id);
      
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      
      if (success) {
        CustomSnackbar.showSuccess(
          message: "Password deleted successfully",
        );
        ref.read(allPasswordProvider.notifier).refreshPasswords();
        // ignore: use_build_context_synchronously
        context.pop();
      } else {
        CustomSnackbar.showError(
          message: "Failed to delete password. Please try again.",
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      log(error.toString());
      CustomSnackbar.showError(
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
