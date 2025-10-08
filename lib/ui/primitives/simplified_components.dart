import 'package:flutter/material.dart';

// Simplified components to resolve compilation errors
class SpacingUtils {
  static EdgeInsets horizontal(double spacing) => EdgeInsets.symmetric(horizontal: spacing);
  static EdgeInsets vertical(double spacing) => EdgeInsets.symmetric(vertical: spacing);
  static EdgeInsets all(double spacing) => EdgeInsets.all(spacing);
  static EdgeInsets only({
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) => EdgeInsets.only(
    top: top ?? 0,
    bottom: bottom ?? 0,
    left: left ?? 0,
    right: right ?? 0,
  );
}

class Radii {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;
}

class AppColors {
  static const Color primary = Color(0xFFfb6406);
  static const Color secondary = Color(0xFF625b71);
  static const Color error = Color(0xFFba1a1a);
  static const Color surface = Color(0xFFfefbff);
  static const Color background = Color(0xFFfefbff);
  static const Color onPrimary = Colors.white;
  static const Color onSecondary = Colors.white;
  static const Color onError = Colors.white;
  static const Color onSurface = Color(0xFF1a1c18);
  static const Color onBackground = Color(0xFF1a1c18);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);
  static const Color successContainer = Color(0xFFE8F5E8);
  static const Color warningContainer = Color(0xFFFFF3E0);
  static const Color errorContainer = Color(0xFFFFEBEE);
  static const Color infoContainer = Color(0xFFE3F2FD);
  static const Color onSuccessContainer = Color(0xFF1B5E20);
  static const Color onWarningContainer = Color(0xFFE65100);
  static const Color onErrorContainer = Color(0xFFB71C1C);
  static const Color onInfo = Color(0xFF0D47A1);
  static const Color surfaceVariant = Color(0xFFe7e0ec);
  static const Color onSurfaceVariant = Color(0xFF49454f);
  static const Color outline = Color(0xFF79747e);
  static const Color glassSurface = Color(0x1AFFFFFF);
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;
  
  // Additional spacing for UI components
  static const double s = sm;
  static const double m = md;
  static const double l = lg;
  static const double cardPadding = md;
  static const double inputPadding = md;
}

class AppTypography {
  static const TextStyle displayLarge = TextStyle(fontSize: 57, fontWeight: FontWeight.w400);
  static const TextStyle displayMedium = TextStyle(fontSize: 45, fontWeight: FontWeight.w400);
  static const TextStyle displaySmall = TextStyle(fontSize: 36, fontWeight: FontWeight.w400);
  static const TextStyle headlineLarge = TextStyle(fontSize: 32, fontWeight: FontWeight.w400);
  static const TextStyle headlineMedium = TextStyle(fontSize: 28, fontWeight: FontWeight.w400);
  static const TextStyle headlineSmall = TextStyle(fontSize: 24, fontWeight: FontWeight.w400);
  static const TextStyle titleLarge = TextStyle(fontSize: 22, fontWeight: FontWeight.w400);
  static const TextStyle titleMedium = TextStyle(fontSize: 16, fontWeight: FontWeight.w500);
  static const TextStyle titleSmall = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static const TextStyle bodyLarge = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static const TextStyle bodyMedium = TextStyle(fontSize: 14, fontWeight: FontWeight.w400);
  static const TextStyle bodySmall = TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
  static const TextStyle labelLarge = TextStyle(fontSize: 14, fontWeight: FontWeight.w500);
  static const TextStyle labelMedium = TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
  static const TextStyle labelSmall = TextStyle(fontSize: 11, fontWeight: FontWeight.w500);
  static const TextStyle inputLabel = TextStyle(fontSize: 12, fontWeight: FontWeight.w500);
  static const TextStyle inputText = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static const TextStyle inputHint = TextStyle(fontSize: 16, fontWeight: FontWeight.w400);
  static const TextStyle errorText = TextStyle(fontSize: 12, fontWeight: FontWeight.w400);
}
