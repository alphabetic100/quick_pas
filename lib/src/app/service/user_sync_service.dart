import 'dart:developer';
import 'dart:typed_data';
import 'package:quick_pass/src/app/core/constants/database/superbase_const.dart';
import 'package:quick_pass/src/app/features/profile/data/user_data.dart';
import 'package:quick_pass/src/app/service/connectivity_service.dart';
import 'package:quick_pass/src/app/service/local_user_service.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserSyncService {
  static final UserSyncService instance = UserSyncService._internal();
  final LocalUserService _localUserService = LocalUserService.instance;
  final ConnectivityService _connectivity = ConnectivityService.instance;
  final supabase = Supabase.instance.client;

  factory UserSyncService() {
    return instance;
  }

  UserSyncService._internal();

  Future<UserData?> getUserProfile() async {
    final userId = SecureStorageService.instance.userId;
    if (userId.isEmpty) {
      log('No user ID found');
      return null;
    }

    if (_connectivity.isConnected && SecureStorageService.instance.hasToken) {
      try {
        log('Fetching user profile from remote server');
        final response = await supabase
            .from(SupabaseConst.userCollection)
            .select()
            .eq("user_id", userId)
            .maybeSingle();

        if (response != null) {
          final userData = UserData.fromJson(response);
          await _saveUserLocally(userData);
          log('Successfully synced user profile from remote');
          return userData;
        } else {
          log('No user data found on remote, loading from local');
          return await _loadUserLocally(userId);
        }
      } catch (error) {
        log('Failed to fetch user from remote, loading from local: $error');
        return await _loadUserLocally(userId);
      }
    } else {
      log('Offline mode: Loading user profile from local storage');
      return await _loadUserLocally(userId);
    }
  }

  Future<void> _saveUserLocally(UserData userData) async {
    try {
      await _localUserService.insertUser(userData);
      log('Saved user profile to local storage for user ${userData.userId}');
    } catch (error) {
      log('Error saving user profile locally: $error');
    }
  }

  Future<UserData?> _loadUserLocally(String userId) async {
    try {
      final userData = await _localUserService.getUserByUserId(userId);
      if (userData != null) {
        log('Loaded user profile from local storage for user $userId');
      } else {
        log('No local user profile found for user $userId');
      }
      return userData;
    } catch (error) {
      log('Error loading user profile from local storage: $error');
      return null;
    }
  }

  Future<bool> updateUserProfile({
    required String fullName,
    String? profileImageUrl,
    Uint8List? imageBytes,
  }) async {
    final userId = SecureStorageService.instance.userId;
    if (userId.isEmpty) {
      log('No user ID found');
      return false;
    }

    try {
      if (_connectivity.isConnected && SecureStorageService.instance.hasToken) {
        log('Updating user profile on remote server');
        
        String imageUrl = profileImageUrl ?? '';
        
        if (imageBytes != null) {
          final imagePath = "$userId/profile_${DateTime.now().millisecondsSinceEpoch}";
          await supabase.storage
              .from(SupabaseConst.avater)
              .uploadBinary(imagePath, imageBytes);
          
          imageUrl = supabase.storage
              .from(SupabaseConst.avater)
              .getPublicUrl(imagePath);
        }

        await supabase
            .from(SupabaseConst.userCollection)
            .update({
              "fullName": fullName,
              "profileImage": imageUrl,
              "updatedAt": DateTime.now().toIso8601String(),
            })
            .eq("user_id", userId);

        await syncUserProfile();
        log('User profile updated on remote server and synced locally');
        return true;
      } else {
        log('Offline mode: Cannot update profile without internet connection');
        return false;
      }
    } catch (error) {
      log('Error updating user profile: $error');
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      if (_connectivity.isConnected && SecureStorageService.instance.hasToken) {
        log('Changing password on remote server');
        
        await supabase.auth.updateUser(
          UserAttributes(password: newPassword),
        );

        await supabase
            .from(SupabaseConst.userCollection)
            .update({
              "password": newPassword,
              "updatedAt": DateTime.now().toIso8601String(),
            })
            .eq("user_id", SecureStorageService.instance.userId);

        await syncUserProfile();
        log('Password changed on remote server and synced locally');
        return true;
      } else {
        log('Offline mode: Cannot change password without internet connection');
        return false;
      }
    } catch (error) {
      log('Error changing password: $error');
      return false;
    }
  }

  Future<void> syncUserProfile() async {
    if (_connectivity.isConnected && SecureStorageService.instance.hasToken) {
      await getUserProfile();
    }
  }

  Future<void> clearLocalUserData() async {
    try {
      final userId = SecureStorageService.instance.userId;
      if (userId.isNotEmpty) {
        await _localUserService.deleteUser(userId);
        log('Local user data cleared for user $userId');
      } else {
        await _localUserService.clearAllUsers();
        log('All local user data cleared');
      }
    } catch (error) {
      log('Error clearing local user data: $error');
    }
  }
}
