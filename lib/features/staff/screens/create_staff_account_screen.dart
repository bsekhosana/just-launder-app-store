import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../ui/primitives/text_field_x.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../providers/staff_management_provider.dart';

/// Screen for creating staff accounts (for testing cross-app flow)
/// This is a simplified version specifically for laundrette→staff account creation
class CreateStaffAccountScreen extends StatefulWidget {
  const CreateStaffAccountScreen({super.key});

  @override
  State<CreateStaffAccountScreen> createState() =>
      _CreateStaffAccountScreenState();
}

class _CreateStaffAccountScreenState extends State<CreateStaffAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Staff Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info card
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.primary),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: Text(
                        'Create a new staff account. The staff member will be able to log in to the Staff app.',
                        style: AppTypography.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.xl),

              // First Name
              TextFieldsX.standard(
                key: const ValueKey('staff.create.firstName'),
                controller: _firstNameController,
                labelText: 'First Name',
                hintText: 'Enter first name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter first name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.l),

              // Last Name
              TextFieldsX.standard(
                key: const ValueKey('staff.create.lastName'),
                controller: _lastNameController,
                labelText: 'Last Name',
                hintText: 'Enter last name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter last name';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.l),

              // Email
              TextFieldsX.email(
                key: const ValueKey('staff.create.email'),
                controller: _emailController,
                labelText: 'Email Address',
                hintText: 'Enter email address',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.l),

              // Mobile
              TextFieldsX.standard(
                key: const ValueKey('staff.create.mobile'),
                controller: _mobileController,
                labelText: 'Mobile Number',
                hintText: 'Enter mobile number',
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter mobile number';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.l),

              // Password
              TextFieldsX.password(
                key: const ValueKey('staff.create.password'),
                controller: _passwordController,
                labelText: 'Password',
                hintText: 'Create password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }
                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.l),

              // Confirm Password
              TextFieldsX.password(
                key: const ValueKey('staff.create.confirmPassword'),
                controller: _confirmPasswordController,
                labelText: 'Confirm Password',
                hintText: 'Confirm password',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.xxl),

              // Create button
              AnimatedButton(
                key: const ValueKey('staff.create.submitBtn'),
                isLoading: _isLoading,
                onPressed: _isLoading ? null : _createStaff,
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.onPrimary,
                height: 56,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.person_add, color: AppColors.onPrimary),
                    const SizedBox(width: AppSpacing.s),
                    Text(
                      'Create Staff Account',
                      style: AppTypography.textTheme.labelLarge?.copyWith(
                        color: AppColors.onPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _createStaff() async {
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

      final response = await staffProvider.addStaffViaAPI(
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        mobile: _mobileController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        isActive: true,
      );

      if (mounted) {
        if (response['success'] == true) {
          CustomSnackbar.showSuccess(
            context,
            message: 'Staff account created successfully!',
          );
          Navigator.of(context).pop(response['data']);
        } else {
          final errorMessage = response['message'] ?? 'Failed to create staff account';
          CustomSnackbar.showError(context, message: errorMessage);
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          context,
          message: 'Error creating staff account: $e',
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
}

