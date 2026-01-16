/// Aggregated voting information for a single voting round.
class VoteTally {
  final Map<String, int> voteCounts;
  final int maxVotes;
  final Set<String> topTargetIds;
  final int totalVotes;
  final int remainingVotes;

  /// Creates a VoteTally snapshot.
  const VoteTally({
    required this.voteCounts,
    required this.maxVotes,
    required this.topTargetIds,
    required this.totalVotes,
    required this.remainingVotes,
  });

  /// Empty tally with zeroed counters.
  const VoteTally.empty()
      : voteCounts = const {},
        maxVotes = 0,
        topTargetIds = const {},
        totalVotes = 0,
        remainingVotes = 0;
}
