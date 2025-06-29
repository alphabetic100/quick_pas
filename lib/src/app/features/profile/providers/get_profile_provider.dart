// providers/get_profile_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/constants/database/superbase_const.dart';
import 'package:quick_pass/src/app/features/profile/data/user_data.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final getProfile = StreamProvider<UserData?>((ref) {
  final SupabaseClient supabase = Supabase.instance.client;

  final userId = SecureStorageService.instance.userId;
  return supabase
      .from(SupabaseConst.userCollection)
      .stream(primaryKey: ['id'])
      .eq("user_id", userId)
      .map((event) {
        if (event.isNotEmpty) {
          return UserData.fromJson(event.first);
        }
        return null;
      });
});
