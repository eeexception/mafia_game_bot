import '../models/vote_tally.dart';

/// Calculates aggregated vote information from raw vote maps.
class VoteCounter {
  /// Builds a VoteTally from the current votes and living player count.
  const VoteCounter();

  VoteTally tally(
    Map<String, String>? votes, {
    required int livingPlayersCount,
  }) {
    if (votes == null || votes.isEmpty) {
      return VoteTally(
        voteCounts: const {},
        maxVotes: 0,
        topTargetIds: const {},
        totalVotes: 0,
        remainingVotes: livingPlayersCount,
      );
    }

    final voteCounts = <String, int>{};
    for (final targetId in votes.values) {
      voteCounts[targetId] = (voteCounts[targetId] ?? 0) + 1;
    }

    var maxVotes = 0;
    for (final count in voteCounts.values) {
      if (count > maxVotes) {
        maxVotes = count;
      }
    }

    final topTargetIds = maxVotes > 0
        ? voteCounts.entries
            .where((e) => e.value == maxVotes)
            .map((e) => e.key)
            .toSet()
        : <String>{};

    final totalVotes = votes.length;
    final remainingVotes = livingPlayersCount - totalVotes;

    return VoteTally(
      voteCounts: Map<String, int>.unmodifiable(voteCounts),
      maxVotes: maxVotes,
      topTargetIds: Set<String>.unmodifiable(topTargetIds),
      totalVotes: totalVotes,
      remainingVotes: remainingVotes,
    );
  }
}
