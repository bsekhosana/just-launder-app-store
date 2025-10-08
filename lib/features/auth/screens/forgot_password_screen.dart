import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/text_field_x.dart';
import '../../../core/widgets/watermark_background.dart';
import '../../../core/widgets/animated_auth_screen.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../providers/auth_provider.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final success = await authProvider.sendPasswordResetEmail(
        _emailController.text.trim(),
      );

      if (mounted) {
        if (success) {
          // Show success message
          CustomSnackbar.showSuccess(
            context,
            message: 'OTP code sent to your email address',
          );

          // Navigate to OTP verification screen
          await Future.delayed(const Duration(milliseconds: 500));

          if (mounted) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder:
                    (context) => OTPVerificationScreen(
                      email: _emailController.text.trim(),
                      isPasswordReset: true,
                    ),
              ),
            );
          }
        } else {
          // Show error message from provider using CustomSnackbar
          final errorMessage =
              authProvider.error ?? 'Failed to send reset email';
          CustomSnackbar.showError(context, message: errorMessage);
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

  @override
  Widget build(BuildContext context) {
    return WatermarkBackgroundBuilder.bottomRight(
      icon: FontAwesomeIcons.key,
      iconColor: AppColors.primary,
      margin: const EdgeInsets.all(16),
      opacity: 0.10,
      iconSizePercentage: 0.45,
      iconShift: -15.0,
      child: AnimatedAuthScreen(
        title: 'Reset Your Password',
        subtitle:
            'Enter your email address and we\'ll send you a link to reset your password',
        icon: Padding(
          padding: EdgeInsets.all(AppSpacing.l),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.lock_reset, color: AppColors.primary, size: 40),
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
                // Email Field
                TextFieldsX.email(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email address',
                ),

                SizedBox(height: AppSpacing.xl),

                // Send OTP button
                AnimatedButtons.primary(
                  isLoading: _isLoading,
                  onPressed: _isLoading ? null : _sendResetEmail,
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sms, size: 20, color: AppColors.onPrimary),
                      SizedBox(width: AppSpacing.s),
                      Text(
                        'Send OTP Code',
                        style: AppTypography.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onPrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                // Back to login
                _buildBackToLogin(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBackToLogin() {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Remember your password? ',
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Text(
              'Sign In',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
