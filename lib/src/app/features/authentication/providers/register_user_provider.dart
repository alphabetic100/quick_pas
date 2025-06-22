import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quick_pass/src/app/core/common/widgets/custom_snackbar.dart';
import 'package:quick_pass/src/app/core/common/widgets/loading_widget.dart';
import 'package:quick_pass/src/app/features/authentication/data/data_source/remote_data_source.dart';
import 'package:quick_pass/src/app/features/authentication/data/repo_impl/auth_repo_impl.dart';
import 'package:quick_pass/src/app/features/home/presentation/screens/home_screen.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';

final registerProvider = StateNotifierProvider<RegisterNotifier, RegisterState>(
  (ref) => RegisterNotifier(),
);

class RegisterNotifier extends StateNotifier<RegisterState> {
  RegisterNotifier()
    : super(
        RegisterState(
          fullName: "",
          email: "",
          password: "",
          passVisibility: true,
          isLoading: false,
        ),
      );

  final AuthRepoImpl repoImpl = AuthRepoImpl(dataSource: RemoteDataSource());

  void toggleVisibility() {
    state = state.copyWith(passVisibility: !state.passVisibility);
  }

  Future<void> registerUser({
    required BuildContext context,
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true);
      LoadingWidget.showLoading(context);
      final user = await repoImpl.register(
        fullName: fullName,
        email: email,
        password: password,
      );
      state = state.copyWith(isLoading: false);
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      if (user.accessToken.isNotEmpty) {
        CustomToast.showSuccess(
          // ignore: use_build_context_synchronously
          context,
          title: "Success!",
          message: "Account registration successfull",
        );
        await SecureStorageService.instance.saveToken(token: user.accessToken);
        // ignore: use_build_context_synchronously
        context.go(HomeScreen.routeName);
        //Ask for the Fingerprint access
      } else {
        CustomToast.showError(
          // ignore: use_build_context_synchronously
          context,
          title: "Opps!",
          message: "Something went wrong, please try again",
        );
      }
    } catch (error) {
      state = state.copyWith(isLoading: false);
      // ignore: use_build_context_synchronously
      LoadingWidget.hideLoading(context);
      log(error.toString());
    }
  }
}

class RegisterState {
  final String fullName;
  final String email;
  final String password;
  final bool passVisibility;
  final bool isLoading;

  RegisterState({
    required this.fullName,
    required this.email,
    required this.password,
    required this.passVisibility,
    required this.isLoading,
  });

  RegisterState copyWith({
    String? fullNmae,
    String? email,
    String? password,
    bool? passVisibility,
    bool? isLoading,
  }) {
    return RegisterState(
      fullName: fullNmae ?? fullName,
      email: email ?? this.email,
      password: password ?? this.password,
      passVisibility: passVisibility ?? this.passVisibility,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
