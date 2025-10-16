import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/motion.dart';
import '../../../design_system/icons.dart';
import '../../../ui/primitives/card_x.dart';
import '../../branches/providers/branch_provider.dart';
import '../../staff/providers/staff_provider.dart';
import '../../auth/providers/auth_provider.dart';
import '../../branches/screens/branches_screen.dart';
import '../../staff/screens/staff_screen.dart';

/// Management overview screen consolidating branches and staff
class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen> {
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);

    // Get current laundrette ID from auth provider
    final laundretteId = authProvider.currentLaundretteId;
    if (laundretteId == null) {
      debugPrint('No authenticated tenant found');
      return;
    }

    await Future.wait([
      branchProvider.loadBranches(laundretteId),
      staffProvider.loadStaff(laundretteId),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: colorScheme.surface.withOpacity(0.9),
        elevation: 0,
        title: Text(
          'Management',
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _loadData,
        color: AppColors.primary,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overview',
                style: AppTypography.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.m),

              // Branches Card
              _buildManagementCard(
                context: context,
                title: 'Branches',
                icon: AppIcons.branches,
                iconColor: AppColors.primary,
                onTap: () => _navigateToBranches(context),
              ),

              const SizedBox(height: AppSpacing.m),

              // Staff Card
              _buildManagementCard(
                context: context,
                title: 'Staff',
                icon: AppIcons.staff,
                iconColor: AppColors.secondary,
                onTap: () => _navigateToStaff(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManagementCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Consumer2<BranchProvider, StaffProvider>(
      builder: (context, branchProvider, staffProvider, child) {
        final int count =
            title == 'Branches'
                ? branchProvider.branches.length
                : staffProvider.staff.length;

        final int activeCount =
            title == 'Branches'
                ? branchProvider.branches
                    .where((b) => b.status.name == 'active')
                    .length
                : staffProvider.staff
                    .where((s) => s.status.name == 'active')
                    .length;

        return GestureDetector(
          onTap: onTap,
          child: CardX(
                variant: CardVariant.elevated,
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  child: Row(
                    children: [
                      // Icon Container
                      Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          color: iconColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(icon, color: iconColor, size: 32),
                      ),

                      const SizedBox(width: AppSpacing.m),

                      // Content
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTypography.textTheme.titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              '$count Total • $activeCount Active',
                              style: AppTypography.textTheme.bodyMedium
                                  ?.copyWith(color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),

                      // Arrow Icon
                      Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              )
              .animate()
              .fadeIn(duration: AppMotion.normal)
              .slideX(
                begin: 0.1,
                end: 0,
                duration: AppMotion.normal,
                curve: AppCurves.standard,
              ),
        );
      },
    );
  }

  void _navigateToBranches(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const BranchesScreen()));
  }

  void _navigateToStaff(BuildContext context) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const StaffScreen()));
  }
}
