import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/core/controllers/session_service.dart';
import 'package:mafia_game/core/models/game_phase.dart';
import 'package:mafia_game/core/models/game_state.dart';
import 'package:mafia_game/core/models/game_config.dart';

void main() {
  test('generates 6-digit numeric session id', () {
    // Arrange
    final service = SessionService();

    // Act
    final id = service.generateSessionId();

    // Assert
    expect(id.length, 6);
    expect(int.tryParse(id), isNotNull);
  });

  test('rejects join when not in lobby', () {
    // Arrange
    final service = SessionService();
    final state = GameState(
      phase: GamePhase.day,
      players: [],
      config: const GameConfig(themeId: 'default'),
      sessionId: 'abc',
    );

    // Act
    final result = service.handleJoin(
      state: state,
      senderId: 'p1',
      nickname: 'P1',
      providedSessionId: 'abc',
    );

    // Assert
    expect(result.rejected, true);
    expect(result.errorMessage, 'Game already in progress');
  });
}
