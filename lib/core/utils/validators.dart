/// Utility class for form validation
/// Provides common validation methods for various input types
class Validators {
  /// Email validation
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Password validation
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    return null;
  }

  /// Strong password validation
  static String? strongPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }

    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }

    return null;
  }

  /// Confirm password validation
  static String? confirmPassword(String? value, String? originalPassword) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }

    if (value != originalPassword) {
      return 'Passwords do not match';
    }

    return null;
  }

  /// Phone number validation (UK format)
  static String? phoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove all non-digit characters
    final digitsOnly = value.replaceAll(RegExp(r'[^\d]'), '');

    // UK phone number patterns
    final ukMobileRegex = RegExp(r'^07\d{9}$');
    final ukLandlineRegex = RegExp(r'^0[1-9]\d{8,9}$');
    final ukInternationalRegex = RegExp(r'^\+44[1-9]\d{8,9}$');

    if (!ukMobileRegex.hasMatch(digitsOnly) &&
        !ukLandlineRegex.hasMatch(digitsOnly) &&
        !ukInternationalRegex.hasMatch(digitsOnly)) {
      return 'Please enter a valid UK phone number';
    }

    return null;
  }

  /// Required field validation
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }
    return null;
  }

  /// Minimum length validation
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (value.length < minLength) {
      return '${fieldName ?? 'This field'} must be at least $minLength characters long';
    }

    return null;
  }

  /// Maximum length validation
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return null; // Allow empty values for max length validation
    }

    if (value.length > maxLength) {
      return '${fieldName ?? 'This field'} must not exceed $maxLength characters';
    }

    return null;
  }

  /// Numeric validation
  static String? numeric(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return '${fieldName ?? 'This field'} is required';
    }

    if (double.tryParse(value) == null) {
      return '${fieldName ?? 'This field'} must be a valid number';
    }

    return null;
  }

  /// Positive number validation
  static String? positiveNumber(String? value, [String? fieldName]) {
    final numericError = numeric(value, fieldName);
    if (numericError != null) return numericError;

    final number = double.parse(value!);
    if (number <= 0) {
      return '${fieldName ?? 'This field'} must be greater than 0';
    }

    return null;
  }

  /// Postcode validation (UK format)
  static String? postcode(String? value) {
    if (value == null || value.isEmpty) {
      return 'Postcode is required';
    }

    final ukPostcodeRegex = RegExp(
      r'^[A-Z]{1,2}[0-9R][0-9A-Z]? [0-9][ABD-HJLNP-UW-Z]{2}$',
      caseSensitive: false,
    );

    if (!ukPostcodeRegex.hasMatch(value.trim())) {
      return 'Please enter a valid UK postcode';
    }

    return null;
  }

  /// OTP validation (6 digits)
  static String? otp(String? value) {
    if (value == null || value.isEmpty) {
      return 'OTP is required';
    }

    final otpRegex = RegExp(r'^\d{6}$');
    if (!otpRegex.hasMatch(value)) {
      return 'Please enter a valid 6-digit OTP';
    }

    return null;
  }

  /// URL validation
  static String? url(String? value) {
    if (value == null || value.isEmpty) {
      return 'URL is required';
    }

    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );

    if (!urlRegex.hasMatch(value)) {
      return 'Please enter a valid URL';
    }

    return null;
  }

  /// Date validation
  static String? date(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date is required';
    }

    final date = DateTime.tryParse(value);
    if (date == null) {
      return 'Please enter a valid date';
    }

    return null;
  }

  /// Future date validation
  static String? futureDate(String? value) {
    final dateError = date(value);
    if (dateError != null) return dateError;

    final parsedDate = DateTime.parse(value!);
    if (parsedDate.isBefore(DateTime.now())) {
      return 'Date must be in the future';
    }

    return null;
  }

  /// Past date validation
  static String? pastDate(String? value) {
    final dateError = date(value);
    if (dateError != null) return dateError;

    final parsedDate = DateTime.parse(value!);
    if (parsedDate.isAfter(DateTime.now())) {
      return 'Date must be in the past';
    }

    return null;
  }

  /// Age validation (minimum age)
  static String? minimumAge(String? value, int minimumAge) {
    final dateError = date(value);
    if (dateError != null) return dateError;

    final parsedDate = DateTime.parse(value!);
    final age = DateTime.now().year - parsedDate.year;

    if (age < minimumAge) {
      return 'You must be at least $minimumAge years old';
    }

    return null;
  }

  /// Custom validation function
  static String? Function(String?) custom(
    bool Function(String?) validator,
    String errorMessage,
  ) {
    return (String? value) {
      if (!validator(value)) {
        return errorMessage;
      }
      return null;
    };
  }

  /// Combine multiple validators
  static String? Function(String?) combine(
    List<String? Function(String?)> validators,
  ) {
    return (String? value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) {
          return result;
        }
      }
      return null;
    };
  }
}
