import 'package:flutter/animation.dart';

/// App motion system following Material 3 design principles
/// Provides consistent animation timing and curves throughout the app
class AppMotion {
  // Base timing unit (100ms)
  static const int baseUnit = 100;

  // Duration scale
  static const Duration instant = Duration.zero; // 0ms
  static const Duration fast = Duration(milliseconds: baseUnit * 2); // 200ms
  static const Duration normal = Duration(milliseconds: 260); // 260ms
  static const Duration slow = Duration(milliseconds: 340); // 340ms
  static const Duration slower = Duration(milliseconds: baseUnit * 5); // 500ms
  static const Duration slowest = Duration(milliseconds: baseUnit * 8); // 800ms

  // Specific durations
  static const Duration veryFast = Duration(milliseconds: 150); // 150ms
  static const Duration quick = Duration(milliseconds: 250); // 250ms
  static const Duration standard = Duration(milliseconds: 300); // 300ms
  static const Duration relaxed = Duration(milliseconds: 400); // 400ms
  static const Duration leisurely = Duration(milliseconds: 600); // 600ms

  // Component specific durations
  static const Duration buttonPress = fast; // 200ms
  static const Duration buttonRelease = veryFast; // 150ms
  static const Duration cardHover = normal; // 260ms
  static const Duration cardPress = fast; // 200ms
  static const Duration inputFocus = normal; // 260ms
  static const Duration inputBlur = fast; // 200ms
  static const Duration pageTransition = slow; // 340ms
  static const Duration modalTransition = slower; // 500ms
  static const Duration snackBarTransition = normal; // 260ms
  static const Duration tooltipTransition = fast; // 200ms
  static const Duration loadingSpinner = Duration(milliseconds: 1200); // 1200ms
  static const Duration shimmer = Duration(milliseconds: 1500); // 1500ms

  // Staggered animation durations
  static const Duration staggerDelay = Duration(milliseconds: 50); // 50ms
  static const Duration staggerFast = Duration(milliseconds: 100); // 100ms
  static const Duration staggerNormal = Duration(milliseconds: 150); // 150ms
  static const Duration staggerSlow = Duration(milliseconds: 200); // 200ms

  // Micro-interaction durations
  static const Duration microInteraction = Duration(milliseconds: 100); // 100ms
  static const Duration ripple = Duration(milliseconds: 300); // 300ms
  static const Duration splash = Duration(milliseconds: 400); // 400ms
  static const Duration highlight = Duration(milliseconds: 200); // 200ms
  static const Duration selection = Duration(milliseconds: 150); // 150ms
}

/// Animation curves following Material 3 design principles
class AppCurves {
  // Standard curves
  static const Curve standard = Curves.fastOutSlowIn; // Material 3 standard
  static const Curve emphasized =
      Curves.easeInOutCubic; // Material 3 emphasized
  static const Curve decelerated =
      Curves.fastOutSlowIn; // Material 3 decelerated
  static const Curve accelerated = Curves.easeInCubic; // Material 3 accelerated

  // Easing curves
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve easeInCubic = Curves.easeInCubic;
  static const Curve easeOutCubic = Curves.easeOutCubic;
  static const Curve easeInOutCubic = Curves.easeInOutCubic;

  // Spring curves
  static const Curve spring = Curves.elasticOut;
  static const Curve springIn = Curves.elasticIn;
  static const Curve springOut = Curves.elasticOut;
  static const Curve springInOut = Curves.elasticInOut;

  // Bounce curves
  static const Curve bounce = Curves.bounceOut;
  static const Curve bounceIn = Curves.bounceIn;
  static const Curve bounceOut = Curves.bounceOut;
  static const Curve bounceInOut = Curves.bounceInOut;

  // Custom curves
  static const Curve quickOut = Curves.easeOutQuart;
  static const Curve quickIn = Curves.easeInQuart;
  static const Curve quickInOut = Curves.easeInOutQuart;
  static const Curve smooth = Curves.easeInOutSine;
  static const Curve sharp = Curves.easeInOutQuad;

  // Component specific curves
  static const Curve buttonPress = Curves.easeOutCubic;
  static const Curve buttonRelease = Curves.easeInCubic;
  static const Curve cardHover = Curves.easeInOutCubic;
  static const Curve cardPress = Curves.easeOutCubic;
  static const Curve inputFocus = Curves.easeInOutCubic;
  static const Curve inputBlur = Curves.easeOutCubic;
  static const Curve pageTransition = Curves.fastOutSlowIn;
  static const Curve modalTransition = Curves.easeInOutCubic;
  static const Curve snackBarTransition = Curves.easeInOutCubic;
  static const Curve tooltipTransition = Curves.easeOutCubic;
  static const Curve loadingSpinner = Curves.linear;
  static const Curve shimmer = Curves.easeInOutSine;
}

/// Motion utilities
class MotionUtils {
  /// Get duration from token
  static Duration getDuration(String token) {
    switch (token) {
      case 'instant':
        return AppMotion.instant;
      case 'fast':
        return AppMotion.fast;
      case 'normal':
        return AppMotion.normal;
      case 'slow':
        return AppMotion.slow;
      case 'slower':
        return AppMotion.slower;
      case 'slowest':
        return AppMotion.slowest;
      case 'veryFast':
        return AppMotion.veryFast;
      case 'quick':
        return AppMotion.quick;
      case 'standard':
        return AppMotion.standard;
      case 'relaxed':
        return AppMotion.relaxed;
      case 'leisurely':
        return AppMotion.leisurely;
      default:
        return AppMotion.normal;
    }
  }

  /// Get curve from token
  static Curve getCurve(String token) {
    switch (token) {
      case 'standard':
        return AppCurves.standard;
      case 'emphasized':
        return AppCurves.emphasized;
      case 'decelerated':
        return AppCurves.decelerated;
      case 'accelerated':
        return AppCurves.accelerated;
      case 'easeIn':
        return AppCurves.easeIn;
      case 'easeOut':
        return AppCurves.easeOut;
      case 'easeInOut':
        return AppCurves.easeInOut;
      case 'spring':
        return AppCurves.spring;
      case 'bounce':
        return AppCurves.bounce;
      case 'quickOut':
        return AppCurves.quickOut;
      case 'smooth':
        return AppCurves.smooth;
      case 'sharp':
        return AppCurves.sharp;
      default:
        return AppCurves.standard;
    }
  }

  /// Get staggered delay
  static Duration getStaggerDelay(
    int index, {
    Duration baseDelay = AppMotion.staggerDelay,
  }) {
    return Duration(milliseconds: baseDelay.inMilliseconds * index);
  }

  /// Get staggered duration
  static Duration getStaggerDuration(
    int count, {
    Duration baseDuration = AppMotion.normal,
  }) {
    return Duration(milliseconds: baseDuration.inMilliseconds * count);
  }
}

/// Animation presets
class AnimationPresets {
  // Fade animations
  static const Duration fadeInDuration = AppMotion.normal;
  static const Duration fadeOutDuration = AppMotion.fast;
  static const Curve fadeInCurve = AppCurves.easeOutCubic;
  static const Curve fadeOutCurve = AppCurves.easeInCubic;

  // Scale animations
  static const Duration scaleInDuration = AppMotion.fast;
  static const Duration scaleOutDuration = AppMotion.veryFast;
  static const Curve scaleInCurve = AppCurves.easeOutCubic;
  static const Curve scaleOutCurve = AppCurves.easeInCubic;

  // Slide animations
  static const Duration slideInDuration = AppMotion.normal;
  static const Duration slideOutDuration = AppMotion.fast;
  static const Curve slideInCurve = AppCurves.easeOutCubic;
  static const Curve slideOutCurve = AppCurves.easeInCubic;

  // Rotation animations
  static const Duration rotateInDuration = AppMotion.slow;
  static const Duration rotateOutDuration = AppMotion.normal;
  static const Curve rotateInCurve = AppCurves.easeInOutCubic;
  static const Curve rotateOutCurve = AppCurves.easeInOutCubic;

  // Bounce animations
  static const Duration bounceInDuration = AppMotion.slower;
  static const Duration bounceOutDuration = AppMotion.normal;
  static const Curve bounceInCurve = AppCurves.bounceIn;
  static const Curve bounceOutCurve = AppCurves.bounceOut;

  // Spring animations
  static const Duration springInDuration = AppMotion.slower;
  static const Duration springOutDuration = AppMotion.normal;
  static const Curve springInCurve = AppCurves.springIn;
  static const Curve springOutCurve = AppCurves.springOut;
}
