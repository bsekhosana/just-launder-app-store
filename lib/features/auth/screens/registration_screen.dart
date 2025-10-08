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

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _businessNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
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
        tenantType: 'business',
        firstName: _businessNameController.text.trim().split(' ').first,
        lastName:
            _businessNameController.text.trim().split(' ').length > 1
                ? _businessNameController.text
                    .trim()
                    .split(' ')
                    .skip(1)
                    .join(' ')
                : '',
        email: _emailController.text.trim(),
        mobile: _phoneController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        termsAccepted: true,
      );

      if (success) {
        CustomSnackbar.showSuccess(
          context,
          message: 'Registration successful! Please verify your email.',
        );

        // Navigate back to login screen after a short delay
        await Future.delayed(const Duration(milliseconds: 1000));

        if (mounted) {
          Navigator.of(context).pop();
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
                // Business Name Field
                TextFieldsX.standard(
                  controller: _businessNameController,
                  labelText: 'Business Name',
                  hintText: 'Enter your business name',
                  prefixIcon: AppIcons.branch,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your business name';
                    }
                    if (value.length < 2) {
                      return 'Business name must be at least 2 characters';
                    }
                    return null;
                  },
                ),

                SizedBox(height: AppSpacing.l),

                // Email Field
                TextFieldsX.email(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email address',
                ),

                SizedBox(height: AppSpacing.l),

                // Phone Field
                TextFieldsX.standard(
                  controller: _phoneController,
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  prefixIcon: AppIcons.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    if (value.length < 10) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),

                SizedBox(height: AppSpacing.l),

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

                SizedBox(height: AppSpacing.l),

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
