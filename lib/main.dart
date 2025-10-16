import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'design_system/theme.dart';
import 'core/services/fcm_service.dart';
import 'core/services/site_settings_service.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/profile/providers/laundrette_profile_provider.dart';
import 'features/branches/providers/branch_provider.dart';
import 'features/orders/providers/order_provider.dart';
import 'features/staff/providers/staff_provider.dart';
import 'features/staff/providers/staff_management_provider.dart';
import 'features/orders/providers/tenant_order_provider.dart';
import 'features/orders/data/repositories/tenant_order_repository_impl.dart';
import 'features/analytics/providers/analytics_provider.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/onboarding/providers/onboarding_provider.dart';
import 'features/connectivity/providers/connectivity_provider.dart';
import 'features/notifications/providers/notification_provider.dart';
import 'features/navigation/screens/main_navigation_screen.dart';
import 'features/onboarding/screens/onboarding_status_screen.dart';
import 'features/auth/screens/login_screen.dart';
import 'features/auth/screens/email_verification_awaiting_screen.dart';
import 'features/auth/screens/onboarding_screen.dart';
import 'core/services/auth_handler_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Set up background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize site settings
  await SiteSettingsService().loadSettings();

  runApp(const JustLaundretteApp());
}

class JustLaundretteApp extends StatelessWidget {
  const JustLaundretteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => LaundretteProfileProvider()),
        ChangeNotifierProvider(create: (_) => BranchProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => StaffProvider()),
        ChangeNotifierProvider(create: (_) => StaffManagementProvider()),
        ChangeNotifierProvider(
          create:
              (_) =>
                  TenantOrderProvider(repository: TenantOrderRepositoryImpl()),
        ),
        ChangeNotifierProvider(create: (_) => AnalyticsProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => OnboardingProvider()),
        ChangeNotifierProvider(
          create: (_) => ConnectivityProvider()..initialize(),
        ),
        ChangeNotifierProvider(
          create: (_) => NotificationProvider()..initialize(),
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
    // Initialize the auth handler service
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      AuthHandlerService().initialize(authProvider, context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);

    // Show loading screen while initializing authentication
    if (authProvider.isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    // Check authentication and route appropriately
    if (authProvider.isAuthenticated) {
      final tenant = authProvider.currentTenant;

      // Check email verification
      if (tenant != null && !tenant.isEmailVerified) {
        return EmailVerificationAwaitingScreen(email: tenant.email);
      }

      // Check onboarding completion
      if (tenant != null && !tenant.onboardingCompleted) {
        return const OnboardingStatusScreen();
      }

      // All checks passed, show main navigation
      return const MainNavigationScreen();
    }

    return const LoginScreen();
  }
}
