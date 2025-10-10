import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../core/widgets/watermark_background.dart';
import '../../../core/widgets/password_input_field.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../core/widgets/reusable_otp_screen.dart';
import '../../../core/utils/log_helper.dart';
import '../../auth/providers/auth_provider.dart';

/// Change Password screen for updating tenant password
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
    final tenant = authProvider.currentTenant;

    if (tenant == null) {
      CustomSnackbar.showError(
        context,
        message: 'Tenant not found. Please log in again.',
      );
      return;
    }

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ReusableOtpScreen(
          email: tenant.email,
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
      final tenant = authProvider.currentTenant;

      if (tenant != null) {
        // Send OTP for password change
        final success = await authProvider.forgotPassword(tenant.email);

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
      final tenant = authProvider.currentTenant;

      if (tenant == null) {
        throw Exception('Tenant not found');
      }

      // For password change, we need to use a different approach
      // Since the profile update API doesn't handle password changes directly,
      // we'll use the reset password API with the verified OTP
      final success = await authProvider.resetPassword(
        email: tenant.email,
        otp: _verifiedOtp!,
        newPassword: _newPasswordController.text,
        confirmPassword: _confirmPasswordController.text,
      );

      if (success) {
        LogHelper.auth('Password changed successfully');

        if (mounted) {
          CustomSnackbar.showSuccess(
            context,
            message: 'Password changed successfully',
          );
          Navigator.of(context).pop();
        }
      } else {
        if (mounted) {
          CustomSnackbar.showError(
            context,
            message: authProvider.error ?? 'Failed to change password. Please try again.',
          );
        }
      }
    } catch (e) {
      LogHelper.error('Error changing password: $e');
      if (mounted) {
        CustomSnackbar.showError(
          context,
          message: 'Failed to change password. Please try again.',
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

  @override
  Widget build(BuildContext context) {
    return WatermarkBackgroundBuilder.bottomRight(
      icon: Icons.lock,
      iconColor: AppColors.primary.withOpacity(0.15),
      iconSizePercentage: 0.35,
      iconShift: -15.0,
      margin: const EdgeInsets.all(16),
      respectSafeArea: false,
      child: Container(
        color: Colors.white,
        child: Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(
              'Change Password',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    
                    // Header Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.lock,
                        size: 40,
                        color: AppColors.primary,
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    Text(
                      'Change Password',
                      style: AppTypography.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    Text(
                      'Enter your current password and choose a new one',
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    
                    const SizedBox(height: 32),
                    
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            PasswordInputField(
                              controller: _currentPasswordController,
                              label: 'Current Password',
                              hint: 'Enter your current password',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter your current password';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            PasswordInputField(
                              controller: _newPasswordController,
                              label: 'New Password',
                              hint: 'Enter your new password',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please enter a new password';
                                }
                                if (value.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 16),
                            
                            PasswordInputField(
                              controller: _confirmPasswordController,
                              label: 'Confirm New Password',
                              hint: 'Confirm your new password',
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Please confirm your new password';
                                }
                                if (value != _newPasswordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            
                            const SizedBox(height: 32),
                            
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primary.withOpacity(0.3),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.security,
                                    color: AppColors.primary,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      'You will receive a verification code to confirm your identity',
                                      style: AppTypography.textTheme.bodySmall?.copyWith(
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            
                            const SizedBox(height: 24),
                            
                            AnimatedButton(
                              onPressed: _isLoading ? null : _handleChangePassword,
                              isLoading: _isLoading,
                              height: 56,
                              child: Text(
                                'Change Password',
                                style: AppTypography.textTheme.titleMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
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