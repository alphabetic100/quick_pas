import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ThemePreferance {
  ThemePreferance._();
  static ThemePreferance instance = ThemePreferance._();

  static const String _themeKey = "currentTheme";

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  bool _darkTheme = false;

  Future<void> init() async {
    try {
      log("[Theme preference] Initializing...");
      final themeValue = await _storage.read(key: _themeKey);
      _darkTheme =
          themeValue != null ? themeValue.toLowerCase() == 'true' : false;
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> saveThem({required bool theme}) async {
    try {
      await _storage.write(key: _themeKey, value: theme.toString());
      _darkTheme = theme.toString().toLowerCase() == "true";
    } catch (error) {
      log(error.toString());
    }
  }

  bool get isDarkMode => _darkTheme;
}
