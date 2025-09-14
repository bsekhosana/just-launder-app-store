import 'package:flutter/material.dart';

/// App elevation system following Material 3 design principles
/// Provides consistent elevation values throughout the app
class AppElevations {
  // Base elevation unit (1px)
  static const double baseUnit = 1.0;

  // Elevation scale
  static const double none = 0.0; // 0px
  static const double low = baseUnit; // 1px
  static const double medium = baseUnit * 3; // 3px
  static const double high = baseUnit * 6; // 6px
  static const double xhigh = baseUnit * 8; // 8px
  static const double xxhigh = baseUnit * 12; // 12px
  static const double xxxhigh = baseUnit * 16; // 16px

  // Component specific elevations
  static const double card = low; // 1px
  static const double button = low; // 1px
  static const double input = medium; // 3px
  static const double chip = low; // 1px
  static const double badge = medium; // 3px
  static const double dialog = high; // 6px
  static const double bottomSheet = high; // 6px
  static const double appBar = low; // 1px
  static const double bottomNav = medium; // 3px
  static const double floatingActionButton = medium; // 3px
  static const double snackBar = medium; // 3px
  static const double tooltip = medium; // 3px
  static const double dropdown = medium; // 3px
  static const double modal = high; // 6px
  static const double overlay = xhigh; // 8px

  // Interactive elevations
  static const double hover = low; // 1px
  static const double focus = medium; // 3px
  static const double pressed = high; // 6px
  static const double selected = medium; // 3px
  static const double disabled = none; // 0px

  // Surface elevations
  static const double surface = none; // 0px
  static const double surfaceVariant = low; // 1px
  static const double surfaceContainer = low; // 1px
  static const double surfaceContainerHigh = medium; // 3px
  static const double surfaceContainerHighest = high; // 6px
}

/// Shadow utilities
class ShadowUtils {
  /// Get shadow with custom elevation
  static List<BoxShadow> getShadow(double elevation) {
    if (elevation <= 0) return [];

    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: elevation * 8,
        spreadRadius: 0,
        offset: Offset(0, elevation * 0.5),
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.02),
        blurRadius: elevation * 16,
        spreadRadius: 0,
        offset: Offset(0, elevation * 0.25),
      ),
    ];
  }

  /// Get shadow with custom color
  static List<BoxShadow> getShadowWithColor(double elevation, Color color) {
    if (elevation <= 0) return [];

    return [
      BoxShadow(
        color: color.withOpacity(0.1),
        blurRadius: elevation * 2,
        spreadRadius: 0,
        offset: Offset(0, elevation),
      ),
      BoxShadow(
        color: color.withOpacity(0.05),
        blurRadius: elevation * 4,
        spreadRadius: 0,
        offset: Offset(0, elevation * 0.5),
      ),
    ];
  }

  /// Get shadow with custom offset
  static List<BoxShadow> getShadowWithOffset(double elevation, Offset offset) {
    if (elevation <= 0) return [];

    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: elevation * 2,
        spreadRadius: 0,
        offset: offset,
      ),
      BoxShadow(
        color: Colors.black.withOpacity(0.05),
        blurRadius: elevation * 4,
        spreadRadius: 0,
        offset: Offset(offset.dx * 0.5, offset.dy * 0.5),
      ),
    ];
  }

  /// Get inner shadow
  static List<BoxShadow> getInnerShadow(double elevation) {
    if (elevation <= 0) return [];

    return [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: elevation * 2,
        spreadRadius: 0,
        offset: Offset(0, elevation),
      ),
    ];
  }

  /// Get colored shadow
  static List<BoxShadow> getColoredShadow(double elevation, Color color) {
    if (elevation <= 0) return [];

    return [
      BoxShadow(
        color: color.withOpacity(0.2),
        blurRadius: elevation * 2,
        spreadRadius: 0,
        offset: Offset(0, elevation),
      ),
      BoxShadow(
        color: color.withOpacity(0.1),
        blurRadius: elevation * 4,
        spreadRadius: 0,
        offset: Offset(0, elevation * 0.5),
      ),
    ];
  }
}

/// Predefined shadow widgets
class Shadows {
  static List<BoxShadow> get none => [];
  static List<BoxShadow> get low => ShadowUtils.getShadow(AppElevations.low);
  static List<BoxShadow> get medium =>
      ShadowUtils.getShadow(AppElevations.medium);
  static List<BoxShadow> get high => ShadowUtils.getShadow(AppElevations.high);
  static List<BoxShadow> get xhigh =>
      ShadowUtils.getShadow(AppElevations.xhigh);
  static List<BoxShadow> get xxhigh =>
      ShadowUtils.getShadow(AppElevations.xxhigh);
  static List<BoxShadow> get xxxhigh =>
      ShadowUtils.getShadow(AppElevations.xxxhigh);

  // Component specific shadows
  static List<BoxShadow> get card => ShadowUtils.getShadow(AppElevations.card);
  static List<BoxShadow> get button =>
      ShadowUtils.getShadow(AppElevations.button);
  static List<BoxShadow> get input =>
      ShadowUtils.getShadow(AppElevations.input);
  static List<BoxShadow> get chip => ShadowUtils.getShadow(AppElevations.chip);
  static List<BoxShadow> get badge =>
      ShadowUtils.getShadow(AppElevations.badge);
  static List<BoxShadow> get dialog =>
      ShadowUtils.getShadow(AppElevations.dialog);
  static List<BoxShadow> get bottomSheet =>
      ShadowUtils.getShadow(AppElevations.bottomSheet);
  static List<BoxShadow> get appBar =>
      ShadowUtils.getShadow(AppElevations.appBar);
  static List<BoxShadow> get bottomNav =>
      ShadowUtils.getShadow(AppElevations.bottomNav);
  static List<BoxShadow> get floatingActionButton =>
      ShadowUtils.getShadow(AppElevations.floatingActionButton);
  static List<BoxShadow> get snackBar =>
      ShadowUtils.getShadow(AppElevations.snackBar);
  static List<BoxShadow> get tooltip =>
      ShadowUtils.getShadow(AppElevations.tooltip);
  static List<BoxShadow> get dropdown =>
      ShadowUtils.getShadow(AppElevations.dropdown);
  static List<BoxShadow> get modal =>
      ShadowUtils.getShadow(AppElevations.modal);
  static List<BoxShadow> get overlay =>
      ShadowUtils.getShadow(AppElevations.overlay);

  // Interactive shadows
  static List<BoxShadow> get hover =>
      ShadowUtils.getShadow(AppElevations.hover);
  static List<BoxShadow> get focus =>
      ShadowUtils.getShadow(AppElevations.focus);
  static List<BoxShadow> get pressed =>
      ShadowUtils.getShadow(AppElevations.pressed);
  static List<BoxShadow> get selected =>
      ShadowUtils.getShadow(AppElevations.selected);
  static List<BoxShadow> get disabled =>
      ShadowUtils.getShadow(AppElevations.disabled);

  // Surface shadows
  static List<BoxShadow> get surface =>
      ShadowUtils.getShadow(AppElevations.surface);
  static List<BoxShadow> get surfaceVariant =>
      ShadowUtils.getShadow(AppElevations.surfaceVariant);
  static List<BoxShadow> get surfaceContainer =>
      ShadowUtils.getShadow(AppElevations.surfaceContainer);
  static List<BoxShadow> get surfaceContainerHigh =>
      ShadowUtils.getShadow(AppElevations.surfaceContainerHigh);
  static List<BoxShadow> get surfaceContainerHighest =>
      ShadowUtils.getShadow(AppElevations.surfaceContainerHighest);
}

/// Elevation utilities
class ElevationUtils {
  /// Get elevation from Material 3 elevation tokens
  static double getElevation(String token) {
    switch (token) {
      case 'none':
        return AppElevations.none;
      case 'low':
        return AppElevations.low;
      case 'medium':
        return AppElevations.medium;
      case 'high':
        return AppElevations.high;
      case 'xhigh':
        return AppElevations.xhigh;
      case 'xxhigh':
        return AppElevations.xxhigh;
      case 'xxxhigh':
        return AppElevations.xxxhigh;
      default:
        return AppElevations.none;
    }
  }

  /// Get shadow from elevation
  static List<BoxShadow> getShadowFromElevation(double elevation) {
    return ShadowUtils.getShadow(elevation);
  }

  /// Get shadow from token
  static List<BoxShadow> getShadowFromToken(String token) {
    return getShadowFromElevation(getElevation(token));
  }
}
