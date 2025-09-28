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
import 'features/onboarding/providers/onboarding_provider.dart';
import 'features/connectivity/providers/connectivity_provider.dart';
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
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(
          create: (_) => ConnectivityProvider()..initialize(),
        ),
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

class AppWrapper extends StatefulWidget {
  const AppWrapper({super.key});

  @override
  State<AppWrapper> createState() => _AppWrapperState();
}

class _AppWrapperState extends State<AppWrapper> {
  @override
  void initState() {
    super.initState();
    // Initialize authentication state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      authProvider.checkAuthStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);

    if (authProvider.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (authProvider.isAuthenticated) {
      return const MainNavigationScreen();
    }

    return const LoginScreen();
  }
}
