import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../core/widgets/watermark_background.dart';
import '../../../core/widgets/animated_auth_screen.dart';
import '../../../core/widgets/custom_snackbar.dart';
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
  int _resendCountdown = 0;
  String? _errorMessage;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
    _setupPasteListener();
  }

  void _setupPasteListener() {
    // Listen for paste events on the first field
    _focusNodes[0].addListener(() {
      if (_focusNodes[0].hasFocus) {
        _handlePasteOnFirstField();
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _startResendCountdown() {
    _countdownTimer?.cancel();
    setState(() => _resendCountdown = 60);
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  void _handlePasteOnFirstField() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    if (clipboardData?.text != null) {
      final text = clipboardData!.text!.replaceAll(RegExp(r'[^0-9]'), '');
      if (text.length >= 6) {
        for (int i = 0; i < 6; i++) {
          _otpControllers[i].text = text[i];
        }
        _verifyOTP();
      }
    }
  }

  void _onDigitChanged(String value, int index) {
    if (value.isNotEmpty) {
      if (index < 5) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
        _verifyOTP();
      }
    } else if (index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  Future<void> _verifyOTP() async {
    final otp = _otpControllers.map((controller) => controller.text).join();

    if (otp.length != 6) {
      setState(() => _errorMessage = 'Please enter a valid 6-digit code');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (widget.isPasswordReset) {
        // Verify OTP with backend before navigating to reset password screen
        final success = await authProvider.verifyOTP(widget.email, otp);

        if (mounted) {
          if (success) {
            // OTP is valid, navigate to reset password screen
            CustomSnackbar.showSuccess(
              context,
              message: 'Code verified successfully',
            );

            await Future.delayed(const Duration(milliseconds: 500));

            if (mounted) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (context) =>
                          ResetPasswordScreen(email: widget.email, otp: otp),
                ),
              );
            }
          } else {
            // OTP is invalid or expired
            final errorMessage =
                authProvider.error ?? 'Invalid or expired code';
            setState(() => _errorMessage = errorMessage);
          }
        }
      } else {
        // Verify OTP for email verification
        final success = await authProvider.checkEmailVerificationStatus(
          widget.email,
        );

        if (success && mounted) {
          CustomSnackbar.showSuccess(
            context,
            message: 'Email verified successfully',
          );
          Navigator.of(context).pushReplacementNamed('/main');
        } else {
          setState(() => _errorMessage = 'Verification failed');
        }
      }
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _resendOTP() async {
    if (_resendCountdown > 0) return;

    setState(() => _isResending = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      if (widget.isPasswordReset) {
        await authProvider.sendPasswordResetEmail(widget.email);
      } else {
        await authProvider.resendVerificationEmail(widget.email);
      }

      _startResendCountdown();

      if (mounted) {
        CustomSnackbar.showSuccess(
          context,
          message: 'Verification code sent again',
        );
      }
    } catch (e) {
      if (mounted) {
        CustomSnackbar.showError(context, message: 'Error: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WatermarkBackgroundBuilder.bottomRight(
      icon: FontAwesomeIcons.shieldHalved,
      iconColor: AppColors.primary,
      margin: const EdgeInsets.all(16),
      opacity: 0.10,
      iconSizePercentage: 0.45,
      iconShift: -15.0,
      child: AnimatedAuthScreen(
        title: widget.isPasswordReset ? 'Verify Reset Code' : 'Verify Code',
        subtitle:
            widget.isPasswordReset
                ? 'We\'ve sent a 6-digit reset code to ${widget.email}'
                : 'We\'ve sent a 6-digit code to ${widget.email}',
        icon: Padding(
          padding: EdgeInsets.all(AppSpacing.l),
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.security, color: AppColors.primary, size: 40),
          ),
        ),
        showAppBar: true,
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside text fields
            FocusScope.of(context).unfocus();
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    height: 60,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      style: AppTypography.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      decoration: InputDecoration(
                        counterText: '',
                        filled: true,
                        fillColor: AppColors.surface,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color:
                                _errorMessage != null
                                    ? AppColors.errorRed
                                    : AppColors.outline,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color:
                                _errorMessage != null
                                    ? AppColors.errorRed
                                    : AppColors.outline,
                          ),
                        ),
                      ),
                      onChanged: (value) => _onDigitChanged(value, index),
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                  );
                }),
              ),

              if (_errorMessage != null) ...[
                SizedBox(height: AppSpacing.m),
                Text(
                  _errorMessage!,
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: AppColors.errorRed,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],

              SizedBox(height: AppSpacing.xl),

              // Verify Button
              AnimatedButtons.primary(
                onPressed: _isLoading ? null : _verifyOTP,
                isLoading: _isLoading,
                child: Text(
                  'Verify Code',
                  style: AppTypography.textTheme.labelLarge?.copyWith(
                    color: AppColors.onPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.l),

              // Resend Code
              Center(
                child: TextButton(
                  onPressed:
                      _resendCountdown > 0 || _isResending ? null : _resendOTP,
                  child: Text(
                    _isResending
                        ? 'Sending...'
                        : _resendCountdown > 0
                        ? 'Resend code in ${_resendCountdown}s'
                        : 'Resend code',
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color:
                          _resendCountdown > 0 || _isResending
                              ? AppColors.onSurfaceVariant
                              : AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: AppSpacing.l),

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
    );
  }
}
