import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/application/services/actions/mafia_sync_service.dart';
import 'package:mafia_game/domain/models/players/player_action.dart';

void main() {
  test('builds sync message for mafia kill actions', () {
    // Arrange
    final service = MafiaSyncService();
    final actions = [
      const PlayerAction(
        type: 'mafia_kill',
        performerId: 'm1',
        targetId: 'p2',
      ),
      const PlayerAction(
        type: 'mafia_kill',
        performerId: 'm2',
        targetId: 'p2',
      ),
      const PlayerAction(
        type: 'doctor_heal',
        performerId: 'd1',
        targetId: 'p2',
      ),
    ];

    // Act
    final payload = service.buildSyncPayload(actions);

    // Assert
    expect(payload['type'], 'mafia_sync_update');
    final syncActions = payload['actions'] as List;
    expect(syncActions.length, 2);
  });
}
