import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Branches'),
        actions: [
          IconButton(icon: const Icon(Icons.add), onPressed: _addBranch),
        ],
      ),
      body: Consumer<BranchProvider>(
        builder: (context, branchProvider, child) {
          if (branchProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (branchProvider.branches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.business_outlined,
                    size: 64,
                    color: AppTheme.lightGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No branches found',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppTheme.mediumGrey),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first branch to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.mediumGrey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: branchProvider.branches.length,
            itemBuilder: (context, index) {
              final branch = branchProvider.branches[index];
              return _buildBranchCard(branch);
            },
          );
        },
      ),
    );
  }

  Widget _buildBranchCard(LaundretteBranch branch) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => _viewBranchDetails(branch),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      branch.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color:
                          branch.isCurrentlyOpen
                              ? AppTheme.successGreen.withOpacity(0.1)
                              : AppTheme.errorRed.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color:
                            branch.isCurrentlyOpen
                                ? AppTheme.successGreen
                                : AppTheme.errorRed,
                      ),
                    ),
                    child: Text(
                      branch.isCurrentlyOpen ? 'Open' : 'Closed',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color:
                            branch.isCurrentlyOpen
                                ? AppTheme.successGreen
                                : AppTheme.errorRed,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                branch.fullAddress,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGrey),
              ),
              const SizedBox(height: 4),
              Text(
                '${branch.currentOrderCount}/${branch.maxConcurrentOrders} orders',
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: AppTheme.mediumGrey),
                  const SizedBox(width: 4),
                  Text(
                    branch.phoneNumber ?? 'No phone',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
                  ),
                  const SizedBox(width: 16),
                  Icon(Icons.email, size: 16, color: AppTheme.mediumGrey),
                  const SizedBox(width: 4),
                  Text(
                    branch.email ?? 'No email',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGrey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (branch.autoAcceptOrders) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Auto Accept',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (branch.supportsPriorityDelivery) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Priority Delivery',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: () => _editBranch(branch),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _deleteBranch(branch),
                    icon: const Icon(
                      Icons.delete,
                      size: 16,
                      color: AppTheme.errorRed,
                    ),
                    label: const Text(
                      'Delete',
                      style: TextStyle(color: AppTheme.errorRed),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
                      const SnackBar(
                        content: Text('Branch deleted successfully'),
                        backgroundColor: AppTheme.successGreen,
                      ),
                    );
                  } else if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to delete branch'),
                        backgroundColor: AppTheme.errorRed,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.errorRed,
                ),
                child: const Text('Delete'),
              ),
            ],
          ),
    );
  }
}
