import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/application/services/session/heartbeat_monitor.dart';
import 'package:mafia_game/domain/models/players/player.dart';
import 'package:mafia_game/domain/models/roles/role.dart';

void main() {
  test('marks players disconnected when heartbeat exceeds timeout', () {
    // Arrange
    final monitor = HeartbeatMonitor();
    final now = DateTime(2024, 1, 1, 12, 0, 0);
    final players = [
      _player(
        id: 'p1',
        isConnected: true,
        lastHeartbeat: now.subtract(const Duration(seconds: 25)),
      ),
      _player(
        id: 'p2',
        isConnected: true,
        lastHeartbeat: now.subtract(const Duration(seconds: 5)),
      ),
      _player(
        id: 'p3',
        isConnected: true,
        lastHeartbeat: null,
      ),
    ];

    // Act
    final result = monitor.updatePlayers(
      players: players,
      now: now,
      timeout: const Duration(seconds: 20),
    );

    // Assert
    expect(result.timedOutPlayers.length, 1);
    expect(result.timedOutPlayers.first.id, 'p1');
    expect(result.players.firstWhere((p) => p.id == 'p1').isConnected, false);
    expect(result.players.firstWhere((p) => p.id == 'p2').isConnected, true);
    expect(result.players.firstWhere((p) => p.id == 'p3').isConnected, true);
  });
}

Player _player({
  required String id,
  required bool isConnected,
  required DateTime? lastHeartbeat,
}) {
  return Player(
    id: id,
    number: 1,
    nickname: id,
    role: const CivilianRole(),
    isConnected: isConnected,
    lastHeartbeat: lastHeartbeat,
  );
}
