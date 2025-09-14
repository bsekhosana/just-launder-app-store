import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'design_system/theme.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/profile/providers/laundrette_profile_provider.dart';
import 'features/branches/providers/branch_provider.dart';
import 'features/orders/providers/order_provider.dart';
import 'features/staff/providers/staff_provider.dart';
import 'features/analytics/providers/analytics_provider.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/navigation/screens/main_navigation_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';

void main() {
  runApp(const JustLaundretteApp());
}

class JustLaundretteApp extends StatelessWidget {
  const JustLaundretteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LaundretteProfileProvider()),
        ChangeNotifierProvider(create: (_) => BranchProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
      ],
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MaterialApp(
          title: 'Just Launder',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const AppWrapper(),
          routes: {
            '/login': (context) => const LoginScreen(),
            '/onboarding': (context) => const OnboardingScreen(),
          },
        ),
      ),
    );
  }
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        print(
          'AppWrapper: isLoading=${authProvider.isLoading}, isAuthenticated=${authProvider.isAuthenticated}',
        );

        if (authProvider.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (authProvider.isAuthenticated) {
          print('AppWrapper: Navigating to MainNavigationScreen');
          return const MainNavigationScreen();
        }

        print('AppWrapper: Navigating to LoginScreen');
        return const LoginScreen();
      },
    );
  }
}
