import '../../domain/entities/user.dart';

class UserModel {
  final String id;
  final String fullName;
  final String profileImage;
  final String email;
  final String createdAt;
  final String accessToken;

  UserModel({
    required this.id,
    required this.fullName,
    required this.profileImage,
    required this.email,
    required this.createdAt,
    required this.accessToken,
  });

  factory UserModel.empty() {
    return UserModel(
      id: "",
      fullName: "",
      profileImage: "",
      email: "",
      createdAt: "",
      accessToken: "",
    );
  }

  User toEntity() {
    return User(
      userId: id,
      userName: fullName,
      profileImage: profileImage,
      accessToken: accessToken,
    );
  }

  static Map<String, dynamic> toJson({
    required String id,
    required String fullName,
    required String email,
    required String password,
  }) {
    return {
      'user_id': id,
      'fullName': fullName,
      'email': email,
      'password': password,
      'created_at': DateTime.now().toIso8601String(),
    };
  }
}
