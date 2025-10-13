import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/radii.dart';
import '../../../design_system/icons.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/text_field_x.dart';
import '../../../core/widgets/watermark_background.dart';
import '../../../core/widgets/animated_auth_screen.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../providers/auth_provider.dart';
import 'email_verification_awaiting_screen.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Tenant Type Selection
  String? _selectedTenantType;
  final List<Map<String, String>> _tenantTypes = [
    {'value': 'tenant', 'label': 'Business Tenant'},
    {'value': 'private_tenant', 'label': 'Private Tenant'},
  ];

  // Personal Details
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _mobileController = TextEditingController();

  // Authentication
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTenantType == null) {
      CustomSnackbar.showError(
        context,
        message: 'Please select your tenant type',
      );
      return;
    }
    if (!_agreeToTerms) {
      CustomSnackbar.showError(
        context,
        message: 'Please agree to the terms and conditions',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.register(
        tenantType: _selectedTenantType!,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: _emailController.text.trim(),
        mobile: _mobileController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        termsAccepted: true,
      );

      if (success) {
      if (mounted) {
          final tenant = authProvider.currentTenant;
          if (tenant != null) {
            // Navigate to email verification screen
            Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder:
                    (context) =>
                        EmailVerificationAwaitingScreen(email: tenant.email),
              ),
              (route) => false,
            );
          }
        }
      } else {
        final errorMessage =
            authProvider.error ?? 'Registration failed. Please try again.';
        CustomSnackbar.showError(context, message: errorMessage);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          context,
          message: 'An error occurred. Please try again.',
        );
      }
    } finally {
        setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WatermarkBackgroundBuilder.bottomRight(
      icon: FontAwesomeIcons.userPlus,
      iconColor: AppColors.primary,
      margin: const EdgeInsets.all(16),
      opacity: 0.10,
      iconSizePercentage: 0.45,
      iconShift: -15.0,
      child: AnimatedAuthScreen(
        title: 'Create Account',
        subtitle:
            'Join Just Laundrette and start managing your laundry business',
        icon: Hero(
          tag: 'app_icon',
          child: AppIcon(
            size: 80,
            color: AppColors.primary,
            showBackground: true,
          ),
        ),
        showAppBar: true,
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside text fields
            FocusScope.of(context).unfocus();
          },
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Tenant Type Selection
                Container(
                  padding: EdgeInsets.all(AppSpacing.m),
                      decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.person,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          SizedBox(width: AppSpacing.s),
                          Text(
                            'Personal Details',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.m),

                      // Tenant Type Dropdown
                      DropdownButtonFormField<String>(
                        value: _selectedTenantType,
                        decoration: InputDecoration(
                          labelText: 'Tenant Type',
                          hintText: 'Select your tenant type',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: Icon(Icons.business),
                        ),
                        items:
                            _tenantTypes.map((type) {
                              return DropdownMenuItem<String>(
                                value: type['value'],
                                child: Text(type['label']!),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTenantType = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your tenant type';
                          }
                          return null;
                        },
                      ),

                      SizedBox(height: AppSpacing.m),

                      // First Name and Last Name Row
                      Row(
                        children: [
                          Expanded(
                            child: TextFieldsX.standard(
                              controller: _firstNameController,
                              labelText: 'First Name',
                              hintText: 'Enter your first name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your first name';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: AppSpacing.s),
                          Expanded(
                            child: TextFieldsX.standard(
                              controller: _lastNameController,
                              labelText: 'Last Name',
                              hintText: 'Enter your last name',
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your last name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: AppSpacing.m),

                      // Mobile Number
                TextFieldsX.standard(
                        controller: _mobileController,
                        labelText: 'Mobile Number',
                        hintText: 'Enter your mobile number',
                        prefixIcon: AppIcons.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                        }
                          if (value.length < 10) {
                            return 'Please enter a valid mobile number';
                        }
                        return null;
                      },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.l),

                // Authentication Section
                Container(
                  padding: EdgeInsets.all(AppSpacing.m),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.outline.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.lock, color: AppColors.primary, size: 20),
                          SizedBox(width: AppSpacing.s),
                          Text(
                            'Authentication',
                            style: Theme.of(
                              context,
                            ).textTheme.titleMedium?.copyWith(
                              color: AppColors.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: AppSpacing.m),

                // Email Field
                TextFieldsX.email(
                      controller: _emailController,
                      labelText: 'Email Address',
                      hintText: 'Enter your email address',
                      ),

                      SizedBox(height: AppSpacing.m),

                // Password Field
                TextFieldsX.password(
                      controller: _passwordController,
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }
                        if (!RegExp(
                          r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)',
                        ).hasMatch(value)) {
                          return 'Password must contain uppercase, lowercase, and number';
                        }
                        return null;
                      },
                      ),

                      SizedBox(height: AppSpacing.m),

                // Confirm Password Field
                TextFieldsX.password(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your password',
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                // Terms and Conditions
                Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                          },
                          activeColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Radii.s),
                      ),
                        ),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'I agree to the ',
                          style: AppTypography.textTheme.bodyMedium?.copyWith(
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                              children: [
                                TextSpan(
                                  text: 'Terms and Conditions',
                                  style: AppTypography.textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: AppTypography.textTheme.bodyMedium
                                      ?.copyWith(
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                ),

                SizedBox(height: AppSpacing.xl),

                // Create Account Button
                AnimatedButtons.primary(
                      onPressed: _isLoading ? null : _register,
                      isLoading: _isLoading,
                      child: Text(
                        'Create Account',
                        style: AppTypography.textTheme.labelLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                ),

                SizedBox(height: AppSpacing.xl),

                // Sign In Link
                Center(
                  child: AnimatedButtons.text(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign In',
                            style: AppTypography.textTheme.bodyMedium?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
