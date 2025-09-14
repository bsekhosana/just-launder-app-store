import 'package:flutter/material.dart';

/// App border radius system following Material 3 design principles
/// Provides consistent border radius values throughout the app
class AppRadii {
  // Base radius unit (4px)
  static const double baseUnit = 4.0;

  // Radius scale
  static const double xs = baseUnit; // 4px
  static const double s = baseUnit * 2; // 8px
  static const double m = baseUnit * 3; // 12px
  static const double l = baseUnit * 4; // 16px
  static const double xl = baseUnit * 7; // 28px
  static const double xxl = baseUnit * 8; // 32px
  static const double xxxl = baseUnit * 12; // 48px
  static const double huge = baseUnit * 16; // 64px

  // Specific radius values
  static const double none = 0.0; // 0px
  static const double small = s; // 8px
  static const double medium = m; // 12px
  static const double large = l; // 16px
  static const double extraLarge = xl; // 28px

  // Component specific radius
  static const double button = m; // 12px
  static const double card = l; // 16px
  static const double input = l; // 16px
  static const double chip = xl; // 28px
  static const double badge = xxl; // 32px
  static const double dialog = l; // 16px
  static const double bottomSheet = l; // 16px
  static const double appBar = none; // 0px
  static const double bottomNav = none; // 0px

  // Special radius values
  static const double circular = 999.0; // Fully rounded
  static const double pill = 999.0; // Fully rounded (alternative name)
  static const double rounded = circular; // Fully rounded (alternative name)
}

/// Radius utilities
class RadiusUtils {
  /// Get BorderRadius with all corners same radius
  static BorderRadius all(double radius) =>
      BorderRadius.all(Radius.circular(radius));

  /// Get BorderRadius with only top corners rounded
  static BorderRadius top(double radius) => BorderRadius.only(
    topLeft: Radius.circular(radius),
    topRight: Radius.circular(radius),
  );

  /// Get BorderRadius with only bottom corners rounded
  static BorderRadius bottom(double radius) => BorderRadius.only(
    bottomLeft: Radius.circular(radius),
    bottomRight: Radius.circular(radius),
  );

  /// Get BorderRadius with only left corners rounded
  static BorderRadius left(double radius) => BorderRadius.only(
    topLeft: Radius.circular(radius),
    bottomLeft: Radius.circular(radius),
  );

  /// Get BorderRadius with only right corners rounded
  static BorderRadius right(double radius) => BorderRadius.only(
    topRight: Radius.circular(radius),
    bottomRight: Radius.circular(radius),
  );

  /// Get BorderRadius with only top-left corner rounded
  static BorderRadius topLeft(double radius) =>
      BorderRadius.only(topLeft: Radius.circular(radius));

  /// Get BorderRadius with only top-right corner rounded
  static BorderRadius topRight(double radius) =>
      BorderRadius.only(topRight: Radius.circular(radius));

  /// Get BorderRadius with only bottom-left corner rounded
  static BorderRadius bottomLeft(double radius) =>
      BorderRadius.only(bottomLeft: Radius.circular(radius));

  /// Get BorderRadius with only bottom-right corner rounded
  static BorderRadius bottomRight(double radius) =>
      BorderRadius.only(bottomRight: Radius.circular(radius));

  /// Get BorderRadius with custom radius for each corner
  static BorderRadius only({
    double? topLeft,
    double? topRight,
    double? bottomLeft,
    double? bottomRight,
  }) => BorderRadius.only(
    topLeft: Radius.circular(topLeft ?? 0),
    topRight: Radius.circular(topRight ?? 0),
    bottomLeft: Radius.circular(bottomLeft ?? 0),
    bottomRight: Radius.circular(bottomRight ?? 0),
  );

  /// Get BorderRadius with horizontal and vertical radius
  static BorderRadius symmetric({double? horizontal, double? vertical}) =>
      BorderRadius.only(
        topLeft: Radius.circular(horizontal ?? 0),
        topRight: Radius.circular(horizontal ?? 0),
        bottomLeft: Radius.circular(vertical ?? 0),
        bottomRight: Radius.circular(vertical ?? 0),
      );
}

/// Predefined radius widgets
class Radii {
  static const BorderRadius none = BorderRadius.zero;
  static final BorderRadius xs = RadiusUtils.all(AppRadii.xs);
  static final BorderRadius s = RadiusUtils.all(AppRadii.s);
  static final BorderRadius m = RadiusUtils.all(AppRadii.m);
  static final BorderRadius l = RadiusUtils.all(AppRadii.l);
  static final BorderRadius xl = RadiusUtils.all(AppRadii.xl);
  static final BorderRadius xxl = RadiusUtils.all(AppRadii.xxl);
  static final BorderRadius xxxl = RadiusUtils.all(AppRadii.xxxl);
  static final BorderRadius huge = RadiusUtils.all(AppRadii.huge);
  static final BorderRadius circular = RadiusUtils.all(AppRadii.circular);

  // Component specific radius
  static final BorderRadius button = RadiusUtils.all(AppRadii.button);
  static final BorderRadius card = RadiusUtils.all(AppRadii.card);
  static final BorderRadius input = RadiusUtils.all(AppRadii.input);
  static final BorderRadius chip = RadiusUtils.all(AppRadii.chip);
  static final BorderRadius badge = RadiusUtils.all(AppRadii.badge);
  static final BorderRadius dialog = RadiusUtils.all(AppRadii.dialog);
  static final BorderRadius bottomSheet = RadiusUtils.all(AppRadii.bottomSheet);

  // Directional radius
  static final BorderRadius topS = RadiusUtils.top(AppRadii.s);
  static final BorderRadius topM = RadiusUtils.top(AppRadii.m);
  static final BorderRadius topL = RadiusUtils.top(AppRadii.l);
  static final BorderRadius topXl = RadiusUtils.top(AppRadii.xl);

  static final BorderRadius bottomS = RadiusUtils.bottom(AppRadii.s);
  static final BorderRadius bottomM = RadiusUtils.bottom(AppRadii.m);
  static final BorderRadius bottomL = RadiusUtils.bottom(AppRadii.l);
  static final BorderRadius bottomXl = RadiusUtils.bottom(AppRadii.xl);

  static final BorderRadius leftS = RadiusUtils.left(AppRadii.s);
  static final BorderRadius leftM = RadiusUtils.left(AppRadii.m);
  static final BorderRadius leftL = RadiusUtils.left(AppRadii.l);
  static final BorderRadius leftXl = RadiusUtils.left(AppRadii.xl);

  static final BorderRadius rightS = RadiusUtils.right(AppRadii.s);
  static final BorderRadius rightM = RadiusUtils.right(AppRadii.m);
  static final BorderRadius rightL = RadiusUtils.right(AppRadii.l);
  static final BorderRadius rightXl = RadiusUtils.right(AppRadii.xl);
}
