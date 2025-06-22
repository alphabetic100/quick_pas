import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  // Private constructor
  SecureStorageService._();

  // Singleton instance
  static final SecureStorageService instance = SecureStorageService._();

  static const String _tokenKey = "accessToken";

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  String _token = "";

  Future<void> init() async {
    try {
      log("[SecureStorageService] Initializing...");
      _token = await _storage.read(key: _tokenKey) ?? "";
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

  Future<void> clearToken() async {
    try {
      await _storage.delete(key: _tokenKey);
      _token = '';
      log("[SecureStorageService] Token cleared");
    } catch (error, stack) {
      log("Error clearing token", error: error, stackTrace: stack);
    }
  }

  String get accessToken => _token;

  bool get hasToken => _token.isNotEmpty;
}
