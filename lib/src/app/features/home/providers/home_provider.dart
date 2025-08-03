import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/utils/password_analyzer.dart';
import 'package:quick_pass/src/app/features/home/data/home_pass_data_mode.dart';
import 'package:quick_pass/src/app/service/connectivity_service.dart';
import 'package:quick_pass/src/app/service/sync_service.dart';

// State class for password management
class PasswordState {
  final List<PasswordModel> passwords;
  final bool isLoading;
  final String? error;
  final TextEditingController search;
  final bool isOffline;

  PasswordState({
    required this.passwords,
    required this.isLoading,
    this.error,
    TextEditingController? search,
    this.isOffline = false,
  }): search = search?? TextEditingController();

  PasswordState copyWith({
    List<PasswordModel>? passwords,
    bool? isLoading,
    String? error,
    bool? isOffline,
  }) {
    return PasswordState(
      passwords: passwords ?? this.passwords,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isOffline: isOffline ?? this.isOffline,
    );
  }

  /// Gets the count of compromised (weak) passwords
  int get compromisedPasswordCount {
    if (passwords.isEmpty) return 0;
    return passwords
        .where((password) => PasswordAnalyzer.isPasswordCompromised(password.password))
        .length;
  }
}

class PasswordNotifier extends StateNotifier<PasswordState> {
  PasswordNotifier() : super( PasswordState(passwords: [], isLoading: true)) {
    loadPasswords();
    _listenToConnectivity();
  }

  final SyncService _syncService = SyncService.instance;
  final ConnectivityService _connectivity = ConnectivityService.instance;

  void _listenToConnectivity() {
    _connectivity.connectionStream.listen((isConnected) {
      if (isConnected && !state.isLoading) {
        log('Connection restored, syncing passwords');
        syncPasswords();
      }
      state = state.copyWith(isOffline: !isConnected);
    });
  }

  Future<void> loadPasswords() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final encryptedPasswords = await _syncService.getPasswords();
      log('Loaded ${encryptedPasswords.length} encrypted passwords');
      
      // Decrypt passwords for display
      final decryptedPasswords = await PasswordModel.decryptList(encryptedPasswords);
      log('Decrypted ${decryptedPasswords.length} passwords for display');
      
      state = state.copyWith(
        passwords: decryptedPasswords,
        isLoading: false,
        isOffline: !_connectivity.isConnected,
      );
    } catch (error) {
      log('Error loading passwords: $error');
      state = state.copyWith(
        passwords: [],
        isLoading: false,
        error: error.toString(),
        isOffline: !_connectivity.isConnected,
      );
    }
  }

  Future<void> refreshPasswords() async {
    await loadPasswords();
  }

  Future<void> syncPasswords() async {
    try {
      await _syncService.syncPasswords();
      await loadPasswords();
    } catch (error) {
      log('Error syncing passwords: $error');
    }
  }

}

// Provider for the password state notifier
final allPasswordProvider = StateNotifierProvider<PasswordNotifier, PasswordState>((ref) {
  return PasswordNotifier();
});

