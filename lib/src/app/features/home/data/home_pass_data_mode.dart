import '../../../service/encryption_service.dart';

class PasswordModel {
  final int id;
  final String passId;
  final String createdAt;
  final String updatedAt;
  final String userId;
  final String name;
  final String url;
  final String password;
  final String email;
  // Add encrypted fields for storage
  final String? encryptedPassword;
  final String? encryptedEmail;

  PasswordModel({
    required this.id,
    required this.passId,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.name,
    required this.url,
    required this.password,
    required this.email,
    this.encryptedPassword,
    this.encryptedEmail,
  });

  factory PasswordModel.fromJson(Map<String, dynamic> json) {
    return PasswordModel(
      id: json['id'] ?? 0,
      passId: json['pass_id'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      userId: json['user_id'] ?? '',
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      encryptedPassword: json['encrypted_password'],
      encryptedEmail: json['encrypted_email'],
    );
  }

  /// Create PasswordModel with encrypted data
  static Future<PasswordModel> createWithEncryption({
    required int id,
    required String passId,
    required String createdAt,
    required String updatedAt,
    required String userId,
    required String name,
    required String url,
    required String password,
    required String email,
  }) async {
    final encryptionService = EncryptionService.instance;
    
    final encryptedData = await encryptionService.encryptSensitiveData(
      password: password,
      email: email.isNotEmpty ? email : null,
    );
    
    return PasswordModel(
      id: id,
      passId: passId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userId: userId,
      name: name,
      url: url,
      password: password,
      email: email,
      encryptedPassword: encryptedData['password']!,
      encryptedEmail: encryptedData['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'passId': passId,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'userId': userId,
      'name': name,
      'url': url,
      'password': encryptedPassword ?? password, // Use encrypted if available
      'email': encryptedEmail ?? email, // Use encrypted if available
      'encrypted_password': encryptedPassword,
      'encrypted_email': encryptedEmail,
    };
  }

  /// Get decrypted password data
  Future<Map<String, String>> getDecryptedData() async {
    if (encryptedPassword == null || encryptedPassword!.isEmpty) {
      // Fallback for non-encrypted data
      return {
        'password': password,
        'email': email,
      };
    }
    
    try {
      final encryptionService = EncryptionService.instance;
      final decryptedData = await encryptionService.decryptSensitiveData(
        encryptedPassword: encryptedPassword!,
        encryptedEmail: encryptedEmail,
      );
      
      // If decryption returns empty strings (corrupted data), use fallback
      if (decryptedData['password']?.isEmpty == true) {
        return {
          'password': password.isNotEmpty ? password : 'Data corrupted',
          'email': email,
        };
      }
      
      return decryptedData;
    } catch (e) {
      // If decryption fails completely, use fallback data
      return {
        'password': password.isNotEmpty ? password : 'Data corrupted',
        'email': email,
      };
    }
  }

  /// Create a copy with decrypted data for display
  Future<PasswordModel> withDecryptedData() async {
    if (encryptedPassword == null) {
      return this; // Already decrypted or plain text
    }
    
    final decryptedData = await getDecryptedData();
    
    return PasswordModel(
      id: id,
      passId: passId,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userId: userId,
      name: name,
      url: url,
      password: decryptedData['password']!,
      email: decryptedData['email'] ?? '',
      encryptedPassword: encryptedPassword,
      encryptedEmail: encryptedEmail,
    );
  }

  static List<PasswordModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PasswordModel.fromJson(json)).toList();
  }

  /// Static method to decrypt a list of password models
  static Future<List<PasswordModel>> decryptList(List<PasswordModel> encryptedList) async {
    List<PasswordModel> decryptedList = [];
    
    for (PasswordModel model in encryptedList) {
      try {
        final decryptedModel = await model.withDecryptedData();
        decryptedList.add(decryptedModel);
      } catch (e) {
        // If decryption fails, add the original (might be plain text)
        decryptedList.add(model);
      }
    }
    
    return decryptedList;
  }
}
