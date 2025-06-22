import '../entities/user.dart';

abstract class AuthRepo {
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
  });

  Future<User> logIn({required String email, required String password});
}
