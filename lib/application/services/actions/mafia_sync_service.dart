import '../../../domain/models/players/player_action.dart';

/// Builds sync payloads for Mafia team voting.
class MafiaSyncService {
  /// Creates a mafia sync update message from current actions.
  Map<String, dynamic> buildSyncPayload(List<PlayerAction> actions) {
    final mafiaActions = actions
        .where((action) => action.type == 'mafia_kill')
        .map((action) => action.toJson())
        .toList();

    return {
      'type': 'mafia_sync_update',
      'actions': mafiaActions,
    };
  }
}
