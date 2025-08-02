
library;

import 'package:flutter/foundation.dart';
import 'password_analyzer.dart';

void demonstratePasswordAnalysis() {

  final List<String> testPasswords = [
    'password',         
    '123456',            
    'abc',            
    'Password123',     
    'MySecurePass@2024', 
    'qwerty',            
    'Aa1!',             
    'verylongpasswordwithnocomplexity', 
  ];

  debugPrint('=== Password Analysis Results ===\n');
  
  for (String password in testPasswords) {
    final bool isCompromised = PasswordAnalyzer.isPasswordCompromised(password);
    final String statusMessage = PasswordAnalyzer.getPasswordStatusMessage(password);
    final PasswordStrength strength = PasswordAnalyzer.getPasswordStrength(password);
    
    debugPrint('Password: "$password"');
    debugPrint('Status: ${isCompromised ? "🔴 COMPROMISED" : "🟢 SECURE"}');
    debugPrint('Message: $statusMessage');
    debugPrint('Strength: ${strength.name.toUpperCase()}');
    debugPrint('---');
  }


  final int compromisedCount = testPasswords
      .where((password) => PasswordAnalyzer.isPasswordCompromised(password))
      .length;
  
  debugPrint('\nSummary:');
  debugPrint('Total passwords: ${testPasswords.length}');
  debugPrint('Compromised passwords: $compromisedCount');
  debugPrint('Secure passwords: ${testPasswords.length - compromisedCount}');
}

