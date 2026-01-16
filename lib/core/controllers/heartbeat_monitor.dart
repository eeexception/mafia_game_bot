import '../models/player.dart';

/// Result of a heartbeat sweep across connected players.
class HeartbeatUpdate {
  /// Updated list of players after applying timeout checks.
  final List<Player> players;

  /// Players that timed out during this sweep.
  final List<Player> timedOutPlayers;

  /// Creates a heartbeat update snapshot.
  const HeartbeatUpdate({
    required this.players,
    required this.timedOutPlayers,
  });
}

/// Evaluates player heartbeats and marks timed out connections.
class HeartbeatMonitor {
  /// Updates player connectivity based on last heartbeat timestamps.
  HeartbeatUpdate updatePlayers({
    required List<Player> players,
    required DateTime now,
    required Duration timeout,
  }) {
    final updatedPlayers = <Player>[];
    final timedOutPlayers = <Player>[];

    for (final player in players) {
      final lastHeartbeat = player.lastHeartbeat;
      if (player.isConnected && lastHeartbeat != null) {
        final diff = now.difference(lastHeartbeat);
        if (diff > timeout) {
          final updated = player.copyWith(isConnected: false);
          updatedPlayers.add(updated);
          timedOutPlayers.add(updated);
          continue;
        }
      }
      updatedPlayers.add(player);
    }

    return HeartbeatUpdate(
      players: updatedPlayers,
      timedOutPlayers: timedOutPlayers,
    );
  }
}
