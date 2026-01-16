import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/application/services/actions/action_buffer_service.dart';
import 'package:mafia_game/domain/models/players/player.dart';
import 'package:mafia_game/domain/models/players/player_action.dart';
import 'package:mafia_game/domain/models/roles/role.dart';

void main() {
  test('buffers action and replaces previous action for same performer', () {
    // Arrange
    final service = ActionBufferService();
    final players = [_player('p1'), _player('p2')];
    final actions = [
      const PlayerAction(
        type: 'doctor_heal',
        performerId: 'p1',
        targetId: 'p2',
      ),
    ];
    const newAction = PlayerAction(
      type: 'doctor_heal',
      performerId: 'p1',
      targetId: 'p1',
    );

    // Act
    final result = service.bufferAction(
      players: players,
      pendingActions: actions,
      action: newAction,
    );

    // Assert
    expect(result.pendingActions.length, 1);
    expect(result.pendingActions.first.targetId, 'p1');
    expect(
      result.players.firstWhere((p) => p.id == 'p1').hasActed,
      true,
    );
  });
}

Player _player(String id) {
  return Player(
    id: id,
    number: 1,
    nickname: id,
    role: const CivilianRole(),
  );
}
