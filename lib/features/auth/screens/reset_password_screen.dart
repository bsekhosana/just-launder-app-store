import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../core/widgets/watermark_background.dart';
import '../../../core/widgets/animated_auth_screen.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/password_input_field.dart';
import '../../../core/utils/log_helper.dart';
import '../providers/auth_provider.dart';
import '../../onboarding/screens/onboarding_status_screen.dart';
import 'email_verification_awaiting_screen.dart';
import '../../navigation/screens/main_navigation_screen.dart';

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
  bool _showRequestNewCode = false;

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

      final success = await authProvider.resetPassword(
        email: widget.email,
        otp: widget.otp,
        newPassword: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (mounted) {
        if (success) {
          // Password reset successful, show message and auto-login
          CustomSnackbar.showSuccess(
            context,
            message: 'Password reset successfully! Signing you in...',
          );

          // Add a small delay to ensure password reset is fully processed
          await Future.delayed(const Duration(seconds: 1));

          await _handleAutoLogin();
        } else {
          // Show error message
          final errorMessage = authProvider.error ?? 'Failed to reset password';
          CustomSnackbar.showError(context, message: errorMessage);

          // Check if error is related to OTP expiration/invalid
          if (errorMessage.toLowerCase().contains('otp') &&
              (errorMessage.toLowerCase().contains('invalid') ||
                  errorMessage.toLowerCase().contains('expired'))) {
            setState(() {
              _showRequestNewCode = true;
            });
          }
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(context, message: 'Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleAutoLogin() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      LogHelper.auth(
        'Auto-login: Attempting login with email: ${widget.email}',
      );

      // Clear any existing authentication state before login
      try {
        await authProvider.logout();
        // Add a small delay to ensure logout is processed
        await Future.delayed(const Duration(milliseconds: 500));
      } catch (e) {
        LogHelper.auth(
          'Logout failed (this is OK if user was not logged in): $e',
        );
        // Continue with login attempt even if logout fails
      }

      // Perform actual login with the new password
      final success = await authProvider.login(
        widget.email,
        _passwordController.text,
      );

      LogHelper.auth('Auto-login: Login result: $success');
      if (!success) {
        LogHelper.auth('Auto-login: AuthProvider error: ${authProvider.error}');
      }

      if (mounted) {
        if (success) {
          // Check if email is verified
          final tenant = authProvider.currentTenant;
          if (tenant != null && !tenant.isEmailVerified) {
            // Email not verified, redirect to verification screen
            CustomSnackbar.showSuccess(
              context,
              message: 'Signed in successfully! Please verify your email.',
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder:
                    (context) =>
                        EmailVerificationAwaitingScreen(email: tenant.email),
              ),
              (route) => false,
            );
          } else if (tenant != null && !tenant.onboardingCompleted) {
            // Email verified but onboarding not complete
            CustomSnackbar.showSuccess(
              context,
              message: 'Signed in successfully! Complete your onboarding.',
            );
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const OnboardingStatusScreen(),
              ),
              (route) => false,
            );
          } else {
            // Email verified and onboarding complete, proceed to main app
            CustomSnackbar.showSuccess(context, message: 'Welcome back!');
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                builder: (context) => const MainNavigationScreen(),
              ),
              (route) => false,
            );
          }
        } else {
          CustomSnackbar.showError(
            context,
            message:
                'Password reset successful, but auto-login failed. Please sign in manually.',
          );
          // Navigate to login screen after a short delay
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(
                context,
              ).pushNamedAndRemoveUntil('/login', (route) => false);
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        LogHelper.error('Auto-login exception: $e');
        CustomSnackbar.showError(
          context,
          message:
              'Password reset successful, but auto-login failed. Please sign in manually.',
        );
        // Navigate to login screen after a short delay
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/login', (route) => false);
          }
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WatermarkBackgroundBuilder.bottomRight(
      icon: FontAwesomeIcons.lock,
      iconColor: AppColors.primary,
      margin: const EdgeInsets.all(16),
      opacity: 0.10,
      iconSizePercentage: 0.45,
      iconShift: -15.0,
      child: AnimatedAuthScreen(
        title: 'Reset Your Password',
        subtitle:
            'Enter your new password below to complete the reset process.',
        icon: Padding(
          padding: EdgeInsets.all(AppSpacing.l),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock, color: AppColors.primary, size: 40),
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
                // New Password Field with generator
                PasswordInputField(
                  controller: _passwordController,
                  label: 'New Password',
                  hint: 'Enter your new password',
                  passwordRequirements: const {
                    'minLength': 8,
                    'maxLength': 128,
                    'requireUppercase': true,
                    'requireLowercase': true,
                    'requireNumbers': true,
                    'requireSymbols': true,
                    'excludeSimilar': true,
                    'excludeAmbiguous': true,
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a new password';
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
                PasswordInputField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                  hint: 'Confirm your new password',
                  showGenerator: false,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please confirm your new password';
                    }
                    if (value != _passwordController.text) {
                      return 'Passwords do not match';
                    }
                    return null;
                  },
                ),

                SizedBox(height: AppSpacing.xl),

                // Request New Code Button (shown when OTP is invalid/expired)
                if (_showRequestNewCode) ...[
                  AnimatedButtons.secondary(
                    onPressed: () {
                      // Pop all screens back to forgot password
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    height: 56,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.refresh, size: 20, color: AppColors.primary),
                        SizedBox(width: AppSpacing.s),
                        Text(
                          'Request New Code',
                          style: AppTypography.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.m),
                ],

                // Reset Password Button
                AnimatedButtons.primary(
                  onPressed: _isLoading ? null : _resetPassword,
                  isLoading: _isLoading,
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lock_reset,
                        size: 20,
                        color: AppColors.onPrimary,
                      ),
                      SizedBox(width: AppSpacing.s),
                      Text(
                        'Reset Password',
                        style: AppTypography.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                // Back to Login Link
                Center(
                  child: AnimatedButtons.text(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Back to Login',
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
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
