import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterController {
  final TextEditingController fullName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  void dispose() {
    fullName.dispose();
    email.dispose();
    password.dispose();
  }
}

final registerControllerProvider = Provider.autoDispose<RegisterController>((
  ref,
) {
  final controller = RegisterController();
  ref.onDispose(controller.dispose);
  return controller;
});
