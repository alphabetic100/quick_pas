import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_snackbar.dart';
import 'package:quick_pass/src/app/core/common/widgets/loading_widget.dart';
import 'package:quick_pass/src/app/features/profile/providers/offline_profile_provider.dart';
import 'package:quick_pass/src/app/service/connectivity_service.dart';
import 'package:quick_pass/src/app/service/user_sync_service.dart';

class UpdateProfileProvider {
  final UserSyncService _userSyncService = UserSyncService.instance;
  final ConnectivityService _connectivity = ConnectivityService.instance;
  static StateProvider<String> profilePicture = StateProvider<String>(
    (ref) => "",
  );

  static Uint8List? byteImage;

  static Future<void> pickImage({required WidgetRef ref}) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) {
        ref.read(profilePicture.notifier).state = pickedImage.path;
        byteImage = await pickedImage.readAsBytes();
      }
    } catch (error) {
      log(error.toString());
    }
  }

  Future<void> updateProfile({
    required BuildContext context,
    required WidgetRef ref,
    required String name,
    required String previousImage,
  }) async {
    try {
      if (!_connectivity.isConnected) {
        CustomToast.showError(
          context,
          title: 'Offline Mode',
          message: "You need internet connection to update your profile",
        );
        return;
      }

      LoadingWidget.showLoading(context);
      final xbyteImage = byteImage;

      final success = await _userSyncService.updateUserProfile(
        fullName: name,
        profileImageUrl: previousImage,
        imageBytes: xbyteImage,
      );

      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);

      if (success) {
        CustomToast.showSuccess(
          // ignore: use_build_context_synchronously
          context,
          title: 'Success',
          message: "Profile updated successfully",
        );
        ref.read(offlineProfileProvider.notifier).refreshProfile();
        // ignore: use_build_context_synchronously
        context.pop();
      } else {
        CustomToast.showError(
          // ignore: use_build_context_synchronously
          context,
          title: 'Failed!',
          message: "Failed to update profile. Please try again.",
        );
      }
    } catch (error) {
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      log("Update Error: $error");
      CustomToast.showError(
        // ignore: use_build_context_synchronously
        context,
        title: 'Error',
        message: "Something went wrong. Please try again.",
      );
    } finally {
      byteImage = null;
    }
  }
}
