import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

final generateProvider =
    StateNotifierProvider<GeneratePassNotifier, GeneratePassState>((ref) {
      return GeneratePassNotifier();
    });

class GeneratePassNotifier extends StateNotifier<GeneratePassState> {
  GeneratePassNotifier()
    : super(
        GeneratePassState(
          generatedPassword: "",
          passwordLength: 8,
          isSymble: false,
        ),
      );

  void genaratePassword() {
    final int passLength = state.passwordLength;
    final bool isSymble = state.isSymble;

    const String letters =
        'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
    const String numbers = '0123456789';
    const String symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';

    final String availableChars = letters + numbers + (isSymble ? symbols : '');

    final Random random = Random();
    final String generatedPassword =
        List.generate(
          passLength,
          (index) => availableChars[random.nextInt(availableChars.length)],
        ).join();

    state = state.copyWith(generatedPassword: generatedPassword);
  }

  void updatePasswordLength({required int passLength}) {
    state = state.copyWith(passwordLength: passLength);
  }

  void updateIsSymble({required bool isSymble}) {
    state = state.copyWith(isSymble: isSymble);
  }
}

class GeneratePassState {
  final String generatedPassword;
  final int passwordLength;
  final bool isSymble;

  GeneratePassState({
    required this.generatedPassword,
    required this.passwordLength,
    required this.isSymble,
  });

  GeneratePassState copyWith({
    String? generatedPassword,
    int? passwordLength,
    bool? isSymble,
  }) {
    return GeneratePassState(
      generatedPassword: generatedPassword ?? this.generatedPassword,
      passwordLength: passwordLength ?? this.passwordLength,
      isSymble: isSymble ?? this.isSymble,
    );
  }
}
