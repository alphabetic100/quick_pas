class UserData {
  final int id;
  final String createdAt;
  final String fullName;
  final String email;
  final String password;
  final String profileImage;
  final String updatedAt;
  final String userId;

  UserData({
    required this.id,
    required this.createdAt,
    required this.fullName,
    required this.email,
    required this.password,
    required this.profileImage,
    required this.updatedAt,
    required this.userId,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      profileImage: json['profileImage'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      userId: json['user_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'fullName': fullName,
      'email': email,
      'password': password,
      'profileImage': profileImage,
      'updatedAt': updatedAt,
      'user_id': userId,
    };
  }
}
