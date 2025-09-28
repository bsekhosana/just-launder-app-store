import 'dart:async';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Connectivity provider for managing internet connection state
class ConnectivityProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  bool _isConnected = true;
  bool _wasDisconnected = false;
  bool _showReconnectionMessage = false;

  // Getters
  bool get isConnected => _isConnected;
  bool get wasDisconnected => _wasDisconnected;
  bool get showReconnectionMessage => _showReconnectionMessage;

  /// Initialize connectivity monitoring
  void initialize() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
  }

  /// Update connection status
  void _updateConnectionStatus(List<ConnectivityResult> results) {
    final wasConnected = _isConnected;
    _isConnected = results.any(
      (result) =>
          result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi ||
          result == ConnectivityResult.ethernet,
    );

    if (!wasConnected && _isConnected) {
      // Just reconnected
      _wasDisconnected = false;
      _showReconnectionMessage = true;

      // Hide reconnection message after 3 seconds
      Timer(const Duration(seconds: 3), () {
        _showReconnectionMessage = false;
        notifyListeners();
      });
    } else if (wasConnected && !_isConnected) {
      // Just disconnected
      _wasDisconnected = true;
    }

    notifyListeners();
  }

  /// Check current connectivity
  Future<void> checkConnectivity() async {
    final results = await _connectivity.checkConnectivity();
    _updateConnectionStatus(results);
  }

  /// Dispose resources
  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    super.dispose();
  }
}
