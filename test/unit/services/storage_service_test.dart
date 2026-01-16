import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/infrastructure/services/storage/storage_service.dart';

void main() {
  group('StorageService', () {
    late StorageService storage;
    late Directory tempDir;

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('hive_test');
      storage = StorageService();
      await storage.init(tempDir.path);
    });

    tearDown(() async {
      await storage.dispose();
      await tempDir.delete(recursive: true);
    });

    test('can save and retrieve settings', () async {
      await storage.saveSetting('themeId', 'test_theme');
      final themeId = storage.getSetting('themeId');
      expect(themeId, equals('test_theme'));
    });

    test('returns null for non-existent setting', () {
      final value = storage.getSetting('non_existent');
      expect(value, isNull);
    });
  });
}
