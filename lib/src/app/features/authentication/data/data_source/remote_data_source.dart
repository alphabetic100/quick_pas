import 'dart:developer';

import 'package:quick_pass/src/app/core/constants/database/superbase_const.dart';
import 'package:quick_pass/src/app/features/authentication/data/model/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RemoteDataSource {
  final supabase = Supabase.instance.client;
  Future<UserModel> logIn({
    required String email,
    required String password,
  }) async {
    log("Login request with email: $email and password: $password");
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      final accessToken = response.session?.accessToken ?? "";

      if (user != null) {
        try {
          final response =
              await supabase
                  .from(SupabaseConst.userCollection)
                  .select()
                  .eq("user_id", user.id)
                  .single();

          return UserModel(
            id: user.id,
            fullName: response['fullName'] ?? "",
            profileImage: "",
            email: email,
            createdAt: "",
            accessToken: accessToken,
          );
        } catch (error) {
          log("${error}noo");
        }
      }
    } on AuthApiException catch (error) {
      log(error.statusCode.toString());
      log("${error}From here");
    }
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
              .from(SupabaseConst.userCollection)
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
    } on AuthApiException catch (error) {
      log(error.toString());
    }
    return UserModel.empty();
  }
}
