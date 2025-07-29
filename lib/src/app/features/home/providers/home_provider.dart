import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/constants/database/superbase_const.dart';
import 'package:quick_pass/src/app/features/home/data/home_pass_data_mode.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// State class for password management
class PasswordState {
  final List<PasswordModel> passwords;
  final bool isLoading;
  final String? error;
  final TextEditingController search;

  PasswordState({
    required this.passwords,
    required this.isLoading,
    this.error,
    TextEditingController? search,
  }): search = search?? TextEditingController();

  PasswordState copyWith({
    List<PasswordModel>? passwords,
    bool? isLoading,
    String? error,
  }) {
    return PasswordState(
      passwords: passwords ?? this.passwords,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class PasswordNotifier extends StateNotifier<PasswordState> {
  PasswordNotifier() : super( PasswordState(passwords: [], isLoading: true)) {
    loadPasswords();
  }

  final supabase = Supabase.instance.client;

  Future<void> loadPasswords() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userId = SecureStorageService.instance.userId;
      final response = await supabase
          .from(SupabaseConst.passwordCollection)
          .select()
          .eq("user_id", userId);

      final passwords = PasswordModel.fromJsonList(response);
      log('Fetched ${passwords.length} passwords');
      state = state.copyWith(passwords: passwords, isLoading: false);
    } catch (error) {
      log('Error fetching passwords: $error');
      state = state.copyWith(
        passwords: [],
        isLoading: false,
        error: error.toString(),
      );
    }
  }

  Future<void> refreshPasswords() async {
    await loadPasswords();
  }

}

// Provider for the password state notifier
final allPasswordProvider = StateNotifierProvider<PasswordNotifier, PasswordState>((ref) {
  return PasswordNotifier();
});

