import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/radii.dart';
import '../../../core/widgets/watermark_background.dart';
import '../../../core/widgets/animated_auth_screen.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../../ui/primitives/animated_button.dart';
import '../providers/auth_provider.dart';
import '../../navigation/screens/main_navigation_screen.dart';
import 'login_screen.dart';

/// Email verification awaiting screen for laundrette app
class EmailVerificationAwaitingScreen extends StatefulWidget {
  final String email;

  const EmailVerificationAwaitingScreen({super.key, required this.email});

  @override
  State<EmailVerificationAwaitingScreen> createState() =>
      _EmailVerificationAwaitingScreenState();
}

class _EmailVerificationAwaitingScreenState
    extends State<EmailVerificationAwaitingScreen>
    with WidgetsBindingObserver {
  Timer? _pollingTimer;
  Timer? _resendCountdownTimer;
  bool _isChecking = false;
  int _pollingCount = 0;
  int _resendCountdown = 0;
  static const int _maxPollingAttempts = 20; // 20 * 15 seconds = 5 minutes
  static const int _resendCooldownSeconds = 60;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _startPolling();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pollingTimer?.cancel();
    _resendCountdownTimer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // Check verification status when app resumes
      _checkVerificationStatus();
    }
  }

  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_pollingCount >= _maxPollingAttempts) {
        timer.cancel();
        return;
      }
      _pollingCount++;
      _checkVerificationStatus();
    });
  }

  Future<void> _checkVerificationStatus() async {
    if (_isChecking || !mounted) return;

    setState(() {
      _isChecking = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final isVerified = await authProvider.checkEmailVerificationStatus(
        widget.email,
      );

      if (isVerified && mounted) {
        _pollingTimer?.cancel();
        CustomSnackbar.showSuccess(
          context,
          message: 'Email verified successfully! Welcome to Just Laundrette.',
        );

        await Future.delayed(const Duration(milliseconds: 500));

        if (mounted) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const MainNavigationScreen(),
            ),
            (route) => false,
          );
        }
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          context,
          message: 'Failed to check verification status. Please try again.',
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (_resendCountdown > 0) {
      return; // Prevent multiple requests during countdown
    }

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.resendVerificationEmail(widget.email);

      if (mounted) {
        CustomSnackbar.showSuccess(
          context,
          message: 'Verification email sent! Please check your inbox.',
        );
        _pollingCount = 0; // Reset polling counter
        _startResendCountdown(); // Start 60-second countdown
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(
          context,
          message: 'Failed to resend verification email. Please try again.',
        );
      }
    }
  }

  void _startResendCountdown() {
    _resendCountdown = _resendCooldownSeconds;
    _resendCountdownTimer?.cancel();
    _resendCountdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        if (_resendCountdown <= 0) {
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WatermarkBackgroundBuilder.bottomRight(
      icon: FontAwesomeIcons.envelope,
      iconColor: AppColors.primary,
      margin: const EdgeInsets.all(16),
      opacity: 0.10,
      iconSizePercentage: 0.45,
      iconShift: -15.0,
      child: AnimatedAuthScreen(
        title: 'Verify Your Email',
        subtitle: 'We\'ve sent a verification link to ${widget.email}',
        icon: Padding(
          padding: EdgeInsets.all(AppSpacing.l),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mark_email_unread,
              color: AppColors.primary,
              size: 40,
            ),
          ),
        ),
        showAppBar: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: AppSpacing.xxl),

            // Instructions
            Container(
              padding: EdgeInsets.all(AppSpacing.l),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(Radii.lg),
              ),
              child: Column(
                children: [
                  Icon(Icons.info_outline, color: AppColors.primary, size: 32),
                  SizedBox(height: AppSpacing.m),
                  Text(
                    'Check Your Email',
                    style: AppTypography.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurface,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: AppSpacing.s),
                  Text(
                    'Click the verification link in your email to activate your account. This screen will automatically update once verified.',
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.xl),

            // Status indicator
            if (_isChecking) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.s),
                  Text(
                    'Checking verification status...',
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.l),
            ],

            // Resend button
            AnimatedButton(
              isLoading: false,
              onPressed: _resendCountdown > 0 ? null : _resendVerificationEmail,
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              borderRadius: BorderRadius.circular(Radii.lg),
              height: 56,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.refresh,
                    size: 20,
                    color:
                        _resendCountdown > 0
                            ? AppColors.onPrimary.withValues(alpha: 0.6)
                            : AppColors.onPrimary,
                  ),
                  SizedBox(width: AppSpacing.s),
                  Text(
                    _resendCountdown > 0
                        ? 'Resend in ${_resendCountdown}s'
                        : 'Resend Verification Email',
                    style: AppTypography.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color:
                          _resendCountdown > 0
                              ? AppColors.onPrimary.withValues(alpha: 0.6)
                              : AppColors.onPrimary,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: AppSpacing.l),

            // Logout button
            Consumer<AuthProvider>(
              builder: (context, authProvider, child) {
                return AnimatedButton(
                  isLoading: authProvider.isLoading,
                  onPressed: () {
                    _pollingTimer?.cancel();
                    _resendCountdownTimer?.cancel();
                    final navigator = Navigator.of(context);
                    authProvider.logout().then((_) {
                      if (mounted) {
                        navigator.pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      }
                    });
                  },
                  backgroundColor: AppColors.surface,
                  foregroundColor: AppColors.onSurface,
                  borderRadius: BorderRadius.circular(Radii.lg),
                  height: 56,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout, size: 20, color: AppColors.onSurface),
                      SizedBox(width: AppSpacing.s),
                      Text(
                        'Logout',
                        style: AppTypography.textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.onSurface,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            SizedBox(height: AppSpacing.xl),

            // Help text
            Text(
              'Didn\'t receive the email? Check your spam folder or try resending.',
              style: AppTypography.textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
