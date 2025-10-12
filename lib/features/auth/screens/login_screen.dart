import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/radii.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/text_field_x.dart';
import '../../../core/widgets/watermark_background.dart';
import '../../../core/widgets/animated_auth_screen.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../providers/auth_provider.dart';
import '../../onboarding/screens/onboarding_status_screen.dart';
import 'forgot_password_screen.dart';
import 'registration_screen.dart';
import 'email_verification_awaiting_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WatermarkBackgroundBuilder.bottomRight(
      icon: FontAwesomeIcons.store,
      iconColor: AppColors.primary,
      margin: const EdgeInsets.all(16),
      opacity: 0.10,
      iconSizePercentage: 0.45,
      iconShift: -15.0,
      child: AnimatedAuthScreen(
        title: 'Just Launder',
        subtitle: 'Manage Your Laundry Business',
        icon: Hero(
          tag: 'app_icon',
          child: AppIcon(
            size: 80,
            color: AppColors.primary,
            showBackground: true,
          ),
        ),
        showAppBar: false,
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

                SizedBox(height: AppSpacing.l),

                // Password Field
                TextFieldsX.password(
                  controller: _passwordController,
                  labelText: 'Password',
                  hintText: 'Enter your password',
                ),

                SizedBox(height: AppSpacing.l),

                // Sign In Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return AnimatedAuthButton(
                      text: 'Sign In',
                      icon: Icons.arrow_forward,
                      onPressed: authProvider.isLoading ? null : _handleLogin,
                      isLoading: authProvider.isLoading,
                    );
                  },
                ),

                SizedBox(height: AppSpacing.l),

                // Forgot Password Link
                Center(
                  child: AnimatedButtons.text(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen(),
                        ),
                      );
                    },
                    child: Text(
                      'Forgot Password?',
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.m,
                      ),
                      child: Text(
                        'OR',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),

                SizedBox(height: AppSpacing.xl),

                // Demo Credentials Section
                Container(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariant.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(Radii.m),
                    border: Border.all(
                      color: AppColors.outline.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Demo Credentials',
                        style: AppTypography.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Text(
                        'Use these credentials to test the app:',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.m),
                      _buildCredentialItem(
                        name: 'Tenant Account',
                        email: 'tenant@example.com',
                        password: 'password',
                      ),
                      const SizedBox(height: AppSpacing.s),
                      _buildCredentialItem(
                        name: 'Private Tenant',
                        email: 'privatetenant@example.com',
                        password: 'password',
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                // Sign Up Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: AppTypography.textTheme.bodyMedium?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegistrationScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Sign Up',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCredentialItem({
    required String name,
    required String email,
    required String password,
  }) {
    return InkWell(
      onTap: () {
        _emailController.text = email;
        _passwordController.text = password;
        CustomSnackbar.showSuccess(
          context,
          message: '$name credentials filled',
        );
      },
      borderRadius: BorderRadius.circular(Radii.s),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.s),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(Radii.s),
          border: Border.all(color: AppColors.outline.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.person, size: 16, color: AppColors.primary),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    email,
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.touch_app,
              size: 16,
              color: AppColors.primary.withOpacity(0.5),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      final success = await authProvider.login(
        _emailController.text.trim(),
        _passwordController.text,
      );

      if (success) {
        if (mounted) {
          final tenant = authProvider.currentTenant;
          if (tenant != null) {
            // Check current email verification status from API
            final isVerified = await authProvider.checkEmailVerificationStatus(
              tenant.email,
            );

            if (!mounted) return;

            if (!isVerified) {
              // Email not verified, redirect to verification screen
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder:
                      (context) =>
                          EmailVerificationAwaitingScreen(email: tenant.email),
                ),
                (route) => false,
              );
            } else {
              // Email verified, check onboarding status
              if (!tenant.onboardingCompleted) {
                // Navigate to onboarding screen
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const OnboardingStatusScreen(),
                  ),
                  (route) => false,
                );
              } else {
                // All checks passed, proceed to main app
                CustomSnackbar.showSuccess(context, message: 'Welcome back!');
                // Navigation will be handled by AppWrapper
              }
            }
          }
        }
      } else {
        if (mounted) {
          final errorMessage =
              authProvider.error ?? 'Invalid email or password';
          CustomSnackbar.showError(context, message: errorMessage);
        }
      }
    }
  }
}
