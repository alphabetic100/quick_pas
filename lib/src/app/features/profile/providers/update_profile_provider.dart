import 'dart:developer';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quick_pass/src/app/core/common/widgets/loading_widget.dart';
import 'package:quick_pass/src/app/core/constants/database/superbase_const.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateProfileProvider {
  final supabase = Supabase.instance.client;
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
    required String priviousImage,
  }) async {
    LoadingWidget.showLoading(context);
    final xbyteImage = byteImage;
    String imagePath = priviousImage;
    log(priviousImage);
    try {
      if (xbyteImage != null) {
        imagePath =
            "${SecureStorageService.instance.userId}/profile_${DateTime.now().millisecondsSinceEpoch}";

        await supabase.storage
            .from(SupabaseConst.avater)
            .uploadBinary(imagePath, xbyteImage);
      }

      final imageUrl = supabase.storage
          .from(SupabaseConst.avater)
          .getPublicUrl(imagePath);

      log("Image URL: $imageUrl");

      await supabase
          .from(SupabaseConst.userCollection)
          .update({
            "fullName": name,
            "profileImage": byteImage != null ? imageUrl : priviousImage,
            "updatedAt": DateTime.now().toIso8601String(),
          })
          .eq("user_id", SecureStorageService.instance.userId);

      // ignore: use_build_context_synchronously
      context.pop();
    } catch (error) {
      byteImage = null;
      log("Update Error: $error");
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
    } finally {
      byteImage = null;
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
    }
  }
}
