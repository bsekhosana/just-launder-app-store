import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: const Text('System Preferences'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildGeneralSettings(),
            const SizedBox(height: 24),
            _buildBusinessSettings(),
            const SizedBox(height: 24),
            _buildDataSettings(),
            const SizedBox(height: 24),
            _buildSecuritySettings(),
            const SizedBox(height: 24),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildGeneralSettings() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'General Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Business Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Data & Privacy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Security Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
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
          activeColor: AppTheme.primaryBlue,
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
          activeColor: AppTheme.primaryBlue,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: AppTheme.primaryBlue, size: 20),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          items:
              options.map((option) {
                return DropdownMenuItem(value: option, child: Text(option));
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  description,
                  style: const TextStyle(
                    color: AppTheme.mediumGrey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.primaryBlue,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Actions',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _saveSettings,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Settings'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _resetToDefaults,
                    icon: const Icon(Icons.restore),
                    label: const Text('Reset to Defaults'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.warningOrange,
                      side: const BorderSide(color: AppTheme.warningOrange),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _exportSettings,
                icon: const Icon(Icons.download),
                label: const Text('Export Settings'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppTheme.primaryTeal,
                  side: const BorderSide(color: AppTheme.primaryTeal),
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings saved successfully!'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
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
                  backgroundColor: AppTheme.warningOrange,
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

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings reset to defaults!'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _exportSettings() {
    // TODO: Implement settings export logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Settings exported successfully!'),
        backgroundColor: AppTheme.primaryTeal,
      ),
    );
  }
}
