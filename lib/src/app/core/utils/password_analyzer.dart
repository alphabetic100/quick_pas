class PasswordAnalyzer {
  static const int minPasswordLength = 8;
  static const List<String> commonPasswords = [
    'password', '123456', '123456789', 'qwerty', 'abc123', 
    'password123', 'admin', 'letmein', 'welcome', 'monkey',
    '1234567890', 'password1', '123123', 'qwerty123'
  ];

  static bool isPasswordCompromised(String password) {
    return isWeakPassword(password) || 
           isCommonPassword(password) || 
           isPasswordTooShort(password);
  }

  static bool isPasswordTooShort(String password) {
    return password.length < minPasswordLength;
  }

  static bool isCommonPassword(String password) {
    return commonPasswords.contains(password.toLowerCase());
  }

  static bool isWeakPassword(String password) {
    bool hasUppercase = password.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = password.contains(RegExp(r'[a-z]'));
    bool hasNumbers = password.contains(RegExp(r'[0-9]'));
    bool hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    
    int criteriaCount = 0;
    if (hasUppercase) criteriaCount++;
    if (hasLowercase) criteriaCount++;
    if (hasNumbers) criteriaCount++;
    if (hasSpecialChars) criteriaCount++;
    
    return criteriaCount < 3;
  }

  static bool hasDuplicatePassword(String password, List<String> allPasswords) {
    return allPasswords.where((p) => p == password).length > 1;
  }

  static PasswordStrength getPasswordStrength(String password) {
    if (isPasswordCompromised(password)) {
      return PasswordStrength.weak;
    } else if (password.length >= 12 && !isWeakPassword(password)) {
      return PasswordStrength.strong;
    } else {
      return PasswordStrength.medium;
    }
  }

  static String getPasswordStatusMessage(String password) {
    if (isPasswordTooShort(password)) {
      return "Password too short";
    } else if (isCommonPassword(password)) {
      return "Common password";
    } else if (isWeakPassword(password)) {
      return "Weak password";
    } else {
      return "Not Compromised";
    }
  }
}

enum PasswordStrength {
  weak,
  medium,
  strong
}
