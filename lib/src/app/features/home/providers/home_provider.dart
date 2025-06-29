import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/constants/database/superbase_const.dart';
import 'package:quick_pass/src/app/features/home/data/home_pass_data_mode.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final allPasswordPrivider = FutureProvider((ref) async {
  final supabase = Supabase.instance.client;
  log("called");
  try {
    List<PasswordModel> passwords = [];
    final response = await supabase
        .from(SupabaseConst.passwordCollection)
        .select()
        .eq("user_id", SecureStorageService.instance.userId);
    if (response.isNotEmpty) {
      log(response.toString());
      passwords = PasswordModel.fromJsonList(response);
    }
    return passwords;
  } catch (error) {
    log(error.toString());
  }
});
