import 'dart:developer';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:quick_pass/src/app/features/home/presentation/screens/home_screen.dart';
import 'package:quick_pass/src/app/features/onboardings/presentation/view/onbording_screen.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';

enum SupportState { unknown, supported, unsupported }

class SplashState {
  final List<BiometricType>? availableBiometrics;
  final SupportState supportState;
  final bool isBiometricAvailable;
  final bool isAuthenticated;
  final bool hasToken;
  final bool isLoading;

  SplashState({
    this.availableBiometrics,
    required this.supportState,
    required this.isBiometricAvailable,
    required this.isAuthenticated,
    required this.hasToken,
    required this.isLoading,
  });

  SplashState copyWith({
    List<BiometricType>? availableBiometrics,
    SupportState? supportState,
    bool? isBiometricAvailable,
    bool? isAuthenticated,
    bool? hasToken,
    bool? isLoading,
  }) {
    return SplashState(
      availableBiometrics: availableBiometrics ?? this.availableBiometrics,
      supportState: supportState ?? this.supportState,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      hasToken: hasToken ?? this.hasToken,
      isLoading: isLoading ?? this.isLoading,
      isBiometricAvailable: isBiometricAvailable ?? this.isBiometricAvailable,
    );
  }
}

// Provider
final splashProvider = StateNotifierProvider<SplashNotifier, SplashState>((
  ref,
) {
  return SplashNotifier();
});

// Notifier
class SplashNotifier extends StateNotifier<SplashState> {
  SplashNotifier()
    : super(
        SplashState(
          supportState: SupportState.unknown,
          isBiometricAvailable: false,
          isAuthenticated: false,
          hasToken: SecureStorageService.instance.hasToken,
          isLoading: true,
        ),
      ) {
    _init();
  }

  final LocalAuthentication auth = LocalAuthentication();

  Future<void> _init() async {
    await _checkSupport();
    await _checkBiometricCapability();
    await _getAvailableBiometrics();
    await Future.delayed(Duration(seconds: 1), () async {
      await _tryFlexibleAuth();
    });
    state = state.copyWith(isLoading: false);
  }

  Future<void> _checkSupport() async {
    final isSupported = await auth.isDeviceSupported();
    state = state.copyWith(
      supportState:
          isSupported ? SupportState.supported : SupportState.unsupported,
    );
  }

  Future<void> _checkBiometricCapability() async {
    try {
      final canCheck = await auth.canCheckBiometrics;
      state = state.copyWith(isBiometricAvailable: canCheck);
    } on PlatformException catch (e) {
      log("Biometric check failed: ${e.message}");
      state = state.copyWith(isBiometricAvailable: false);
    }
  }

  Future<void> _getAvailableBiometrics() async {
    try {
      final available = await auth.getAvailableBiometrics();
      state = state.copyWith(availableBiometrics: available);
    } on PlatformException catch (e) {
      log("Failed to get available biometrics: ${e.message}");
      state = state.copyWith(availableBiometrics: []);
    }
  }

  Future<void> _tryFlexibleAuth() async {
    try {
      bool biometricOnly = false;
      if (state.availableBiometrics != null &&
          state.availableBiometrics!.contains(BiometricType.fingerprint)) {
        biometricOnly = true;
      } else if (Platform.isIOS &&
          state.availableBiometrics!.contains(BiometricType.face)) {
        biometricOnly = true;
        biometricOnly = false;
      }

      final bool authenticated = await auth.authenticate(
        localizedReason: 'Authenticate to continue',
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: biometricOnly,
          sensitiveTransaction: true,
        ),
      );

      state = state.copyWith(isAuthenticated: authenticated);
    } on PlatformException catch (e) {
      log("Authentication failed: ${e.message}");
      state = state.copyWith(isAuthenticated: false);
    }
  }

  void navigateAfterSplash(BuildContext context) {
    if (state.hasToken && state.isAuthenticated) {
      context.go(HomeScreen.routeName);
    } else {
      context.go(OnbordingScreen.routeName);
    }
  }
}
