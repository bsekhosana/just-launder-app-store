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
import '../../../ui/primitives/snack_x.dart';
import '../providers/staff_provider.dart';
import '../../../data/models/staff_member.dart';
import '../../branches/providers/branch_provider.dart';

class AddEditStaffScreen extends StatefulWidget {
  final StaffMember? staff;
  final bool isEdit;

  const AddEditStaffScreen({super.key, this.staff, this.isEdit = false});

  @override
  State<AddEditStaffScreen> createState() => _AddEditStaffScreenState();
}

class _AddEditStaffScreenState extends State<AddEditStaffScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _hourlyRateController = TextEditingController();

  StaffRole _selectedRole = StaffRole.staff;
  StaffStatus _selectedStatus = StaffStatus.active;
  List<String> _selectedBranchIds = [];
  final Map<String, String> _workingHours = {
    'monday': '09:00-17:00',
    'tuesday': '09:00-17:00',
    'wednesday': '09:00-17:00',
    'thursday': '09:00-17:00',
    'friday': '09:00-17:00',
    'saturday': '10:00-16:00',
    'sunday': 'closed',
  };

  final Map<String, bool> _permissions = {
    'manage_orders': false,
    'manage_customers': false,
    'manage_inventory': false,
    'view_analytics': false,
    'manage_staff': false,
    'manage_branches': false,
    'manage_drivers': false,
  };

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.staff != null) {
      _populateFields();
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _hourlyRateController.dispose();
    super.dispose();
  }

  void _populateFields() {
    final staff = widget.staff!;
    _firstNameController.text = staff.firstName;
    _lastNameController.text = staff.lastName;
    _emailController.text = staff.email;
    _phoneController.text = staff.phoneNumber ?? '';
    _hourlyRateController.text = staff.hourlyRate?.toString() ?? '';

    _selectedRole = staff.role;
    _selectedStatus = staff.status;
    _selectedBranchIds = List<String>.from(staff.branchIds);

    // Populate working hours
    for (var entry in staff.workingHours.entries) {
      _workingHours[entry.key] = entry.value;
    }

    // Populate permissions
    for (var entry in staff.permissions.entries) {
      _permissions[entry.key] = entry.value as bool? ?? false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Staff Member' : 'Add Staff Member'),
        actions: [TextButton(onPressed: _saveStaff, child: const Text('Save'))],
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBasicInfoSection(),
              const SizedBox(height: 24),
              _buildRoleAndStatusSection(),
              const SizedBox(height: 24),
              _buildBranchAssignmentSection(),
              const SizedBox(height: 24),
              _buildWorkingHoursSection(),
              const SizedBox(height: 24),
              _buildPermissionsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _firstNameController,
                    decoration: const InputDecoration(
                      labelText: 'First Name *',
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
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _lastNameController,
                    decoration: const InputDecoration(
                      labelText: 'Last Name *',
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
            const SizedBox(height: 16),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email *',
                hintText: 'Enter email address',
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number *',
                      hintText: 'Enter phone number',
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _hourlyRateController,
                    decoration: const InputDecoration(
                      labelText: 'Hourly Rate',
                      hintText: '0.00',
                      prefixText: '£',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleAndStatusSection() {
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
            const SizedBox(height: 16),
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
                });
              },
            ),
            const SizedBox(height: 16),
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

  Widget _buildBranchAssignmentSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Branch Assignment',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Consumer<BranchProvider>(
              builder: (context, branchProvider, child) {
                if (branchProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children:
                      branchProvider.branches.map((branch) {
                        final isSelected = _selectedBranchIds.contains(
                          branch.id,
                        );
                        return CheckboxListTile(
                          title: Text(branch.name),
                          subtitle: Text(branch.fullAddress),
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedBranchIds.add(branch.id);
                              } else {
                                _selectedBranchIds.remove(branch.id);
                              }
                            });
                          },
                        );
                      }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkingHoursSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Working Hours',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._workingHours.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(
                        entry.key.toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        initialValue: entry.value,
                        decoration: const InputDecoration(
                          hintText: '09:00-17:00 or closed',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          _workingHours[entry.key] = value;
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPermissionsSection() {
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
            const SizedBox(height: 16),
            ..._permissions.entries.map((entry) {
              return SwitchListTile(
                title: Text(_getPermissionDisplayText(entry.key)),
                subtitle: Text(_getPermissionDescription(entry.key)),
                value: entry.value,
                onChanged: (value) {
                  setState(() {
                    _permissions[entry.key] = value;
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  String _getRoleDisplayText(StaffRole role) {
    switch (role) {
      case StaffRole.owner:
        return 'Owner';
      case StaffRole.manager:
        return 'Manager';
      case StaffRole.staff:
        return 'Staff';
      // Driver role removed - handled by standalone app
      case StaffRole.cleaner:
        return 'Cleaner';
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

  String _getPermissionDisplayText(String permission) {
    switch (permission) {
      case 'manage_orders':
        return 'Manage Orders';
      case 'manage_customers':
        return 'Manage Customers';
      case 'manage_inventory':
        return 'Manage Inventory';
      case 'view_analytics':
        return 'View Analytics';
      case 'manage_staff':
        return 'Manage Staff';
      case 'manage_branches':
        return 'Manage Branches';
      case 'manage_drivers':
        return 'Manage Drivers';
      default:
        return permission.replaceAll('_', ' ').toUpperCase();
    }
  }

  String _getPermissionDescription(String permission) {
    switch (permission) {
      case 'manage_orders':
        return 'Can approve, decline, and manage orders';
      case 'manage_customers':
        return 'Can view and manage customer information';
      case 'manage_inventory':
        return 'Can manage inventory and pricing';
      case 'view_analytics':
        return 'Can view business analytics and reports';
      case 'manage_staff':
        return 'Can add, edit, and manage staff members';
      case 'manage_branches':
        return 'Can manage branch settings and information';
      case 'manage_drivers':
        return 'Can manage driver assignments and tracking';
      default:
        return 'Permission description';
    }
  }

  Future<void> _saveStaff() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final staffProvider = Provider.of<StaffProvider>(context, listen: false);

    final staff = StaffMember(
      id:
          widget.isEdit
              ? widget.staff!.id
              : DateTime.now().millisecondsSinceEpoch.toString(),
      laundretteId: 'laundrette_business_1', // Mock laundrette ID
      userId: DateTime.now().millisecondsSinceEpoch.toString(), // Mock user ID
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      role: _selectedRole,
      status: _selectedStatus,
      branchIds: _selectedBranchIds,
      permissions: _permissions,
      workingHours: Map.from(_workingHours),
      hourlyRate:
          _hourlyRateController.text.isNotEmpty
              ? double.tryParse(_hourlyRateController.text)
              : null,
      hireDate: widget.isEdit ? widget.staff!.hireDate : DateTime.now(),
      lastActiveAt: DateTime.now(),
      metadata: {},
      createdAt: widget.isEdit ? widget.staff!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    bool success;
    if (widget.isEdit) {
      success = await staffProvider.updateStaff(staff);
    } else {
      success = await staffProvider.addStaff(staff);
    }

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEdit
                ? 'Staff member updated successfully'
                : 'Staff member added successfully',
          ),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save staff member'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }
}
