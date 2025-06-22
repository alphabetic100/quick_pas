import 'package:quick_pass/src/app/features/authentication/domain/entities/user.dart';
import 'package:quick_pass/src/app/features/authentication/domain/repo/auth_repo.dart';

class AuthUsecases {
  final AuthRepo authRepo;

  AuthUsecases({required this.authRepo});

  Future<User> executeLogin({required String email, required String password}) {
    return authRepo.logIn(email: email, password: password);
  }

  Future<User> registerUser({
    required String fullName,
    required String email,
    required String password,
  }) {
    return authRepo.register(
      fullName: fullName,
      email: email,
      password: password,
    );
  }
}
