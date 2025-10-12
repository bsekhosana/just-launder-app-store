import 'package:flutter/material.dart';

/// App spacing system following Material 3 design principles
/// Provides consistent spacing values throughout the app
class AppSpacing {
  // Base spacing unit (4px)
  static const double baseUnit = 4.0;

  // Spacing scale
  static const double xs = baseUnit; // 4px
  static const double s = baseUnit * 2; // 8px
  static const double m = baseUnit * 3; // 12px
  static const double l = baseUnit * 4; // 16px
  static const double xl = baseUnit * 6; // 24px
  static const double xxl = baseUnit * 8; // 32px
  static const double xxxl = baseUnit * 12; // 48px
  static const double huge = baseUnit * 16; // 64px

  // Specific spacing values
  static const double padding = l; // 16px
  static const double margin = l; // 16px
  static const double gap = m; // 12px
  static const double divider = 1.0; // 1px

  // Component specific spacing
  static const double cardPadding = l; // 16px
  static const double cardMargin = s; // 8px
  static const double buttonPadding = m; // 12px
  static const double inputPadding = m; // 12px
  static const double listItemPadding = l; // 16px
  static const double appBarPadding = l; // 16px
  static const double bottomNavPadding = s; // 8px

  // Screen specific spacing
  static const double screenPadding = l; // 16px
  static const double screenMargin = l; // 16px
  static const double sectionSpacing = xl; // 24px
  static const double contentSpacing = m; // 12px

  // Icon spacing
  static const double iconPadding = s; // 8px
  static const double iconMargin = s; // 8px
  static const double iconSize = l; // 16px
  static const double iconSizeSmall = m; // 12px
  static const double iconSizeLarge = xl; // 24px
  static const double iconSizeXLarge = xxl; // 32px

  // Border spacing
  static const double borderWidth = 1.0; // 1px
  static const double borderWidthThick = 2.0; // 2px
  static const double borderWidthThin = 0.5; // 0.5px

  // Shadow spacing
  static const double shadowBlur = 4.0; // 4px
  static const double shadowSpread = 0.0; // 0px
  static const double shadowOffset = 2.0; // 2px
}

/// Spacing utilities
class SpacingUtils {
  /// Get spacing value as EdgeInsets
  static EdgeInsets all(double value) => EdgeInsets.all(value);

  /// Get horizontal spacing
  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value);

  /// Get vertical spacing
  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: value);

  /// Get top spacing
  static EdgeInsets top(double value) => EdgeInsets.only(top: value);

  /// Get bottom spacing
  static EdgeInsets bottom(double value) => EdgeInsets.only(bottom: value);

  /// Get left spacing
  static EdgeInsets left(double value) => EdgeInsets.only(left: value);

  /// Get right spacing
  static EdgeInsets right(double value) => EdgeInsets.only(right: value);

  /// Get symmetric spacing
  static EdgeInsets symmetric({
    required double horizontal,
    required double vertical,
  }) => EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  /// Get only spacing
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

/// Gap widget for consistent spacing
class Gap extends StatelessWidget {
  final double size;
  final Axis direction;

  const Gap(this.size, {super.key, this.direction = Axis.vertical});

  const Gap.horizontal(this.size, {super.key}) : direction = Axis.horizontal;
  const Gap.vertical(this.size, {super.key}) : direction = Axis.vertical;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: direction == Axis.horizontal ? size : 0,
      height: direction == Axis.vertical ? size : 0,
    );
  }
}

/// Predefined gap widgets
class Gaps {
  static const Gap xs = Gap(AppSpacing.xs);
  static const Gap s = Gap(AppSpacing.s);
  static const Gap m = Gap(AppSpacing.m);
  static const Gap l = Gap(AppSpacing.l);
  static const Gap xl = Gap(AppSpacing.xl);
  static const Gap xxl = Gap(AppSpacing.xxl);
  static const Gap xxxl = Gap(AppSpacing.xxxl);
  static const Gap huge = Gap(AppSpacing.huge);

  static const Gap horizontalXs = Gap.horizontal(AppSpacing.xs);
  static const Gap horizontalS = Gap.horizontal(AppSpacing.s);
  static const Gap horizontalM = Gap.horizontal(AppSpacing.m);
  static const Gap horizontalL = Gap.horizontal(AppSpacing.l);
  static const Gap horizontalXl = Gap.horizontal(AppSpacing.xl);
  static const Gap horizontalXxl = Gap.horizontal(AppSpacing.xxl);
  static const Gap horizontalXxxl = Gap.horizontal(AppSpacing.xxxl);
  static const Gap horizontalHuge = Gap.horizontal(AppSpacing.huge);

  static const Gap verticalXs = Gap.vertical(AppSpacing.xs);
  static const Gap verticalS = Gap.vertical(AppSpacing.s);
  static const Gap verticalM = Gap.vertical(AppSpacing.m);
  static const Gap verticalL = Gap.vertical(AppSpacing.l);
  static const Gap verticalXl = Gap.vertical(AppSpacing.xl);
  static const Gap verticalXxl = Gap.vertical(AppSpacing.xxl);
  static const Gap verticalXxxl = Gap.vertical(AppSpacing.xxxl);
  static const Gap verticalHuge = Gap.vertical(AppSpacing.huge);
}
