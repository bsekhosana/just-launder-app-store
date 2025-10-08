import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/spacing_utils.dart';
import '../../../design_system/motion.dart';
import '../../../design_system/icons.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/card_x.dart';
import '../providers/staff_management_provider.dart';
import '../data/models/staff_model.dart';

class AddStaffScreen extends StatefulWidget {
  const AddStaffScreen({super.key});

  @override
  State<AddStaffScreen> createState() => _AddStaffScreenState();
}

class _AddStaffScreenState extends State<AddStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  StaffRole _selectedRole = StaffRole.operator;
  StaffStatus _selectedStatus = StaffStatus.active;
  List<StaffPermission> _selectedPermissions = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Add Staff Member',
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
            onPressed: _isLoading ? null : _saveStaff,
            child: Text(
              'Save',
              style: AppTypography.textTheme.labelMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.s),
        ],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: SpacingUtils.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPersonalInfoCard(),
              const SizedBox(height: AppSpacing.l),
              _buildRoleAndStatusCard(),
              const SizedBox(height: AppSpacing.l),
              _buildPermissionsCard(),
              const SizedBox(height: AppSpacing.l),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Personal Information',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      hintText: 'Enter first name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter first name';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      hintText: 'Enter last name',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter last name';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter email address',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email address';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.m),
            TextFormField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone (Optional)',
                hintText: 'Enter phone number',
              ),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleAndStatusCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Role & Status',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            DropdownButtonFormField<StaffRole>(
              value: _selectedRole,
              decoration: const InputDecoration(labelText: 'Role'),
              items:
                  StaffRole.values.map((role) {
                    return DropdownMenuItem(
                      value: role,
                      child: Text(_getRoleDisplayText(role)),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                  _updatePermissionsForRole();
                });
              },
            ),
            const SizedBox(height: AppSpacing.m),
            DropdownButtonFormField<StaffStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Status'),
              items:
                  StaffStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(_getStatusDisplayText(status)),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsCard() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Permissions',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Select the permissions this staff member should have:',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            ...StaffPermission.values.map(
              (permission) => _buildPermissionCheckbox(permission),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionCheckbox(StaffPermission permission) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = _selectedPermissions.contains(permission);

    return CheckboxListTile(
      title: Text(
        _getPermissionDisplayText(permission),
        style: AppTypography.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        _getPermissionDescription(permission),
        style: AppTypography.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      value: isSelected,
      onChanged: (value) {
        setState(() {
          if (value == true) {
            _selectedPermissions.add(permission);
          } else {
            _selectedPermissions.remove(permission);
          }
        });
      },
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
            Row(
              children: [
                Expanded(
                  child: AnimatedButton(
                    onPressed: _isLoading ? null : _saveStaff,
                    backgroundColor: AppColors.primary,
                    child:
                        _isLoading
                            ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text(
                              'Save Staff Member',
                              style: AppTypography.textTheme.labelMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                  ),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: AnimatedButton(
                    onPressed: _isLoading ? null : _cancel,
                    backgroundColor: AppColors.onSurfaceVariant,
                    child: Text(
                      'Cancel',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
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

  String _getRoleDisplayText(StaffRole role) {
    switch (role) {
      case StaffRole.manager:
        return 'Manager';
      case StaffRole.supervisor:
        return 'Supervisor';
      case StaffRole.operator:
        return 'Operator';
      case StaffRole.cleaner:
        return 'Cleaner';
      case StaffRole.driver:
        return 'Driver';
      case StaffRole.admin:
        return 'Admin';
    }
  }

  String _getStatusDisplayText(StaffStatus status) {
    switch (status) {
      case StaffStatus.active:
        return 'Active';
      case StaffStatus.inactive:
        return 'Inactive';
      case StaffStatus.suspended:
        return 'Suspended';
      case StaffStatus.terminated:
        return 'Terminated';
    }
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

  String _getPermissionDescription(StaffPermission permission) {
    switch (permission) {
      case StaffPermission.viewOrders:
        return 'Can view order information';
      case StaffPermission.updateOrders:
        return 'Can update order status and details';
      case StaffPermission.manageOrders:
        return 'Can create, update, and delete orders';
      case StaffPermission.viewAnalytics:
        return 'Can view analytics and reports';
      case StaffPermission.manageStaff:
        return 'Can manage other staff members';
      case StaffPermission.manageInventory:
        return 'Can manage inventory and supplies';
      case StaffPermission.managePricing:
        return 'Can manage pricing and discounts';
      case StaffPermission.manageCustomers:
        return 'Can manage customer information';
      case StaffPermission.manageDrivers:
        return 'Can manage driver assignments';
      case StaffPermission.manageSettings:
        return 'Can manage system settings';
    }
  }

  void _updatePermissionsForRole() {
    setState(() {
      _selectedPermissions.clear();

      // Set default permissions based on role
      switch (_selectedRole) {
        case StaffRole.admin:
          _selectedPermissions.addAll(StaffPermission.values);
          break;
        case StaffRole.manager:
          _selectedPermissions.addAll([
            StaffPermission.viewOrders,
            StaffPermission.updateOrders,
            StaffPermission.manageOrders,
            StaffPermission.viewAnalytics,
            StaffPermission.manageStaff,
            StaffPermission.managePricing,
            StaffPermission.manageCustomers,
            StaffPermission.manageDrivers,
          ]);
          break;
        case StaffRole.supervisor:
          _selectedPermissions.addAll([
            StaffPermission.viewOrders,
            StaffPermission.updateOrders,
            StaffPermission.manageOrders,
            StaffPermission.viewAnalytics,
          ]);
          break;
        case StaffRole.operator:
          _selectedPermissions.addAll([
            StaffPermission.viewOrders,
            StaffPermission.updateOrders,
          ]);
          break;
        case StaffRole.cleaner:
          _selectedPermissions.addAll([
            StaffPermission.viewOrders,
            StaffPermission.updateOrders,
          ]);
          break;
        case StaffRole.driver:
          _selectedPermissions.addAll([
            StaffPermission.viewOrders,
            StaffPermission.updateOrders,
          ]);
          break;
      }
    });
  }

  Future<void> _saveStaff() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final staffProvider = Provider.of<StaffManagementProvider>(
        context,
        listen: false,
      );

      final newStaff = StaffModel(
        id: 'staff_${DateTime.now().millisecondsSinceEpoch}',
        tenantId: 'laundrette_business_1',
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        phone:
            _phoneController.text.trim().isNotEmpty
                ? _phoneController.text.trim()
                : null,
        role: _selectedRole,
        status: _selectedStatus,
        permissions: _selectedPermissions,
        profileImageUrl: null,
        lastLoginAt: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        metadata: {
          'department': _getDepartmentForRole(_selectedRole),
          'shift': 'Day',
          'performance_rating': 0.0,
        },
      );

      final success = await staffProvider.addStaff(newStaff);

      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${newStaff.fullName} added successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.of(context).pop();
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add staff member'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  String _getDepartmentForRole(StaffRole role) {
    switch (role) {
      case StaffRole.manager:
      case StaffRole.supervisor:
        return 'Operations';
      case StaffRole.operator:
        return 'Processing';
      case StaffRole.cleaner:
        return 'Cleaning';
      case StaffRole.driver:
        return 'Delivery';
      case StaffRole.admin:
        return 'Administration';
    }
  }

  void _cancel() {
    Navigator.of(context).pop();
  }
}
