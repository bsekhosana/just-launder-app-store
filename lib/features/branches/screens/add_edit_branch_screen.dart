import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/branch_provider.dart';
import '../../../data/models/laundrette_branch.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isEdit ? 'Edit Branch' : 'Add Branch'),
        actions: [
          TextButton(onPressed: _saveBranch, child: const Text('Save')),
        ],
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
              _buildStatusSection(),
              const SizedBox(height: 24),
              _buildOperatingHoursSection(),
              const SizedBox(height: 24),
              _buildPricingSection(),
              const SizedBox(height: 24),
              _buildSettingsSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Basic Information',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Status & Availability',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Operating Hours',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pricing',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
                          prefixText: '\$',
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
                          prefixText: '\$',
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Branch Settings',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
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
      laundretteId: 'laundrette_business_1', // Mock laundrette ID
      name: _nameController.text.trim(),
      description:
          _descriptionController.text.trim().isEmpty
              ? null
              : _descriptionController.text.trim(),
      address: _addressController.text.trim(),
      city: _cityController.text.trim(),
      postcode: _postcodeController.text.trim(),
      country: _countryController.text.trim(),
      latitude: 40.7128, // Mock coordinates
      longitude: -74.0060,
      status: _selectedStatus,
      isOpen: _isOpen,
      operatingHours: Map.from(_operatingHours),
      bagPricing: bagPricing,
      servicePricing: servicePricing,
      autoAcceptOrders: _autoAcceptOrders,
      supportsPriorityDelivery: _supportsPriorityDelivery,
      phoneNumber:
          _phoneController.text.trim().isEmpty
              ? null
              : _phoneController.text.trim(),
      email:
          _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
      maxConcurrentOrders: int.parse(_maxOrdersController.text),
      currentOrderCount: widget.isEdit ? widget.branch!.currentOrderCount : 0,
      settings: {'notifications': true, 'autoAssignDrivers': true},
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
          backgroundColor: AppTheme.successGreen,
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to save branch'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
    }
  }
}
