import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:quick_pass/src/app/service/sync_service.dart';
import 'package:quick_pass/src/app/service/user_sync_service.dart';
import 'package:quick_pass/src/app/service/image_cache_service.dart';

class SecureStorageService {
  // Private constructor
  SecureStorageService._();

  // Singleton instance
  static final SecureStorageService instance = SecureStorageService._();

  static const String _tokenKey = "accessToken";

  static const String _userIdKey = "userId";

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String _token = "";
  String _userId = "";

  Future<void> init() async {
    try {
      log("[SecureStorageService] Initializing...");
      _token = await _storage.read(key: _tokenKey) ?? "";
      _userId = await _storage.read(key: _userIdKey) ?? "";
      log("[SecureStorageService] Token loaded: $_token");
    } catch (error, stack) {
      log("Error initializing secure storage", error: error, stackTrace: stack);
    }
  }

  Future<void> saveToken({required String token}) async {
    try {
      await _storage.write(key: _tokenKey, value: token);
      _token = token;
      log("[SecureStorageService] Token saved: $token");
    } catch (error, stack) {
      log("Error saving token", error: error, stackTrace: stack);
    }
  }

  Future<void> saveUserId({required String userId}) async {
    try {
      await _storage.write(key: _userIdKey, value: userId);
      _userId = userId;
      log("[SecureStorageService] Token saved: $userId");
    } catch (error, stack) {
      log("Error saving token", error: error, stackTrace: stack);
    }
  }

  Future<void> clearToken() async {
    try {
      await _storage.delete(key: _tokenKey);
      await _storage.delete(key: _userIdKey);

      _token = '';
      _userId = "";
      
      await SyncService.instance.clearLocalData();
      await UserSyncService.instance.clearLocalUserData();
      await ImageCacheService.instance.clearAllCachedImages();
      log("[SecureStorageService] Token, local data, and cached images cleared");
    } catch (error, stack) {
      log("Error clearing token", error: error, stackTrace: stack);
    }
  }

  String get accessToken => _token;
  String get userId => _userId;

  bool get hasToken => _token.isNotEmpty;
}
