import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginController {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  void dispose() {
    email.dispose();
    password.dispose();
  }
}

final loginControllerProvider = Provider.autoDispose<LoginController>((ref) {
  final controller = LoginController();
  ref.onDispose(controller.dispose);
  return controller;
});
