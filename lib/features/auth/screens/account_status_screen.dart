import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';

/// Account status screen for suspended/banned accounts
class AccountStatusScreen extends StatelessWidget {
  final String status;
  final String message;

  const AccountStatusScreen({
    super.key,
    required this.status,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorSchemes.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Spacer(),

              // Status icon
              Icon(
                status == 'suspended' ? Icons.pause_circle : Icons.block,
                size: 120,
                color:
                    status == 'suspended'
                        ? AppColorSchemes.warning
                        : AppColorSchemes.error,
              ),

              const SizedBox(height: 32),

              // Status title
              Text(
                status == 'suspended' ? 'Account Suspended' : 'Account Banned',
                style: AppTypography.textTheme.headlineLarge?.copyWith(
                  color:
                      status == 'suspended'
                          ? AppColorSchemes.warning
                          : AppColorSchemes.error,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Status message
              Text(
                message,
                style: AppTypography.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              // Contact support button
              AnimatedButton(
                onPressed: () {
                  _showContactSupportDialog(context);
                },
                child: const Text('Contact Support'),
              ),

              const SizedBox(height: 16),

              // Logout button
              Consumer<AuthProvider>(
                builder: (context, authProvider, child) {
                  return AnimatedButton(
                    onPressed: () async {
                      await authProvider.logout();
                      if (context.mounted) {
                        Navigator.of(
                          context,
                        ).pushNamedAndRemoveUntil('/login', (route) => false);
                      }
                    },
                    backgroundColor: AppColorSchemes.surface,
                    foregroundColor: AppColorSchemes.textPrimary,
                    child: const Text('Logout'),
                  );
                },
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void _showContactSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Contact Support'),
            content: const Text(
              'If you believe this is an error or need assistance, please contact our support team.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              AnimatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _openSupportChannel();
                },
                child: const Text('Contact Support'),
              ),
            ],
          ),
    );
  }

  void _openSupportChannel() {
    // Support channel - can be implemented with url_launcher
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Text(
          'Email: support@justlaunder.co.uk\nPhone: +44 XXX XXX XXXX',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
