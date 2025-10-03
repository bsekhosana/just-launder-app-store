import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/radii.dart';
import '../../../design_system/motion.dart';
import '../../../design_system/icons.dart';
import '../../../design_system/elevations.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/text_field_x.dart';
import '../../../ui/primitives/snack_x.dart';
import '../../../core/widgets/watermark_background.dart';
import '../providers/auth_provider.dart';
import 'otp_verification_screen.dart';

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
      SnackXUtils.showError(
        context,
        message: 'Please agree to the terms and conditions',
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.register(
        businessName: _businessNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder:
                (context) => OTPVerificationScreen(
                  email: _emailController.text.trim(),
                  isPasswordReset: false,
                ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        SnackXUtils.showError(
          context,
          message: 'Registration failed: ${e.toString()}',
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return WatermarkBackgroundBuilder.bottomRight(
      icon: FontAwesomeIcons.userPlus,
      iconColor: AppColors.primary,
      margin: const EdgeInsets.all(16),
      opacity: 0.10,
      iconSizePercentage: 0.45,
      iconShift: -15.0,
      child: Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: AnimatedButton(
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.transparent,
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(Icons.arrow_back_ios, color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: SpacingUtils.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Hero(
                    tag: 'app_icon',
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: Radii.l,
                        boxShadow: Shadows.low,
                      ),
                      child: ClipRRect(
                        borderRadius: Radii.l,
                        child: Image.asset(
                          'assets/images/app_icon.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
                const Gap.vertical(AppSpacing.xxl),

                // Header
                Text(
                      'Create Account',
                      style: AppTypography.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: AppMotion.normal)
                    .slideY(begin: 0.3, end: 0.0, duration: AppMotion.normal),
                const Gap.vertical(AppSpacing.s),
                Text(
                      'Join Just Laundrette and start managing your laundry business',
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
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
                const Gap.vertical(AppSpacing.xxxl),

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
                    )
                    .animate()
                    .fadeIn(delay: AppMotion.normal, duration: AppMotion.normal)
                    .slideX(
                      begin: -0.3,
                      end: 0.0,
                      delay: AppMotion.normal,
                      duration: AppMotion.normal,
                    ),
                const Gap.vertical(AppSpacing.l),

                // Email Field
                TextFieldsX.email(
                      controller: _emailController,
                      labelText: 'Email Address',
                      hintText: 'Enter your email address',
                    )
                    .animate()
                    .fadeIn(
                      delay: AppMotion.normal + AppMotion.fast,
                      duration: AppMotion.normal,
                    )
                    .slideX(
                      begin: -0.3,
                      end: 0.0,
                      delay: AppMotion.normal + AppMotion.fast,
                      duration: AppMotion.normal,
                    ),
                const Gap.vertical(AppSpacing.l),

                // Phone Field
                TextFieldsX.standard(
                      controller: _phoneController,
                      labelText: 'Phone Number',
                      hintText: 'Enter your phone number',
                      prefixIcon: AppIcons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        if (value.length < 10) {
                          return 'Please enter a valid phone number';
                        }
                        return null;
                      },
                    )
                    .animate()
                    .fadeIn(delay: AppMotion.slow, duration: AppMotion.normal)
                    .slideX(
                      begin: -0.3,
                      end: 0.0,
                      delay: AppMotion.slow,
                      duration: AppMotion.normal,
                    ),
                const Gap.vertical(AppSpacing.l),

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
                    )
                    .animate()
                    .fadeIn(
                      delay: AppMotion.slow + AppMotion.fast,
                      duration: AppMotion.normal,
                    )
                    .slideX(
                      begin: -0.3,
                      end: 0.0,
                      delay: AppMotion.slow + AppMotion.fast,
                      duration: AppMotion.normal,
                    ),
                const Gap.vertical(AppSpacing.l),

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
                    )
                    .animate()
                    .fadeIn(delay: AppMotion.slower, duration: AppMotion.normal)
                    .slideX(
                      begin: -0.3,
                      end: 0.0,
                      delay: AppMotion.slower,
                      duration: AppMotion.normal,
                    ),
                const Gap.vertical(AppSpacing.xl),

                // Terms and Conditions
                Row(
                      children: [
                        Checkbox(
                          value: _agreeToTerms,
                          onChanged: (value) {
                            setState(() => _agreeToTerms = value ?? false);
                          },
                          activeColor: AppColors.primary,
                          shape: RoundedRectangleBorder(borderRadius: Radii.s),
                        ),
                        Expanded(
                          child: Text.rich(
                            TextSpan(
                              text: 'I agree to the ',
                              style: AppTypography.textTheme.bodyMedium
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
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
                    )
                    .animate()
                    .fadeIn(
                      delay: AppMotion.slower + AppMotion.fast,
                      duration: AppMotion.normal,
                    )
                    .slideY(
                      begin: 0.3,
                      end: 0.0,
                      delay: AppMotion.slower + AppMotion.fast,
                      duration: AppMotion.normal,
                    ),
                const Gap.vertical(AppSpacing.xl),

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
                    )
                    .animate()
                    .fadeIn(
                      delay: AppMotion.slower + AppMotion.normal,
                      duration: AppMotion.normal,
                    )
                    .slideY(
                      begin: 0.3,
                      end: 0.0,
                      delay: AppMotion.slower + AppMotion.normal,
                      duration: AppMotion.normal,
                    ),
                const Gap.vertical(AppSpacing.xl),

                // Sign In Link
                Center(
                  child: AnimatedButtons.text(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
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
                ).animate().fadeIn(
                  delay: AppMotion.slower + AppMotion.normal + AppMotion.fast,
                  duration: AppMotion.normal,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
    );
  }
}
