import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/core/models/game_phase.dart';

void main() {
  group('GamePhase', () {
    test('contains all required phases', () {
      expect(GamePhase.values.length, equals(13));
      expect(GamePhase.lobby, isNotNull);
      expect(GamePhase.setup, isNotNull);
      expect(GamePhase.nightMafia, isNotNull);
      expect(GamePhase.nightProstitute, isNotNull);
      expect(GamePhase.nightManiac, isNotNull);
      expect(GamePhase.nightDoctor, isNotNull);
      expect(GamePhase.nightCommissar, isNotNull);
      expect(GamePhase.morning, isNotNull);
      expect(GamePhase.dayDiscussion, isNotNull);
      expect(GamePhase.dayVoting, isNotNull);
      expect(GamePhase.dayDefense, isNotNull);
      expect(GamePhase.dayVerdict, isNotNull);
      expect(GamePhase.gameOver, isNotNull);
    });
  });
}
