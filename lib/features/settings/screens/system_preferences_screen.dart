import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/motion.dart';
import '../../../design_system/icons.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/card_x.dart';
import '../../../ui/primitives/snack_x.dart';

class SystemPreferencesScreen extends StatefulWidget {
  const SystemPreferencesScreen({super.key});

  @override
  State<SystemPreferencesScreen> createState() =>
      _SystemPreferencesScreenState();
}

class _SystemPreferencesScreenState extends State<SystemPreferencesScreen> {
  // General settings
  String _language = 'English';
  String _currency = 'USD';
  String _timezone = 'UTC';
  bool _darkMode = false;
  bool _autoSync = true;
  bool _locationServices = true;

  // Business settings
  String _businessHours = '24/7';
  bool _autoAcceptOrders = false;
  bool _requireOrderConfirmation = true;
  int _orderTimeoutMinutes = 30;
  bool _enablePriorityDelivery = true;

  // Data settings
  bool _dataBackup = true;
  String _backupFrequency = 'daily';
  bool _analyticsTracking = true;
  bool _crashReporting = true;

  // Security settings
  bool _twoFactorAuth = false;
  bool _sessionTimeout = true;
  int _sessionTimeoutMinutes = 60;
  bool _loginNotifications = true;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'System Preferences',
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
      ),
      body: SingleChildScrollView(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGeneralSettings()
                .animate()
                .fadeIn(duration: AppMotion.normal)
                .slideY(begin: 0.1, end: 0.0),
            const Gap.vertical(AppSpacing.l),
            _buildBusinessSettings()
                .animate()
                .fadeIn(delay: AppMotion.fast, duration: AppMotion.normal)
                .slideY(begin: 0.1, end: 0.0),
            const Gap.vertical(AppSpacing.l),
            _buildDataSettings()
                .animate()
                .fadeIn(delay: AppMotion.normal, duration: AppMotion.normal)
                .slideY(begin: 0.1, end: 0.0),
            const Gap.vertical(AppSpacing.l),
            _buildSecuritySettings()
                .animate()
                .fadeIn(delay: AppMotion.slow, duration: AppMotion.normal)
                .slideY(begin: 0.1, end: 0.0),
            const Gap.vertical(AppSpacing.l),
            _buildActionButtons()
                .animate()
                .fadeIn(delay: AppMotion.slower, duration: AppMotion.normal)
                .slideY(begin: 0.1, end: 0.0),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'General Settings',
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap.vertical(AppSpacing.m),
            _buildLanguageSelector(),
            const SizedBox(height: 16),
            _buildCurrencySelector(),
            const SizedBox(height: 16),
            _buildTimezoneSelector(),
            const SizedBox(height: 16),
            _buildSwitchSetting(
              'Dark Mode',
              'Use dark theme throughout the app',
              _darkMode,
              (value) => setState(() => _darkMode = value),
              Icons.dark_mode,
            ),
            _buildSwitchSetting(
              'Auto Sync',
              'Automatically sync data when connected',
              _autoSync,
              (value) => setState(() => _autoSync = value),
              Icons.sync,
            ),
            _buildSwitchSetting(
              'Location Services',
              'Allow location access for branch services',
              _locationServices,
              (value) => setState(() => _locationServices = value),
              Icons.location_on,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessSettings() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Business Settings',
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap.vertical(AppSpacing.m),
            _buildBusinessHoursSelector(),
            const SizedBox(height: 16),
            _buildSwitchSetting(
              'Auto Accept Orders',
              'Automatically accept incoming orders',
              _autoAcceptOrders,
              (value) => setState(() => _autoAcceptOrders = value),
              Icons.check_circle,
            ),
            _buildSwitchSetting(
              'Require Order Confirmation',
              'Require manual confirmation for all orders',
              _requireOrderConfirmation,
              (value) => setState(() => _requireOrderConfirmation = value),
              Icons.verified,
            ),
            _buildTimeoutSelector(),
            const SizedBox(height: 16),
            _buildSwitchSetting(
              'Priority Delivery',
              'Enable priority delivery options',
              _enablePriorityDelivery,
              (value) => setState(() => _enablePriorityDelivery = value),
              Icons.local_shipping,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSettings() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Data & Privacy',
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap.vertical(AppSpacing.m),
            _buildSwitchSetting(
              'Data Backup',
              'Automatically backup your data',
              _dataBackup,
              (value) => setState(() => _dataBackup = value),
              Icons.backup,
            ),
            if (_dataBackup) ...[
              const SizedBox(height: 16),
              _buildBackupFrequencySelector(),
            ],
            const SizedBox(height: 16),
            _buildSwitchSetting(
              'Analytics Tracking',
              'Help improve the app by sharing usage data',
              _analyticsTracking,
              (value) => setState(() => _analyticsTracking = value),
              Icons.analytics,
            ),
            _buildSwitchSetting(
              'Crash Reporting',
              'Send crash reports to help fix issues',
              _crashReporting,
              (value) => setState(() => _crashReporting = value),
              Icons.bug_report,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSecuritySettings() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Security Settings',
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap.vertical(AppSpacing.m),
            _buildSwitchSetting(
              'Two-Factor Authentication',
              'Add an extra layer of security to your account',
              _twoFactorAuth,
              (value) => setState(() => _twoFactorAuth = value),
              Icons.security,
            ),
            _buildSwitchSetting(
              'Session Timeout',
              'Automatically log out after inactivity',
              _sessionTimeout,
              (value) => setState(() => _sessionTimeout = value),
              Icons.timer,
            ),
            if (_sessionTimeout) ...[
              const SizedBox(height: 16),
              _buildSessionTimeoutSelector(),
            ],
            const SizedBox(height: 16),
            _buildSwitchSetting(
              'Login Notifications',
              'Get notified when someone logs into your account',
              _loginNotifications,
              (value) => setState(() => _loginNotifications = value),
              Icons.notifications_active,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return _buildDropdownSetting(
      'Language',
      _language,
      ['English', 'Spanish', 'French', 'German', 'Italian'],
      (value) => setState(() => _language = value!),
      Icons.language,
    );
  }

  Widget _buildCurrencySelector() {
    return _buildDropdownSetting(
      'Currency',
      _currency,
      ['USD', 'EUR', 'GBP', 'CAD', 'AUD'],
      (value) => setState(() => _currency = value!),
      Icons.attach_money,
    );
  }

  Widget _buildTimezoneSelector() {
    return _buildDropdownSetting(
      'Timezone',
      _timezone,
      ['UTC', 'EST', 'PST', 'GMT', 'CET'],
      (value) => setState(() => _timezone = value!),
      Icons.schedule,
    );
  }

  Widget _buildBusinessHoursSelector() {
    return _buildDropdownSetting(
      'Business Hours',
      _businessHours,
      ['24/7', '9 AM - 6 PM', '8 AM - 8 PM', 'Custom'],
      (value) => setState(() => _businessHours = value!),
      Icons.access_time,
    );
  }

  Widget _buildTimeoutSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Order Timeout (minutes)',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Slider(
          value: _orderTimeoutMinutes.toDouble(),
          min: 5,
          max: 120,
          divisions: 23,
          label: '$_orderTimeoutMinutes minutes',
          onChanged:
              (value) => setState(() => _orderTimeoutMinutes = value.round()),
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildBackupFrequencySelector() {
    return _buildDropdownSetting(
      'Backup Frequency',
      _backupFrequency,
      ['daily', 'weekly', 'monthly'],
      (value) => setState(() => _backupFrequency = value!),
      Icons.schedule,
    );
  }

  Widget _buildSessionTimeoutSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Session Timeout (minutes)',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        Slider(
          value: _sessionTimeoutMinutes.toDouble(),
          min: 15,
          max: 480,
          divisions: 31,
          label: '$_sessionTimeoutMinutes minutes',
          onChanged:
              (value) => setState(() => _sessionTimeoutMinutes = value.round()),
          activeColor: AppColors.primary,
        ),
      ],
    );
  }

  Widget _buildDropdownSetting(
    String title,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const Gap.horizontal(AppSpacing.xs),
            Text(
              title,
              style: AppTypography.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ),
        const Gap.vertical(AppSpacing.xs),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.outline),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            contentPadding: SpacingUtils.symmetric(
              horizontal: AppSpacing.s,
              vertical: AppSpacing.xs,
            ),
          ),
          items:
              options.map((option) {
                return DropdownMenuItem(
                  value: option,
                  child: Text(
                    option,
                    style: AppTypography.textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurface,
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildSwitchSetting(
    String title,
    String description,
    bool value,
    ValueChanged<bool> onChanged,
    IconData icon,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const Gap.horizontal(AppSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  description,
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Actions',
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Gap.vertical(AppSpacing.m),
            Row(
              children: [
                Expanded(
                  child: AnimatedButtons.primary(
                    onPressed: _saveSettings,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(AppIcons.save, color: AppColors.onPrimary),
                        const Gap.horizontal(AppSpacing.xs),
                        Text(
                          'Save Settings',
                          style: AppTypography.textTheme.labelMedium?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap.horizontal(AppSpacing.s),
                Expanded(
                  child: AnimatedButtons.secondary(
                    onPressed: _resetToDefaults,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.restore, color: AppColors.warning),
                        const Gap.horizontal(AppSpacing.xs),
                        Text(
                          'Reset to Defaults',
                          style: AppTypography.textTheme.labelMedium?.copyWith(
                            color: AppColors.warning,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Gap.vertical(AppSpacing.s),
            SizedBox(
              width: double.infinity,
              child: AnimatedButtons.secondary(
                onPressed: _exportSettings,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(AppIcons.download, color: AppColors.primary),
                    const Gap.horizontal(AppSpacing.xs),
                    Text(
                      'Export Settings',
                      style: AppTypography.textTheme.labelMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveSettings() {
    // TODO: Implement settings save logic
    SnackXUtils.showSuccess(context, message: 'Settings saved successfully!');
  }

  void _resetToDefaults() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Reset to Defaults'),
            content: const Text(
              'Are you sure you want to reset all settings to their default values?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  _performReset();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.warning,
                ),
                child: const Text('Reset'),
              ),
            ],
          ),
    );
  }

  void _performReset() {
    setState(() {
      _language = 'English';
      _currency = 'USD';
      _timezone = 'UTC';
      _darkMode = false;
      _autoSync = true;
      _locationServices = true;
      _businessHours = '24/7';
      _autoAcceptOrders = false;
      _requireOrderConfirmation = true;
      _orderTimeoutMinutes = 30;
      _enablePriorityDelivery = true;
      _dataBackup = true;
      _backupFrequency = 'daily';
      _analyticsTracking = true;
      _crashReporting = true;
      _twoFactorAuth = false;
      _sessionTimeout = true;
      _sessionTimeoutMinutes = 60;
      _loginNotifications = true;
    });

    SnackXUtils.showSuccess(context, message: 'Settings reset to defaults!');
  }

  void _exportSettings() {
    // TODO: Implement settings export logic
    SnackXUtils.showInfo(context, message: 'Settings exported successfully!');
  }
}
