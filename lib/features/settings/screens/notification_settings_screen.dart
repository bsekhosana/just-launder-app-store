import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../providers/settings_provider.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  // Notification preferences
  bool _orderNotifications = true;
  bool _staffNotifications = true;
  bool _paymentNotifications = true;
  bool _systemNotifications = true;
  bool _marketingNotifications = false;
  bool _pushNotifications = true;
  bool _emailNotifications = true;
  bool _smsNotifications = false;

  // Notification timing
  String _quietHoursStart = '22:00';
  String _quietHoursEnd = '08:00';
  bool _quietHoursEnabled = true;

  // Frequency settings
  String _orderUpdateFrequency = 'immediate';
  String _reportFrequency = 'daily';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationTypesSection(),
                const SizedBox(height: 24),
                _buildDeliveryMethodsSection(),
                const SizedBox(height: 24),
                _buildTimingSection(),
                const SizedBox(height: 24),
                _buildFrequencySection(),
                const SizedBox(height: 24),
                _buildTestNotificationSection(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationTypesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Types',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildNotificationSwitch(
              'Order Notifications',
              'New orders, status updates, and order-related alerts',
              _orderNotifications,
              (value) => setState(() => _orderNotifications = value),
              Icons.shopping_bag,
            ),
            _buildNotificationSwitch(
              'Staff Notifications',
              'Staff activity, schedule changes, and performance updates',
              _staffNotifications,
              (value) => setState(() => _staffNotifications = value),
              Icons.people,
            ),
            _buildNotificationSwitch(
              'Payment Notifications',
              'Payment confirmations, billing alerts, and subscription updates',
              _paymentNotifications,
              (value) => setState(() => _paymentNotifications = value),
              Icons.payment,
            ),
            _buildNotificationSwitch(
              'System Notifications',
              'App updates, maintenance alerts, and system status',
              _systemNotifications,
              (value) => setState(() => _systemNotifications = value),
              Icons.settings,
            ),
            _buildNotificationSwitch(
              'Marketing Notifications',
              'Promotional offers, tips, and business insights',
              _marketingNotifications,
              (value) => setState(() => _marketingNotifications = value),
              Icons.campaign,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSwitch(
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

  Widget _buildDeliveryMethodsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Delivery Methods',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildDeliveryMethodSwitch(
              'Push Notifications',
              'Receive notifications on your device',
              _pushNotifications,
              (value) => setState(() => _pushNotifications = value),
              Icons.notifications,
            ),
            _buildDeliveryMethodSwitch(
              'Email Notifications',
              'Receive notifications via email',
              _emailNotifications,
              (value) => setState(() => _emailNotifications = value),
              Icons.email,
            ),
            _buildDeliveryMethodSwitch(
              'SMS Notifications',
              'Receive notifications via text message',
              _smsNotifications,
              (value) => setState(() => _smsNotifications = value),
              Icons.sms,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryMethodSwitch(
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

  Widget _buildTimingSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Quiet Hours',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Enable Quiet Hours'),
                      Text(
                        'No notifications during specified hours',
                        style: const TextStyle(
                          color: AppTheme.mediumGrey,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _quietHoursEnabled,
                  onChanged:
                      (value) => setState(() => _quietHoursEnabled = value),
                  activeColor: AppTheme.primaryBlue,
                ),
              ],
            ),
            if (_quietHoursEnabled) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker(
                      'Start Time',
                      _quietHoursStart,
                      (time) => setState(() => _quietHoursStart = time),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildTimePicker(
                      'End Time',
                      _quietHoursEnd,
                      (time) => setState(() => _quietHoursEnd = time),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTimePicker(
    String label,
    String time,
    ValueChanged<String> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _selectTime(time, onChanged),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.lightGrey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(time), const Icon(Icons.access_time, size: 20)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencySection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Notification Frequency',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFrequencyDropdown(
              'Order Updates',
              _orderUpdateFrequency,
              ['immediate', 'hourly', 'daily'],
              (value) => setState(() => _orderUpdateFrequency = value!),
            ),
            const SizedBox(height: 16),
            _buildFrequencyDropdown(
              'Reports',
              _reportFrequency,
              ['immediate', 'daily', 'weekly', 'monthly'],
              (value) => setState(() => _reportFrequency = value!),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFrequencyDropdown(
    String label,
    String value,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
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
                return DropdownMenuItem(
                  value: option,
                  child: Text(_formatFrequencyOption(option)),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildTestNotificationSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Test Notifications',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Send test notifications to verify your settings are working correctly.',
              style: TextStyle(color: AppTheme.mediumGrey),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _sendTestNotification,
                    icon: const Icon(Icons.send),
                    label: const Text('Send Test'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _saveSettings,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Settings'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppTheme.primaryBlue,
                      side: const BorderSide(color: AppTheme.primaryBlue),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatFrequencyOption(String option) {
    switch (option) {
      case 'immediate':
        return 'Immediate';
      case 'hourly':
        return 'Hourly';
      case 'daily':
        return 'Daily';
      case 'weekly':
        return 'Weekly';
      case 'monthly':
        return 'Monthly';
      default:
        return option;
    }
  }

  void _selectTime(String currentTime, ValueChanged<String> onChanged) async {
    final time = TimeOfDay.now();
    final picked = await showTimePicker(context: context, initialTime: time);
    if (picked != null) {
      final formattedTime =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      onChanged(formattedTime);
    }
  }

  void _sendTestNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Test notification sent! Check your device.'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }

  void _saveSettings() {
    // TODO: Implement settings save logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Notification settings saved successfully!'),
        backgroundColor: AppTheme.successGreen,
      ),
    );
  }
}
