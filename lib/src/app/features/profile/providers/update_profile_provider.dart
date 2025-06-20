import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class UpdateProfileProvider {
  static StateProvider<String> profilePicture = StateProvider<String>((ref) => "");

 static Future<void> pickImage({required WidgetRef ref}) async {
    try {
      final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedImage != null) {
        ref.read(profilePicture.notifier).state = pickedImage.path;
      }
    } catch (error) {
      log(error.toString());
    }
  }
}
