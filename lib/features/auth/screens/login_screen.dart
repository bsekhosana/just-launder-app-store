import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
import '../../../ui/primitives/accordion_x.dart';
import '../providers/auth_provider.dart';
import 'forgot_password_screen.dart';
import 'registration_screen.dart';

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
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: SpacingUtils.all(AppSpacing.xl),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo and Title
                Column(
                  children: [
                    Hero(
                          tag: 'app_icon',
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: Radii.xl,
                              boxShadow: Shadows.medium,
                            ),
                            child: ClipRRect(
                              borderRadius: Radii.xl,
                              child: Image.asset(
                                'assets/images/app_icon.png',
                                width: 80,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        )
                        .animate()
                        .scale(
                          duration: AppMotion.slow,
                          curve: AppCurves.emphasized,
                        )
                        .fadeIn(duration: AppMotion.normal),
                    const Gap.vertical(AppSpacing.xl),
                    Text(
                          'Just Launder',
                          style: AppTypography.textTheme.displayMedium
                              ?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        )
                        .animate()
                        .fadeIn(
                          delay: AppMotion.fast,
                          duration: AppMotion.normal,
                        )
                        .slideY(
                          begin: 0.3,
                          end: 0.0,
                          delay: AppMotion.fast,
                          duration: AppMotion.normal,
                        ),
                    const Gap.vertical(AppSpacing.s),
                    Text(
                          'Manage Your Laundry Business',
                          style: AppTypography.textTheme.bodyLarge?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        )
                        .animate()
                        .fadeIn(
                          delay: AppMotion.normal,
                          duration: AppMotion.normal,
                        )
                        .slideY(
                          begin: 0.3,
                          end: 0.0,
                          delay: AppMotion.normal,
                          duration: AppMotion.normal,
                        ),
                  ],
                ),
                const Gap.vertical(AppSpacing.xxxl),

                // Email Field
                TextFieldsX.email(
                      controller: _emailController,
                      labelText: 'Email',
                      hintText: 'Enter your email address',
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
                const Gap.vertical(AppSpacing.xl),

                // Login Button
                Consumer<AuthProvider>(
                  builder: (context, authProvider, child) {
                    return AnimatedButtons.primary(
                          onPressed:
                              authProvider.isLoading ? null : _handleLogin,
                          isLoading: authProvider.isLoading,
                          child: Text(
                            'Login',
                            style: AppTypography.textTheme.labelLarge?.copyWith(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                        .animate()
                        .fadeIn(
                          delay: AppMotion.slower,
                          duration: AppMotion.normal,
                        )
                        .slideY(
                          begin: 0.3,
                          end: 0.0,
                          delay: AppMotion.slower,
                          duration: AppMotion.normal,
                        );
                  },
                ),
                const Gap.vertical(AppSpacing.l),

                // Demo Accounts Accordion
                AccordionX(
                      title: 'Demo Accounts',
                      icon: AppIcons.staff,
                      content: Column(
                        children: [
                          DemoAccountItem(
                            accountType: 'Business Account',
                            email: 'business@laundrette.com',
                            password: 'password',
                            onEmailCopy: () {
                              Clipboard.setData(
                                const ClipboardData(
                                  text: 'business@laundrette.com',
                                ),
                              );
                              SnackXUtils.showSuccess(
                                context,
                                message: 'Email copied to clipboard',
                              );
                            },
                            onPasswordCopy: () {
                              Clipboard.setData(
                                const ClipboardData(text: 'password'),
                              );
                              SnackXUtils.showSuccess(
                                context,
                                message: 'Password copied to clipboard',
                              );
                            },
                          ),
                          DemoAccountItem(
                            accountType: 'Private Account',
                            email: 'private@laundrette.com',
                            password: 'password',
                            onEmailCopy: () {
                              Clipboard.setData(
                                const ClipboardData(
                                  text: 'private@laundrette.com',
                                ),
                              );
                              SnackXUtils.showSuccess(
                                context,
                                message: 'Email copied to clipboard',
                              );
                            },
                            onPasswordCopy: () {
                              Clipboard.setData(
                                const ClipboardData(text: 'password'),
                              );
                              SnackXUtils.showSuccess(
                                context,
                                message: 'Password copied to clipboard',
                              );
                            },
                          ),
                        ],
                      ),
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
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ).animate().fadeIn(
                  delay: AppMotion.slower + AppMotion.normal,
                  duration: AppMotion.normal,
                ),
                const Gap.vertical(AppSpacing.l),

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
                          color: colorScheme.onSurfaceVariant,
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
                ).animate().fadeIn(
                  delay: AppMotion.slower + AppMotion.normal + AppMotion.fast,
                  duration: AppMotion.normal,
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
          SnackXUtils.showSuccess(context, message: 'Login successful!');
          // Navigation will be handled by AppWrapper
        }
      } else {
        if (mounted) {
          SnackXUtils.showError(context, message: 'Invalid email or password');
        }
      }
    }
  }
}
