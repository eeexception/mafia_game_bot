import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/core/controllers/voting_service.dart';
import 'package:mafia_game/core/models/player.dart';
import 'package:mafia_game/core/models/role.dart';

void main() {
  test('toggleReady flips ready flag and reports allReady', () {
    // Arrange
    final service = VotingService();
    final players = [
      _player('p1', isReady: false),
      _player('p2', isReady: true),
    ];

    // Act
    final result = service.toggleReady(
      players: players,
      senderId: 'p1',
    );

    // Assert
    expect(result.players.firstWhere((p) => p.id == 'p1').isReadyToVote, true);
    expect(result.allReady, true);
  });

  test('applyVote registers vote and marks sender as acted', () {
    // Arrange
    final service = VotingService();
    final players = [_player('p1'), _player('p2')];

    // Act
    final result = service.applyVote(
      players: players,
      currentVotes: const {},
      senderId: 'p1',
      targetId: 'p2',
    );

    // Assert
    expect(result.votes['p1'], 'p2');
    expect(result.players.firstWhere((p) => p.id == 'p1').hasActed, true);
  });

  test('applyVerdict registers decision and marks sender as acted', () {
    // Arrange
    final service = VotingService();
    final players = [_player('p1'), _player('p2')];

    // Act
    final result = service.applyVerdict(
      players: players,
      currentVerdicts: const {},
      senderId: 'p1',
      decision: true,
    );

    // Assert
    expect(result.verdicts['p1'], true);
    expect(result.players.firstWhere((p) => p.id == 'p1').hasActed, true);
  });
}

Player _player(
  String id, {
  bool isReady = false,
}) {
  return Player(
    id: id,
    number: 1,
    nickname: id,
    role: const CivilianRole(),
    isReadyToVote: isReady,
  );
}
