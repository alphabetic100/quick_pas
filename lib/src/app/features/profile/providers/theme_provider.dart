import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/service/theme_preferance.dart';

class ThemeState {
  final bool isDarkmode;

  ThemeState({required this.isDarkmode});

  ThemeState copyWith({required bool isDarkmode}) {
    return ThemeState(isDarkmode: isDarkmode);
  }
}

class ThemeNotifier extends StateNotifier<ThemeState> {
  ThemeNotifier()
    : super(ThemeState(isDarkmode: ThemePreferance.instance.isDarkMode));

  void toggleTheme({required BuildContext context}) async {
    log(
      state.isDarkmode
          ? "Switching to Light mode..."
          : "Switching to Dark mode",
    );
    state = state.copyWith(isDarkmode: !state.isDarkmode);
    await ThemePreferance.instance.saveThem(theme: state.isDarkmode);
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeState>((ref) {
  return ThemeNotifier();
});
