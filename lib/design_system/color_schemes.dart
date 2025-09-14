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
  static const Color warning = Color(0xFFF5A524); // Orange
  static const Color onWarning = Colors.white;
  static const Color warningContainer = Color(0xFFFEF3C7); // Light orange
  static const Color onWarningContainer = Color(0xFF92400E); // Dark orange

  // Neutral Colors
  static const Color outline = Color(0xFFE2E8F0); // Light border
  static const Color outlineVariant = Color(0xFFF1F5F9); // Very light border
  static const Color shadow = Color(0xFF000000); // Black shadow
  static const Color scrim = Color(0xFF000000); // Black overlay

  // Glass Effect Colors
  static const Color glassSurface = Color(0x1AFFFFFF); // 10% white
  static const Color glassBorder = Color(0x33FFFFFF); // 20% white
  static const Color glassOverlay = Color(0x80000000); // 50% black

  // Status Colors
  static const Color info = Color(0xFF3B82F6); // Blue
  static const Color onInfo = Colors.white;
  static const Color infoContainer = Color(0xFFDBEAFE); // Light blue

  // Surface Tint (for Material 3)
  static const Color surfaceTint = primary;

  // Legacy Colors (for backward compatibility)
  static const Color lightGrey = Color(0xFFF1F5F9);
  static const Color mediumGrey = Color(0xFF64748B);
  static const Color darkGrey = Color(0xFF1B1B1B);
  static const Color backgroundGrey = Color(0xFFF8FAFC);
  static const Color primaryBlue = primary;
  static const Color successGreen = success;
  static const Color errorRed = error;
  static const Color warningOrange = warning;
}

/// Dark theme colors (for future implementation)
class AppColorsDark {
  // Primary Colors
  static const Color primary = Color(0xFF60A5FA); // Light blue
  static const Color onPrimary = Color(0xFF1E3A8A); // Dark blue
  static const Color primaryContainer = Color(0xFF1E3A8A); // Dark blue
  static const Color onPrimaryContainer = Color(0xFFDBEAFE); // Light blue

  // Secondary Colors
  static const Color secondary = Color(0xFF34D399); // Light green
  static const Color onSecondary = Color(0xFF064E3B); // Dark green
  static const Color secondaryContainer = Color(0xFF064E3B); // Dark green
  static const Color onSecondaryContainer = Color(0xFFD1FAE5); // Light green

  // Surface Colors
  static const Color surface = Color(0xFF1B1B1B); // Dark grey
  static const Color onSurface = Color(0xFFF8FAFC); // Light grey
  static const Color surfaceVariant = Color(0xFF374151); // Medium dark grey
  static const Color onSurfaceVariant = Color(0xFF9CA3AF); // Light grey

  // Background Colors
  static const Color background = Color(0xFF111827); // Very dark grey
  static const Color onBackground = Color(0xFFF8FAFC); // Light grey

  // Error Colors
  static const Color error = Color(0xFFF87171); // Light red
  static const Color onError = Color(0xFF991B1B); // Dark red
  static const Color errorContainer = Color(0xFF991B1B); // Dark red
  static const Color onErrorContainer = Color(0xFFFEE2E2); // Light red
}

/// Utility class for color operations
class ColorUtils {
  /// Get color with opacity
  static Color withOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }

  /// Get color with alpha
  static Color withAlpha(Color color, int alpha) {
    return color.withAlpha(alpha);
  }

  /// Get glass effect color
  static Color getGlassColor(Color baseColor, double opacity) {
    return baseColor.withOpacity(opacity);
  }

  /// Get surface color with elevation
  static Color getSurfaceColor(Color baseColor, double elevation) {
    final double opacity = (elevation * 0.05).clamp(0.0, 0.12);
    return baseColor.withOpacity(opacity);
  }
}
