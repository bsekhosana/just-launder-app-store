import 'dart:async';
import 'package:flutter/material.dart';

/// Optimized polling service with smart intervals and lifecycle management
class PollingService {
  Timer? _timer;
  bool _isActive = false;
  Duration _interval;
  final VoidCallback onPoll;
  final VoidCallback? onError;
  
  // Adaptive polling - slower when app is in background
  bool _isInForeground = true;
  Duration _foregroundInterval;
  Duration _backgroundInterval;

  PollingService({
    required this.onPoll,
    this.onError,
    Duration interval = const Duration(seconds: 3),
    Duration? backgroundInterval,
  })  : _interval = interval,
        _foregroundInterval = interval,
        _backgroundInterval = backgroundInterval ?? Duration(seconds: interval.inSeconds * 3);

  /// Start polling
  void start() {
    if (_isActive) return;
    
    _isActive = true;
    _startTimer();
    debugPrint('✅ PollingService: Started with ${_interval.inSeconds}s interval');
  }

  /// Stop polling
  void stop() {
    _isActive = false;
    _timer?.cancel();
    _timer = null;
    debugPrint('✅ PollingService: Stopped');
  }

  /// Pause polling (e.g., when app goes to background)
  void pause() {
    _isInForeground = false;
    _adjustInterval();
    debugPrint('⏸️ PollingService: Paused (slower interval)');
  }

  /// Resume polling (e.g., when app comes to foreground)
  void resume() {
    _isInForeground = true;
    _adjustInterval();
    debugPrint('▶️ PollingService: Resumed (normal interval)');
  }

  /// Adjust interval based on app state
  void _adjustInterval() {
    final newInterval = _isInForeground ? _foregroundInterval : _backgroundInterval;
    
    if (_interval != newInterval) {
      _interval = newInterval;
      if (_isActive) {
        _timer?.cancel();
        _startTimer();
        debugPrint('🔄 PollingService: Interval adjusted to ${_interval.inSeconds}s');
      }
    }
  }

  /// Start the timer
  void _startTimer() {
    _timer = Timer.periodic(_interval, (timer) {
      if (_isActive) {
        try {
          onPoll();
        } catch (e) {
          debugPrint('❌ PollingService: Error during poll: $e');
          onError?.call();
        }
      }
    });
  }

  /// Change polling interval
  void setInterval(Duration interval, {Duration? backgroundInterval}) {
    _foregroundInterval = interval;
    _backgroundInterval = backgroundInterval ?? Duration(seconds: interval.inSeconds * 3);
    _adjustInterval();
  }

  /// Check if service is active
  bool get isActive => _isActive;

  /// Get current interval
  Duration get currentInterval => _interval;

  /// Dispose and cleanup
  void dispose() {
    stop();
  }
}

/// Mixin for widgets that need lifecycle-aware polling
mixin PollingLifecycleMixin<T extends StatefulWidget> on State<T>, WidgetsBindingObserver {
  PollingService? pollingService;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    switch (state) {
      case AppLifecycleState.resumed:
        pollingService?.resume();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        pollingService?.pause();
        break;
      case AppLifecycleState.detached:
        pollingService?.stop();
        break;
      case AppLifecycleState.hidden:
        pollingService?.pause();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    pollingService?.dispose();
    super.dispose();
  }
}

