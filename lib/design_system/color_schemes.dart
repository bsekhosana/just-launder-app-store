import 'package:flutter/material.dart';

/// App color schemes following Material 3 design principles
/// Vibrant palette with orange primary and white secondary
class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFFfb6406); // Orange - vibrant, energetic
  static const Color onPrimary = Colors.white;
  static const Color primaryContainer = Color(0xFFFFE4D1); // Light orange
  static const Color onPrimaryContainer = Color(0xFFCC4A00); // Dark orange

  // Secondary Colors
  static const Color secondary = Colors.white; // White - clean, professional
  static const Color onSecondary = Color(0xFF1B1B1B); // Dark text on white
  static const Color secondaryContainer = Color(0xFFF8FAFC); // Light grey
  static const Color onSecondaryContainer = Color(0xFF64748B); // Medium grey

  // Tertiary Colors
  static const Color tertiary = Color(
    0xFFF59E0B,
  ); // Orange - attention, warnings
  static const Color onTertiary = Colors.white;
  static const Color tertiaryContainer = Color(0xFFFEF3C7); // Light orange
  static const Color onTertiaryContainer = Color(0xFF92400E); // Dark orange

  // Accent Colors
  static const Color accent = Color(0xFFF59E0B); // Orange - same as tertiary
  static const Color onAccent = Colors.white;

  // Surface Colors
  static const Color surface = Colors.white;
  static const Color onSurface = Color(0xFF1B1B1B); // Dark grey
  static const Color surfaceVariant = Color(0xFFF8FAFC); // Light grey
  static const Color onSurfaceVariant = Color(0xFF64748B); // Medium grey

  // Background Colors
  static const Color background = Color(0xFFF8FAFC); // Light grey
  static const Color onBackground = Color(0xFF1B1B1B); // Dark grey

  // Error Colors
  static const Color error = Color(0xFFE54D2E); // Red
  static const Color onError = Colors.white;
  static const Color errorContainer = Color(0xFFFEE2E2); // Light red
  static const Color onErrorContainer = Color(0xFF991B1B); // Dark red

  // Success Colors
  static const Color success = Color(0xFF20B26C); // Green
  static const Color onSuccess = Colors.white;
  static const Color successContainer = Color(0xFFD1FAE5); // Light green
  static const Color onSuccessContainer = Color(0xFF064E3B); // Dark green

  // Warning Colors
  static const Color warning = Color(0xFFF59E0B); // Orange
  static const Color onWarning = Colors.white;
  static const Color warningContainer = Color(0xFFFEF3C7); // Light orange
  static const Color onWarningContainer = Color(0xFF92400E); // Dark orange

  // Info Colors
  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color onInfo = Colors.white;
  static const Color infoContainer = Color(0xFFDBEAFE); // Light blue
  static const Color onInfoContainer = Color(0xFF1E40AF); // Dark blue

  // Outline Colors
  static const Color outline = Color(0xFFD1D5DB); // Light grey
  static const Color outlineVariant = Color(0xFFE5E7EB); // Very light grey

  // Shadow Colors
  static const Color shadow = Color(0xFF000000);
  static const Color scrim = Color(0xFF000000);

  // Additional UI Colors
  static const Color lightGrey = Color(0xFFF8FAFC);
  static const Color mediumGrey = Color(0xFF64748B);
  static const Color darkGrey = Color(0xFF1B1B1B);
  static const Color successGreen = Color(0xFF20B26C);
  static const Color errorRed = Color(0xFFE54D2E);
  static const Color warningOrange = Color(0xFFF59E0B);
  static const Color textPrimary = Color(0xFF1B1B1B);
  static const Color primaryBlue = Color(0xFF3B82F6);

  // Additional UI Colors
  static const Color surfaceTint = Color(0xFFfb6406);
  static const Color glassSurface = Color(0xCCFFFFFF); // White with 80% opacity

  // Legacy color names for backward compatibility
  // static const Color accent = Color(0xFFF59E0B); // Already defined above
}

/// Material 3 color scheme for the app
class AppColorSchemes {
  static const Color primary = Color(0xFFfb6406);
  static const Color primaryContainer = Color(0xFFFFE4D1);
  static const Color secondary = Color(0xFF625b71);
  static const Color secondaryContainer = Color(0xFFe8def8);
  static const Color tertiary = Color(0xFF7d5260);
  static const Color tertiaryContainer = Color(0xFFffd8e4);
  static const Color error = Color(0xFFba1a1a);
  static const Color errorContainer = Color(0xFFffdad6);
  static const Color background = Color(0xFFfefbff);
  static const Color onBackground = Color(0xFF1a1c18);
  static const Color surface = Color(0xFFfefbff);
  static const Color onSurface = Color(0xFF1a1c18);
  static const Color surfaceVariant = Color(0xFFe7e0ec);
  static const Color onSurfaceVariant = Color(0xFF49454f);
  static const Color outline = Color(0xFF79747e);
  static const Color onInverseSurface = Color(0xFFf4eff4);
  static const Color inverseSurface = Color(0xFF313033);
  static const Color inversePrimary = Color(0xFFffb59c);
  static const Color shadow = Color(0xFF000000);
  static const Color surfaceTint = Color(0xFFfb6406);
  static const Color outlineVariant = Color(0xFFcac4d0);
  static const Color scrim = Color(0xFF000000);
  static const Color warning = Color(0xFFFF9800);
  static const Color textPrimary = Color(0xFF212121);
  static const Color success = Color(0xFF20B26C);
}
