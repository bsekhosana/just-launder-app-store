import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

/// Enum for watermark position
enum WatermarkPosition {
  topLeft,
  topCenter,
  topRight,
  centerLeft,
  center,
  centerRight,
  bottomLeft,
  bottomCenter,
  bottomRight,
}

/// Watermark background widget with configurable icon, position, and styling
class WatermarkBackground extends StatelessWidget {
  final Widget child;
  final dynamic icon; // Can be IconData or IconDataSolid
  final Color iconColor;
  final WatermarkPosition position;
  final double opacity;
  final double
  iconSizePercentage; // Percentage of screen width (e.g., 0.2 for 20%)
  final double iconShift; // Angle shift in degrees
  final bool visible;
  final EdgeInsets margin;
  final bool respectSafeArea;

  const WatermarkBackground({
    super.key,
    required this.child,
    required this.icon,
    this.iconColor = Colors.grey,
    this.position = WatermarkPosition.center,
    this.opacity = 0.1,
    this.iconSizePercentage = 0.2, // 20% of screen width by default
    this.iconShift = 0.0,
    this.visible = true,
    this.margin = const EdgeInsets.all(16),
    this.respectSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    if (!visible) return child;

    // Make the overlay fill the entire viewport
    final content = Stack(
      fit: StackFit.expand, // <-- important
      clipBehavior: Clip.none,
      children: [child, _buildWatermark(context)],
    );

    // Optionally keep it out of notches/home indicators
    return respectSafeArea ? SafeArea(child: content) : content;
  }

  Widget _buildWatermark(BuildContext context) {
    // Create the positioned pins based on enum
    final positioned = _positionForEnum(
      context: context,
      position: position,
      margin: margin,
      child: IgnorePointer(
        child: SizedBox(
          width: _calculateResponsiveIconSize(context),
          height: _calculateResponsiveIconSize(context),
          child: Center(
            child: Transform.rotate(
              angle: iconShift * (3.14159 / 180),
              child: Opacity(opacity: opacity, child: _buildIcon(context)),
            ),
          ),
        ),
      ),
    );

    return positioned;
  }

  /// Build icon widget supporting both Material and FontAwesome icons
  Widget _buildIcon(BuildContext context) {
    final responsiveIconSize = _calculateResponsiveIconSize(context) * 0.8;

    if (icon is IconData) {
      // Detect FontAwesome by its fontPackage
      final IconData d = icon as IconData;
      final isFontAwesome = d.fontPackage == 'font_awesome_flutter';
      if (isFontAwesome) {
        return FaIcon(d, size: responsiveIconSize, color: iconColor);
      }
      return Icon(d, size: responsiveIconSize, color: iconColor);
    }

    // Fallbacks remain
    if (icon is IconDataSolid) {
      return FaIcon(icon as IconDataSolid,
          size: responsiveIconSize, color: iconColor);
    }

    return Icon(Icons.help_outline, size: responsiveIconSize, color: iconColor);
  }

  /// Calculate responsive icon size based on screen width percentage
  double _calculateResponsiveIconSize(BuildContext context) {
    // Get screen width
    final screenWidth = MediaQuery.of(context).size.width;

    // Calculate icon size as percentage of screen width
    final calculatedSize = screenWidth * iconSizePercentage;

    // Clamp between minimum and maximum sizes for consistency
    return calculatedSize.clamp(60.0, 400.0);
  }

  /// Calculate responsive margin based on screen size
  EdgeInsets _calculateResponsiveMargin(
    BuildContext context,
    EdgeInsets baseMargin,
  ) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Calculate responsive margin as percentage of screen size
    final responsiveHorizontal = screenWidth * 0.04; // 4% of screen width
    final responsiveVertical = screenHeight * 0.02; // 2% of screen height

    return EdgeInsets.only(
      left: baseMargin.left > 0 ? responsiveHorizontal : 0,
      top: baseMargin.top > 0 ? responsiveVertical : 0,
      right: baseMargin.right > 0 ? responsiveHorizontal : 0,
      bottom: baseMargin.bottom > 0 ? responsiveVertical : 0,
    );
  }

  // Pins using top/bottom/left/right instead of computing pixel offsets
  Widget _positionForEnum({
    required BuildContext context,
    required WatermarkPosition position,
    required EdgeInsets margin,
    required Widget child,
  }) {
    // Use responsive margin
    final responsiveMargin = _calculateResponsiveMargin(context, margin);
    switch (position) {
      case WatermarkPosition.topLeft:
        return Positioned(
          top: responsiveMargin.top,
          left: responsiveMargin.left,
          child: child,
        );
      case WatermarkPosition.topCenter:
        return Positioned(
          top: responsiveMargin.top,
          left: 0,
          right: 0,
          child: Align(alignment: Alignment.topCenter, child: child),
        );
      case WatermarkPosition.topRight:
        return Positioned(
          top: responsiveMargin.top,
          right: responsiveMargin.right,
          child: child,
        );
      case WatermarkPosition.centerLeft:
        return Positioned(
          left: responsiveMargin.left,
          top: 0,
          bottom: 0,
          child: Align(alignment: Alignment.centerLeft, child: child),
        );
      case WatermarkPosition.center:
        return Positioned.fill(
          child: Align(alignment: Alignment.center, child: child),
        );
      case WatermarkPosition.centerRight:
        return Positioned(
          right: responsiveMargin.right,
          top: 0,
          bottom: 0,
          child: Align(alignment: Alignment.centerRight, child: child),
        );
      case WatermarkPosition.bottomLeft:
        return Positioned(
          bottom: responsiveMargin.bottom,
          left: responsiveMargin.left,
          child: child,
        );
      case WatermarkPosition.bottomCenter:
        return Positioned(
          bottom: responsiveMargin.bottom,
          left: 0,
          right: 0,
          child: Align(alignment: Alignment.bottomCenter, child: child),
        );
      case WatermarkPosition.bottomRight:
        return Positioned(
          bottom: responsiveMargin.bottom,
          right: responsiveMargin.right,
          child: child,
        );
    }
  }
}

/// Convenience widget for common watermark configurations
class WatermarkBackgroundBuilder {
  /// Bottom right corner watermark
  static Widget bottomRight({
    required Widget child,
    dynamic icon = FontAwesomeIcons.user,
    Color iconColor = Colors.grey,
    double opacity = 0.08,
    double iconSizePercentage = 0.2, // 20% of screen width
    double iconShift = 0.0,
    bool visible = true,
    EdgeInsets margin = const EdgeInsets.all(16),
    bool respectSafeArea = true,
  }) {
    return WatermarkBackground(
      child: child,
      icon: icon,
      iconColor: iconColor,
      position: WatermarkPosition.bottomRight,
      opacity: opacity,
      iconSizePercentage: iconSizePercentage,
      iconShift: iconShift,
      visible: visible,
      margin: margin,
      respectSafeArea: respectSafeArea,
    );
  }

  /// Bottom left corner watermark
  static Widget bottomLeft({
    required Widget child,
    dynamic icon = FontAwesomeIcons.user,
    Color iconColor = Colors.grey,
    double opacity = 0.08,
    double iconSizePercentage = 0.2, // 20% of screen width
    double iconShift = 0.0,
    bool visible = true,
    EdgeInsets margin = const EdgeInsets.all(16),
    bool respectSafeArea = true,
  }) {
    return WatermarkBackground(
      child: child,
      icon: icon,
      iconColor: iconColor,
      position: WatermarkPosition.bottomLeft,
      opacity: opacity,
      iconSizePercentage: iconSizePercentage,
      iconShift: iconShift,
      visible: visible,
      margin: margin,
      respectSafeArea: respectSafeArea,
    );
  }

  /// Top right corner watermark
  static Widget topRight({
    required Widget child,
    dynamic icon = FontAwesomeIcons.user,
    Color iconColor = Colors.grey,
    double opacity = 0.08,
    double iconSizePercentage = 0.2, // 20% of screen width
    double iconShift = 0.0,
    bool visible = true,
    EdgeInsets margin = const EdgeInsets.all(16),
    bool respectSafeArea = true,
  }) {
    return WatermarkBackground(
      child: child,
      icon: icon,
      iconColor: iconColor,
      position: WatermarkPosition.topRight,
      opacity: opacity,
      iconSizePercentage: iconSizePercentage,
      iconShift: iconShift,
      visible: visible,
      margin: margin,
      respectSafeArea: respectSafeArea,
    );
  }

  /// Top left corner watermark
  static Widget topLeft({
    required Widget child,
    dynamic icon = FontAwesomeIcons.user,
    Color iconColor = Colors.grey,
    double opacity = 0.08,
    double iconSizePercentage = 0.2, // 20% of screen width
    double iconShift = 0.0,
    bool visible = true,
    EdgeInsets margin = const EdgeInsets.all(16),
    bool respectSafeArea = true,
  }) {
    return WatermarkBackground(
      child: child,
      icon: icon,
      iconColor: iconColor,
      position: WatermarkPosition.topLeft,
      opacity: opacity,
      iconSizePercentage: iconSizePercentage,
      iconShift: iconShift,
      visible: visible,
      margin: margin,
      respectSafeArea: respectSafeArea,
    );
  }

  /// Center watermark
  static Widget center({
    required Widget child,
    dynamic icon = FontAwesomeIcons.user,
    Color iconColor = Colors.grey,
    double opacity = 0.05,
    double iconSizePercentage = 0.3, // 30% of screen width for center
    double iconShift = -15.0,
    bool visible = true,
    EdgeInsets margin = const EdgeInsets.all(16),
    bool respectSafeArea = true,
  }) {
    return WatermarkBackground(
      child: child,
      icon: icon,
      iconColor: iconColor,
      position: WatermarkPosition.center,
      opacity: opacity,
      iconSizePercentage: iconSizePercentage,
      iconShift: iconShift,
      visible: visible,
      margin: margin,
      respectSafeArea: respectSafeArea,
    );
  }

  /// Custom position watermark
  static Widget custom({
    required Widget child,
    required WatermarkPosition position,
    dynamic icon = FontAwesomeIcons.user,
    Color iconColor = Colors.grey,
    double opacity = 0.05,
    double iconSizePercentage = 0.25, // 25% of screen width
    double iconShift = 0.0,
    bool visible = true,
    EdgeInsets margin = const EdgeInsets.all(16),
    bool respectSafeArea = true,
  }) {
    return WatermarkBackground(
      child: child,
      icon: icon,
      iconColor: iconColor,
      position: position,
      opacity: opacity,
      iconSizePercentage: iconSizePercentage,
      iconShift: iconShift,
      visible: visible,
      margin: margin,
      respectSafeArea: respectSafeArea,
    );
  }
}