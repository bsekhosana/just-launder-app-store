import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_laundrette_app/design_system/icons.dart';
import 'package:just_laundrette_app/ui/primitives/accordion_x.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/text_field_x.dart';
import '../../../core/widgets/watermark_background.dart';
import '../../../core/widgets/animated_auth_screen.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../providers/auth_provider.dart';
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

                SizedBox(height: AppSpacing.xl),

                // Demo Accounts Accordion
                AccordionX(
                  title: 'Demo Accounts',
                  icon: AppIcons.staff,
                  content: Column(
                    children: [
                      // Quick Fill Buttons
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _emailController.text = 'tenant@example.com';
                                _passwordController.text = 'password';
                                CustomSnackbar.showSuccess(
                                  context,
                                  message: 'Tenant account filled',
                                );
                              },
                              icon: const Icon(Icons.business, size: 16),
                              label: const Text('Fill Tenant'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                _emailController.text =
                                    'privatetenant@example.com';
                                _passwordController.text = 'password';
                                CustomSnackbar.showSuccess(
                                  context,
                                  message: 'Private tenant filled',
                                );
                              },
                              icon: const Icon(Icons.person, size: 16),
                              label: const Text('Fill Private'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      DemoAccountItem(
                        accountType: 'Tenant Account',
                        email: 'tenant@example.com',
                        password: 'password',
                        onEmailCopy: () {
                          const email = 'tenant@example.com';
                          Clipboard.setData(const ClipboardData(text: email));
                          _emailController.text = email;
                          CustomSnackbar.showSuccess(
                            context,
                            message: 'Email copied and pasted',
                          );
                        },
                        onPasswordCopy: () {
                          const password = 'password';
                          Clipboard.setData(
                            const ClipboardData(text: password),
                          );
                          _passwordController.text = password;
                          CustomSnackbar.showSuccess(
                            context,
                            message: 'Password copied and pasted',
                          );
                        },
                      ),
                      DemoAccountItem(
                        accountType: 'Private Tenant',
                        email: 'privatetenant@example.com',
                        password: 'password',
                        onEmailCopy: () {
                          const email = 'privatetenant@example.com';
                          Clipboard.setData(const ClipboardData(text: email));
                          _emailController.text = email;
                          CustomSnackbar.showSuccess(
                            context,
                            message: 'Email copied and pasted',
                          );
                        },
                        onPasswordCopy: () {
                          const password = 'password';
                          Clipboard.setData(
                            const ClipboardData(text: password),
                          );
                          _passwordController.text = password;
                          CustomSnackbar.showSuccess(
                            context,
                            message: 'Password copied and pasted',
                          );
                        },
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.xl),

                // Register Link
                Center(
                  child: AnimatedButtons.text(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const RegistrationScreen(),
                        ),
                      );
                    },
                    child: Text.rich(
                      TextSpan(
                        text: 'Don\'t have an account? ',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign Up',
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
              // Email verified, proceed to main app
              CustomSnackbar.showSuccess(context, message: 'Welcome back!');
              // Navigation will be handled by AppWrapper
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
