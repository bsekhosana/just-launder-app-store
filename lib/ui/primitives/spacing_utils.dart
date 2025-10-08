import 'package:flutter/material.dart';

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
