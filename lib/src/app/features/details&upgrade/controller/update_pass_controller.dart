import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/loading_widget.dart';
import 'package:quick_pass/src/app/core/constants/database/superbase_const.dart';
import 'package:quick_pass/src/app/features/details&upgrade/data/update_model.dart';
import 'package:quick_pass/src/app/features/home/data/home_pass_data_mode.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdatePassController {
  final nameTEController = TextEditingController();
  final urlTEController = TextEditingController();
  final emailTEController = TextEditingController();
  final passwordTEController = TextEditingController();
  String createdAtValue = "";
  String passwordID = "";
  final SupabaseClient supabase = Supabase.instance.client;

  void assignValue({required PasswordModel password}) {
    passwordID = password.passId;
    nameTEController.text = password.name;
    urlTEController.text = password.url;
    emailTEController.text = password.email;
    passwordTEController.text = password.email;
    createdAtValue = password.createdAt;
  }

  void dispose() {
    nameTEController.dispose();
    urlTEController.dispose();
    emailTEController.dispose();
    passwordTEController.dispose();
    createdAtValue = "";
  }

  Future<void> updatePassword({required BuildContext context}) async {
    try {
      if (passwordID.isEmpty) {
        return;
      }
      LoadingWidget.showLoading(context);
      await supabase
          .from(SupabaseConst.passwordCollection)
          .update(
            UpdateModel.toJson(
              passId: passwordID,
              name: nameTEController.text.trim(),
              url: urlTEController.text.trim(),
              email: emailTEController.text.trim(),
              password: passwordTEController.text.trim(),
              createdAt: createdAtValue,
            ),
          )
          .eq('pass_id', passwordID)
          .then((onValue) {
            context.pop();
          });
    } catch (error) {
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      log(error.toString());
    } finally {
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
    }
  }

  Future<void> deletePass({
    required BuildContext context,
    required PasswordModel password,
  }) async {
    try {
      LoadingWidget.showLoading(context);
      await supabase
          .from(SupabaseConst.passwordCollection)
          .delete()
          .eq("pass_id", password.passId)
          .then((onValue) {
            context.pop();
          });
    } catch (error) {
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      log(error.toString());
    } finally {
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
    }
  }
}

final updateControllers = Provider.autoDispose((ref) {
  final controllers = UpdatePassController();
  ref.onDispose(controllers.dispose);
  return controllers;
});
