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
// Driver screens removed - drivers handled by standalone app

class StaffScreen extends StatefulWidget {
  const StaffScreen({super.key});

  @override
  State<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends State<StaffScreen> {
  @override
  void initState() {
    super.initState();
    // Load staff after the first frame is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadStaff();
    });
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
      backgroundColor: Colors.white,
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
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedButton(
                  onPressed: _openDriverManagement,
                  backgroundColor: Colors.white,
                  width: 48,
                  height: 48,
                  borderRadius: BorderRadius.circular(24),
                  tooltip: 'Driver Management',
                  border: Border.all(color: Colors.white, width: 1),
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      AppIcons.delivery,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedButton(
                  onPressed: _addStaffMember,
                  backgroundColor: Colors.white,
                  width: 48,
                  height: 48,
                  borderRadius: BorderRadius.circular(24),
                  tooltip: 'Add Staff',
                  border: Border.all(color: Colors.white, width: 1),
                  child: Align(
                    alignment: Alignment.center,
                    child: Icon(
                      AppIcons.add,
                      color: AppColors.primary,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
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
                  const SizedBox(height: AppSpacing.l),
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
                  const SizedBox(height: AppSpacing.s),
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
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primary.withOpacity(0.1),
                  ),
                  child:
                      staffMember.profileImageUrl != null
                          ? ClipOval(
                            child: Image.network(
                              staffMember.profileImageUrl!,
                              width: 48,
                              height: 48,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return SizedBox(
                                  width: 48,
                                  height: 48,
                                  child: Icon(
                                    AppIcons.staff,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                );
                              },
                            ),
                          )
                          : SizedBox(
                            width: 48,
                            height: 48,
                            child: Icon(
                              AppIcons.staff,
                              color: AppColors.primary,
                              size: 20,
                            ),
                          ),
                ),
                const SizedBox(width: AppSpacing.m),
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
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        staffMember.roleDisplayText,
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
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
                    const SizedBox(height: AppSpacing.s),
                    if (staffMember.hourlyRate != null &&
                        staffMember.hourlyRate! > 0)
                      Text(
                        '£${staffMember.hourlyRate!.toStringAsFixed(2)}/hr',
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Driver management is handled by the standalone driver app',
        ),
      ),
    );
  }

  void _viewStaffDetails(StaffMember staffMember) {
    // Navigate to edit staff screen for all staff members
    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => AddEditStaffScreen(staff: staffMember, isEdit: true),
      ),
    );
  }
}
