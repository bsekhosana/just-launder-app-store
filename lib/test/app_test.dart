import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:just_laundrette_app/main.dart';
import 'package:just_laundrette_app/data/services/mock_data_service.dart';
import 'package:just_laundrette_app/features/auth/providers/auth_provider.dart';
import 'package:just_laundrette_app/features/profile/providers/laundrette_profile_provider.dart';
import 'package:just_laundrette_app/features/branches/providers/branch_provider.dart';
import 'package:just_laundrette_app/features/orders/providers/order_provider.dart';
import 'package:just_laundrette_app/features/staff/providers/staff_provider.dart';
import 'package:just_laundrette_app/features/analytics/providers/analytics_provider.dart';
import 'package:just_laundrette_app/features/settings/providers/settings_provider.dart';

void main() {
  group('Just Laundrette App Tests', () {
    testWidgets('App launches successfully', (WidgetTester tester) async {
      await tester.pumpWidget(const JustLaundretteApp());
      await tester.pumpAndSettle();

      // Verify app launches without errors
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Login screen displays correctly', (WidgetTester tester) async {
      await tester.pumpWidget(const JustLaundretteApp());
      await tester.pumpAndSettle();

      // Should show login screen initially
      expect(find.text('Welcome to Just Laundrette'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('Mock data service generates valid data', (
      WidgetTester tester,
    ) async {
      // Test profiles
      final profiles = MockDataService.getMockProfiles();
      expect(profiles.length, greaterThan(0));
      expect(profiles.first.businessName, isNotEmpty);
      expect(profiles.first.email, isNotEmpty);

      // Test subscriptions
      final subscriptions = MockDataService.getMockSubscriptions();
      expect(subscriptions.length, greaterThan(0));
      expect(subscriptions.first.monthlyPrice, greaterThan(0));

      // Test branches
      final branches = MockDataService.getMockBranches();
      expect(branches.length, greaterThan(0));
      expect(branches.first.name, isNotEmpty);
      expect(branches.first.services, isNotEmpty);

      // Test staff
      final staff = MockDataService.getMockStaff();
      expect(staff.length, greaterThan(0));
      expect(staff.first.name, isNotEmpty);
      expect(staff.first.role, isNotNull);

      // Test orders
      final orders = MockDataService.getMockOrders();
      expect(orders.length, greaterThan(0));
      expect(orders.first.customerName, isNotEmpty);
      expect(orders.first.total, greaterThan(0));

      // Test analytics data
      final analytics = MockDataService.getMockAnalyticsData();
      expect(analytics['totalOrders'], greaterThan(0));
      expect(analytics['totalRevenue'], greaterThan(0));
    });
  });

  group('Provider Tests', () {
    testWidgets('AuthProvider works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AuthProvider(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final authProvider = Provider.of<AuthProvider>(context);
                expect(authProvider.isAuthenticated, isFalse);
                return const Text('Test');
              },
            ),
          ),
        ),
      );
    });

    testWidgets('LaundretteProfileProvider works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => LaundretteProfileProvider(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final profileProvider = Provider.of<LaundretteProfileProvider>(
                  context,
                );
                expect(profileProvider.currentProfile, isNull);
                return const Text('Test');
              },
            ),
          ),
        ),
      );
    });

    testWidgets('BranchProvider works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => BranchProvider(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final branchProvider = Provider.of<BranchProvider>(context);
                expect(branchProvider.branches, isEmpty);
                return const Text('Test');
              },
            ),
          ),
        ),
      );
    });

    testWidgets('OrderProvider works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => OrderProvider(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final orderProvider = Provider.of<OrderProvider>(context);
                expect(orderProvider.orders, isEmpty);
                return const Text('Test');
              },
            ),
          ),
        ),
      );
    });

    testWidgets('StaffProvider works correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => StaffProvider(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final staffProvider = Provider.of<StaffProvider>(context);
                expect(staffProvider.staff, isEmpty);
                return const Text('Test');
              },
            ),
          ),
        ),
      );
    });

    testWidgets('AnalyticsProvider works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => AnalyticsProvider(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final analyticsProvider = Provider.of<AnalyticsProvider>(
                  context,
                );
                expect(analyticsProvider.totalOrders, equals(0));
                expect(analyticsProvider.totalRevenue, equals(0.0));
                return const Text('Test');
              },
            ),
          ),
        ),
      );
    });

    testWidgets('SettingsProvider works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final settingsProvider = Provider.of<SettingsProvider>(context);
                expect(settingsProvider.language, equals('English'));
                expect(settingsProvider.currency, equals('USD'));
                expect(settingsProvider.darkMode, isFalse);
                return const Text('Test');
              },
            ),
          ),
        ),
      );
    });
  });

  group('Data Model Tests', () {
    test('LaundretteProfile model works correctly', () {
      final profile = MockDataService.getMockProfiles().first;
      expect(profile.id, isNotEmpty);
      expect(profile.businessName, isNotEmpty);
      expect(profile.email, isNotEmpty);
      expect(profile.isActive, isTrue);
    });

    test('Subscription model works correctly', () {
      final subscription = MockDataService.getMockSubscriptions().first;
      expect(subscription.id, isNotEmpty);
      expect(subscription.monthlyPrice, greaterThan(0));
      expect(subscription.isActive, isTrue);
      expect(subscription.features, isNotEmpty);
    });

    test('LaundretteBranch model works correctly', () {
      final branch = MockDataService.getMockBranches().first;
      expect(branch.id, isNotEmpty);
      expect(branch.name, isNotEmpty);
      expect(branch.services, isNotEmpty);
      expect(branch.operatingHours, isNotEmpty);
    });

    test('LaundretteOrder model works correctly', () {
      final order = MockDataService.getMockOrders().first;
      expect(order.id, isNotEmpty);
      expect(order.customerName, isNotEmpty);
      expect(order.total, greaterThan(0));
      expect(order.orderItems, isNotEmpty);
    });

    test('StaffMember model works correctly', () {
      final staff = MockDataService.getMockStaff().first;
      expect(staff.id, isNotEmpty);
      expect(staff.name, isNotEmpty);
      expect(staff.role, isNotNull);
      expect(staff.permissions, isNotEmpty);
    });
  });

  group('Business Logic Tests', () {
    test('Order total calculation is correct', () {
      final orders = MockDataService.getMockOrders();
      for (final order in orders) {
        final calculatedTotal = order.subtotal + order.tax;
        expect(order.total, equals(calculatedTotal));
      }
    });

    test('Order status transitions are valid', () {
      final orders = MockDataService.getMockOrders();
      for (final order in orders) {
        expect(order.status, isA<LaundretteOrderStatus>());
        expect(order.priority, isA<OrderPriority>());
        expect(order.paymentStatus, isA<PaymentStatus>());
      }
    });

    test('Staff permissions are valid', () {
      final staff = MockDataService.getMockStaff();
      for (final member in staff) {
        expect(member.permissions, isNotEmpty);
        for (final permission in member.permissions) {
          expect(permission, isA<StaffPermission>());
        }
      }
    });

    test('Branch operating hours are valid', () {
      final branches = MockDataService.getMockBranches();
      for (final branch in branches) {
        expect(branch.operatingHours, isNotEmpty);
        expect(branch.operatingHours.keys, contains('monday'));
        expect(branch.operatingHours.keys, contains('sunday'));
      }
    });

    test('Service pricing is valid', () {
      final branches = MockDataService.getMockBranches();
      for (final branch in branches) {
        expect(branch.services, isNotEmpty);
        for (final service in branch.services.entries) {
          expect(service.value, greaterThan(0));
        }
      }
    });
  });

  group('Analytics Data Tests', () {
    test('Analytics data is comprehensive', () {
      final analytics = MockDataService.getMockAnalyticsData();

      expect(analytics['totalOrders'], greaterThan(0));
      expect(analytics['totalRevenue'], greaterThan(0));
      expect(analytics['averageOrderValue'], greaterThan(0));
      expect(analytics['revenueByDay'], isNotEmpty);
      expect(analytics['ordersByDay'], isNotEmpty);
      expect(analytics['revenueByBranch'], isNotEmpty);
      expect(analytics['ordersByBranch'], isNotEmpty);
      expect(analytics['topServices'], isNotEmpty);
      expect(analytics['topCustomers'], isNotEmpty);
      expect(analytics['staffPerformance'], isNotEmpty);
    });

    test('Analytics calculations are correct', () {
      final analytics = MockDataService.getMockAnalyticsData();
      final orders = MockDataService.getMockOrders();

      final expectedTotalOrders = orders.length;
      final expectedTotalRevenue = orders.fold(
        0.0,
        (sum, order) => sum + order.total,
      );
      final expectedAverageOrderValue =
          expectedTotalRevenue / expectedTotalOrders;

      expect(analytics['totalOrders'], equals(expectedTotalOrders));
      expect(analytics['totalRevenue'], closeTo(expectedTotalRevenue, 0.01));
      expect(
        analytics['averageOrderValue'],
        closeTo(expectedAverageOrderValue, 0.01),
      );
    });
  });

  group('Settings Tests', () {
    test('Settings provider has correct defaults', () {
      final settings = SettingsProvider();
      expect(settings.language, equals('English'));
      expect(settings.currency, equals('USD'));
      expect(settings.timezone, equals('UTC'));
      expect(settings.darkMode, isFalse);
      expect(settings.autoSync, isTrue);
      expect(settings.locationServices, isTrue);
    });

    test('Settings can be updated', () {
      final settings = SettingsProvider();

      settings.setLanguage('Spanish');
      expect(settings.language, equals('Spanish'));

      settings.setCurrency('EUR');
      expect(settings.currency, equals('EUR'));

      settings.setDarkMode(true);
      expect(settings.darkMode, isTrue);
    });

    test('Settings can be reset to defaults', () {
      final settings = SettingsProvider();

      // Change some settings
      settings.setLanguage('Spanish');
      settings.setCurrency('EUR');
      settings.setDarkMode(true);

      // Reset to defaults
      settings.resetToDefaults();

      expect(settings.language, equals('English'));
      expect(settings.currency, equals('USD'));
      expect(settings.darkMode, isFalse);
    });

    test('Settings export works correctly', () {
      final settings = SettingsProvider();
      final exported = settings.exportSettings();

      expect(exported, isA<Map<String, dynamic>>());
      expect(exported['general'], isA<Map<String, dynamic>>());
      expect(exported['business'], isA<Map<String, dynamic>>());
      expect(exported['data'], isA<Map<String, dynamic>>());
      expect(exported['security'], isA<Map<String, dynamic>>());
      expect(exported['notifications'], isA<Map<String, dynamic>>());
    });
  });
}
