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

class StaffDetailsScreen extends StatefulWidget {
  final StaffModel staff;

  const StaffDetailsScreen({super.key, required this.staff});

  @override
  State<StaffDetailsScreen> createState() => _StaffDetailsScreenState();
}

class _StaffDetailsScreenState extends State<StaffDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.staff.fullName,
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
        actions: [
          AnimatedButton(
            onPressed: _editStaff,
            child: Text(
              'Edit',
              style: AppTypography.textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s),
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
                Tab(text: 'Overview'),
                Tab(text: 'Permissions'),
                Tab(text: 'Activity'),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildPermissionsTab(),
          _buildActivityTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: SpacingUtils.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileCard(),
          const SizedBox(height: AppSpacing.l),
          _buildStatusCard(),
          const SizedBox(height: AppSpacing.l),
          _buildContactCard(),
          const SizedBox(height: AppSpacing.l),
          _buildPerformanceCard(),
          const SizedBox(height: AppSpacing.l),
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                widget.staff.firstName[0].toUpperCase(),
                style: AppTypography.textTheme.headlineMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              widget.staff.fullName,
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              widget.staff.email,
              style: AppTypography.textTheme.bodyLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            ChipsX.status(
              label: widget.staff.roleDisplayText,
              status: _getRoleChipStatus(widget.staff.role),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status Information',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Status',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                ChipsX.status(
                  label: widget.staff.statusDisplayText,
                  status: _getChipStatus(widget.staff.status),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last Login',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  widget.staff.lastLoginDisplayText,
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Member Since',
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                Text(
                  _formatDateTime(widget.staff.createdAt),
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Contact Information',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            _buildContactRow('Email', widget.staff.email, AppIcons.email),
            if (widget.staff.phone != null)
              _buildContactRow('Phone', widget.staff.phone!, AppIcons.phone),
          ],
        ),
      ),
    );
  }

  Widget _buildContactRow(String label, String value, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
          const SizedBox(width: AppSpacing.s),
          Text(
            '$label: ',
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard() {
    final colorScheme = Theme.of(context).colorScheme;
    final rating =
        widget.staff.metadata['performance_rating'] as double? ?? 0.0;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              children: [
                Icon(AppIcons.star, color: AppColors.warning, size: 24),
                const SizedBox(width: AppSpacing.s),
                Text(
                  'Rating: $rating',
                  style: AppTypography.textTheme.titleMedium?.copyWith(
                    color: colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            LinearProgressIndicator(
              value: rating / 5.0,
              backgroundColor: colorScheme.outline.withOpacity(0.2),
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.warning),
            ),
            const SizedBox(height: AppSpacing.s),
            if (widget.staff.metadata['department'] != null)
              Text(
                'Department: ${widget.staff.metadata['department']}',
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            if (widget.staff.metadata['shift'] != null)
              Text(
                'Shift: ${widget.staff.metadata['shift']}',
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                if (widget.staff.isActive) ...[
                  AnimatedButton(
                    onPressed: () => _updateStatus(StaffStatus.inactive),
                    backgroundColor: AppColors.warning,
                    child: Text(
                      'Deactivate',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  AnimatedButton(
                    onPressed: () => _updateStatus(StaffStatus.suspended),
                    backgroundColor: AppColors.error,
                    child: Text(
                      'Suspend',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ] else if (widget.staff.status == StaffStatus.inactive) ...[
                  AnimatedButton(
                    onPressed: () => _updateStatus(StaffStatus.active),
                    backgroundColor: AppColors.success,
                    child: Text(
                      'Activate',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ] else if (widget.staff.status == StaffStatus.suspended) ...[
                  AnimatedButton(
                    onPressed: () => _updateStatus(StaffStatus.active),
                    backgroundColor: AppColors.success,
                    child: Text(
                      'Reactivate',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
                AnimatedButton(
                  onPressed: _editPermissions,
                  backgroundColor: AppColors.primary,
                  child: Text(
                    'Edit Permissions',
                    style: AppTypography.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AnimatedButton(
                  onPressed: _deleteStaff,
                  backgroundColor: AppColors.error,
                  child: Text(
                    'Delete',
                    style: AppTypography.textTheme.labelMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsTab() {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: SpacingUtils.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Staff Permissions',
            style: AppTypography.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          ...StaffPermission.values.map(
            (permission) => _buildPermissionItem(permission),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionItem(StaffPermission permission) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasPermission = widget.staff.hasPermission(permission);

    return CardsX.elevated(
      margin: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.m),
        child: Row(
          children: [
            Icon(
              hasPermission ? AppIcons.checkCircle : AppIcons.cancel,
              color: hasPermission ? AppColors.success : AppColors.error,
              size: 20,
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: Text(
                _getPermissionDisplayText(permission),
                style: AppTypography.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            if (hasPermission)
              ChipsX.status(label: 'Granted', status: ChipStatus.success),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityTab() {
    final colorScheme = Theme.of(context).colorScheme;

    return SingleChildScrollView(
      padding: SpacingUtils.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Recent Activity',
            style: AppTypography.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          _buildActivityItem(
            'Last Login',
            widget.staff.lastLoginDisplayText,
            AppIcons.login,
            widget.staff.lastLoginAt,
          ),
          _buildActivityItem(
            'Account Created',
            _formatDateTime(widget.staff.createdAt),
            AppIcons.personAdd,
            widget.staff.createdAt,
          ),
          _buildActivityItem(
            'Last Updated',
            _formatDateTime(widget.staff.updatedAt),
            AppIcons.edit,
            widget.staff.updatedAt,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem(
    String title,
    String description,
    IconData icon,
    DateTime? dateTime,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      margin: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.m),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(icon, color: AppColors.primary, size: 16),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    description,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getPermissionDisplayText(StaffPermission permission) {
    switch (permission) {
      case StaffPermission.viewOrders:
        return 'View Orders';
      case StaffPermission.updateOrders:
        return 'Update Orders';
      case StaffPermission.manageOrders:
        return 'Manage Orders';
      case StaffPermission.viewAnalytics:
        return 'View Analytics';
      case StaffPermission.manageStaff:
        return 'Manage Staff';
      case StaffPermission.manageInventory:
        return 'Manage Inventory';
      case StaffPermission.managePricing:
        return 'Manage Pricing';
      case StaffPermission.manageCustomers:
        return 'Manage Customers';
      case StaffPermission.manageDrivers:
        return 'Manage Drivers';
      case StaffPermission.manageSettings:
        return 'Manage Settings';
    }
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

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _updateStatus(StaffStatus status) async {
    final staffProvider = Provider.of<StaffManagementProvider>(
      context,
      listen: false,
    );
    final success = await staffProvider.updateStaffStatus(
      widget.staff.id,
      status,
    );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Staff status updated to ${status.name}'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.of(context).pop();
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update staff status'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  void _editStaff() {
    // TODO: Implement edit staff functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit staff functionality coming soon'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  void _editPermissions() {
    // TODO: Implement edit permissions functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit permissions functionality coming soon'),
        backgroundColor: AppColors.info,
      ),
    );
  }

  Future<void> _deleteStaff() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Staff'),
            content: Text(
              'Are you sure you want to delete ${widget.staff.fullName}?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      final staffProvider = Provider.of<StaffManagementProvider>(
        context,
        listen: false,
      );
      final success = await staffProvider.deleteStaff(widget.staff.id);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.staff.fullName} deleted successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete staff'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
