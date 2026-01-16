import '../../../domain/models/players/player.dart';

/// Result of toggling ready-to-vote state.
class VotingReadyResult {
  final List<Player> players;
  final bool allReady;

  const VotingReadyResult({
    required this.players,
    required this.allReady,
  });
}

/// Result of applying a vote.
class VoteUpdateResult {
  final List<Player> players;
  final Map<String, String> votes;

  const VoteUpdateResult({
    required this.players,
    required this.votes,
  });
}

/// Result of applying a verdict.
class VerdictUpdateResult {
  final List<Player> players;
  final Map<String, bool> verdicts;

  const VerdictUpdateResult({
    required this.players,
    required this.verdicts,
  });
}

/// Handles ready-to-vote toggles and vote/verdict updates.
class VotingService {
  VotingReadyResult toggleReady({
    required List<Player> players,
    required String senderId,
  }) {
    final updatedPlayers = List<Player>.from(players);
    final index = updatedPlayers.indexWhere((p) => p.id == senderId);
    if (index == -1) {
      return VotingReadyResult(
        players: updatedPlayers,
        allReady: false,
      );
    }

    final current = updatedPlayers[index];
    updatedPlayers[index] = current.copyWith(
      isReadyToVote: !current.isReadyToVote,
    );

    final livingPlayers = updatedPlayers.where((p) => p.isAlive).toList();
    final readyPlayers =
        livingPlayers.where((p) => p.isReadyToVote).toList();

    return VotingReadyResult(
      players: updatedPlayers,
      allReady: livingPlayers.length == readyPlayers.length,
    );
  }

  VoteUpdateResult applyVote({
    required List<Player> players,
    required Map<String, String> currentVotes,
    required String senderId,
    required String? targetId,
  }) {
    final updatedVotes = Map<String, String>.from(currentVotes);
    if (targetId != null) {
      updatedVotes[senderId] = targetId;
    } else {
      updatedVotes.remove(senderId);
    }

    final updatedPlayers = List<Player>.from(players);
    final index = updatedPlayers.indexWhere((p) => p.id == senderId);
    if (index != -1) {
      updatedPlayers[index] = updatedPlayers[index].copyWith(hasActed: true);
    }

    return VoteUpdateResult(
      players: updatedPlayers,
      votes: updatedVotes,
    );
  }

  VerdictUpdateResult applyVerdict({
    required List<Player> players,
    required Map<String, bool> currentVerdicts,
    required String senderId,
    required bool decision,
  }) {
    final updatedVerdicts = Map<String, bool>.from(currentVerdicts);
    updatedVerdicts[senderId] = decision;

    final updatedPlayers = List<Player>.from(players);
    final index = updatedPlayers.indexWhere((p) => p.id == senderId);
    if (index != -1) {
      updatedPlayers[index] = updatedPlayers[index].copyWith(hasActed: true);
    }

    return VerdictUpdateResult(
      players: updatedPlayers,
      verdicts: updatedVerdicts,
    );
  }
}
