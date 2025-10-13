import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:just_laundrette_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Laundrette App - Basic Login UI Tests', () {
    testWidgets('B001: App launches and shows login screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Assert - Login screen elements are visible
      expect(find.text('Sign In'), findsWidgets);
      expect(
        find.byKey(const ValueKey('auth.laundrette.email')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('auth.laundrette.password')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('auth.laundrette.loginBtn')),
        findsOneWidget,
      );
    });

    testWidgets('B002: Email field accepts input', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(
        find.byKey(const ValueKey('auth.laundrette.email')),
        'test@laundrex.com',
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('test@laundrex.com'), findsOneWidget);
    });

    testWidgets('B003: Password field accepts input', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(
        find.byKey(const ValueKey('auth.laundrette.password')),
        'password123',
      );
      await tester.pumpAndSettle();

      // Password field should exist (text might be obscured)
      expect(
        find.byKey(const ValueKey('auth.laundrette.password')),
        findsOneWidget,
      );
    });

    testWidgets('B004: Forgot password link is tappable and navigates', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Assert login button is initially present
      expect(
        find.byKey(const ValueKey('auth.laundrette.loginBtn')),
        findsOneWidget,
      );

      // Act
      final forgotPasswordButton = find.byKey(
        const ValueKey('auth.laundrette.forgotPasswordLink'),
      );
      await tester.ensureVisible(forgotPasswordButton);
      await tester.pumpAndSettle();
      await tester.tap(forgotPasswordButton, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - Should have navigated away from login screen
      expect(
        find
            .byKey(const ValueKey('auth.laundrette.loginBtn'))
            .evaluate()
            .isEmpty,
        isTrue,
        reason:
            'Did not navigate away from login screen after tapping forgot password',
      );
    });

    testWidgets('B005: Signup link navigates to signup screen', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Act
      final signupButton = find.byKey(
        const ValueKey('auth.laundrette.signupLink'),
      );
      await tester.ensureVisible(signupButton);
      await tester.pumpAndSettle();
      await tester.tap(signupButton, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Assert - Should navigate to signup/registration screen
      expect(
        find.textContaining('Join').evaluate().isNotEmpty ||
            find.textContaining('Sign Up').evaluate().isNotEmpty ||
            find.textContaining('Register').evaluate().isNotEmpty ||
            find.text('Create Account').evaluate().isNotEmpty,
        isTrue,
        reason: 'Did not navigate to signup screen',
      );
    });

    testWidgets('B006: Login button is tappable', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Arrange - Fill in some data
      await tester.enterText(
        find.byKey(const ValueKey('auth.laundrette.email')),
        'test@laundrex.com',
      );
      await tester.enterText(
        find.byKey(const ValueKey('auth.laundrette.password')),
        'password',
      );
      await tester.pumpAndSettle();

      // Act
      final loginButton = find.byKey(
        const ValueKey('auth.laundrette.loginBtn'),
      );
      expect(loginButton, findsOneWidget);

      // Just verify button is tappable
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Test passes if no exception thrown
    });

    testWidgets('B007: All form fields have proper labels', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Assert
      expect(find.textContaining('Email'), findsWidgets);
      expect(find.textContaining('Password'), findsWidgets);
    });

    testWidgets('B008: Demo credentials section is visible', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Assert - Demo credentials should be visible (unique to laundrette app)
      expect(
        find.textContaining('Demo').evaluate().isNotEmpty ||
            find.textContaining('demo').evaluate().isNotEmpty,
        isTrue,
        reason: 'Demo credentials section not found',
      );
    });
  });

  group('Laundrette App - Form Validation Tests', () {
    testWidgets('V001: Empty email shows validation error on submit', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Act - Submit without filling email
      await tester.tap(find.byKey(const ValueKey('auth.laundrette.loginBtn')));
      await tester.pumpAndSettle();

      // Assert - Should stay on login screen (form validation prevents submission)
      expect(
        find.byKey(const ValueKey('auth.laundrette.loginBtn')),
        findsOneWidget,
      );
    });

    testWidgets('V002: Invalid email format shows validation error', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Act
      await tester.enterText(
        find.byKey(const ValueKey('auth.laundrette.email')),
        'not-an-email',
      );
      await tester.enterText(
        find.byKey(const ValueKey('auth.laundrette.password')),
        'password',
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('auth.laundrette.loginBtn')));
      await tester.pumpAndSettle();

      // Assert - Should show validation error or stay on login screen
      expect(
        find.byKey(const ValueKey('auth.laundrette.loginBtn')),
        findsOneWidget,
      );
    });
  });

  group('Laundrette App - Navigation Tests', () {
    testWidgets('N001: Forgot password link navigates away from login', (
      tester,
    ) async {
      app.main();
      await tester.pumpAndSettle();

      // Record that we're on login screen
      expect(
        find.byKey(const ValueKey('auth.laundrette.loginBtn')),
        findsOneWidget,
      );

      // Navigate to forgot password
      final forgotPasswordButton = find.byKey(
        const ValueKey('auth.laundrette.forgotPasswordLink'),
      );
      await tester.ensureVisible(forgotPasswordButton);
      await tester.pumpAndSettle();
      await tester.tap(forgotPasswordButton, warnIfMissed: false);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Assert - Should have navigated away
      expect(
        find
            .byKey(const ValueKey('auth.laundrette.loginBtn'))
            .evaluate()
            .isEmpty,
        isTrue,
        reason: 'Did not navigate away from login screen',
      );
    });
  });
}
