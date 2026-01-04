import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/core/models/game_state.dart';
import 'package:mafia_game/core/models/game_phase.dart';
import 'package:mafia_game/core/models/game_config.dart';
import 'package:mafia_game/core/models/player.dart';
import 'package:mafia_game/core/models/role.dart';

void main() {
  group('GameState', () {
    const config = GameConfig(themeId: 'classic_chicago');
    final player = Player(
      id: 'uuid-1',
      number: 1,
      nickname: 'Alice',
      role: const CivilianRole(),
    );

    test('Initial state creation', () {
      final state = GameState(
        phase: GamePhase.lobby,
        players: [player],
        config: config,
      );

      expect(state.phase, equals(GamePhase.lobby));
      expect(state.players.length, equals(1));
      expect(state.isPaused, isFalse);
      expect(state.publicEventLog, isEmpty);
    });

    test('Immutability and copyWith', () {
      final state = GameState(
        phase: GamePhase.lobby,
        players: [player],
        config: config,
      );

      final nextState = state.copyWith(phase: GamePhase.setup);
      
      expect(state.phase, equals(GamePhase.lobby));
      expect(nextState.phase, equals(GamePhase.setup));
    });

    test('Json serialization', () {
      final state = GameState(
        phase: GamePhase.lobby,
        players: [player],
        config: config,
      );

      final json = state.toJson();
      expect(json['phase'], equals('lobby'));
      expect(json['players'], isA<List>());
      expect((json['players'] as List).length, equals(1));
    });
  });
}
