import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'color_schemes.dart';
import 'typography.dart';
import 'spacing.dart';
import 'radii.dart';
import 'elevations.dart';

/// App theme system following Material 3 design principles
/// Provides comprehensive theming for the Just Laundrette app
class AppTheme {
  /// Light theme configuration
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.onPrimaryContainer,
      secondary: AppColors.secondary,
      onSecondary: AppColors.onSecondary,
      secondaryContainer: AppColors.secondaryContainer,
      onSecondaryContainer: AppColors.onSecondaryContainer,
      tertiary: AppColors.tertiary,
      onTertiary: AppColors.onTertiary,
      tertiaryContainer: AppColors.tertiaryContainer,
      onTertiaryContainer: AppColors.onTertiaryContainer,
      error: AppColors.error,
      onError: AppColors.onError,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.onErrorContainer,
      surface: AppColors.surface,
      onSurface: AppColors.onSurface,
      surfaceVariant: AppColors.surfaceVariant,
      onSurfaceVariant: AppColors.onSurfaceVariant,
      background: AppColors.background,
      onBackground: AppColors.onBackground,
      outline: AppColors.outline,
      outlineVariant: AppColors.outlineVariant,
      shadow: AppColors.shadow,
      scrim: AppColors.scrim,
      surfaceTint: AppColors.surfaceTint,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      textTheme: AppTypography.textTheme,
      scaffoldBackgroundColor: colorScheme.background,

      // App Bar Theme
      appBarTheme: AppBarTheme(
        elevation: AppElevations.appBar,
        backgroundColor: colorScheme.surface.withOpacity(0.9),
        foregroundColor: colorScheme.onSurface,
        centerTitle: false,
        titleTextStyle: AppTypography.appBarTitle.copyWith(
          color: colorScheme.onSurface,
        ),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        elevation: AppElevations.card,
        shape: RoundedRectangleBorder(borderRadius: Radii.card),
        color: colorScheme.surface,
        shadowColor: colorScheme.shadow.withOpacity(0.1),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: AppElevations.button,
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: AppTypography.buttonText,
          shape: RoundedRectangleBorder(borderRadius: Radii.button),
          padding: SpacingUtils.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          minimumSize: const Size(64, 48),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: AppTypography.buttonText,
          shape: RoundedRectangleBorder(borderRadius: Radii.button),
          padding: SpacingUtils.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          minimumSize: const Size(64, 48),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colorScheme.primary,
          textStyle: AppTypography.buttonText,
          side: BorderSide(
            color: colorScheme.outline,
            width: AppSpacing.borderWidth,
          ),
          shape: RoundedRectangleBorder(borderRadius: Radii.button),
          padding: SpacingUtils.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          minimumSize: const Size(64, 48),
        ),
      ),

      // Filled Button Theme
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textStyle: AppTypography.buttonText,
          shape: RoundedRectangleBorder(borderRadius: Radii.button),
          padding: SpacingUtils.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.m,
          ),
          minimumSize: const Size(64, 48),
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: AppSpacing.borderWidth,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(
            color: colorScheme.outline,
            width: AppSpacing.borderWidth,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(
            color: colorScheme.primary,
            width: AppSpacing.borderWidthThick,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppSpacing.borderWidthThick,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: Radii.input,
          borderSide: BorderSide(
            color: colorScheme.error,
            width: AppSpacing.borderWidthThick,
          ),
        ),
        contentPadding: SpacingUtils.all(AppSpacing.inputPadding),
        labelStyle: AppTypography.inputLabel.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        hintStyle: AppTypography.inputHint.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        errorStyle: AppTypography.errorText.copyWith(color: colorScheme.error),
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: colorScheme.surfaceVariant,
        selectedColor: colorScheme.primaryContainer,
        disabledColor: colorScheme.surfaceVariant.withOpacity(0.38),
        labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        secondaryLabelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: colorScheme.onPrimaryContainer,
        ),
        padding: SpacingUtils.symmetric(
          horizontal: AppSpacing.m,
          vertical: AppSpacing.s,
        ),
        shape: RoundedRectangleBorder(borderRadius: Radii.chip),
        side: BorderSide(
          color: colorScheme.outline,
          width: AppSpacing.borderWidth,
        ),
        elevation: AppElevations.chip,
      ),

      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primaryContainer;
          }
          return colorScheme.surfaceVariant;
        }),
      ),

      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(colorScheme.onPrimary),
        side: BorderSide(
          color: colorScheme.outline,
          width: AppSpacing.borderWidth,
        ),
        shape: RoundedRectangleBorder(borderRadius: Radii.s),
      ),

      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return colorScheme.outline;
        }),
      ),

      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: colorScheme.primary,
        inactiveTrackColor: colorScheme.surfaceVariant,
        thumbColor: colorScheme.primary,
        overlayColor: colorScheme.primary.withOpacity(0.12),
        valueIndicatorColor: colorScheme.primary,
        valueIndicatorTextStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: colorScheme.onPrimary,
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colorScheme.primary,
        linearTrackColor: colorScheme.surfaceVariant,
        circularTrackColor: colorScheme.surfaceVariant,
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: AppElevations.bottomNav,
        backgroundColor: colorScheme.surface,
        selectedItemColor: colorScheme.primary,
        unselectedItemColor: colorScheme.onSurfaceVariant,
        selectedLabelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
        ),
        unselectedLabelStyle: AppTypography.textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        type: BottomNavigationBarType.fixed,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        elevation: AppElevations.floatingActionButton,
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: Radii.circular),
      ),

      // Snack Bar Theme
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: colorScheme.surface,
        contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
        shape: RoundedRectangleBorder(borderRadius: Radii.m),
        elevation: AppElevations.snackBar,
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        elevation: AppElevations.dialog,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: Radii.dialog),
        titleTextStyle: AppTypography.textTheme.titleLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        contentTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),

      // Bottom Sheet Theme
      bottomSheetTheme: BottomSheetThemeData(
        elevation: AppElevations.bottomSheet,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: colorScheme.surfaceTint,
        shape: RoundedRectangleBorder(borderRadius: Radii.bottomSheet),
        showDragHandle: true,
        dragHandleColor: colorScheme.onSurfaceVariant,
        dragHandleSize: const Size(32, 4),
      ),

      // Tooltip Theme
      tooltipTheme: TooltipThemeData(
        textStyle: AppTypography.textTheme.bodySmall?.copyWith(
          color: colorScheme.onInverseSurface,
        ),
        decoration: BoxDecoration(
          borderRadius: Radii.s,
          color: colorScheme.inverseSurface,
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: colorScheme.outlineVariant,
        thickness: AppSpacing.divider,
        space: AppSpacing.divider,
      ),

      // List Tile Theme
      listTileTheme: ListTileThemeData(
        contentPadding: SpacingUtils.symmetric(
          horizontal: AppSpacing.listItemPadding,
          vertical: AppSpacing.s,
        ),
        titleTextStyle: AppTypography.textTheme.bodyLarge?.copyWith(
          color: colorScheme.onSurface,
        ),
        subtitleTextStyle: AppTypography.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
        leadingAndTrailingTextStyle: AppTypography.textTheme.bodyMedium
            ?.copyWith(color: colorScheme.onSurfaceVariant),
        iconColor: colorScheme.onSurfaceVariant,
        textColor: colorScheme.onSurface,
        tileColor: Colors.transparent,
        selectedTileColor: colorScheme.primaryContainer,
        shape: RoundedRectangleBorder(borderRadius: Radii.m),
      ),

      // Page Transitions Theme
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        },
      ),

      // Visual Density
      visualDensity: VisualDensity.adaptivePlatformDensity,
    );
  }

  /// Dark theme configuration (for future implementation)
  static ThemeData get darkTheme {
    // TODO: Implement dark theme
    return lightTheme;
  }
}

/// Theme utilities
class ThemeUtils {
  /// Get theme from context
  static ThemeData themeOf(BuildContext context) {
    return Theme.of(context);
  }

  /// Get color scheme from context
  static ColorScheme colorSchemeOf(BuildContext context) {
    return Theme.of(context).colorScheme;
  }

  /// Get text theme from context
  static TextTheme textThemeOf(BuildContext context) {
    return Theme.of(context).textTheme;
  }

  /// Check if dark mode is enabled
  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  /// Get surface color with elevation
  static Color getSurfaceColor(BuildContext context, double elevation) {
    final colorScheme = colorSchemeOf(context);
    return ColorUtils.getSurfaceColor(colorScheme.surface, elevation);
  }

  /// Get glass surface color
  static Color getGlassSurfaceColor(BuildContext context, double opacity) {
    final colorScheme = colorSchemeOf(context);
    return ColorUtils.getGlassColor(colorScheme.surface, opacity);
  }
}
