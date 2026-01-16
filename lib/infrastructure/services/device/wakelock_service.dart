import 'package:wakelock_plus/wakelock_plus.dart';
import 'dart:developer' as developer;

class WakeLockService {
  /// Enable wakelock to prevent screen from sleeping
  Future<void> enable() async {
    try {
      await WakelockPlus.enable();
      developer.log('WakeLock enabled', name: 'WakeLockService');
    } catch (e, st) {
      developer.log('Failed to enable WakeLock', error: e, stackTrace: st, name: 'WakeLockService');
    }
  }

  /// Disable wakelock
  Future<void> disable() async {
    try {
      await WakelockPlus.disable();
      developer.log('WakeLock disabled', name: 'WakeLockService');
    } catch (e, st) {
      developer.log('Failed to disable WakeLock', error: e, stackTrace: st, name: 'WakeLockService');
    }
  }

  /// Check if wakelock is enabled
  Future<bool> get isEnabled => WakelockPlus.enabled;
}
