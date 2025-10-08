import 'package:flutter/material.dart';

/// Custom app icon widget that displays the Just Launder logo
class AppIcon extends StatelessWidget {
  final double size;
  final Color? color;
  final bool showBackground;
  final String? assetPath;

  const AppIcon({
    super.key,
    this.size = 24.0,
    this.color,
    this.showBackground = true,
    this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = color ?? Theme.of(context).colorScheme.primary;
    final actualAssetPath = assetPath ?? 'assets/images/app_icon.png';

    if (showBackground) {
      return Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Padding(
          padding: EdgeInsets.all(size * 0.1),
          child: Image.asset(
            actualAssetPath,
            width: size * 0.8,
            height: size * 0.8,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Fallback to icon if image fails to load
              return Icon(
                Icons.local_laundry_service,
                size: size * 0.6,
                color: iconColor,
              );
            },
          ),
        ),
      );
    }

    return Image.asset(
      actualAssetPath,
      width: size,
      height: size,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to icon if image fails to load
        return Icon(
          Icons.local_laundry_service,
          size: size,
          color: iconColor,
        );
      },
    );
  }
}
