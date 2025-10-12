/// Test configuration for authentication tests - Laundrette App
/// Contains API endpoints, test accounts, and configuration
class TestConfig {
  // API Configuration
  static const String apiBaseUrl = 'https://justlaunder.co.uk/api/v1';
  static const Duration apiTimeout = Duration(seconds: 30);
  
  // Test Accounts (Seeded from MockDataSeeder.php)
  static const Map<String, TestAccount> laundretteAccounts = {
    'verified_onboarded': TestAccount(
      email: 'sarah.williams@laundrex.com',
      password: 'password123',
      firstName: 'Sarah',
      lastName: 'Williams',
      isVerified: true,
      onboardingComplete: true,
    ),
    'verified_not_onboarded': TestAccount(
      email: 'david.brown@laundrex.com',
      password: 'password123',
      firstName: 'David',
      lastName: 'Brown',
      isVerified: true,
      onboardingComplete: false,
    ),
    'private_tenant': TestAccount(
      email: 'lisa.davis@laundrex.com',
      password: 'password123',
      firstName: 'Lisa',
      lastName: 'Davis',
      isVerified: true,
      onboardingComplete: true,
    ),
  };
  
  // New test accounts (to be created during tests)
  static const Map<String, TestAccount> newTestAccounts = {
    'unverified': TestAccount(
      email: 'laundrette.unverified@test.com',
      password: 'Test@123456',
      firstName: 'Unverified',
      lastName: 'Laundrette',
      isVerified: false,
      onboardingComplete: false,
    ),
    'mid_onboarding': TestAccount(
      email: 'laundrette.mid.onboarding@test.com',
      password: 'Test@123456',
      firstName: 'MidOnboard',
      lastName: 'Laundrette',
      isVerified: true,
      onboardingComplete: false,
    ),
  };
  
  // Invalid credentials for negative tests
  static const String invalidEmail = 'invalid@nonexistent.com';
  static const String invalidPassword = 'WrongPassword123!';
  static const String malformedEmail = 'not-an-email';
  static const String sqlInjection = "admin' OR '1'='1";
  static const String xssAttempt = '<script>alert("xss")</script>';
  
  // OTP Configuration
  static const String testOtp = '123456';
  static const int otpLength = 6;
  static const Duration otpResendCooldown = Duration(seconds: 60);
  
  // UI Configuration
  static const Duration screenTransitionTimeout = Duration(seconds: 5);
  static const Duration apiCallTimeout = Duration(seconds: 10);
  static const Duration otpInputDelay = Duration(milliseconds: 100);
  static const Duration onboardingPollInterval = Duration(seconds: 5);
  
  // Widget Keys - Login Screen
  static const String loginEmailKey = 'auth.laundrette.email';
  static const String loginPasswordKey = 'auth.laundrette.password';
  static const String loginButtonKey = 'auth.laundrette.loginBtn';
  static const String signupLinkKey = 'auth.laundrette.signupLink';
  static const String forgotPasswordLinkKey = 'auth.laundrette.forgotPasswordLink';
  static const String demoCredsKey = 'auth.laundrette.demoCreds';
  
  // Widget Keys - Signup Screen
  static const String signupBusinessTypeKey = 'auth.laundrette.signup.businessType';
  static const String signupBusinessNameKey = 'auth.laundrette.signup.businessName';
  static const String signupFirstNameKey = 'auth.laundrette.signup.firstName';
  static const String signupLastNameKey = 'auth.laundrette.signup.lastName';
  static const String signupEmailKey = 'auth.laundrette.signup.email';
  static const String signupMobileKey = 'auth.laundrette.signup.mobile';
  static const String signupPasswordKey = 'auth.laundrette.signup.password';
  static const String signupConfirmPasswordKey = 'auth.laundrette.signup.confirmPassword';
  static const String signupSubmitButtonKey = 'auth.laundrette.signup.submitBtn';
  static const String signupTermsCheckboxKey = 'auth.laundrette.signup.termsCheckbox';
  
  // Widget Keys - Forgot/Reset Password
  static const String forgotPasswordEmailKey = 'auth.laundrette.forgot.email';
  static const String forgotPasswordSubmitKey = 'auth.laundrette.forgot.submitBtn';
  static const String resetPasswordEmailKey = 'auth.laundrette.reset.email';
  static const String resetPasswordOtpKey = 'auth.laundrette.reset.otp';
  static const String resetPasswordNewPasswordKey = 'auth.laundrette.reset.newPassword';
  static const String resetPasswordConfirmPasswordKey = 'auth.laundrette.reset.confirmPassword';
  static const String resetPasswordSubmitKey = 'auth.laundrette.reset.submitBtn';
  
  // Widget Keys - Email Verification
  static const String verifyEmailOtpKey = 'auth.laundrette.verify.otp';
  static const String verifyEmailSubmitKey = 'auth.laundrette.verify.submitBtn';
  static const String verifyEmailResendKey = 'auth.laundrette.verify.resendBtn';
  
  // Widget Keys - Onboarding
  static const String onboardingStatusCardKey = 'onboarding.laundrette.statusCard';
  static const String onboardingWebButtonKey = 'onboarding.laundrette.webBtn';
  static const String onboardingLogoutButtonKey = 'onboarding.laundrette.logoutBtn';
  
  // Widget Keys - Staff Creation (Cross-app)
  static const String staffCreateEmailKey = 'staff.create.email';
  static const String staffCreatePasswordKey = 'staff.create.password';
  static const String staffCreateFirstNameKey = 'staff.create.firstName';
  static const String staffCreateLastNameKey = 'staff.create.lastName';
  static const String staffCreateBranchKey = 'staff.create.branch';
  static const String staffCreateRoleKey = 'staff.create.role';
  static const String staffCreateSubmitKey = 'staff.create.submitBtn';
}

/// Test account model
class TestAccount {
  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final bool isVerified;
  final bool onboardingComplete;
  final String? mobile;
  final String? businessName;
  
  const TestAccount({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.isVerified,
    this.onboardingComplete = false,
    this.mobile,
    this.businessName,
  });
  
  String get fullName => '$firstName $lastName';
}

