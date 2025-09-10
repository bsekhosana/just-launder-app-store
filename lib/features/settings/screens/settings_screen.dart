import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/providers/auth_provider.dart';
import '../../profile/providers/laundrette_profile_provider.dart';
import '../../../data/models/subscription.dart';
import 'subscription_management_screen.dart';
import 'notification_settings_screen.dart';
import 'system_preferences_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Consumer2<LaundretteProfileProvider, AuthProvider>(
        builder: (context, profileProvider, authProvider, child) {
          final profile = profileProvider.currentProfile;
          final subscription = profileProvider.currentSubscription;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Profile Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Business Profile',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (profile != null) ...[
                        _buildInfoRow('Business Name', profile.businessName),
                        _buildInfoRow('Type', profile.type.name.toUpperCase()),
                        _buildInfoRow('Email', profile.email ?? 'Not set'),
                        _buildInfoRow(
                          'Phone',
                          profile.phoneNumber ?? 'Not set',
                        ),
                        _buildInfoRow('Address', profile.fullAddress),
                        _buildInfoRow(
                          'Status',
                          profile.isActive ? 'Active' : 'Inactive',
                        ),
                        _buildInfoRow(
                          'Verified',
                          profile.isVerified ? 'Yes' : 'No',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Subscription Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Subscription',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (subscription != null) ...[
                        _buildInfoRow('Plan', subscription.name),
                        _buildInfoRow(
                          'Type',
                          subscription.type.name.toUpperCase(),
                        ),
                        _buildInfoRow(
                          'Tier',
                          subscription.currentTier.toUpperCase(),
                        ),
                        _buildInfoRow(
                          'Price',
                          '\$${subscription.monthlyPrice.toStringAsFixed(2)}/month',
                        ),
                        _buildInfoRow(
                          'Status',
                          subscription.isActive ? 'Active' : 'Inactive',
                        ),
                        _buildInfoRow(
                          'Expires',
                          _formatDate(subscription.endDate),
                        ),
                        if (subscription.isExpiringSoon) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppTheme.warningOrange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppTheme.warningOrange),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.warning,
                                  color: AppTheme.warningOrange,
                                  size: 16,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Subscription expires soon',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.warningOrange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Features Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Features',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (subscription != null) ...[
                        _buildFeatureRow(
                          'Max Branches',
                          subscription
                              .getFeature(SubscriptionFeatures.maxBranches)
                              .toString(),
                        ),
                        _buildFeatureRow(
                          'Max Staff',
                          subscription
                              .getFeature(SubscriptionFeatures.maxStaff)
                              .toString(),
                        ),
                        _buildFeatureRow(
                          'Advanced Analytics',
                          subscription.hasFeature(
                                SubscriptionFeatures.advancedAnalytics,
                              )
                              ? 'Yes'
                              : 'No',
                        ),
                        _buildFeatureRow(
                          'Priority Support',
                          subscription.hasFeature(
                                SubscriptionFeatures.prioritySupport,
                              )
                              ? 'Yes'
                              : 'No',
                        ),
                        _buildFeatureRow(
                          'Custom Branding',
                          subscription.hasFeature(
                                SubscriptionFeatures.customBranding,
                              )
                              ? 'Yes'
                              : 'No',
                        ),
                        _buildFeatureRow(
                          'API Access',
                          subscription.hasFeature(
                                SubscriptionFeatures.apiAccess,
                              )
                              ? 'Yes'
                              : 'No',
                        ),
                        _buildFeatureRow(
                          'Driver Management',
                          subscription.hasFeature(
                                SubscriptionFeatures.driverManagement,
                              )
                              ? 'Yes'
                              : 'No',
                        ),
                        _buildFeatureRow(
                          'Auto Accept Orders',
                          subscription.hasFeature(
                                SubscriptionFeatures.orderAutoAccept,
                              )
                              ? 'Yes'
                              : 'No',
                        ),
                        _buildFeatureRow(
                          'Priority Delivery',
                          subscription.hasFeature(
                                SubscriptionFeatures.priorityDelivery,
                              )
                              ? 'Yes'
                              : 'No',
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Settings Options Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings & Configuration',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.subscriptions),
                        title: const Text('Subscription Management'),
                        subtitle: const Text(
                          'Manage your subscription plan and billing',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const SubscriptionManagementScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.notifications),
                        title: const Text('Notification Settings'),
                        subtitle: const Text(
                          'Configure notifications and alerts',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      const NotificationSettingsScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.settings),
                        title: const Text('System Preferences'),
                        subtitle: const Text(
                          'App settings and system configuration',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder:
                                  (context) => const SystemPreferencesScreen(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Actions Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Account Actions',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        leading: const Icon(Icons.edit),
                        title: const Text('Edit Profile'),
                        onTap: () {
                          // TODO: Implement edit profile
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Edit profile functionality coming soon',
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.help),
                        title: const Text('Help & Support'),
                        onTap: () {
                          // TODO: Implement help & support
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Help & support functionality coming soon',
                              ),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.logout,
                          color: AppTheme.errorRed,
                        ),
                        title: const Text(
                          'Logout',
                          style: TextStyle(color: AppTheme.errorRed),
                        ),
                        onTap: () async {
                          final authProvider = Provider.of<AuthProvider>(
                            context,
                            listen: false,
                          );
                          await authProvider.logout();
                        },
                      ),
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

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppTheme.mediumGrey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: AppTheme.darkGrey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String feature, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(feature, style: const TextStyle(color: AppTheme.darkGrey)),
          Text(
            value,
            style: TextStyle(
              color:
                  value == 'Yes'
                      ? AppTheme.successGreen
                      : value == 'No'
                      ? AppTheme.errorRed
                      : AppTheme.mediumGrey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
