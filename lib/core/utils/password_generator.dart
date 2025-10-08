import 'dart:math';

/// Password Generator Utility
/// Generates secure passwords that meet all requirements
class PasswordGenerator {
  static const String _lowercase = 'abcdefghijklmnopqrstuvwxyz';
  static const String _uppercase = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  static const String _numbers = '0123456789';
  static const String _symbols = '!@#\$%^&*()_+-=[]{}|;:,.<>?';
  static const String _similar = 'il1Lo0O';
  static const String _ambiguous = '{}[]()/\\\'"`~,;.<>';

  /// Password requirements
  static const Map<String, dynamic> defaultRequirements = {
    'minLength': 8,
    'maxLength': 128,
    'requireUppercase': true,
    'requireLowercase': true,
    'requireNumbers': true,
    'requireSymbols': true,
    'excludeSimilar': true,
    'excludeAmbiguous': true,
  };

  /// Generate a secure password
  static String generate({Map<String, dynamic>? requirements}) {
    final config = Map<String, dynamic>.from(defaultRequirements);
    if (requirements != null) {
      config.addAll(requirements);
    }

    final length = (config['minLength'] as int).clamp(
      8,
      (config['maxLength'] as int).clamp(8, 32),
    );

    String charset = '';
    String requiredChars = '';

    // Build character set based on requirements
    if (config['requireLowercase'] as bool) {
      charset += _lowercase;
      requiredChars += _getRandomChar(_lowercase);
    }

    if (config['requireUppercase'] as bool) {
      charset += _uppercase;
      requiredChars += _getRandomChar(_uppercase);
    }

    if (config['requireNumbers'] as bool) {
      charset += _numbers;
      requiredChars += _getRandomChar(_numbers);
    }

    if (config['requireSymbols'] as bool) {
      charset += _symbols;
      requiredChars += _getRandomChar(_symbols);
    }

    // Remove similar characters if required
    if (config['excludeSimilar'] as bool) {
      charset = _removeCharacters(charset, _similar);
    }

    // Remove ambiguous characters if required
    if (config['excludeAmbiguous'] as bool) {
      charset = _removeCharacters(charset, _ambiguous);
    }

    // Generate remaining characters
    String password = requiredChars;
    for (int i = requiredChars.length; i < length; i++) {
      password += _getRandomChar(charset);
    }

    // Shuffle the password
    return _shuffleString(password);
  }

  /// Get a random character from a character set
  static String _getRandomChar(String charset) {
    final random = Random();
    return charset[random.nextInt(charset.length)];
  }

  /// Remove characters from a character set
  static String _removeCharacters(String charset, String toRemove) {
    return charset.split('').where((char) => !toRemove.contains(char)).join('');
  }

  /// Shuffle a string
  static String _shuffleString(String str) {
    final List<String> array = str.split('');
    final random = Random();

    for (int i = array.length - 1; i > 0; i--) {
      final j = random.nextInt(i + 1);
      final temp = array[i];
      array[i] = array[j];
      array[j] = temp;
    }

    return array.join('');
  }

  /// Validate password against requirements
  static PasswordValidationResult validatePassword(
    String password, {
    Map<String, dynamic>? requirements,
  }) {
    final config = Map<String, dynamic>.from(defaultRequirements);
    if (requirements != null) {
      config.addAll(requirements);
    }

    final result = PasswordValidationResult(
      isValid: true,
      errors: <String>[],
      strength: PasswordStrength.weak,
    );

    if (password.isEmpty) {
      result.isValid = false;
      result.errors.add('Password is required');
      return result;
    }

    if (password.length < (config['minLength'] as int)) {
      result.isValid = false;
      result.errors.add(
        'Password must be at least ${config['minLength']} characters long',
      );
    }

    if (password.length > (config['maxLength'] as int)) {
      result.isValid = false;
      result.errors.add(
        'Password must be no more than ${config['maxLength']} characters long',
      );
    }

    if ((config['requireUppercase'] as bool) &&
        !password.contains(RegExp(r'[A-Z]'))) {
      result.isValid = false;
      result.errors.add('Password must contain at least one uppercase letter');
    }

    if ((config['requireLowercase'] as bool) &&
        !password.contains(RegExp(r'[a-z]'))) {
      result.isValid = false;
      result.errors.add('Password must contain at least one lowercase letter');
    }

    if ((config['requireNumbers'] as bool) &&
        !password.contains(RegExp(r'[0-9]'))) {
      result.isValid = false;
      result.errors.add('Password must contain at least one number');
    }

    if ((config['requireSymbols'] as bool) &&
        !password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]'))) {
      result.isValid = false;
      result.errors.add('Password must contain at least one special character');
    }

    // Calculate password strength
    result.strength = _calculateStrength(password);

    return result;
  }

  /// Calculate password strength
  static PasswordStrength _calculateStrength(String password) {
    int score = 0;

    // Length scoring
    if (password.length >= 8) score += 1;
    if (password.length >= 12) score += 1;
    if (password.length >= 16) score += 1;

    // Character variety scoring
    if (password.contains(RegExp(r'[a-z]'))) score += 1;
    if (password.contains(RegExp(r'[A-Z]'))) score += 1;
    if (password.contains(RegExp(r'[0-9]'))) score += 1;
    if (password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]')))
      score += 1;

    // Complexity scoring
    if (password.length >= 12 &&
        password.contains(RegExp(r'[a-z]')) &&
        password.contains(RegExp(r'[A-Z]')) &&
        password.contains(RegExp(r'[0-9]')) &&
        password.contains(RegExp(r'[!@#$%^&*()_+\-=\[\]{}|;:,.<>?]'))) {
      score += 2;
    }

    if (score <= 3) return PasswordStrength.weak;
    if (score <= 5) return PasswordStrength.medium;
    if (score <= 7) return PasswordStrength.strong;
    return PasswordStrength.veryStrong;
  }
}

/// Password validation result
class PasswordValidationResult {
  bool isValid;
  final List<String> errors;
  PasswordStrength strength;

  PasswordValidationResult({
    required this.isValid,
    required this.errors,
    required this.strength,
  });
}

/// Password strength levels
enum PasswordStrength { weak, medium, strong, veryStrong }

/// Extension for password strength display
extension PasswordStrengthExtension on PasswordStrength {
  String get displayName {
    switch (this) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
      case PasswordStrength.veryStrong:
        return 'Very Strong';
    }
  }

  String get color {
    switch (this) {
      case PasswordStrength.weak:
        return '#dc3545'; // Red
      case PasswordStrength.medium:
        return '#fd7e14'; // Orange
      case PasswordStrength.strong:
        return '#198754'; // Green
      case PasswordStrength.veryStrong:
        return '#0d6efd'; // Blue
    }
  }
}
