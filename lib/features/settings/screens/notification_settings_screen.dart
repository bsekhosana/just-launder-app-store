import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';
import '../../../design_system/spacing.dart';
import '../../../design_system/spacing_utils.dart';
import '../../../design_system/motion.dart';
import '../../../design_system/icons.dart';
import '../../../ui/primitives/animated_button.dart';
import '../../../ui/primitives/card_x.dart';
import '../../../ui/primitives/snack_x.dart';
import '../providers/settings_provider.dart';
import '../../../data/services/settings_mock_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Notification Settings',
          style: AppTypography.textTheme.titleLarge?.copyWith(
            color: colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: colorScheme.onSurface,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: AnimatedButton(
              onPressed: _saveSettings,
              backgroundColor: Colors.white,
              width: 48,
              height: 48,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white, width: 1),
              tooltip: 'Save Settings',
              child: Align(
                alignment: Alignment.center,
                child: Icon(AppIcons.save, color: AppColors.primary, size: 20),
              ),
            ),
          ),
        ],
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, child) {
          return SingleChildScrollView(
            padding: SpacingUtils.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildNotificationTypesSection(settingsProvider)
                    .animate()
                    .fadeIn(duration: AppMotion.normal)
                    .slideY(begin: 0.1, end: 0.0),
                const SizedBox(height: AppSpacing.l),
                _buildDeliveryMethodsSection()
                    .animate()
                    .fadeIn(delay: AppMotion.fast, duration: AppMotion.normal)
                    .slideY(begin: 0.1, end: 0.0),
                const SizedBox(height: AppSpacing.l),
                _buildTimingSection()
                    .animate()
                    .fadeIn(delay: AppMotion.normal, duration: AppMotion.normal)
                    .slideY(begin: 0.1, end: 0.0),
                const SizedBox(height: AppSpacing.l),
                _buildFrequencySection()
                    .animate()
                    .fadeIn(delay: AppMotion.slow, duration: AppMotion.normal)
                    .slideY(begin: 0.1, end: 0.0),
                const SizedBox(height: AppSpacing.l),
                _buildTestNotificationSection()
                    .animate()
                    .fadeIn(delay: AppMotion.slower, duration: AppMotion.normal)
                    .slideY(begin: 0.1, end: 0.0),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationTypesSection(SettingsProvider settingsProvider) {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Types',
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            _buildNotificationSwitch(
              'Order Notifications',
              'New orders, status updates, and order-related alerts',
              settingsProvider.orderNotifications,
              (value) => settingsProvider.toggleOrderNotifications(value),
              AppIcons.orders,
            ),
            _buildNotificationSwitch(
              'Staff Notifications',
              'Staff activity, schedule changes, and performance updates',
              settingsProvider.staffNotifications,
              (value) => settingsProvider.toggleStaffNotifications(value),
              AppIcons.staff,
            ),
            _buildNotificationSwitch(
              'Payment Notifications',
              'Payment confirmations, billing alerts, and subscription updates',
              settingsProvider.paymentNotifications,
              (value) => settingsProvider.togglePaymentNotifications(value),
              AppIcons.payment,
            ),
            _buildNotificationSwitch(
              'System Notifications',
              'App updates, maintenance alerts, and system status',
              settingsProvider.systemNotifications,
              (value) => settingsProvider.toggleSystemNotifications(value),
              AppIcons.settings,
            ),
            _buildNotificationSwitch(
              'Marketing Notifications',
              'Promotional offers, tips, and business insights',
              settingsProvider.marketingNotifications,
              (value) => settingsProvider.toggleMarketingNotifications(value),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.s),
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

  Widget _buildDeliveryMethodsSection() {
    final colorScheme = Theme.of(context).colorScheme;
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Delivery Methods',
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            _buildDeliveryMethodSwitch(
              'Push Notifications',
              'Receive notifications on your device',
              settingsProvider.pushNotifications,
              (value) => settingsProvider.togglePushNotifications(value),
              Icons.notifications,
            ),
            _buildDeliveryMethodSwitch(
              'Email Notifications',
              'Receive notifications via email',
              settingsProvider.emailNotifications,
              (value) => settingsProvider.toggleEmailNotifications(value),
              AppIcons.email,
            ),
            _buildDeliveryMethodSwitch(
              'SMS Notifications',
              'Receive notifications via text message',
              settingsProvider.smsNotifications,
              (value) => settingsProvider.toggleSmsNotifications(value),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: AppSpacing.s),
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

  Widget _buildTimingSection() {
    final colorScheme = Theme.of(context).colorScheme;
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quiet Hours',
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Enable Quiet Hours',
                        style: AppTypography.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'No notifications during specified hours',
                        style: AppTypography.textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: settingsProvider.quietHoursEnabled,
                  onChanged: (value) => settingsProvider.toggleQuietHours(value),
                  activeColor: AppColors.primary,
                ),
              ],
            ),
            if (settingsProvider.quietHoursEnabled) ...[
              const SizedBox(height: AppSpacing.m),
              Row(
                children: [
                  Expanded(
                    child: _buildTimePicker(
                      'Start Time',
                      '${settingsProvider.quietHoursStart.hour.toString().padLeft(2, '0')}:${settingsProvider.quietHoursStart.minute.toString().padLeft(2, '0')}',
                      (time) {
                        final parts = time.split(':');
                        final timeOfDay = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
                        settingsProvider.updateQuietHours(
                          enabled: settingsProvider.quietHoursEnabled,
                          start: timeOfDay,
                          end: settingsProvider.quietHoursEnd,
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: _buildTimePicker(
                      'End Time',
                      '${settingsProvider.quietHoursEnd.hour.toString().padLeft(2, '0')}:${settingsProvider.quietHoursEnd.minute.toString().padLeft(2, '0')}',
                      (time) {
                        final parts = time.split(':');
                        final timeOfDay = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
                        settingsProvider.updateQuietHours(
                          enabled: settingsProvider.quietHoursEnabled,
                          start: settingsProvider.quietHoursStart,
                          end: timeOfDay,
                        );
                      },
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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          onTap: () => _selectTime(time, onChanged),
          child: Container(
            padding: SpacingUtils.symmetric(
              horizontal: AppSpacing.s,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.outline),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  time,
                  style: AppTypography.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurface,
                  ),
                ),
                Icon(
                  AppIcons.time,
                  size: 20,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFrequencySection() {
    final colorScheme = Theme.of(context).colorScheme;
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Notification Frequency',
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            _buildFrequencyDropdown(
              'Order Updates',
              settingsProvider.orderUpdateFrequency,
              ['immediate', 'hourly', 'daily'],
              (value) => settingsProvider.updateOrderUpdateFrequency(value!),
            ),
            const SizedBox(height: AppSpacing.m),
            _buildFrequencyDropdown(
              'Reports',
              settingsProvider.reportFrequency,
              ['immediate', 'daily', 'weekly', 'monthly'],
              (value) => settingsProvider.updateReportFrequency(value!),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
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
                    _formatFrequencyOption(option),
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

  Widget _buildTestNotificationSection() {
    final colorScheme = Theme.of(context).colorScheme;

    return CardsX.elevated(
      child: Padding(
        padding: SpacingUtils.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Test Notifications',
              style: AppTypography.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Send test notifications to verify your settings are working correctly.',
              style: AppTypography.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              children: [
                Expanded(
                  child: AnimatedButtons.primary(
                    onPressed: _sendTestNotification,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.send, color: AppColors.onPrimary),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Send Test',
                          style: AppTypography.textTheme.labelMedium?.copyWith(
                            color: AppColors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: AnimatedButtons.secondary(
                    onPressed: _saveSettings,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(AppIcons.save, color: AppColors.primary),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'Save Settings',
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

  void _sendTestNotification() async {
    try {
      final success = await SettingsMockService.testNotification();

      if (success) {
        SnackXUtils.showSuccess(
          context,
          message: 'Test notification sent! Check your device.',
        );
      } else {
        SnackXUtils.showError(
          context,
          message: 'Failed to send test notification.',
        );
      }
    } catch (e) {
      SnackXUtils.showError(
        context,
        message: 'An error occurred while sending test notification.',
      );
    }
  }

  void _saveSettings() async {
    final settingsProvider = Provider.of<SettingsProvider>(
      context,
      listen: false,
    );

    try {
      // Export current settings
      await settingsProvider.exportSettings();

      // Save to mock service (mock success)
      final success = true;

      if (success) {
        SnackXUtils.showSuccess(
          context,
          message: 'Notification settings saved successfully!',
        );
      } else {
        SnackXUtils.showError(
          context,
          message: 'Failed to save settings. Please try again.',
        );
      }
    } catch (e) {
      SnackXUtils.showError(
        context,
        message: 'An error occurred while saving settings.',
      );
    }
  }
}
