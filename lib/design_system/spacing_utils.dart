import 'package:flutter/material.dart';

class SpacingUtils {
  static const double none = 0.0;
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double s = 8.0;
  static const double m = 16.0;
  static const double l = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  static SizedBox verticalSpace(double height) => SizedBox(height: height);
  static SizedBox horizontalSpace(double width) => SizedBox(width: width);

  static EdgeInsets all(double spacing) => EdgeInsets.all(spacing);
  static EdgeInsets horizontal(double spacing) =>
      EdgeInsets.symmetric(horizontal: spacing);
  static EdgeInsets vertical(double spacing) =>
      EdgeInsets.symmetric(vertical: spacing);
  static EdgeInsets only({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  static EdgeInsets symmetric({
    double vertical = 0.0,
    double horizontal = 0.0,
  }) => EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal);
}
