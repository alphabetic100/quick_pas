import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/core/utils/password_analyzer.dart';
import 'package:quick_pass/src/app/features/home/data/home_pass_data_mode.dart';
import 'package:quick_pass/src/app/service/connectivity_service.dart';
import 'package:quick_pass/src/app/service/sync_service.dart';
import 'package:quick_pass/src/app/service/data_recovery_service.dart';

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
  final DataRecoveryService _recoveryService = DataRecoveryService.instance;

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
      
      // First, try normal decryption
      try {
        final decryptedPasswords = await PasswordModel.decryptList(encryptedPasswords);
        log('Decrypted ${decryptedPasswords.length} passwords for display');
        
        state = state.copyWith(
          passwords: decryptedPasswords,
          isLoading: false,
          isOffline: !_connectivity.isConnected,
        );
        return;
      } catch (decryptionError) {
        log('Decryption failed, attempting recovery: $decryptionError');
        
        // If decryption fails, use emergency recovery
        final recoveredPasswords = await _recoveryService.recoverCorruptedData(encryptedPasswords);
        
        state = state.copyWith(
          passwords: recoveredPasswords,
          isLoading: false,
          error: 'Some encrypted data was corrupted and recovered. Please update affected passwords.',
          isOffline: !_connectivity.isConnected,
        );
        return;
      }
    } catch (error) {
      log('Error loading passwords: $error');
      
      // Final fallback - try to load passwords directly from database without decryption
      try {
        log('Attempting final fallback - loading raw data...');
        final rawPasswords = await _syncService.getPasswords();
        final fallbackPasswords = rawPasswords.map((password) => PasswordModel(
          id: password.id,
          passId: password.passId,
          createdAt: password.createdAt,
          updatedAt: password.updatedAt,
          userId: password.userId,
          name: password.name,
          url: password.url,
          password: password.password.isNotEmpty ? password.password : '[Encrypted - Please Update]',
          email: password.email.isNotEmpty ? password.email : '[Encrypted - Please Update]',
          encryptedPassword: null,
          encryptedEmail: null,
        )).toList();
        
        state = state.copyWith(
          passwords: fallbackPasswords,
          isLoading: false,
          error: 'Encryption error detected. Data recovered in safe mode. Please update your passwords.',
          isOffline: !_connectivity.isConnected,
        );
      } catch (fallbackError) {
        log('All recovery attempts failed: $fallbackError');
        state = state.copyWith(
          passwords: [],
          isLoading: false,
          error: 'Unable to load passwords. Please contact support.',
          isOffline: !_connectivity.isConnected,
        );
      }
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

