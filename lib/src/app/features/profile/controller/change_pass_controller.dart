import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_snackbar.dart';
import 'package:quick_pass/src/app/core/common/widgets/loading_widget.dart';
import 'package:quick_pass/src/app/core/constants/database/superbase_const.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePassController {
  final currentPassword = TextEditingController();
  final newPassword = TextEditingController();
  final confirmPassword = TextEditingController();

  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> changePassword({required BuildContext context}) async {
    try {
      LoadingWidget.showLoading(context);
      final dbPass =
          await supabase
              .from(SupabaseConst.userCollection)
              .select('password')
              .eq("user_id", SecureStorageService.instance.userId)
              .single();

      log(dbPass.toString());
      log(currentPassword.text.trim());
      if (dbPass['password'] == currentPassword.text.trim()) {
        final result = await supabase.auth.updateUser(
          UserAttributes(password: confirmPassword.text.trim()),
        );
        if (result.user != null) {
          log("User updated");
          await supabase
              .from(SupabaseConst.userCollection)
              .update({
                "password": confirmPassword.text.trim(),
                "updatedAt": DateTime.now().toIso8601String(),
              })
              .eq("user_id", SecureStorageService.instance.userId);

          context.pop();
          CustomToast.showSuccess(
            context,
            title: "Success!",
            message: "Password Changed successfully",
          );
        }

        // ignore: use_build_context_synchronously
        LoadingWidget.hideLoading(context);
      } else {
        LoadingWidget.hideLoading(context);
        CustomToast.showError(
          // ignore: use_build_context_synchronously
          context,
          title: "Fatal!",
          message: "Current password is not currect!",
        );
      }
    } catch (error, stackTrace) {
      LoadingWidget.hideLoading(context);
      CustomToast.showError(
        // ignore: use_build_context_synchronously
        context,
        title: "Fatal!",
        message: "Current password is not currect!",
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
