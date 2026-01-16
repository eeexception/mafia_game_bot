import 'package:hive_flutter/hive_flutter.dart';

class StorageService {
  late Box _settingsBox;
  late Box _statsBox;
  
  /// Initialize storage
  Future<void> init([String? path]) async {
    if (path != null) {
      Hive.init(path);
    } else {
      await Hive.initFlutter();
    }
    _settingsBox = await Hive.openBox('settings');
    _statsBox = await Hive.openBox('statistics');
  }
  
  /// Save a setting value
  Future<void> saveSetting(String key, dynamic value) async {
    await _settingsBox.put(key, value);
  }
  
  /// Get a setting value
  dynamic getSetting(String key) {
    return _settingsBox.get(key);
  }

  /// Increment a statistic
  Future<void> incrementStat(String key, [int amount = 1]) async {
    final current = _statsBox.get(key, defaultValue: 0) as int;
    await _statsBox.put(key, current + amount);
  }

  /// Get a statistic value
  dynamic getStat(String key, {dynamic defaultValue}) {
    return _statsBox.get(key, defaultValue: defaultValue);
  }
  
  /// Clear all settings and stats
  Future<void> clear() async {
    await _settingsBox.clear();
    await _statsBox.clear();
  }
  
  /// Dispose resources
  Future<void> dispose() async {
    await Hive.close();
  }
}
