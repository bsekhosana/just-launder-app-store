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
import '../providers/staff_provider.dart';
import '../../../data/models/staff_member.dart';
import 'add_edit_staff_screen.dart';
import 'driver_management_screen.dart';
import 'driver_details_screen.dart';

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  @override
  void initState() {
    super.initState();
    _loadStaff();
  }

  Future<void> _loadStaff() async {
    final staffProvider = Provider.of<StaffProvider>(context, listen: false);
    await staffProvider.loadStaff(
      'laundrette_business_1',
    ); // Mock laundrette ID
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        backgroundColor: colorScheme.surface.withOpacity(0.9),
        elevation: 0,
        title: Text(
          'Staff',
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          AnimatedButtons.icon(
            onPressed: _openDriverManagement,
            child: Icon(AppIcons.delivery, color: AppColors.primary),
            tooltip: 'Driver Management',
          ),
          AnimatedButtons.icon(
            onPressed: _addStaffMember,
            child: Icon(AppIcons.add, color: AppColors.primary),
            tooltip: 'Add Staff',
          ),
        ],
      ),
      body: Consumer<StaffProvider>(
        builder: (context, staffProvider, child) {
          if (staffProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (staffProvider.staff.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                        AppIcons.staff,
                        size: 64,
                        color: colorScheme.onSurfaceVariant.withOpacity(0.5),
                      )
                      .animate()
                      .scale(
                        duration: AppMotion.slow,
                        curve: AppCurves.emphasized,
                      )
                      .fadeIn(duration: AppMotion.normal),
                  const Gap.vertical(AppSpacing.l),
                  Text(
                        'No staff members found',
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
                  const Gap.vertical(AppSpacing.s),
                  Text(
                        'Add your first staff member to get started',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      )
                      .animate()
                      .fadeIn(
                        delay: AppMotion.normal,
                        duration: AppMotion.normal,
                      )
                      .slideY(
                        begin: 0.3,
                        end: 0.0,
                        delay: AppMotion.normal,
                        duration: AppMotion.normal,
                      ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: SpacingUtils.all(AppSpacing.l),
            itemCount: staffProvider.staff.length,
            itemBuilder: (context, index) {
              final staffMember = staffProvider.staff[index];
              return _buildStaffCard(staffMember, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildStaffCard(StaffMember staffMember, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
          onTap: () => _viewStaffDetails(staffMember),
          margin: const EdgeInsets.only(bottom: AppSpacing.m),
          child: Padding(
            padding: SpacingUtils.all(AppSpacing.l),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.primary.withOpacity(0.1),
                  child:
                      staffMember.profileImageUrl != null
                          ? ClipOval(
                            child: Image.network(
                              staffMember.profileImageUrl!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  AppIcons.staff,
                                  color: AppColors.primary,
                                  size: 24,
                                );
                              },
                            ),
                          )
                          : Icon(
                            AppIcons.staff,
                            color: AppColors.primary,
                            size: 24,
                          ),
                ),
                const Gap.horizontal(AppSpacing.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        staffMember.fullName,
                        style: AppTypography.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const Gap.vertical(AppSpacing.xs),
                      Text(
                        staffMember.roleDisplayText,
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const Gap.vertical(AppSpacing.xs),
                      Text(
                        staffMember.email,
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ChipsX.status(
                      label: staffMember.statusDisplayText,
                      status:
                          staffMember.isActive
                              ? ChipStatus.success
                              : ChipStatus.error,
                    ),
                    const Gap.vertical(AppSpacing.s),
                    if (staffMember.hourlyRate != null &&
                        staffMember.hourlyRate! > 0)
                      Text(
                        '\$${staffMember.hourlyRate!.toStringAsFixed(2)}/hr',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
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

  void _addStaffMember() {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const AddEditStaffScreen()));
  }

  void _openDriverManagement() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const DriverManagementScreen()),
    );
  }

  void _viewStaffDetails(StaffMember staffMember) {
    if (staffMember.role == StaffRole.driver) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DriverDetailsScreen(driver: staffMember),
        ),
      );
    } else {
      // TODO: Implement staff details screen for non-drivers
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Staff details coming soon'),
          backgroundColor: AppColors.info,
        ),
      );
    }
  }
}
