import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/application/services/voting/vote_counter.dart';

void main() {
  test('tally returns empty results when there are no votes', () {
    // Arrange
    const counter = VoteCounter();
    final votes = <String, String>{};

    // Act
    final result = counter.tally(votes, livingPlayersCount: 4);

    // Assert
    expect(result.voteCounts, isEmpty);
    expect(result.maxVotes, 0);
    expect(result.topTargetIds, isEmpty);
    expect(result.totalVotes, 0);
    expect(result.remainingVotes, 4);
  });

  test('tally aggregates vote counts and top accused', () {
    // Arrange
    const counter = VoteCounter();
    final votes = <String, String>{
      'voter1': 'p1',
      'voter2': 'p1',
      'voter3': 'p2',
    };

    // Act
    final result = counter.tally(votes, livingPlayersCount: 5);

    // Assert
    expect(result.voteCounts['p1'], 2);
    expect(result.voteCounts['p2'], 1);
    expect(result.maxVotes, 2);
    expect(result.topTargetIds, {'p1'});
    expect(result.totalVotes, 3);
    expect(result.remainingVotes, 2);
  });

  test('tally returns all tied targets as top accused', () {
    // Arrange
    const counter = VoteCounter();
    final votes = <String, String>{
      'voter1': 'p1',
      'voter2': 'p2',
    };

    // Act
    final result = counter.tally(votes, livingPlayersCount: 2);

    // Assert
    expect(result.maxVotes, 1);
    expect(result.topTargetIds, {'p1', 'p2'});
  });
}
