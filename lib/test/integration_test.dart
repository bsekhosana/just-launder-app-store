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
  group('Integration Tests', () {
    testWidgets(
      'Complete user flow: Login -> Dashboard -> Orders -> Analytics -> Settings',
      (WidgetTester tester) async {
        // Start with the app
        await tester.pumpWidget(const JustLaundretteApp());
        await tester.pumpAndSettle();

        // Verify login screen is displayed
        expect(find.text('Welcome to Just Laundrette'), findsOneWidget);
        expect(find.text('Email'), findsOneWidget);
        expect(find.text('Password'), findsOneWidget);

        // Simulate login
        await tester.enterText(
          find.byKey(const Key('email_field')),
          'business@cleanfresh.com',
        );
        await tester.enterText(
          find.byKey(const Key('password_field')),
          'password123',
        );
        await tester.tap(find.text('Login'));
        await tester.pumpAndSettle();

        // Verify main navigation is displayed
        expect(find.text('Dashboard'), findsOneWidget);
        expect(find.text('Orders'), findsOneWidget);
        expect(find.text('Branches'), findsOneWidget);
        expect(find.text('Staff'), findsOneWidget);
        expect(find.text('Analytics'), findsOneWidget);
        expect(find.text('Settings'), findsOneWidget);
      },
    );

    testWidgets('Order management flow works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => LaundretteProfileProvider()),
            ChangeNotifierProvider(create: (_) => BranchProvider()),
            ChangeNotifierProvider(create: (_) => OrderProvider()),
            ChangeNotifierProvider(create: (_) => StaffProvider()),
            ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final orderProvider = Provider.of<OrderProvider>(context);

                // Load mock orders
                orderProvider.loadOrders('laundrette_business_1');

                return Scaffold(
                  body: ListView.builder(
                    itemCount: orderProvider.orders.length,
                    itemBuilder: (context, index) {
                      final order = orderProvider.orders[index];
                      return ListTile(
                        title: Text(order.customerName),
                        subtitle: Text('Order #${order.id}'),
                        trailing: Text('\$${order.total.toStringAsFixed(2)}'),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify orders are loaded
      expect(find.text('Order #'), findsWidgets);
    });

    testWidgets('Branch management flow works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => LaundretteProfileProvider()),
            ChangeNotifierProvider(create: (_) => BranchProvider()),
            ChangeNotifierProvider(create: (_) => OrderProvider()),
            ChangeNotifierProvider(create: (_) => StaffProvider()),
            ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final branchProvider = Provider.of<BranchProvider>(context);

                // Load mock branches
                branchProvider.loadBranches('laundrette_business_1');

                return Scaffold(
                  body: ListView.builder(
                    itemCount: branchProvider.branches.length,
                    itemBuilder: (context, index) {
                      final branch = branchProvider.branches[index];
                      return ListTile(
                        title: Text(branch.name),
                        subtitle: Text(branch.address),
                        trailing: Text(branch.status.name),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify branches are loaded
      expect(find.text('Downtown Branch'), findsOneWidget);
      expect(find.text('Uptown Branch'), findsOneWidget);
    });

    testWidgets('Staff management flow works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => LaundretteProfileProvider()),
            ChangeNotifierProvider(create: (_) => BranchProvider()),
            ChangeNotifierProvider(create: (_) => OrderProvider()),
            ChangeNotifierProvider(create: (_) => StaffProvider()),
            ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final staffProvider = Provider.of<StaffProvider>(context);

                // Load mock staff
                staffProvider.loadStaff('laundrette_business_1');

                return Scaffold(
                  body: ListView.builder(
                    itemCount: staffProvider.staff.length,
                    itemBuilder: (context, index) {
                      final staff = staffProvider.staff[index];
                      return ListTile(
                        title: Text(staff.name),
                        subtitle: Text(staff.role.name),
                        trailing: Text(staff.status.name),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify staff are loaded
      expect(find.text('John Smith'), findsOneWidget);
      expect(find.text('Sarah Johnson'), findsOneWidget);
    });

    testWidgets('Analytics dashboard works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => LaundretteProfileProvider()),
            ChangeNotifierProvider(create: (_) => BranchProvider()),
            ChangeNotifierProvider(create: (_) => OrderProvider()),
            ChangeNotifierProvider(create: (_) => StaffProvider()),
            ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final analyticsProvider = Provider.of<AnalyticsProvider>(
                  context,
                );
                final orderProvider = Provider.of<OrderProvider>(context);
                final branchProvider = Provider.of<BranchProvider>(context);
                final staffProvider = Provider.of<StaffProvider>(context);

                // Load mock data
                orderProvider.loadOrders('laundrette_business_1');
                branchProvider.loadBranches('laundrette_business_1');
                staffProvider.loadStaff('laundrette_business_1');

                // Load analytics
                analyticsProvider.loadAnalytics(
                  orders: orderProvider.orders,
                  branches: branchProvider.branches,
                  staff: staffProvider.staff,
                );

                return Scaffold(
                  body: Column(
                    children: [
                      Text('Total Orders: ${analyticsProvider.totalOrders}'),
                      Text(
                        'Total Revenue: \$${analyticsProvider.totalRevenue.toStringAsFixed(2)}',
                      ),
                      Text(
                        'Average Order Value: \$${analyticsProvider.averageOrderValue.toStringAsFixed(2)}',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify analytics are loaded
      expect(find.text('Total Orders:'), findsOneWidget);
      expect(find.text('Total Revenue:'), findsOneWidget);
      expect(find.text('Average Order Value:'), findsOneWidget);
    });

    testWidgets('Settings management works correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (_) => AuthProvider()),
            ChangeNotifierProvider(create: (_) => LaundretteProfileProvider()),
            ChangeNotifierProvider(create: (_) => BranchProvider()),
            ChangeNotifierProvider(create: (_) => OrderProvider()),
            ChangeNotifierProvider(create: (_) => StaffProvider()),
            ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
            ChangeNotifierProvider(create: (_) => SettingsProvider()),
          ],
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                final settingsProvider = Provider.of<SettingsProvider>(context);

                return Scaffold(
                  body: Column(
                    children: [
                      Text('Language: ${settingsProvider.language}'),
                      Text('Currency: ${settingsProvider.currency}'),
                      Text('Dark Mode: ${settingsProvider.darkMode}'),
                      ElevatedButton(
                        onPressed:
                            () => settingsProvider.setLanguage('Spanish'),
                        child: const Text('Change Language'),
                      ),
                      ElevatedButton(
                        onPressed: () => settingsProvider.setDarkMode(true),
                        child: const Text('Enable Dark Mode'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify settings are displayed
      expect(find.text('Language: English'), findsOneWidget);
      expect(find.text('Currency: USD'), findsOneWidget);
      expect(find.text('Dark Mode: false'), findsOneWidget);

      // Test settings changes
      await tester.tap(find.text('Change Language'));
      await tester.pumpAndSettle();
      expect(find.text('Language: Spanish'), findsOneWidget);

      await tester.tap(find.text('Enable Dark Mode'));
      await tester.pumpAndSettle();
      expect(find.text('Dark Mode: true'), findsOneWidget);
    });
  });

  group('Data Validation Tests', () {
    test('Mock data is consistent and valid', () {
      final profiles = MockDataService.getMockProfiles();
      final subscriptions = MockDataService.getMockSubscriptions();
      final branches = MockDataService.getMockBranches();
      final staff = MockDataService.getMockStaff();
      final orders = MockDataService.getMockOrders();

      // Verify data consistency
      for (final profile in profiles) {
        expect(profile.id, isNotEmpty);
        expect(profile.businessName, isNotEmpty);
        expect(profile.email, contains('@'));
        expect(profile.phoneNumber, startsWith('+1-555-'));
      }

      for (final subscription in subscriptions) {
        expect(subscription.id, isNotEmpty);
        expect(subscription.monthlyPrice, greaterThan(0));
        expect(subscription.features, isNotEmpty);
      }

      for (final branch in branches) {
        expect(branch.id, isNotEmpty);
        expect(branch.name, isNotEmpty);
        expect(branch.services, isNotEmpty);
        expect(branch.operatingHours, isNotEmpty);
      }

      for (final member in staff) {
        expect(member.id, isNotEmpty);
        expect(member.name, isNotEmpty);
        expect(member.role, isNotNull);
        expect(member.permissions, isNotEmpty);
      }

      for (final order in orders) {
        expect(order.id, isNotEmpty);
        expect(order.customerName, isNotEmpty);
        expect(order.total, greaterThan(0));
        expect(order.orderItems, isNotEmpty);
      }
    });

    test('Analytics data is mathematically correct', () {
      final orders = MockDataService.getMockOrders();
      final analytics = MockDataService.getMockAnalyticsData();

      // Verify total orders
      expect(analytics['totalOrders'], equals(orders.length));

      // Verify total revenue
      final expectedRevenue = orders.fold(
        0.0,
        (sum, order) => sum + order.total,
      );
      expect(analytics['totalRevenue'], closeTo(expectedRevenue, 0.01));

      // Verify average order value
      final expectedAverage = expectedRevenue / orders.length;
      expect(analytics['averageOrderValue'], closeTo(expectedAverage, 0.01));

      // Verify order counts by status
      final completedOrders =
          orders
              .where((o) => o.status == LaundretteOrderStatus.delivered)
              .length;
      expect(analytics['completedOrders'], equals(completedOrders));
    });

    test('Business logic constraints are respected', () {
      final profiles = MockDataService.getMockProfiles();
      final subscriptions = MockDataService.getMockSubscriptions();
      final branches = MockDataService.getMockBranches();
      final staff = MockDataService.getMockStaff();

      // Verify subscription limits
      for (final subscription in subscriptions) {
        final maxBranches = subscription.getFeature(
          SubscriptionFeatures.maxBranches,
        );
        final maxStaff = subscription.getFeature(SubscriptionFeatures.maxStaff);

        expect(maxBranches, greaterThan(0));
        expect(maxStaff, greaterThan(0));
      }

      // Verify branch-staff relationships
      for (final member in staff) {
        final branch = branches.firstWhere((b) => b.id == member.branchId);
        expect(branch, isNotNull);
        expect(branch.laundretteId, equals(member.laundretteId));
      }

      // Verify order-branch relationships
      final orders = MockDataService.getMockOrders();
      for (final order in orders) {
        final branch = branches.firstWhere((b) => b.id == order.branchId);
        expect(branch, isNotNull);
        expect(branch.laundretteId, equals(order.laundretteId));
      }
    });
  });

  group('Performance Tests', () {
    test('Mock data generation is performant', () {
      final stopwatch = Stopwatch()..start();

      // Generate all mock data
      MockDataService.getMockProfiles();
      MockDataService.getMockSubscriptions();
      MockDataService.getMockBranches();
      MockDataService.getMockStaff();
      MockDataService.getMockOrders();
      MockDataService.getMockAnalyticsData();

      stopwatch.stop();

      // Should complete within reasonable time (1 second)
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });

    test('Analytics calculations are performant', () {
      final orders = MockDataService.getMockOrders();
      final branches = MockDataService.getMockBranches();
      final staff = MockDataService.getMockStaff();

      final stopwatch = Stopwatch()..start();

      // Simulate analytics calculation
      final analytics = MockDataService.getMockAnalyticsData();

      stopwatch.stop();

      // Should complete within reasonable time (500ms)
      expect(stopwatch.elapsedMilliseconds, lessThan(500));
    });
  });
}

