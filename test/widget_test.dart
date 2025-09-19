// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:just_laundrette_app/main.dart';
import 'package:just_laundrette_app/features/auth/providers/auth_provider.dart';

void main() {
  testWidgets('App loads without crashing', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const JustLaundretteApp());

    // Wait for the authentication check to complete
    await tester.pumpAndSettle();

    // Verify that the app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });

  test('AuthProvider login method works correctly', () async {
    final authProvider = AuthProvider();

    // Test successful login
    final result = await authProvider.login(
      'business@laundrette.com',
      'password',
    );
    expect(result, isTrue);
    expect(authProvider.isAuthenticated, isTrue);
    expect(authProvider.currentUserId, isNotNull);
    expect(authProvider.currentLaundretteId, isNotNull);
  });

  testWidgets('Login screen auto-paste functionality works', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const JustLaundretteApp());
    await tester.pumpAndSettle();

    // Find the email and password text fields
    final emailField = find.byType(TextFormField).first;
    final passwordField = find.byType(TextFormField).last;

    // Initially fields should be empty
    expect(tester.widget<TextFormField>(emailField).controller?.text, isEmpty);
    expect(
      tester.widget<TextFormField>(passwordField).controller?.text,
      isEmpty,
    );

    // Find and tap the "Fill Business" button
    final fillBusinessButton = find.text('Fill Business');
    expect(fillBusinessButton, findsOneWidget);

    await tester.tap(fillBusinessButton);
    await tester.pumpAndSettle();

    // Fields should now be filled
    expect(
      tester.widget<TextFormField>(emailField).controller?.text,
      equals('business@laundrette.com'),
    );
    expect(
      tester.widget<TextFormField>(passwordField).controller?.text,
      equals('password'),
    );
  });
}
