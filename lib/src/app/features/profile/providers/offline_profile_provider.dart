import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_pass/src/app/features/profile/data/user_data.dart';
import 'package:quick_pass/src/app/service/connectivity_service.dart';
import 'package:quick_pass/src/app/service/user_sync_service.dart';

class ProfileState {
  final UserData? userData;
  final bool isLoading;
  final String? error;
  final bool isOffline;

  ProfileState({
    this.userData,
    required this.isLoading,
    this.error,
    this.isOffline = false,
  });

  ProfileState copyWith({
    UserData? userData,
    bool? isLoading,
    String? error,
    bool? isOffline,
  }) {
    return ProfileState(
      userData: userData ?? this.userData,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isOffline: isOffline ?? this.isOffline,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  ProfileNotifier() : super(ProfileState(isLoading: true)) {
    loadUserProfile();
    _listenToConnectivity();
  }

  final UserSyncService _userSyncService = UserSyncService.instance;
  final ConnectivityService _connectivity = ConnectivityService.instance;

  void _listenToConnectivity() {
    _connectivity.connectionStream.listen((isConnected) {
      if (isConnected && !state.isLoading) {
        log('Connection restored, syncing user profile');
        syncUserProfile();
      }
      state = state.copyWith(isOffline: !isConnected);
    });
  }

  Future<void> loadUserProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final userData = await _userSyncService.getUserProfile();
      state = state.copyWith(
        userData: userData,
        isLoading: false,
        isOffline: !_connectivity.isConnected,
      );
    } catch (error) {
      log('Error loading user profile: $error');
      state = state.copyWith(
        isLoading: false,
        error: error.toString(),
        isOffline: !_connectivity.isConnected,
      );
    }
  }

  Future<void> syncUserProfile() async {
    try {
      await _userSyncService.syncUserProfile();
      await loadUserProfile();
    } catch (error) {
      log('Error syncing user profile: $error');
    }
  }

  Future<void> refreshProfile() async {
    await loadUserProfile();
  }
}

final offlineProfileProvider = StateNotifierProvider<ProfileNotifier, ProfileState>((ref) {
  return ProfileNotifier();
});

final profileDataProvider = Provider<UserData?>((ref) {
  final profileState = ref.watch(offlineProfileProvider);
  return profileState.userData;
});
