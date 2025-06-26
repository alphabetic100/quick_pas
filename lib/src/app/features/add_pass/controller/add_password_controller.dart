import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_snackbar.dart';
import 'package:quick_pass/src/app/core/common/widgets/loading_widget.dart';
import 'package:quick_pass/src/app/core/constants/database/superbase_const.dart';
import 'package:quick_pass/src/app/features/add_pass/data/add_pass_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddPasswordController {
  AddPasswordController();
  final name = TextEditingController();
  final url = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  // Supabase Client
  final supabase = Supabase.instance.client;

  Future<bool> addPaasord({required BuildContext context}) async {
    try {
      LoadingWidget.showLoading(context);
      await supabase
          .from(SupabaseConst.passwordCollection)
          .insert(
            AddPassModel.toJson(
              name: name.text,
              url: url.text,
              email: email.text,
              password: password.text,
            ),
          );
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);

      CustomToast.showSuccess(
        // ignore: use_build_context_synchronously
        context,
        title: 'Successfully created',
        message: "Password has been stored successfully",
      );
      // ignore: use_build_context_synchronously
      context.pop();
      clearControllers();
    } on PlatformException catch (error) {
      log(error.toString());
      CustomToast.showSuccess(
        // ignore: use_build_context_synchronously
        context,
        title: 'Failed!',
        message: error.message ?? "Something went wrong, please try again.",
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
  final controller = AddPasswordController();
  ref.onDispose(controller.dispose);
  return controller;
});
