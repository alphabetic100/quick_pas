import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/constants/database/superbase_const.dart';
import 'package:quick_pass/src/app/quick_pass_app.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: SupabaseConst.supabaseUrl,
    anonKey: SupabaseConst.supabaseAnonKey,
  );
  await SecureStorageService.instance.init();
  runApp(ProviderScope(child: QuickPassApp()));
}
