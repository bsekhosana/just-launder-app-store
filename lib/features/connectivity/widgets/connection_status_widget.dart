import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/connectivity_provider.dart';
import '../../../design_system/color_schemes.dart';
import '../../../design_system/typography.dart';

/// Widget to display connection status
class ConnectionStatusWidget extends StatelessWidget {
  const ConnectionStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivity, child) {
        if (connectivity.isConnected) {
          if (connectivity.showReconnectionMessage) {
            return _buildReconnectionMessage();
          }
          return const SizedBox.shrink();
        } else {
          return _buildNoConnectionMessage();
        }
      },
    );
  }

  Widget _buildNoConnectionMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: AppColorSchemes.error,
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'No internet connection. Please check your network settings.',
              style: AppTypography.bodyMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReconnectionMessage() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: AppColorSchemes.success,
      child: Row(
        children: [
          const Icon(Icons.wifi, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Internet connection restored. Syncing latest data...',
              style: AppTypography.bodyMedium.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
