import '../../../domain/models/players/player.dart';
import '../../../domain/models/players/player_action.dart';

/// Result of buffering a player action.
class ActionBufferResult {
  /// Updated pending actions.
  final List<PlayerAction> pendingActions;

  /// Updated players list with hasActed applied.
  final List<Player> players;

  /// Creates an action buffer result.
  const ActionBufferResult({
    required this.pendingActions,
    required this.players,
  });
}

/// Handles pending action buffering for night actions.
class ActionBufferService {
  /// Adds or replaces the player's pending action and marks them as acted.
  ActionBufferResult bufferAction({
    required List<Player> players,
    required List<PlayerAction> pendingActions,
    required PlayerAction action,
  }) {
    final updatedActions = List<PlayerAction>.from(pendingActions);
    updatedActions.removeWhere((a) => a.performerId == action.performerId);
    updatedActions.add(action);

    final updatedPlayers = List<Player>.from(players);
    final index = updatedPlayers.indexWhere((p) => p.id == action.performerId);
    if (index != -1) {
      updatedPlayers[index] = updatedPlayers[index].copyWith(hasActed: true);
    }

    return ActionBufferResult(
      pendingActions: updatedActions,
      players: updatedPlayers,
    );
  }
}
