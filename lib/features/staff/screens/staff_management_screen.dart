import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/motion.dart';
import '../../../design_system/icons.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/card_x.dart';
import '../../../ui/primitives/chip_x.dart';
import '../providers/staff_management_provider.dart';
import '../data/models/staff_model.dart';
import 'staff_details_screen.dart';
import 'add_staff_screen.dart';

class StaffManagementScreen extends StatefulWidget {
  const StaffManagementScreen({super.key});

  @override
  State<StaffManagementScreen> createState() => _StaffManagementScreenState();
}

class _StaffManagementScreenState extends State<StaffManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showAnalytics = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this, initialIndex: 0);
    // Load staff after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStaff();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadStaff() async {
    final staffProvider = Provider.of<StaffManagementProvider>(
      context,
      listen: false,
    );
    await staffProvider.loadStaff('laundrette_business_1');
    await staffProvider.loadStaffAnalytics('laundrette_business_1');
    await staffProvider.loadStaffStatistics('laundrette_business_1');
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
          'Staff Management',
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: AnimatedButton(
              onPressed: () {
                setState(() {
                  _showAnalytics = !_showAnalytics;
                });
              },
              backgroundColor: Colors.white,
              width: 48,
              height: 48,
              borderRadius: BorderRadius.circular(24),
              tooltip: _showAnalytics ? 'Hide Analytics' : 'Show Analytics',
              border: Border.all(color: Colors.white, width: 1),
              child: Align(
                alignment: Alignment.center,
                child: Icon(
                  AppIcons.analytics,
                  color:
                      _showAnalytics
                          ? AppColors.primary
                          : AppColors.onSurfaceVariant,
                  size: 20,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AnimatedButton(
              onPressed: _addStaff,
              backgroundColor: AppColors.primary,
              width: 48,
              height: 48,
              borderRadius: BorderRadius.circular(24),
              tooltip: 'Add Staff',
              child: Align(
                alignment: Alignment.center,
                child: Icon(AppIcons.add, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.surface.withOpacity(0.9),
              border: Border(
                bottom: BorderSide(
                  color: colorScheme.outline.withOpacity(0.1),
                  width: 1,
                ),
              ),
            ),
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              tabAlignment: TabAlignment.start,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              indicatorColor: AppColors.primary,
              indicatorWeight: 3,
              labelColor: AppColors.primary,
              unselectedLabelColor: colorScheme.onSurfaceVariant,
              labelStyle: AppTypography.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              unselectedLabelStyle: AppTypography.textTheme.labelMedium,
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Active'),
                Tab(text: 'Managers'),
                Tab(text: 'Operators'),
              ],
            ),
          ),
        ),
      ),
      body: Consumer<StaffManagementProvider>(
        builder: (context, staffProvider, child) {
          if (staffProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          return Column(
            children: [
              if (_showAnalytics) ...[
                Flexible(
                  flex: 0,
                  child: AnimatedContainer(
                        duration: AppMotion.normal,
                        curve: AppCurves.standard,
                        constraints: const BoxConstraints(maxHeight: 300),
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              _buildAnalyticsCard(staffProvider),
                              const Gap.vertical(AppSpacing.s),
                            ],
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(duration: AppMotion.normal)
                      .slideY(
                        begin: -0.3,
                        end: 0.0,
                        duration: AppMotion.normal,
                      ),
                ),
                const Gap.vertical(AppSpacing.s),
              ],
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildStaffList(staffProvider.staff, 'No staff found'),
                    _buildStaffList(
                      staffProvider.activeStaff,
                      'No active staff',
                    ),
                    _buildStaffList(
                      staffProvider.managers,
                      'No managers found',
                    ),
                    _buildStaffList(
                      staffProvider.operators,
                      'No operators found',
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAnalyticsCard(StaffManagementProvider staffProvider) {
    final colorScheme = Theme.of(context).colorScheme;
    final analytics = staffProvider.staffAnalytics;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Staff Analytics',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap.vertical(AppSpacing.m),
            Row(
              children: [
                Expanded(
                  child: _buildAnalyticsItem(
                    'Total Staff',
                    '${analytics['total_staff'] ?? 0}',
                    AppIcons.people,
                    AppColors.primary,
                  ),
                ),
                Expanded(
                  child: _buildAnalyticsItem(
                    'Active',
                    '${analytics['active_staff'] ?? 0}',
                    AppIcons.checkCircle,
                    AppColors.success,
                  ),
                ),
                Expanded(
                  child: _buildAnalyticsItem(
                    'Avg Rating',
                    '${(analytics['performance_metrics']?['average_rating'] ?? 0.0).toStringAsFixed(1)}',
                    AppIcons.star,
                    AppColors.warning,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsItem(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const Gap.vertical(AppSpacing.s),
        Text(
          value,
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          title,
          style: AppTypography.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildStaffList(List<StaffModel> staff, String emptyMessage) {
    final colorScheme = Theme.of(context).colorScheme;

    if (staff.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                  AppIcons.people,
                  size: 64,
                  color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                )
                .animate()
                .scale(duration: AppMotion.slow, curve: AppCurves.emphasized)
                .fadeIn(duration: AppMotion.normal),
            const Gap.vertical(AppSpacing.l),
            Text(
                  emptyMessage,
                  style: AppTypography.textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                )
                .animate()
                .fadeIn(delay: AppMotion.fast, duration: AppMotion.normal)
                .slideY(
                  begin: 0.3,
                  end: 0.0,
                  delay: AppMotion.fast,
                  duration: AppMotion.normal,
                ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: SpacingUtils.all(AppSpacing.l),
      itemCount: staff.length,
      itemBuilder: (context, index) {
        final member = staff[index];
        return _buildStaffCard(member, index);
      },
    );
  }

  Widget _buildStaffCard(StaffModel member, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
          onTap: () => _viewStaffDetails(member),
          margin: const EdgeInsets.only(bottom: AppSpacing.m),
          child: Padding(
            padding: SpacingUtils.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Text(
                            member.firstName[0].toUpperCase(),
                            style: AppTypography.textTheme.titleMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ),
                        const Gap.horizontal(AppSpacing.m),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              member.fullName,
                              style: AppTypography.textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSurface,
                                  ),
                            ),
                            Text(
                              member.email,
                              style: AppTypography.textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    ChipsX.status(
                      label: member.statusDisplayText,
                      status: _getChipStatus(member.status),
                    ),
                  ],
                ),
                const Gap.vertical(AppSpacing.s),
                Row(
                  children: [
                    ChipsX.status(
                      label: member.roleDisplayText,
                      status: _getRoleChipStatus(member.role),
                    ),
                    const Gap.horizontal(AppSpacing.s),
                    if (member.phone != null) ...[
                      Icon(
                        AppIcons.phone,
                        size: 16,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      const Gap.horizontal(AppSpacing.xs),
                      Text(
                        member.phone!,
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
                const Gap.vertical(AppSpacing.s),
                Row(
                  children: [
                    Icon(
                      AppIcons.clock,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const Gap.horizontal(AppSpacing.xs),
                    Text(
                      'Last login: ${member.lastLoginDisplayText}',
                      style: AppTypography.textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    if (member.metadata['performance_rating'] != null) ...[
                      Icon(AppIcons.star, size: 16, color: AppColors.warning),
                      const Gap.horizontal(AppSpacing.xs),
                      Text(
                        '${member.metadata['performance_rating']}',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.warning,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        )
        .animate()
        .fadeIn(
          delay: Duration(milliseconds: index * 100),
          duration: AppMotion.normal,
        )
        .slideY(
          begin: 0.3,
          end: 0.0,
          delay: Duration(milliseconds: index * 100),
          duration: AppMotion.normal,
        );
  }

  ChipStatus _getChipStatus(StaffStatus status) {
    switch (status) {
      case StaffStatus.active:
        return ChipStatus.success;
      case StaffStatus.inactive:
        return ChipStatus.warning;
      case StaffStatus.suspended:
        return ChipStatus.error;
      case StaffStatus.terminated:
        return ChipStatus.neutral;
    }
  }

  ChipStatus _getRoleChipStatus(StaffRole role) {
    switch (role) {
      case StaffRole.manager:
        return ChipStatus.primary;
      case StaffRole.supervisor:
        return ChipStatus.info;
      case StaffRole.operator:
        return ChipStatus.success;
      case StaffRole.cleaner:
        return ChipStatus.warning;
      case StaffRole.driver:
        return ChipStatus.info;
      case StaffRole.admin:
        return ChipStatus.error;
    }
  }

  void _viewStaffDetails(StaffModel member) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => StaffDetailsScreen(staff: member),
      ),
    );
  }

  void _addStaff() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddStaffScreen()));
  }
}
