import 'dart:developer';
import 'package:quick_pass/src/app/service/encryption_service.dart';
import 'package:quick_pass/src/app/service/local_database_service.dart';
import 'package:quick_pass/src/app/service/secure_sotrage_service.dart';
import 'package:quick_pass/src/app/features/home/data/home_pass_data_mode.dart';

/// Service for handling data corruption and recovery scenarios
class DataRecoveryService {
  static final DataRecoveryService instance = DataRecoveryService._internal();
  
  factory DataRecoveryService() {
    return instance;
  }
  
  DataRecoveryService._internal();
  
  final EncryptionService _encryptionService = EncryptionService.instance;
  final LocalDatabaseService _localDB = LocalDatabaseService.instance;
  
  /// Check if the current encryption keys can decrypt existing data
  Future<bool> validateEncryptionIntegrity() async {
    try {
      log('[DataRecoveryService] Validating encryption integrity...');
      
      final userId = SecureStorageService.instance.userId;
      if (userId.isEmpty) {
        log('[DataRecoveryService] No user ID found, skipping validation');
        return true;
      }
      
      final passwords = await _localDB.fetchPasswordsForUser(userId);
      
      for (final password in passwords) {
        if (password.encryptedPassword != null && password.encryptedPassword!.isNotEmpty) {
          final isValid = await _encryptionService.isDataValid(password.encryptedPassword!);
          if (!isValid) {
            log('[DataRecoveryService] Found corrupted password data for ID: ${password.id}');
            return false;
          }
        }
      }
      
      log('[DataRecoveryService] All encrypted data is valid');
      return true;
    } catch (error) {
      log('[DataRecoveryService] Error validating encryption integrity: $error');
      return false;
    }
  }
  
  /// Attempt to recover corrupted password data
  Future<List<PasswordModel>> recoverCorruptedData(List<PasswordModel> passwordList) async {
    try {
      log('[DataRecoveryService] Attempting to recover corrupted data...');
      
      List<PasswordModel> recoveredList = [];
      int corruptedCount = 0;
      
      for (final password in passwordList) {
        // For corrupted data, bypass encryption entirely and use fallback data
        if (password.encryptedPassword != null && password.encryptedPassword!.isNotEmpty) {
          log('[DataRecoveryService] Recovering corrupted password ID: ${password.id}');
          corruptedCount++;
          
          // Create a version with fallback data, bypassing decryption
          final recoveredPassword = PasswordModel(
            id: password.id,
            passId: password.passId,
            createdAt: password.createdAt,
            updatedAt: password.updatedAt,
            userId: password.userId,
            name: password.name,
            url: password.url,
            password: password.password.isNotEmpty ? password.password : '[Encrypted - Please Update]',
            email: password.email.isNotEmpty ? password.email : '[Encrypted - Please Update]',
            encryptedPassword: null, // Clear corrupted encrypted data
            encryptedEmail: null,
          );
          
          recoveredList.add(recoveredPassword);
        } else {
          // No encrypted data, add as is
          recoveredList.add(password);
        }
      }
      
      if (corruptedCount > 0) {
        log('[DataRecoveryService] Recovered $corruptedCount corrupted password entries');
      }
      
      return recoveredList;
    } catch (error) {
      log('[DataRecoveryService] Error during data recovery: $error');
      return passwordList; 
    }
  }
  
  /// Reset encryption keys and clear all encrypted data (emergency recovery)
  Future<bool> performEmergencyRecovery() async {
    try {
      log('[DataRecoveryService] Performing emergency recovery...');
      
      // Reset encryption keys
      await _encryptionService.resetEncryptionKeys();
      
      // Clear local encrypted data that can't be decrypted
      final userId = SecureStorageService.instance.userId;
      if (userId.isNotEmpty) {
        final passwords = await _localDB.fetchPasswordsForUser(userId);
        
        for (final password in passwords) {
          if (password.encryptedPassword != null) {
            // Clear encrypted fields and update with plain text data
            final cleanPassword = PasswordModel(
              id: password.id,
              passId: password.passId,
              createdAt: password.createdAt,
              updatedAt: password.updatedAt,
              userId: password.userId,
              name: password.name,
              url: password.url,
              password: password.password,
              email: password.email,
              encryptedPassword: null,
              encryptedEmail: null,
            );
            
            await _localDB.insertPassword(cleanPassword);
          }
        }
      }
      
      log('[DataRecoveryService] Emergency recovery completed successfully');
      return true;
    } catch (error) {
      log('[DataRecoveryService] Error during emergency recovery: $error');
      return false;
    }
  }
  
  /// Check if data recovery is needed
  Future<bool> isRecoveryNeeded() async {
    return !(await validateEncryptionIntegrity());
  }
}
