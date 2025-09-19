import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/motion.dart';
import '../../../ui/primitives/animated_button.dart';
import '../providers/auth_provider.dart';
import 'reset_password_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final bool isPasswordReset;

  const OTPVerificationScreen({
    super.key,
    required this.email,
    this.isPasswordReset = false,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  bool _isResending = false;
  int _resendCountdown = 60;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (final controller in _otpControllers) {
      controller.dispose();
    }
    for (final node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startResendCountdown() {
    _countdownTimer?.cancel();
    setState(() => _resendCountdown = 60);

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          } else {
            _resendCountdown = 0;
            timer.cancel();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _getOTP() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  Future<void> _verifyOTP() async {
    final otp = _getOTP();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete 6-digit code'),
          backgroundColor: AppColors.errorRed,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.verifyOTP(otp);

      if (mounted) {
        if (widget.isPasswordReset) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) =>
                      ResetPasswordScreen(email: widget.email, otp: otp),
            ),
          );
        } else {
          // Handle registration OTP verification
          Navigator.of(context).pushReplacementNamed('/onboarding');
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Invalid OTP: ${e.toString()}'),
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

  Future<void> _resendOTP() async {
    setState(() => _isResending = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      await authProvider.sendPasswordResetEmail(widget.email);
      _startResendCountdown();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification code sent successfully'),
            backgroundColor: AppColors.successGreen,
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
        setState(() => _isResending = false);
      }
    }
  }

  void _onOTPChanged(int index, String value) {
    if (value.length == 1) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyOTP();
      }
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
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
          onPressed: () {
            if (widget.isPasswordReset) {
              // For password reset flow, go back to forgot password screen
              Navigator.of(context).pop();
            } else {
              // For registration flow, go back to previous screen
              Navigator.of(context).pop();
            }
          },
          child: Icon(Icons.arrow_back_ios, color: AppColors.primary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                'Verify Your Email',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'We\'ve sent a 6-digit verification code to\n${widget.email}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 55,
                    child: TextFormField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.outline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.outline,
                          ),
                        ),
                        filled: true,
                        fillColor: AppColors.surface,
                      ),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      onChanged: (value) => _onOTPChanged(index, value),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 32),
              AnimatedButtons.primary(
                onPressed: _isLoading ? null : _verifyOTP,
                isLoading: _isLoading,
                width: double.infinity,
                height: 50,
                child: Text(
                  'Verify Code',
                  style: AppTypography.textTheme.labelLarge?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: AnimatedSwitcher(
                  duration: AppMotion.normal,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child:
                      _resendCountdown > 0
                          ? Container(
                            key: const ValueKey('countdown'),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryContainer,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Resend code in',
                                  style: AppTypography.textTheme.bodySmall
                                      ?.copyWith(
                                        color: AppColors.onPrimaryContainer,
                                        fontWeight: FontWeight.w500,
                                      ),
                                ),
                                const SizedBox(width: 12),
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Stack(
                                    children: [
                                      CircularProgressIndicator(
                                        strokeWidth: 2,
                                        value: (60 - _resendCountdown) / 60,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              AppColors.primary,
                                            ),
                                        backgroundColor: AppColors.primary
                                            .withOpacity(0.2),
                                      ),
                                      Center(
                                        child: Text(
                                          '${_resendCountdown}',
                                          style: AppTypography
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                        ).animate().scale(
                                          duration: AppMotion.fast,
                                          curve: AppCurves.emphasized,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                          : Container(
                            key: const ValueKey('resend'),
                            child:
                                AnimatedButtons.text(
                                  onPressed: _isResending ? null : _resendOTP,
                                  isLoading: _isResending,
                                  child: Text(
                                    'Resend Code',
                                    style: AppTypography.textTheme.labelMedium
                                        ?.copyWith(
                                          color: AppColors.primary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ).animate().fadeIn().scale(),
                          ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
