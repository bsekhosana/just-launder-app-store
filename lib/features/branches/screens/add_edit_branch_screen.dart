import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../ui/primitives/card_x.dart';
import '../../../ui/primitives/animated_button.dart';
import '../providers/branch_provider.dart';
import '../data/models/laundrette_branch.dart';

class AddEditBranchScreen extends StatefulWidget {
  final LaundretteBranch? branch;
  final bool isEdit;

  const AddEditBranchScreen({super.key, this.branch, this.isEdit = false});

  @override
  State<AddEditBranchScreen> createState() => _AddEditBranchScreenState();
}

class _AddEditBranchScreenState extends State<AddEditBranchScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postcodeController = TextEditingController();
  final _countryController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _maxOrdersController = TextEditingController();

  BranchStatus _selectedStatus = BranchStatus.active;
  bool _isOpen = true;
  bool _autoAcceptOrders = false;
  bool _supportsPriorityDelivery = false;

  // Operating hours
  final Map<String, String> _operatingHours = {
    'monday': '09:00-17:00',
    'tuesday': '09:00-17:00',
    'wednesday': '09:00-17:00',
    'thursday': '09:00-17:00',
    'friday': '09:00-17:00',
    'saturday': '10:00-16:00',
    'sunday': 'closed',
  };

  // Bag pricing
  final Map<String, TextEditingController> _bagPricingControllers = {
    'small': TextEditingController(text: '15.99'),
    'medium': TextEditingController(text: '19.99'),
    'large': TextEditingController(text: '24.99'),
    'extra_large': TextEditingController(text: '29.99'),
  };

  // Service pricing
  final Map<String, TextEditingController> _servicePricingControllers = {
    'wash_and_fold': TextEditingController(text: '2.50'),
    'dry_clean': TextEditingController(text: '8.99'),
    'ironing': TextEditingController(text: '1.99'),
    'express': TextEditingController(text: '5.00'),
    'stain_removal': TextEditingController(text: '3.50'),
  };

  @override
  void initState() {
    super.initState();
    if (widget.isEdit && widget.branch != null) {
      _populateFields();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postcodeController.dispose();
    _countryController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _maxOrdersController.dispose();

    for (var controller in _bagPricingControllers.values) {
      controller.dispose();
    }
    for (var controller in _servicePricingControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _populateFields() {
    final branch = widget.branch!;
    _nameController.text = branch.name;
    _descriptionController.text = branch.description ?? '';
    _addressController.text = branch.address;
    _cityController.text = branch.city;
    _postcodeController.text = branch.postcode;
    _countryController.text = branch.country;
    _phoneController.text = branch.phoneNumber ?? '';
    _emailController.text = branch.email ?? '';
    _maxOrdersController.text = branch.maxConcurrentOrders.toString();

    _selectedStatus = branch.status;
    _isOpen = branch.isOpen;
    _autoAcceptOrders = branch.autoAcceptOrders;
    _supportsPriorityDelivery = branch.supportsPriorityDelivery;

    // Populate operating hours
    for (var entry in branch.operatingHours.entries) {
      _operatingHours[entry.key] = entry.value;
    }

    // Populate pricing
    for (var entry in branch.bagPricing.entries) {
      _bagPricingControllers[entry.key]?.text = entry.value.toString();
    }
    for (var entry in branch.servicePricing.entries) {
      _servicePricingControllers[entry.key]?.text = entry.value.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.isEdit ? 'Edit Branch' : 'Add Branch',
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
        actions: [
          AnimatedButtons.secondary(
            onPressed: _saveBranch,
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
              _buildBasicInfoSection(),
              const SizedBox(height: AppSpacing.l),
              _buildStatusSection(),
              const SizedBox(height: AppSpacing.l),
              _buildOperatingHoursSection(),
              const SizedBox(height: AppSpacing.l),
              _buildPricingSection(),
              const SizedBox(height: AppSpacing.l),
              _buildSettingsSection(),
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
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Branch Name *',
                hintText: 'Enter branch name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter branch name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Description',
                hintText: 'Enter branch description',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Address *',
                      hintText: 'Street address',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter address';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'City *',
                      hintText: 'City',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter city';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _postcodeController,
                    decoration: const InputDecoration(
                      labelText: 'Postcode *',
                      hintText: 'Postal code',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter postcode';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _countryController,
                    decoration: const InputDecoration(
                      labelText: 'Country *',
                      hintText: 'Country',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter country';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Phone number',
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      hintText: 'Email address',
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _maxOrdersController,
              decoration: const InputDecoration(
                labelText: 'Max Concurrent Orders *',
                hintText: 'Maximum orders at once',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter max orders';
                }
                if (int.tryParse(value) == null) {
                  return 'Please enter a valid number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status & Availability',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<BranchStatus>(
              value: _selectedStatus,
              decoration: const InputDecoration(labelText: 'Branch Status'),
              items:
                  BranchStatus.values.map((status) {
                    return DropdownMenuItem(
                      value: status,
                      child: Text(status.name.toUpperCase()),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedStatus = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Branch is Open'),
              subtitle: const Text('Branch is currently accepting orders'),
              value: _isOpen,
              onChanged: (value) {
                setState(() {
                  _isOpen = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperatingHoursSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Operating Hours',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ..._operatingHours.entries.map((entry) {
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
                          _operatingHours[entry.key] = value;
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

  Widget _buildPricingSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Bag Pricing',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ..._bagPricingControllers.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 100,
                      child: Text(
                        entry.key.replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: entry.value,
                        decoration: const InputDecoration(
                          prefixText: '£',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
            const SizedBox(height: 16),
            Text(
              'Service Pricing',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ..._servicePricingControllers.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    SizedBox(
                      width: 120,
                      child: Text(
                        entry.key.replaceAll('_', ' ').toUpperCase(),
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: entry.value,
                        decoration: const InputDecoration(
                          prefixText: '£',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
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

  Widget _buildSettingsSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Branch Settings',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            SwitchListTile(
              title: const Text('Auto Accept Orders'),
              subtitle: const Text('Automatically accept incoming orders'),
              value: _autoAcceptOrders,
              onChanged: (value) {
                setState(() {
                  _autoAcceptOrders = value;
                });
              },
            ),
            SwitchListTile(
              title: const Text('Priority Delivery'),
              subtitle: const Text('Support priority delivery service'),
              value: _supportsPriorityDelivery,
              onChanged: (value) {
                setState(() {
                  _supportsPriorityDelivery = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBranch() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final branchProvider = Provider.of<BranchProvider>(context, listen: false);

    // Create bag pricing map
    final bagPricing = <String, double>{};
    for (var entry in _bagPricingControllers.entries) {
      final value = double.tryParse(entry.value.text);
      if (value != null) {
        bagPricing[entry.key] = value;
      }
    }

    // Create service pricing map
    final servicePricing = <String, double>{};
    for (var entry in _servicePricingControllers.entries) {
      final value = double.tryParse(entry.value.text);
      if (value != null) {
        servicePricing[entry.key] = value;
      }
    }

    final branch = LaundretteBranch(
      id:
          widget.isEdit
              ? widget.branch!.id
              : DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text.trim(),
      description:
          _descriptionController.text.trim().isEmpty
              ? ''
              : _descriptionController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      postcode: _postcodeController.text.trim(),
      phone:
          _phoneController.text.trim().isEmpty
              ? ''
              : _phoneController.text.trim(),
      email:
          _emailController.text.trim().isEmpty
              ? ''
              : _emailController.text.trim(),
      status: _selectedStatus,
      services: [], // Empty services list for now
      operatingHours: Map.from(_operatingHours),
      latitude: 40.7128, // Mock coordinates
      longitude: -74.0060,
      images: [], // Empty images list for now
      createdAt: widget.isEdit ? widget.branch!.createdAt : DateTime.now(),
      updatedAt: DateTime.now(),
    );

    bool success;
    if (widget.isEdit) {
      success = await branchProvider.updateBranch(branch);
    } else {
      success = await branchProvider.addBranch(branch);
    }

    if (success && mounted) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEdit
                ? 'Branch updated successfully'
                : 'Branch added successfully',
          ),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save branch'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }
}
