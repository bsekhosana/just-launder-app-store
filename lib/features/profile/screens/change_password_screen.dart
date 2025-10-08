import 'package:flutter/material.dart';
import 'package:just_laundrette_app/design_system/color_schemes.dart';
import 'package:just_laundrette_app/design_system/spacing.dart';
import 'package:just_laundrette_app/design_system/typography.dart';
import 'package:provider/provider.dart';
import '../../../design_system/theme.dart';
import '../../../core/widgets/animated_auth_screen.dart';
import '../../../core/widgets/watermark_background.dart';
import '../../../core/widgets/password_input_field.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/widgets/reusable_otp_screen.dart';
import '../../../core/utils/log_helper.dart';
import '../../auth/providers/auth_provider.dart';

/// Change Password screen for updating user password
class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _verifiedOtp;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleChangePassword() async {
    if (!_formKey.currentState!.validate()) return;

    // Navigate to OTP verification first
    _navigateToOtpVerification();
  }

  void _navigateToOtpVerification() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.currentUser;

    if (user == null) {
      CustomSnackbar.showError('User not found. Please log in again.');
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder:
            (context) => ReusableOtpScreen(
              email: user.email,
              purpose: 'password_change',
              onOtpVerified: _handleOtpVerified,
              onResendOtp: _resendOtp,
            ),
      ),
    );
  }

  Future<void> _handleOtpVerified(String otp) async {
    LogHelper.auth('OTP verified for password change: $otp');

    // Store the OTP and proceed with password change
    _verifiedOtp = otp;
    await _updatePassword();
  }

  Future<bool> _resendOtp() async {
    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;

      if (user != null) {
        // Send OTP for password change
        final success = await authProvider.forgotPassword(user.email);

        LogHelper.auth('OTP resent for password change');
        return success;
      }
      return false;
    } catch (e) {
      LogHelper.error('Failed to resend OTP for password change: $e');
      return false;
    }
  }

  Future<void> _updatePassword() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final user = authProvider.currentUser;

      if (user == null) {
        throw Exception('User not found');
      }

      // For password change, we need to use a different approach
      // Since the profile update API doesn't handle password changes directly,
      // we'll use the reset password API with the verified OTP
      final success = await authProvider.resetPassword(
        email: user.email,
        otp: _verifiedOtp!,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (success) {
        LogHelper.auth('Password changed successfully');

        if (mounted) {
          CustomSnackbar.showSuccess('Password changed successfully!');

          // Navigate back to settings
          Navigator.of(context).pop();
        }
      } else {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      LogHelper.error('Failed to change password: $e');

      if (mounted) {
        CustomSnackbar.showError(
          'Failed to change password. Please try again.',
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

  String? _validateCurrentPassword(String? value) {
    // Current password not required for logged-in users
    return null;
  }

  String? _validateNewPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'New password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    if (value == _currentPasswordController.text) {
      return 'New password must be different from current password';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please confirm your new password';
    }
    if (value != _newPasswordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: WatermarkBackground(
        icon: Icons.lock,
        iconColor: AppColors.primary,
        margin: const EdgeInsets.all(16),
        opacity: 0.10,
        iconSizePercentage: 0.45,
        iconShift: -15.0,
        child: AnimatedAuthScreen(
          title: 'Change Password',
          subtitle: 'Update your account password',
          showAppBar: true,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppSpacing.xxl),

                // Current Password
                PasswordInputField(
                  controller: _currentPasswordController,
                  label: 'Current Password',
                  hint: 'Enter your current password',
                  validator: _validateCurrentPassword,
                ),

                SizedBox(height: AppSpacing.l),

                // New Password
                PasswordInputField(
                  controller: _newPasswordController,
                  label: 'New Password',
                  hint: 'Enter your new password',
                  validator: _validateNewPassword,
                ),

                SizedBox(height: AppSpacing.l),

                // Confirm Password
                PasswordInputField(
                  controller: _confirmPasswordController,
                  label: 'Confirm New Password',
                  hint: 'Confirm your new password',
                  validator: _validateConfirmPassword,
                ),

                SizedBox(height: AppSpacing.l),

                // Password requirements
                Container(
                  padding: EdgeInsets.all(AppSpacing.m),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(AppRadii.m),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Password Requirements:',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      Text(
                        '• At least 6 characters long\n• Different from your current password',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                // OTP requirement notice
                Container(
                  padding: EdgeInsets.all(AppSpacing.m),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(AppRadii.m),
                    border: Border.all(
                      color: AppColors.primary.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.security, color: AppColors.primary, size: 20),
                      SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: Text(
                          'For security, you\'ll receive a verification code via email to confirm your password change.',
                          style: AppTypography.textTheme.bodySmall?.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                // Change Password button
                AnimatedButton(
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _handleChangePassword,
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.onPrimary,
                  borderRadius: BorderRadius.circular(AppRadii.l),
                  height: 56,
                  child: Text(
                    'Change Password',
                    style: AppTypography.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onPrimary,
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
