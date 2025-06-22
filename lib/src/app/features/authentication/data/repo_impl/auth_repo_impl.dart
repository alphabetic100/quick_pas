
import 'package:quick_pass/src/app/features/authentication/data/data_source/remote_data_source.dart';
import 'package:quick_pass/src/app/features/authentication/data/model/user_model.dart';
import 'package:quick_pass/src/app/features/authentication/domain/repo/auth_repo.dart';

import '../../domain/entities/user.dart';

class AuthRepoImpl extends AuthRepo {
  final RemoteDataSource dataSource;

  AuthRepoImpl({required this.dataSource});
  @override
  Future<User> logIn({required String email, required String password}) async {
    final UserModel userModel = await dataSource.logIn(
      email: email,
      password: password,
    );

    return userModel.toEntity();
  }

  @override
  Future<User> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final UserModel userModel = await dataSource.register(
      fullName: fullName,
      email: email,
      password: password,
    );

    return userModel.toEntity();
  }
}
