import 'package:flutter/material.dart';

class Radii {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
  static const double xxl = 32.0;
  static const double xxxl = 48.0;

  // Additional missing properties
  static const double card = lg;
  static const double button = md;
  static const double input = md;
  static const double chip = sm;
  static const double dialog = lg;
  static const double bottomSheet = lg;
  static const double s = sm;
  static const double m = md;
  static const double l = lg;

  // Circular radius variants
  static BorderRadius circular(double radius) => BorderRadius.circular(radius);
}
