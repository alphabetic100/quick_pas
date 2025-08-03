import '../../../service/encryption_service.dart';

class AddPassModel {
  final String name;
  final String url;
  final String email;
  final String password;
  // Store encrypted versions for database/API
  final String? encryptedEmail;
  final String? encryptedPassword;

  AddPassModel({
    required this.name,
    required this.url,
    required this.email,
    required this.password,
    this.encryptedEmail,
    this.encryptedPassword,
  });

  factory AddPassModel.fromJson(Map<String, dynamic> json) {
    return AddPassModel(
      name: json['name'] as String,
      url: json['url'] as String,
      email: json['email'] as String? ?? '',
      password: json['password'] as String? ?? '',
      encryptedEmail: json['encrypted_email'] as String?,
      encryptedPassword: json['encrypted_password'] as String?,
    );
  }

  /// Create model with encrypted sensitive data
  static Future<AddPassModel> createWithEncryption({
    required String name,
    required String url,
    required String email,
    required String password,
  }) async {
    final encryptionService = EncryptionService.instance;
    
    final encryptedData = await encryptionService.encryptSensitiveData(
      password: password,
      email: email.isNotEmpty ? email : null,
    );
    
    return AddPassModel(
      name: name,
      url: url,
      email: email,
      password: password,
      encryptedEmail: encryptedData['email'],
      encryptedPassword: encryptedData['password']!,
    );
  }

  /// Convert to JSON for storage/API with encrypted data
  static Future<Map<String, dynamic>> toJsonEncrypted({
    required String name,
    required String url,
    required String email,
    required String password,
  }) async {
    final encryptionService = EncryptionService.instance;
    
    final encryptedData = await encryptionService.encryptSensitiveData(
      password: password,
      email: email.isNotEmpty ? email : null,
    );
    
    return {
      'name': name,
      'url': url,
      'email': encryptedData['email'] ?? '',
      'password': encryptedData['password']!,
      'encrypted_email': encryptedData['email'],
      'encrypted_password': encryptedData['password']!,
      "created_at": DateTime.now().toIso8601String(),
      "updated_at": DateTime.now().toIso8601String(),
    };
  }

  /// Legacy method for backward compatibility (will be encrypted)
  static Future<Map<String, dynamic>> toJson({
    required String name,
    required String url,
    required String email,
    required String password,
  }) async {
    return await toJsonEncrypted(
      name: name,
      url: url,
      email: email,
      password: password,
    );
  }

  /// Decrypt sensitive data from this model
  Future<Map<String, String>> getDecryptedData() async {
    if (encryptedPassword == null) {
      // Fallback for non-encrypted data
      return {
        'password': password,
        'email': email,
      };
    }
    
    final encryptionService = EncryptionService.instance;
    return await encryptionService.decryptSensitiveData(
      encryptedPassword: encryptedPassword!,
      encryptedEmail: encryptedEmail,
    );
  }
}
