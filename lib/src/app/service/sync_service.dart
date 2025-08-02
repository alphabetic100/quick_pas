import 'dart:developer';
import 'package:quick_pass/src/app/core/constants/database/superbase_const.dart';
import 'package:quick_pass/src/app/features/home/data/home_pass_data_mode.dart';
import 'package:quick_pass/src/app/service/connectivity_service.dart';
import 'package:quick_pass/src/app/service/local_database_service.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SyncService {
  static final SyncService instance = SyncService._internal();
  final LocalDatabaseService _localDB = LocalDatabaseService.instance;
  final ConnectivityService _connectivity = ConnectivityService.instance;
  final supabase = Supabase.instance.client;

  factory SyncService() {
    return instance;
  }

  SyncService._internal();

  Future<List<PasswordModel>> getPasswords() async {
    if (_connectivity.isConnected && SecureStorageService.instance.hasToken) {
      try {
        log('Fetching passwords from remote server');
        final userId = SecureStorageService.instance.userId;
        final response = await supabase
            .from(SupabaseConst.passwordCollection)
            .select()
            .eq("user_id", userId);

        final passwords = PasswordModel.fromJsonList(response);
        
        await _savePasswordsLocally(passwords);
        
        log('Successfully synced ${passwords.length} passwords from remote');
        return passwords;
      } catch (error) {
        log('Failed to fetch from remote, loading from local: $error');
        return await _loadPasswordsLocally();
      }
    } else {
      log('Offline mode: Loading passwords from local storage');
      return await _loadPasswordsLocally();
    }
  }

  Future<void> _savePasswordsLocally(List<PasswordModel> passwords) async {
    try {
      final userId = SecureStorageService.instance.userId;
      await _localDB.clearPasswordsForUser(userId);
      for (var password in passwords) {
        await _localDB.insertPassword(password);
      }
      log('Saved ${passwords.length} passwords to local storage for user $userId');
    } catch (error) {
      log('Error saving passwords locally: $error');
    }
  }

  Future<List<PasswordModel>> _loadPasswordsLocally() async {
    try {
      final userId = SecureStorageService.instance.userId;
      if (userId.isEmpty) {
        log('No user ID found, returning empty list');
        return [];
      }
      final passwords = await _localDB.fetchPasswordsForUser(userId);
      log('Loaded ${passwords.length} passwords from local storage for user $userId');
      return passwords;
    } catch (error) {
      log('Error loading passwords from local storage: $error');
      return [];
    }
  }

  Future<bool> addPassword({
    required String name,
    required String url,
    required String email,
    required String password,
  }) async {
    try {
      if (_connectivity.isConnected && SecureStorageService.instance.hasToken) {
        log('Adding password to remote server');
        await supabase.from(SupabaseConst.passwordCollection).insert({
          'user_id': SecureStorageService.instance.userId,
          'name': name,
          'url': url,
          'email': email,
          'password': password,
        });
        
        await syncPasswords();
        log('Password added to remote server and synced locally');
        return true;
      } else {
        log('Offline mode: Cannot add password without internet connection');
        return false;
      }
    } catch (error) {
      log('Error adding password: $error');
      return false;
    }
  }

  Future<bool> updatePassword({
    required int id,
    required String name,
    required String url,
    required String email,
    required String password,
  }) async {
    try {
      if (_connectivity.isConnected && SecureStorageService.instance.hasToken) {
        log('Updating password on remote server');
        await supabase
            .from(SupabaseConst.passwordCollection)
            .update({
              'name': name,
              'url': url,
              'email': email,
              'password': password,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', id);
        
        await syncPasswords();
        log('Password updated on remote server and synced locally');
        return true;
      } else {
        log('Offline mode: Cannot update password without internet connection');
        return false;
      }
    } catch (error) {
      log('Error updating password: $error');
      return false;
    }
  }

  Future<bool> deletePassword(int id) async {
    try {
      if (_connectivity.isConnected && SecureStorageService.instance.hasToken) {
        log('Deleting password from remote server');
        await supabase
            .from(SupabaseConst.passwordCollection)
            .delete()
            .eq('id', id);
        
        await syncPasswords();
        log('Password deleted from remote server and synced locally');
        return true;
      } else {
        log('Offline mode: Cannot delete password without internet connection');
        return false;
      }
    } catch (error) {
      log('Error deleting password: $error');
      return false;
    }
  }

  Future<void> syncPasswords() async {
    if (_connectivity.isConnected && SecureStorageService.instance.hasToken) {
      await getPasswords();
    }
  }

  Future<void> clearLocalData() async {
    try {
      final userId = SecureStorageService.instance.userId;
      if (userId.isNotEmpty) {
        await _localDB.clearPasswordsForUser(userId);
        log('Local data cleared for user $userId');
      } else {
        await _localDB.clearPasswords();
        log('All local data cleared');
      }
    } catch (error) {
      log('Error clearing local data: $error');
    }
  }
}
