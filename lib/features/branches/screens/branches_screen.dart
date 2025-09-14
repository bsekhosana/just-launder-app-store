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
import '../providers/branch_provider.dart';
import '../../../data/models/laundrette_branch.dart';
import 'add_edit_branch_screen.dart';
import 'branch_details_screen.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({super.key});

  @override
  State<BranchesScreen> createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  @override
  void initState() {
    super.initState();
    _loadBranches();
  }

  Future<void> _loadBranches() async {
    final branchProvider = Provider.of<BranchProvider>(context, listen: false);
    await branchProvider.loadBranches(
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
          'Branches',
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AnimatedButton(
              onPressed: _addBranch,
              backgroundColor: Colors.white,
              width: 48,
              height: 48,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 1),
              tooltip: 'Add Branch',
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(AppIcons.add, color: AppColors.primary, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<BranchProvider>(
        builder: (context, branchProvider, child) {
          if (branchProvider.isLoading) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          if (branchProvider.branches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                        AppIcons.branches,
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
                        'No branches found',
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
                        'Add your first branch to get started',
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
            itemCount: branchProvider.branches.length,
            itemBuilder: (context, index) {
              final branch = branchProvider.branches[index];
              return _buildBranchCard(branch, index);
            },
          );
        },
      ),
    );
  }

  Widget _buildBranchCard(LaundretteBranch branch, int index) {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
          onTap: () => _viewBranchDetails(branch),
          margin: const EdgeInsets.only(bottom: AppSpacing.m),
          child: Padding(
            padding: SpacingUtils.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        branch.name,
                        style: AppTypography.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    ChipsX.status(
                      label: branch.isCurrentlyOpen ? 'Open' : 'Closed',
                      status:
                          branch.isCurrentlyOpen
                              ? ChipStatus.success
                              : ChipStatus.error,
                    ),
                  ],
                ),
                const Gap.vertical(AppSpacing.s),
                Text(
                  branch.fullAddress,
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Gap.vertical(AppSpacing.xs),
                Text(
                  '${branch.currentOrderCount}/${branch.maxConcurrentOrders} orders',
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                const Gap.vertical(AppSpacing.m),
                Row(
                  children: [
                    Icon(
                      AppIcons.phone,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const Gap.horizontal(AppSpacing.xs),
                    Expanded(
                      child: Text(
                        branch.phoneNumber ?? 'No phone',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const Gap.horizontal(AppSpacing.m),
                    Icon(
                      AppIcons.email,
                      size: 16,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const Gap.horizontal(AppSpacing.xs),
                    Expanded(
                      child: Text(
                        branch.email ?? 'No email',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const Gap.vertical(AppSpacing.m),
                Wrap(
                  spacing: AppSpacing.s,
                  runSpacing: AppSpacing.xs,
                  children: [
                    if (branch.autoAcceptOrders) ...[
                      ChipsX.status(
                        label: 'Auto Accept',
                        status: ChipStatus.info,
                      ),
                    ],
                    if (branch.supportsPriorityDelivery) ...[
                      ChipsX.status(
                        label: 'Priority Delivery',
                        status: ChipStatus.success,
                      ),
                    ],
                  ],
                ),
                const Gap.vertical(AppSpacing.m),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedButtons.text(
                      onPressed: () => _editBranch(branch),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            AppIcons.edit,
                            size: 16,
                            color: AppColors.primary,
                          ),
                          const Gap.horizontal(AppSpacing.xs),
                          Text(
                            'Edit',
                            style: AppTypography.textTheme.labelMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Gap.horizontal(AppSpacing.s),
                    AnimatedButtons.text(
                      onPressed: () => _deleteBranch(branch),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            AppIcons.delete,
                            size: 16,
                            color: AppColors.error,
                          ),
                          const Gap.horizontal(AppSpacing.xs),
                          Text(
                            'Delete',
                            style: AppTypography.textTheme.labelMedium
                                ?.copyWith(
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
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

  void _addBranch() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddEditBranchScreen()),
    );
  }

  void _viewBranchDetails(LaundretteBranch branch) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BranchDetailsScreen(branch: branch),
      ),
    );
  }

  void _editBranch(LaundretteBranch branch) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddEditBranchScreen(branch: branch, isEdit: true),
      ),
    );
  }

  void _deleteBranch(LaundretteBranch branch) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Branch'),
            content: Text('Are you sure you want to delete "${branch.name}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final branchProvider = Provider.of<BranchProvider>(
                    context,
                    listen: false,
                  );
                  final success = await branchProvider.deleteBranch(branch.id);

                  if (success && mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Branch deleted successfully'),
                        backgroundColor: AppColors.success,
                      ),
                    );
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Failed to delete branch'),
                        backgroundColor: AppColors.error,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
