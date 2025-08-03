import 'dart:convert';
import 'dart:developer';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for handling AES-256 encryption/decryption of sensitive password data
class EncryptionService {
  // Private constructor for singleton pattern
  EncryptionService._();

  // Singleton instance
  static final EncryptionService instance = EncryptionService._();

  static const String _masterKeyKey = "masterEncryptionKey";
  static const String _ivKey = "encryptionIV";
  
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Encrypter? _encrypter;
  IV? _iv;
  bool _isInitialized = false;

  /// Initialize the encryption service with master key and IV
  Future<void> initialize() async {
    try {
      log("[EncryptionService] Initializing encryption service...");
      
      // Get or generate master key
      String? storedKey = await _secureStorage.read(key: _masterKeyKey);
      Key masterKey;
      
      if (storedKey != null) {
        // Use existing key
        masterKey = Key.fromBase64(storedKey);
        log("[EncryptionService] Using existing master key");
      } else {
        // Generate new master key (256-bit for AES-256)
        masterKey = Key.fromSecureRandom(32);
        await _secureStorage.write(key: _masterKeyKey, value: masterKey.base64);
        log("[EncryptionService] Generated new master key");
      }

      // Get or generate IV
      String? storedIV = await _secureStorage.read(key: _ivKey);
      if (storedIV != null) {
        // Use existing IV
        _iv = IV.fromBase64(storedIV);
        log("[EncryptionService] Using existing IV");
      } else {
        // Generate new IV (16 bytes for AES)
        _iv = IV.fromSecureRandom(16);
        await _secureStorage.write(key: _ivKey, value: _iv!.base64);
        log("[EncryptionService] Generated new IV");
      }

      // Initialize encrypter with AES-256-CBC
      _encrypter = Encrypter(AES(masterKey, mode: AESMode.cbc));
      _isInitialized = true;
      
      log("[EncryptionService] Initialization completed successfully");
    } catch (error, stackTrace) {
      log("[EncryptionService] Error during initialization", 
          error: error, stackTrace: stackTrace);
      throw Exception("Failed to initialize encryption service: $error");
    }
  }

  /// Encrypt a password string using AES-256
  Future<String> encryptPassword(String password) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (_encrypter == null || _iv == null) {
        throw Exception("Encryption service not properly initialized");
      }

      // Encrypt the password
      final encrypted = _encrypter!.encrypt(password, iv: _iv!);
      
      log("[EncryptionService] Password encrypted successfully");
      return encrypted.base64;
    } catch (error, stackTrace) {
      log("[EncryptionService] Error encrypting password", 
          error: error, stackTrace: stackTrace);
      throw Exception("Failed to encrypt password: $error");
    }
  }

  /// Decrypt a password string using AES-256
  Future<String> decryptPassword(String encryptedPassword) async {
    try {
      if (!_isInitialized) {
        await initialize();
      }

      if (_encrypter == null || _iv == null) {
        throw Exception("Encryption service not properly initialized");
      }

      // Decrypt the password
      final encrypted = Encrypted.fromBase64(encryptedPassword);
      final decrypted = _encrypter!.decrypt(encrypted, iv: _iv!);
      
      log("[EncryptionService] Password decrypted successfully");
      return decrypted;
    } catch (error, stackTrace) {
      log("[EncryptionService] Error decrypting password", 
          error: error, stackTrace: stackTrace);
      throw Exception("Failed to decrypt password: $error");
    }
  }

  /// Encrypt multiple fields of sensitive data
  Future<Map<String, String>> encryptSensitiveData({
    required String password,
    String? email,
    String? notes,
  }) async {
    try {
      Map<String, String> encryptedData = {};
      
      // Always encrypt password
      encryptedData['password'] = await encryptPassword(password);
      
      // Encrypt email if provided
      if (email != null && email.isNotEmpty) {
        encryptedData['email'] = await encryptPassword(email);
      }
      
      // Encrypt notes if provided
      if (notes != null && notes.isNotEmpty) {
        encryptedData['notes'] = await encryptPassword(notes);
      }
      
      return encryptedData;
    } catch (error, stackTrace) {
      log("[EncryptionService] Error encrypting sensitive data", 
          error: error, stackTrace: stackTrace);
      throw Exception("Failed to encrypt sensitive data: $error");
    }
  }

  /// Decrypt multiple fields of sensitive data
  Future<Map<String, String>> decryptSensitiveData({
    required String encryptedPassword,
    String? encryptedEmail,
    String? encryptedNotes,
  }) async {
    try {
      Map<String, String> decryptedData = {};
      
      // Always decrypt password
      decryptedData['password'] = await decryptPassword(encryptedPassword);
      
      // Decrypt email if provided
      if (encryptedEmail != null && encryptedEmail.isNotEmpty) {
        decryptedData['email'] = await decryptPassword(encryptedEmail);
      }
      
      // Decrypt notes if provided
      if (encryptedNotes != null && encryptedNotes.isNotEmpty) {
        decryptedData['notes'] = await decryptPassword(encryptedNotes);
      }
      
      return decryptedData;
    } catch (error, stackTrace) {
      log("[EncryptionService] Error decrypting sensitive data", 
          error: error, stackTrace: stackTrace);
      throw Exception("Failed to decrypt sensitive data: $error");
    }
  }

  /// Generate a hash of the password for verification purposes (non-reversible)
  String generatePasswordHash(String password) {
    try {
      final bytes = utf8.encode(password);
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (error, stackTrace) {
      log("[EncryptionService] Error generating password hash", 
          error: error, stackTrace: stackTrace);
      throw Exception("Failed to generate password hash: $error");
    }
  }

  /// Verify a password against its hash
  bool verifyPasswordHash(String password, String hash) {
    try {
      final generatedHash = generatePasswordHash(password);
      return generatedHash == hash;
    } catch (error, stackTrace) {
      log("[EncryptionService] Error verifying password hash", 
          error: error, stackTrace: stackTrace);
      return false;
    }
  }

  /// Clear all encryption keys (use with caution - will make existing data unreadable)
  Future<void> clearEncryptionKeys() async {
    try {
      await _secureStorage.delete(key: _masterKeyKey);
      await _secureStorage.delete(key: _ivKey);
      
      _encrypter = null;
      _iv = null;
      _isInitialized = false;
      
      log("[EncryptionService] Encryption keys cleared");
    } catch (error, stackTrace) {
      log("[EncryptionService] Error clearing encryption keys", 
          error: error, stackTrace: stackTrace);
      throw Exception("Failed to clear encryption keys: $error");
    }
  }

  /// Check if the encryption service is initialized
  bool get isInitialized => _isInitialized;

  /// Get encryption strength information
  String get encryptionInfo => "AES-256-CBC with secure random IV";
}
