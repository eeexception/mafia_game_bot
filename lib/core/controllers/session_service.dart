import 'dart:math';
import '../models/game_state.dart';
import '../models/game_phase.dart';
import '../models/player.dart';
import '../models/role.dart';

/// Result of handling a player join request.
class SessionJoinResult {
  final bool rejected;
  final String? errorMessage;
  final Player? newPlayer;
  final String? sessionToken;
  final List<Player> updatedPlayers;

  const SessionJoinResult({
    required this.rejected,
    required this.errorMessage,
    required this.newPlayer,
    required this.sessionToken,
    required this.updatedPlayers,
  });
}

/// Handles session id generation and join validation.
class SessionService {
  String generateSessionId() {
    final rand = Random();
    return List.generate(6, (_) => rand.nextInt(10).toString()).join();
  }

  String generateSessionToken() {
    return 'token-${Random().nextInt(10000)}';
  }

  SessionJoinResult handleJoin({
    required GameState state,
    required String senderId,
    required String nickname,
    required String? providedSessionId,
  }) {
    if (state.phase != GamePhase.lobby) {
      return const SessionJoinResult(
        rejected: true,
        errorMessage: 'Game already in progress',
        newPlayer: null,
        sessionToken: null,
        updatedPlayers: [],
      );
    }

    if (providedSessionId != null && providedSessionId != state.sessionId) {
      return const SessionJoinResult(
        rejected: true,
        errorMessage: 'Wrong game session',
        newPlayer: null,
        sessionToken: null,
        updatedPlayers: [],
      );
    }

    final newPlayer = Player(
      id: senderId,
      number: state.players.length + 1,
      nickname: nickname,
      role: const CivilianRole(),
    );
    final token = generateSessionToken();

    return SessionJoinResult(
      rejected: false,
      errorMessage: null,
      newPlayer: newPlayer,
      sessionToken: token,
      updatedPlayers: [...state.players, newPlayer],
    );
  }
}
