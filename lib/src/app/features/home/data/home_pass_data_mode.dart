class PasswordModel {
  final int id;
  final String createdAt;
  final String updatedAt;
  final String userId;
  final String name;
  final String url;
  final String password;
  final String email;

  PasswordModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.name,
    required this.url,
    required this.password,
    required this.email,
  });

  factory PasswordModel.fromJson(Map<String, dynamic> json) {
    return PasswordModel(
      id: json['id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'user_id': userId,
      'name': name,
      'url': url,
      'password': password,
      'email': email,
    };
  }

  static List<PasswordModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PasswordModel.fromJson(json)).toList();
  }
}
