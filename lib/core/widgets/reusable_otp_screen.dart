import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../design_system/color_schemes.dart';
import '../../design_system/typography.dart';
import '../../design_system/spacing.dart';
import '../../design_system/radii.dart';
import '../widgets/watermark_background.dart';
import '../widgets/custom_snackbar.dart';
import '../../ui/primitives/animated_button.dart';

/// Reusable OTP verification screen for different contexts
class ReusableOtpScreen extends StatefulWidget {
  final String email;
  final String
  purpose; // 'email_verification', 'password_reset', 'profile_edit', 'password_change'
  final Function(String otp) onOtpVerified;
  final Future<bool> Function() onResendOtp;
  final String? initialOtp;

  const ReusableOtpScreen({
    super.key,
    required this.email,
    required this.purpose,
    required this.onOtpVerified,
    required this.onResendOtp,
    this.initialOtp,
  });

  @override
  State<ReusableOtpScreen> createState() => _ReusableOtpScreenState();
}

class _ReusableOtpScreenState extends State<ReusableOtpScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage;
  int _resendCountdown = 0;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
    if (widget.initialOtp != null && widget.initialOtp!.length == 6) {
      _fillOtpFields(widget.initialOtp!);
    }
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    _resendTimer?.cancel();
    super.dispose();
  }

  String _getOtpCode() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  void _fillOtpFields(String otp) {
    for (int i = 0; i < otp.length && i < 6; i++) {
      _otpControllers[i].text = otp[i];
    }
    _focusNodes.last.requestFocus();
    _verifyOtp();
  }

  void _handlePasteOnFirstField() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null) {
        final pastedText = clipboardData!.text!.replaceAll(
          RegExp(r'[^0-9]'),
          '',
        );
        if (pastedText.length >= 6) {
          // Fill all fields with the pasted OTP
          for (int i = 0; i < 6; i++) {
            _otpControllers[i].text = pastedText[i];
          }
          // Focus on the last field
          _focusNodes[5].requestFocus();
          // Auto-verify if all fields are filled
          _verifyOtp();
        } else if (pastedText.isNotEmpty) {
          // Fill available fields
          for (int i = 0; i < pastedText.length && i < 6; i++) {
            _otpControllers[i].text = pastedText[i];
          }
          // Focus on the next empty field
          final nextIndex = pastedText.length < 6 ? pastedText.length : 5;
          _focusNodes[nextIndex].requestFocus();
        }
      }
    } catch (e) {
      // Handle clipboard access errors silently
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _getOtpCode();
    if (otp.length != 6) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await widget.onOtpVerified(otp);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      CustomSnackbar.showError(context, message: _errorMessage!);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _startResendCountdown() {
    setState(() {
      _resendCountdown = 60;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown == 0) {
        timer.cancel();
        if (mounted) {
          setState(() {});
        }
      } else {
        if (mounted) {
          setState(() {
            _resendCountdown--;
          });
        }
      }
    });
  }

  Future<void> _resendOtp() async {
    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      final success = await widget.onResendOtp();
      if (success) {
        CustomSnackbar.showSuccess(
          context,
          message: 'Verification code sent again',
        );
        _startResendCountdown();
        _clearOtpFields();
      } else {
        _errorMessage = 'Failed to resend verification code.';
        CustomSnackbar.showError(context, message: _errorMessage!);
      }
    } catch (e) {
      _errorMessage = 'Error: ${e.toString()}';
      CustomSnackbar.showError(context, message: _errorMessage!);
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  void _clearOtpFields() {
    for (var controller in _otpControllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  String _getTitle() {
    switch (widget.purpose) {
      case 'email_verification':
        return 'Verify Your Email';
      case 'password_reset':
        return 'Verify Reset Code';
      case 'profile_edit':
        return 'Verify Your Identity';
      case 'password_change':
        return 'Verify Password Change';
      default:
        return 'Verify Code';
    }
  }

  String _getSubtitle() {
    switch (widget.purpose) {
      case 'email_verification':
        return 'We\'ve sent a 6-digit code to ${widget.email} to verify your account.';
      case 'password_reset':
        return 'We\'ve sent a 6-digit reset code to ${widget.email}';
      case 'profile_edit':
        return 'We\'ve sent a verification code to ${widget.email}. Please enter it below to confirm your changes.';
      case 'password_change':
        return 'We\'ve sent a verification code to ${widget.email}. Please enter it below to confirm your password change.';
      default:
        return 'We\'ve sent a 6-digit code to ${widget.email}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return WatermarkBackgroundBuilder.bottomRight(
      icon: Icons.lock_outline,
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
              'Verify OTP',
              style: AppTypography.textTheme.titleLarge?.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
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
                    child: Icon(Icons.sms, color: AppColors.primary, size: 40),
                  ),

                  const SizedBox(height: 24),

                  Text(
                    _getTitle(),
                    textAlign: TextAlign.center,
                    style: AppTypography.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    _getSubtitle(),
                    textAlign: TextAlign.center,
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // OTP input fields
                  _buildOtpInput(),

                  if (_errorMessage != null) ...[
                    const SizedBox(height: 16),
                    _buildErrorMessage(),
                  ],

                  const SizedBox(height: 32),

                  // Verify button
                  _buildVerifyButton(),

                  const SizedBox(height: 16),

                  // Resend section
                  _buildResendSection(),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOtpInput() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 50,
          height: 65,
          child: TextFormField(
            controller: _otpControllers[index],
            focusNode: _focusNodes[index],
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            maxLength: 1,
            style: AppTypography.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.grey[800], // Dark grey text
            ),
            decoration: InputDecoration(
              counterText: '',
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Radii.m),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Radii.m),
                borderSide: BorderSide(color: AppColors.primary, width: 2),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Radii.m),
                borderSide: BorderSide(color: AppColors.error),
              ),
            ),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            onChanged: (value) {
              if (index == 0 && value.length > 1) {
                _handlePasteOnFirstField();
              } else if (value.isNotEmpty) {
                if (index < 5) {
                  _focusNodes[index + 1].requestFocus();
                } else {
                  _focusNodes[index].unfocus();
                  _verifyOtp();
                }
              } else if (value.isEmpty && index > 0) {
                _focusNodes[index - 1].requestFocus();
              }
            },
            onTap: () {
              setState(() {
                _errorMessage = null;
              });
            },
          ),
        );
      }),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(Radii.m),
        border: Border.all(color: AppColors.error.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: AppColors.error, size: 20),
          SizedBox(width: AppSpacing.s),
          Expanded(
            child: Text(
              _errorMessage!,
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerifyButton() {
    return AnimatedButton(
      isLoading: _isLoading,
      onPressed: _isLoading ? null : _verifyOtp,
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      borderRadius: BorderRadius.circular(Radii.l),
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.verified, size: 20, color: AppColors.onPrimary),
          SizedBox(width: AppSpacing.s),
          Text(
            'Verify Code',
            style: AppTypography.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResendSection() {
    return Column(
      children: [
        Text(
          'Didn\'t receive the code?',
          style: AppTypography.textTheme.bodyMedium?.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
        SizedBox(height: AppSpacing.s),
        if (_resendCountdown > 0)
          Text(
            'Resend code in ${_resendCountdown}s',
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
          )
        else
          AnimatedButton(
            onPressed: _isResending ? null : _resendOtp,
            isLoading: _isResending,
            backgroundColor: AppColors.surface,
            foregroundColor: AppColors.primary,
            borderRadius: BorderRadius.circular(Radii.l),
            height: 48,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.refresh, size: 18, color: AppColors.primary),
                SizedBox(width: AppSpacing.s),
                Text(
                  'Resend Code',
                  style: AppTypography.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
