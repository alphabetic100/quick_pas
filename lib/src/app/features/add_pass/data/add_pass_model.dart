class AddPassModel {
  final String name;
  final String url;
  final String email;
  final String password;

  AddPassModel({
    required this.name,
    required this.url,
    required this.email,
    required this.password,
  });

  factory AddPassModel.fromJson(Map<String, dynamic> json) {
    return AddPassModel(
      name: json['name'] as String,
      url: json['url'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  static Map<String, dynamic> toJson({
    required String name,
    required String url,
    required String email,
    required String password,
  }) {
    return {
      'name': name,
      'url': url,
      'email': email,
      'password': password,
      "created_at": DateTime.now().toIso8601String(),
      "updated_at": DateTime.now().toIso8601String(),
    };
  }
}
