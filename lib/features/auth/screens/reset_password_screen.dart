import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/motion.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/text_field_x.dart';
import '../../../ui/primitives/snack_x.dart';
import '../providers/auth_provider.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String otp;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.otp,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      // Reset password
      final resetSuccess = await authProvider.resetPassword(
        widget.email,
        widget.otp,
        _passwordController.text.trim(),
      );

      if (resetSuccess && mounted) {
        // Navigate to login screen as fallback
        Navigator.of(
          context,
        ).pushNamedAndRemoveUntil('/login', (route) => false);

        SnackXUtils.showSuccess(
          context,
          message:
              'Password reset successfully! Please login with your new password.',
        );
      }
    } catch (e) {
      if (mounted) {
        SnackXUtils.showError(context, message: 'Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap.vertical(AppSpacing.l),
                Text(
                      'Reset Password',
                      style: Theme.of(
                        context,
                      ).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    )
                    .animate()
                    .fadeIn(duration: AppMotion.normal)
                    .slideY(begin: 0.3, end: 0.0, duration: AppMotion.normal),
                const Gap.vertical(AppSpacing.s),
                Text(
                      'Enter your new password below',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
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
                const Gap.vertical(AppSpacing.xxl),
                TextFieldsX.password(
                      controller: _passwordController,
                      labelText: 'New Password',
                      hintText: 'Enter your new password',
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
                    .fadeIn(delay: AppMotion.normal, duration: AppMotion.normal)
                    .slideX(
                      begin: -0.3,
                      end: 0.0,
                      delay: AppMotion.normal,
                      duration: AppMotion.normal,
                    ),
                const Gap.vertical(AppSpacing.l),
                TextFieldsX.password(
                      controller: _confirmPasswordController,
                      labelText: 'Confirm Password',
                      hintText: 'Confirm your new password',
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
                const Gap.vertical(AppSpacing.xl),
                AnimatedButtons.primary(
                      onPressed: _isLoading ? null : _resetPassword,
                      isLoading: _isLoading,
                      width: double.infinity,
                      height: 50,
                      child: Text(
                        'Reset Password',
                        style: AppTypography.textTheme.labelLarge?.copyWith(
                          color: AppColors.onPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                    .animate()
                    .fadeIn(delay: AppMotion.slow, duration: AppMotion.normal)
                    .slideY(
                      begin: 0.3,
                      end: 0.0,
                      delay: AppMotion.slow,
                      duration: AppMotion.normal,
                    ),
                const Gap.vertical(AppSpacing.l),
                Center(
                  child: AnimatedButtons.text(
                    onPressed:
                        () => Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/login', (route) => false),
                    child: Text(
                      'Back to Login',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ).animate().fadeIn(
                  delay: AppMotion.slow + AppMotion.fast,
                  duration: AppMotion.normal,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
