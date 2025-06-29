import 'dart:developer';

class UpdateModel {
  static Map<String, dynamic> toJson({
    required String passId,
    required String name,
    required String url,
    required String email,
    required String password,
    required String createdAt,
  }) {
    final payload = {
      'pass_id': passId,
      'name': name,
      'url': url,
      'email': email,
      'password': password,
      "created_at": DateTime.parse(createdAt).toIso8601String(),
      "updated_at": DateTime.now().toIso8601String(),
    };

    log(payload.toString());
    return payload;
  }
}
