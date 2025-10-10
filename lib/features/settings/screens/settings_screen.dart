import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/spacing_utils.dart';
import '../../../design_system/motion.dart';
import '../../../ui/primitives/card_x.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../core/widgets/custom_snackbar.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/laundrette_profile_provider.dart';
import '../../../data/models/subscription.dart';
import 'subscription_management_screen.dart';
import 'notification_settings_screen.dart';
import 'system_preferences_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Mock settings data
  bool _darkMode = false;
  bool _biometricAuth = false;
  bool _autoSync = true;
  bool _locationServices = true;
  String _language = 'English';
  // Currency setting removed from local state - managed by provider

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: colorScheme.surface.withOpacity(0.9),
        elevation: 0,
        title: Text(
          'Settings',
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Consumer2<LaundretteProfileProvider, AuthProvider>(
        builder: (context, profileProvider, authProvider, child) {
          final profile = profileProvider.currentProfile;
          final subscription = profileProvider.currentSubscription;

          return CustomScrollView(
            slivers: [
              // Profile Card
              SliverToBoxAdapter(
                child: Padding(
                  padding: SpacingUtils.all(AppSpacing.l),
                  child: _buildProfileCard(profile, subscription),
                ),
              ),

              // Settings Sections
              SliverToBoxAdapter(
                child: Padding(
                  padding: SpacingUtils.symmetric(
                    horizontal: AppSpacing.l,
                    vertical: 0,
                  ),
                  child: Column(
                    children: [
                      _buildSettingsSection('Account Settings', [
                        _buildSettingsItem(
                          'Edit Profile',
                          'Update your business information',
                          Icons.edit,
                          () => _showEditProfileDialog(),
                        ),
                        _buildSettingsItem(
                          'Change Password',
                          'Update your account password',
                          Icons.lock,
                          () => _showChangePasswordDialog(),
                        ),
                        _buildSettingsItem(
                          'Language',
                          _language,
                          Icons.language,
                          () => _showLanguageDialog(),
                        ),
                      ]),

                      const SizedBox(height: AppSpacing.l),

                      _buildSettingsSection('Security', [
                        _buildToggleItem(
                          'Biometric Authentication',
                          'Use fingerprint or face recognition',
                          Icons.fingerprint,
                          _biometricAuth,
                          (value) => setState(() => _biometricAuth = value),
                        ),
                        _buildToggleItem(
                          'Auto Sync',
                          'Automatically sync data when connected',
                          Icons.sync,
                          _autoSync,
                          (value) => setState(() => _autoSync = value),
                        ),
                        _buildToggleItem(
                          'Location Services',
                          'Allow location access for branch services',
                          Icons.location_on,
                          _locationServices,
                          (value) => setState(() => _locationServices = value),
                        ),
                      ]),

                      const SizedBox(height: AppSpacing.l),

                      _buildSettingsSection('App Settings', [
                        _buildToggleItem(
                          'Dark Mode',
                          'Use dark theme throughout the app',
                          Icons.dark_mode,
                          _darkMode,
                          (value) => setState(() => _darkMode = value),
                        ),
                        _buildSettingsItem(
                          'Notification Settings',
                          'Configure notifications and alerts',
                          Icons.notifications,
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const NotificationSettingsScreen(),
                            ),
                          ),
                        ),
                        _buildSettingsItem(
                          'System Preferences',
                          'App settings and system configuration',
                          Icons.settings,
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => const SystemPreferencesScreen(),
                            ),
                          ),
                        ),
                      ]),

                      const SizedBox(height: AppSpacing.l),

                      _buildSettingsSection('Subscription', [
                        _buildSettingsItem(
                          'Subscription Management',
                          'Manage your subscription plan and billing',
                          Icons.subscriptions,
                          () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const SubscriptionManagementScreen(),
                            ),
                          ),
                        ),
                        if (subscription != null)
                          _buildSubscriptionInfo(subscription),
                      ]),

                      const SizedBox(height: AppSpacing.l),

                      _buildSettingsSection('Support', [
                        _buildSettingsItem(
                          'Help & Support',
                          'Get help and contact support',
                          Icons.help,
                          () => _showHelpDialog(),
                        ),
                        _buildSettingsItem(
                          'About',
                          'App version and information',
                          Icons.info,
                          () => _showAboutDialog(),
                        ),
                        _buildSettingsItem(
                          'Privacy Policy',
                          'View our privacy policy',
                          Icons.privacy_tip,
                          () => _showPrivacyDialog(),
                        ),
                      ]),

                      const SizedBox(height: AppSpacing.l),

                      _buildLogoutSection(authProvider),

                      const SizedBox(height: AppSpacing.xl),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProfileCard(profile, subscription) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primary.withOpacity(0.8)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hi, ${profile?.businessName ?? 'Laundrette Owner'}',
                        style: AppTypography.textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.s),
                      Text(
                        'Member since: ${_formatDate(profile?.createdAt ?? DateTime.now())}',
                        style: AppTypography.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  child: Icon(Icons.business, size: 30, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.l),
            Row(
              children: [
                Icon(
                  Icons.settings,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.s),
                Icon(
                  Icons.dark_mode,
                  color: Colors.white.withOpacity(0.8),
                  size: 20,
                ),
                const Spacer(),
                Container(
                  padding: SpacingUtils.symmetric(
                    horizontal: AppSpacing.m,
                    vertical: AppSpacing.s,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Edit Account',
                    style: AppTypography.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fadeIn(duration: AppMotion.normal).slideY(begin: 0.2, end: 0.0);
  }

  Widget _buildSettingsSection(String title, List<Widget> children) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.textTheme.titleMedium?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: AppSpacing.s),
        CardsX.elevated(child: Column(children: children)),
      ],
    );
  }

  Widget _buildSettingsItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: SpacingUtils.all(AppSpacing.s),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: AppTypography.textTheme.titleSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: colorScheme.onSurfaceVariant,
        size: 16,
      ),
      onTap: onTap,
    );
  }

  Widget _buildToggleItem(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return ListTile(
      leading: Container(
        padding: SpacingUtils.all(AppSpacing.s),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.primary, size: 20),
      ),
      title: Text(
        title,
        style: AppTypography.textTheme.titleSmall?.copyWith(
          color: colorScheme.onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.textTheme.bodySmall?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.primary,
      ),
    );
  }

  Widget _buildSubscriptionInfo(Subscription subscription) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      margin: SpacingUtils.all(AppSpacing.s),
      padding: SpacingUtils.all(AppSpacing.m),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.star, color: AppColors.success, size: 20),
          const SizedBox(width: AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${subscription.name} Plan',
                  style: AppTypography.textTheme.titleSmall?.copyWith(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '£${subscription.monthlyPrice.toStringAsFixed(2)}/month',
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutSection(AuthProvider authProvider) {
    return CardsX.elevated(
      child: ListTile(
        leading: Container(
          padding: SpacingUtils.all(AppSpacing.s),
          decoration: BoxDecoration(
            color: AppColors.error.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.logout, color: AppColors.error, size: 20),
        ),
        title: Text(
          'Logout',
          style: AppTypography.textTheme.titleSmall?.copyWith(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          'Sign out of your account',
          style: AppTypography.textTheme.bodySmall?.copyWith(
            color: AppColors.error.withOpacity(0.7),
          ),
        ),
        onTap: () => _showLogoutConfirmation(authProvider),
      ),
    );
  }

  void _showLogoutConfirmation(AuthProvider authProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder:
          (context) => Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: SpacingUtils.all(AppSpacing.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.l),
                  decoration: BoxDecoration(
                    color: AppColors.onSurfaceVariant.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                // Icon
                Container(
                  padding: SpacingUtils.all(AppSpacing.l),
                  decoration: BoxDecoration(
                    color: AppColors.error.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.logout, color: AppColors.error, size: 32),
                ),

                const SizedBox(height: AppSpacing.l),

                // Title
                Text(
                  'Logout',
                  style: AppTypography.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.onSurface,
                  ),
                ),

                const SizedBox(height: AppSpacing.s),

                // Message
                Text(
                  'Are you sure you want to logout? You will need to sign in again to access your account.',
                  textAlign: TextAlign.center,
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),

                const SizedBox(height: AppSpacing.xl),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: AnimatedButtons.secondary(
                        onPressed: () => Navigator.of(context).pop(),
                        height: 52,
                        child: Text(
                          'Cancel',
                          style: AppTypography.textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      child: AnimatedButton(
                        onPressed: () async {
                          await authProvider.logout();
                          if (mounted) {
                            CustomSnackbar.showSuccess(
                              context,
                              message: 'Logged out successfully',
                            );
                            // Navigate away after showing the snackbar
                            Navigator.of(context).pop();
                          }
                        },
                        height: 52,
                        backgroundColor: AppColors.error,
                        foregroundColor: AppColors.onPrimary,
                        borderRadius: BorderRadius.circular(12),
                        child: Text(
                          'Logout',
                          style: AppTypography.textTheme.labelLarge?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.m),
              ],
            ),
          ),
    );
  }

  // Dialog methods
  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Profile'),
            content: const Text(
              'Edit profile functionality will be implemented soon.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Password'),
            content: const Text(
              'Change password functionality will be implemented soon.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Select Language'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  ['English', 'Spanish', 'French', 'German'].map((lang) {
                    return ListTile(
                      title: Text(lang),
                      onTap: () {
                        setState(() => _language = lang);
                        Navigator.of(context).pop();
                      },
                    );
                  }).toList(),
            ),
          ),
    );
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Help & Support'),
            content: const Text(
              'Contact our support team at support@laundrex.com or call +44 20 1234 5678',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showAboutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('About Laundrex'),
            content: const Text(
              'Laundrex Business App\nVersion 1.0.0\n\nManage your laundrette business efficiently with our comprehensive platform.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Privacy Policy'),
            content: const Text(
              'Our privacy policy outlines how we collect, use, and protect your data. Full policy available at laundrex.com/privacy',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
