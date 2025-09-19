import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/radii.dart';
import '../../../design_system/elevations.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/text_field_x.dart';
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
      await authProvider.sendPasswordResetEmail(_emailController.text.trim());

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
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: AppColors.errorRed,
          ),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
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
                Text(
                  'Forgot Password?',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const Gap.vertical(AppSpacing.s),
                Text(
                  'Enter your email address and we\'ll send you a verification code to reset your password.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 40),
                TextFieldsX.email(
                  controller: _emailController,
                  labelText: 'Email Address',
                  hintText: 'Enter your email address',
                ),
                const SizedBox(height: 32),
                AnimatedButtons.primary(
                  onPressed: _isLoading ? null : _sendResetEmail,
                  isLoading: _isLoading,
                  width: double.infinity,
                  height: 50,
                  child: Text(
                    'Send Reset Code',
                    style: AppTypography.textTheme.labelLarge?.copyWith(
                      color: AppColors.onPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: AnimatedButtons.text(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Back to Login',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
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
