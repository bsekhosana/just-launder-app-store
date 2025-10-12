import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'test_config.dart';

/// Helper methods for authentication tests - Laundrette App
class AuthHelpers {
  /// Enter text into a field identified by ValueKey
  static Future<void> enterText(
    WidgetTester tester,
    String key,
    String text, {
    Duration delay = const Duration(milliseconds: 100),
  }) async {
    final finder = find.byKey(ValueKey(key));
    expect(finder, findsOneWidget, reason: 'Field with key "$key" not found');
    
    await tester.enterText(finder, text);
    await tester.pump(delay);
  }
  
  /// Tap a button or widget identified by ValueKey
  static Future<void> tapButton(
    WidgetTester tester,
    String key, {
    Duration settleDelay = const Duration(milliseconds: 500),
  }) async {
    final finder = find.byKey(ValueKey(key));
    expect(finder, findsOneWidget, reason: 'Button with key "$key" not found');
    
    await tester.tap(finder);
    await tester.pumpAndSettle(settleDelay);
  }
  
  /// Wait for a screen to appear by searching for text
  static Future<void> waitForScreen(
    WidgetTester tester,
    String screenText, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tester.pumpAndSettle();
    
    final deadline = DateTime.now().add(timeout);
    while (DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 100));
      
      if (find.text(screenText).evaluate().isNotEmpty) {
        return;
      }
    }
    
    fail('Screen with text "$screenText" did not appear within $timeout');
  }
  
  /// Wait for a widget by key to appear
  static Future<void> waitForWidget(
    WidgetTester tester,
    String key, {
    Duration timeout = const Duration(seconds: 5),
  }) async {
    await tester.pumpAndSettle();
    
    final deadline = DateTime.now().add(timeout);
    final finder = find.byKey(ValueKey(key));
    
    while (DateTime.now().isBefore(deadline)) {
      await tester.pump(const Duration(milliseconds: 100));
      
      if (finder.evaluate().isNotEmpty) {
        return;
      }
    }
    
    fail('Widget with key "$key" did not appear within $timeout');
  }
  
  /// Verify that an error message is displayed
  static void expectErrorMessage(String errorText) {
    expect(
      find.text(errorText),
      findsOneWidget,
      reason: 'Error message "$errorText" not found',
    );
  }
  
  /// Verify that a success message is displayed
  static void expectSuccessMessage(String successText) {
    expect(
      find.text(successText),
      findsOneWidget,
      reason: 'Success message "$successText" not found',
    );
  }
  
  /// Login with provided credentials
  static Future<void> login(
    WidgetTester tester, {
    required String email,
    required String password,
  }) async {
    await enterText(tester, TestConfig.loginEmailKey, email);
    await enterText(tester, TestConfig.loginPasswordKey, password);
    await tapButton(tester, TestConfig.loginButtonKey);
    
    // Wait for navigation
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
  
  /// Login with a test account
  static Future<void> loginWithAccount(
    WidgetTester tester,
    TestAccount account,
  ) async {
    await login(
      tester,
      email: account.email,
      password: account.password,
    );
  }
  
  /// Logout (assumes logout button is accessible)
  static Future<void> logout(WidgetTester tester) async {
    await tapButton(tester, TestConfig.onboardingLogoutButtonKey);
    await tester.pumpAndSettle();
  }
  
  /// Enter OTP code
  static Future<void> enterOtp(
    WidgetTester tester,
    String otp, {
    String keyPrefix = 'auth.laundrette.verify.otp',
  }) async {
    for (int i = 0; i < otp.length; i++) {
      final key = '$keyPrefix.$i';
      final finder = find.byKey(ValueKey(key));
      
      if (finder.evaluate().isNotEmpty) {
        await tester.enterText(finder, otp[i]);
        await tester.pump(TestConfig.otpInputDelay);
      }
    }
    
    await tester.pumpAndSettle();
  }
  
  /// Verify email with OTP
  static Future<void> verifyEmail(
    WidgetTester tester,
    String otp,
  ) async {
    await enterOtp(tester, otp);
    await tapButton(tester, TestConfig.verifyEmailSubmitKey);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
  
  /// Sign up a new laundrette
  static Future<void> signup(
    WidgetTester tester, {
    required String businessType,
    required String businessName,
    required String firstName,
    required String lastName,
    required String email,
    required String mobile,
    required String password,
    required String confirmPassword,
    bool acceptTerms = true,
  }) async {
    // Select business type (business or private)
    await tapButton(tester, TestConfig.signupBusinessTypeKey);
    await tester.pumpAndSettle();
    
    await enterText(tester, TestConfig.signupBusinessNameKey, businessName);
    await enterText(tester, TestConfig.signupFirstNameKey, firstName);
    await enterText(tester, TestConfig.signupLastNameKey, lastName);
    await enterText(tester, TestConfig.signupEmailKey, email);
    await enterText(tester, TestConfig.signupMobileKey, mobile);
    await enterText(tester, TestConfig.signupPasswordKey, password);
    await enterText(tester, TestConfig.signupConfirmPasswordKey, confirmPassword);
    
    if (acceptTerms) {
      await tapButton(tester, TestConfig.signupTermsCheckboxKey);
    }
    
    await tapButton(tester, TestConfig.signupSubmitButtonKey);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
  
  /// Request password reset
  static Future<void> requestPasswordReset(
    WidgetTester tester,
    String email,
  ) async {
    await enterText(tester, TestConfig.forgotPasswordEmailKey, email);
    await tapButton(tester, TestConfig.forgotPasswordSubmitKey);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
  
  /// Reset password with OTP
  static Future<void> resetPassword(
    WidgetTester tester, {
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    await enterText(tester, TestConfig.resetPasswordEmailKey, email);
    await enterText(tester, TestConfig.resetPasswordOtpKey, otp);
    await enterText(tester, TestConfig.resetPasswordNewPasswordKey, newPassword);
    await enterText(tester, TestConfig.resetPasswordConfirmPasswordKey, confirmPassword);
    await tapButton(tester, TestConfig.resetPasswordSubmitKey);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
  
  /// Wait for onboarding screen
  static Future<void> waitForOnboardingScreen(WidgetTester tester) async {
    await waitForWidget(tester, TestConfig.onboardingStatusCardKey);
  }
  
  /// Click demo credentials
  static Future<void> useDemoCredentials(
    WidgetTester tester,
    String accountName,
  ) async {
    // Find and tap the specific demo account
    final finder = find.text(accountName);
    expect(finder, findsOneWidget, reason: 'Demo account "$accountName" not found');
    await tester.tap(finder);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
  
  /// Create staff account (for cross-app testing)
  static Future<void> createStaffAccount(
    WidgetTester tester, {
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String branch,
    required String role,
  }) async {
    await enterText(tester, TestConfig.staffCreateEmailKey, email);
    await enterText(tester, TestConfig.staffCreatePasswordKey, password);
    await enterText(tester, TestConfig.staffCreateFirstNameKey, firstName);
    await enterText(tester, TestConfig.staffCreateLastNameKey, lastName);
    await enterText(tester, TestConfig.staffCreateBranchKey, branch);
    await enterText(tester, TestConfig.staffCreateRoleKey, role);
    await tapButton(tester, TestConfig.staffCreateSubmitKey);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  }
  
  /// Clear all text fields
  static Future<void> clearTextField(
    WidgetTester tester,
    String key,
  ) async {
    final finder = find.byKey(ValueKey(key));
    if (finder.evaluate().isNotEmpty) {
      await tester.enterText(finder, '');
      await tester.pump();
    }
  }
  
  /// Scroll to make a widget visible
  static Future<void> scrollToWidget(
    WidgetTester tester,
    String key,
  ) async {
    final finder = find.byKey(ValueKey(key));
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
  }
  
  /// Verify that user is on login screen
  static void expectLoginScreen() {
    expect(find.text('Sign In'), findsWidgets);
    expect(find.byKey(const ValueKey(TestConfig.loginButtonKey)), findsOneWidget);
  }
  
  /// Verify that user is on main/dashboard screen
  static void expectMainScreen() {
    expect(find.text('Dashboard'), findsOneWidget);
  }
  
  /// Verify that user is on email verification screen
  static void expectEmailVerificationScreen() {
    expect(find.text('Verify Your Email'), findsOneWidget);
    expect(find.byKey(const ValueKey(TestConfig.verifyEmailSubmitKey)), findsOneWidget);
  }
  
  /// Verify that user is on onboarding screen
  static void expectOnboardingScreen() {
    expect(find.byKey(const ValueKey(TestConfig.onboardingStatusCardKey)), findsOneWidget);
  }
  
  /// Take a screenshot (for debugging)
  static Future<void> takeScreenshot(
    WidgetTester tester,
    String name,
  ) async {
    await tester.pumpAndSettle();
    print('📸 Screenshot: $name');
  }
}

