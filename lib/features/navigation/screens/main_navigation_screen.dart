import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/radii.dart';
import '../../../design_system/motion.dart';
import '../../../design_system/icons.dart';
import '../../../ui/primitives/glass_surface.dart';
import '../../orders/screens/orders_screen.dart';
import '../../branches/screens/branches_screen.dart';
import '../../staff/screens/staff_screen.dart';
import '../../analytics/screens/analytics_screen.dart';
import '../../settings/screens/settings_screen.dart';

/// Main navigation screen with bottom navigation bar
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  // Navigation items for bottom navigation bar
  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: AppIcons.orders,
      activeIcon: AppIcons.orders,
      label: 'Orders',
    ),
    NavigationItem(
      icon: AppIcons.branches,
      activeIcon: AppIcons.branches,
      label: 'Branches',
    ),
    NavigationItem(
      icon: AppIcons.staff,
      activeIcon: AppIcons.staff,
      label: 'Staff',
    ),
    NavigationItem(
      icon: AppIcons.analytics,
      activeIcon: AppIcons.analytics,
      label: 'Analytics',
    ),
    NavigationItem(
      icon: AppIcons.settings,
      activeIcon: AppIcons.settings,
      label: 'Settings',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: const [
          OrdersScreen(),
          BranchesScreen(),
          StaffScreen(),
          AnalyticsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: GlassSurface(
        opacity: 0.8,
        blurIntensity: 20.0,
        backgroundColor: colorScheme.surface.withOpacity(0.9),
        child: Container(
          height: 80 + MediaQuery.of(context).padding.bottom,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).padding.bottom,
            left: AppSpacing.l,
            right: AppSpacing.l,
            top: AppSpacing.s,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                _navigationItems.asMap().entries.map((entry) {
                  final index = entry.key;
                  final item = entry.value;
                  final isSelected = _currentIndex == index;

                  return Expanded(
                    child: _buildNavItem(
                      item: item,
                      isSelected: isSelected,
                      onTap: () {
                        setState(() {
                          _currentIndex = index;
                        });
                        _pageController.animateToPage(
                          index,
                          duration: AppMotion.normal,
                          curve: AppCurves.standard,
                        );
                      },
                    ),
                  );
                }).toList(),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required NavigationItem item,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: SpacingUtils.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.s,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: AppMotion.fast,
              curve: AppCurves.standard,
              padding: SpacingUtils.all(AppSpacing.s),
              decoration: BoxDecoration(
                color:
                    isSelected
                        ? AppColors.primary.withOpacity(0.1)
                        : Colors.transparent,
                borderRadius: Radii.m,
              ),
              child: Icon(
                item.icon,
                color:
                    isSelected
                        ? AppColors.primary
                        : colorScheme.onSurfaceVariant,
                size: 24,
              ),
            ).animate().scale(
              duration: AppMotion.fast,
              curve: AppCurves.standard,
            ),
            const Gap.vertical(AppSpacing.xs),
            AnimatedDefaultTextStyle(
              duration: AppMotion.fast,
              style:
                  AppTypography.textTheme.labelSmall?.copyWith(
                    color:
                        isSelected
                            ? AppColors.primary
                            : colorScheme.onSurfaceVariant,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ) ??
                  const TextStyle(),
              child: Text(item.label),
            ),
          ],
        ),
      ),
    );
  }
}

/// Data class for navigation items
class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
