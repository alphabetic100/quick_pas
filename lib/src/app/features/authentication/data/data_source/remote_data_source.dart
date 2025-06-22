import 'dart:developer';

import 'package:quick_pass/src/app/features/authentication/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteDataSource {
  final supabase = Supabase.instance.client;
  Future<UserModel> logIn({
    required String email,
    required String password,
  }) async {
    log("Login request with email: $email and password: $password");

    return UserModel.empty();
  }

  Future<UserModel> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    log("register request with email: $email and password: $password");
    try {
      final response = await supabase.auth.signUp(
        email: email,
        password: password,
      );
      final user = response.user;
      final accessToken = response.session?.accessToken ?? "";

      if (user != null) {
        try {
          await supabase
              .from("user")
              .insert(
                UserModel.toJson(
                  id: user.id,
                  fullName: fullName,
                  email: email,
                  password: password,
                ),
              );
          return UserModel(
            id: user.id,
            fullName: fullName,
            profileImage: "",
            email: email,
            createdAt: "",
            accessToken: accessToken,
          );
        } catch (error) {
          log(error.toString());
        }
      }
    } catch (error) {
      log(error.toString());
    }
    return UserModel.empty();
  }
}
