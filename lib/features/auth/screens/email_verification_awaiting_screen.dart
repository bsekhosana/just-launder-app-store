import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../providers/auth_provider.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../navigation/screens/main_navigation_screen.dart';

/// Email verification awaiting screen for laundrette app
class EmailVerificationAwaitingScreen extends StatefulWidget {
  final String email;

  const EmailVerificationAwaitingScreen({super.key, required this.email});

  @override
  State<EmailVerificationAwaitingScreen> createState() =>
      _EmailVerificationAwaitingScreenState();
}

class _EmailVerificationAwaitingScreenState
    extends State<EmailVerificationAwaitingScreen> {
  bool _isResending = false;
  int _resendCountdown = 0;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startResendCountdown();
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
                'We\'ve sent a verification link to\n${widget.email}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 40),

              // Verification status
              _buildVerificationStatus(),

              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                _buildErrorMessage(),
              ],

              const Spacer(),

              // Resend button
              _buildResendButton(),

              const SizedBox(height: 16),

              // Logout button
              _buildLogoutButton(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerificationStatus() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.mark_email_unread_outlined,
            size: 48,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Check Your Email',
            style: AppTypography.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'We\'ve sent a verification link to your email address. Please check your inbox and click the link to verify your account.',
            style: AppTypography.textTheme.bodyMedium?.copyWith(
              color: AppColors.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_outline, color: Colors.red[700], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                color: Colors.red[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResendButton() {
    return AnimatedButtons.primary(
      onPressed:
          _isResending || _resendCountdown > 0
              ? null
              : _resendVerificationEmail,
      isLoading: _isResending,
      child: Text(
        _resendCountdown > 0
            ? 'Resend in ${_resendCountdown}s'
            : 'Resend Verification Email',
        style: AppTypography.textTheme.labelLarge?.copyWith(
          color: AppColors.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return AnimatedButtons.secondary(
      onPressed: _logout,
      child: Text(
        'Logout',
        style: AppTypography.textTheme.labelLarge?.copyWith(
          color: AppColors.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Future<void> _resendVerificationEmail() async {
    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    try {
      // TODO: Implement actual resend verification email API call
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Verification email sent successfully'),
            backgroundColor: AppColors.successGreen,
          ),
        );

        _startResendCountdown();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage =
              'Failed to resend verification email. Please try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MainNavigationScreen()),
        (route) => false,
      );
    }
  }

  void _startResendCountdown() {
    setState(() {
      _resendCountdown = 60;
    });

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() {
          _resendCountdown--;
        });
        return _resendCountdown > 0;
      }
      return false;
    });
  }
}
