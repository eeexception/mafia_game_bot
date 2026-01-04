import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/core/models/game_config.dart';

void main() {
  group('GameConfig', () {
    test('Default values are correct', () {
      const config = GameConfig(themeId: 'classic_chicago');
      
      expect(config.themeId, equals('classic_chicago'));
      expect(config.mafiaBlindMode, isTrue);
      expect(config.donMechanicsEnabled, isFalse);
      expect(config.prostituteEnabled, isTrue);
      expect(config.maniacEnabled, isTrue);
      expect(config.discussionTime, equals(120));
      expect(config.votingTime, equals(60));
      expect(config.defenseTime, equals(60));
      expect(config.mafiaActionTime, equals(90));
      expect(config.otherActionTime, equals(60));
    });

    test('Json serialization', () {
      const config = GameConfig(
        themeId: 'test_theme',
        discussionTime: 150,
      );

      final json = config.toJson();
      expect(json['themeId'], equals('test_theme'));
      expect(json['discussionTime'], equals(150));
    });
  });
}
