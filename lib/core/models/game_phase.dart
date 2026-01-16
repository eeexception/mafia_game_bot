import 'package:freezed_annotation/freezed_annotation.dart';
import 'game_move.dart';

/// Base class for all possible game phases in the state machine.
abstract class GamePhase {
  const GamePhase();

  /// Unique identifier for the phase (used for serialization/logic)
  String get id;

  /// Human-readable name or localization key
  String get nameKey;

  static const lobby = LobbyPhase();
  static const setup = SetupPhase();
  static const roleReveal = RoleRevealPhase();
  static const night = NightGamePhase(moves: []);
  static const day = DayGamePhase(moves: []);
  static const gameOver = GameOverPhase();
}

class GamePhaseConverter implements JsonConverter<GamePhase, String> {
  const GamePhaseConverter();

  @override
  GamePhase fromJson(String json) {
    switch (json) {
      case 'lobby': return const LobbyPhase();
      case 'setup': return const SetupPhase();
      case 'roleReveal': return const RoleRevealPhase();
      case 'night': return const NightGamePhase(moves: []);
      case 'day': return const DayGamePhase(moves: []);
      case 'gameOver': return const GameOverPhase();
      default: return const LobbyPhase();
    }
  }

  @override
  String toJson(GamePhase object) => object.id;
}

/// Waiting for players to connect
class LobbyPhase extends GamePhase {
  const LobbyPhase();
  @override
  String get id => 'lobby';
  @override
  String get nameKey => 'phaseLobby';
}

/// Role distribution and game setup
class SetupPhase extends GamePhase {
  const SetupPhase();
  @override
  String get id => 'setup';
  @override
  String get nameKey => 'phaseSetup';
}

/// Period for players to view their assigned roles
class RoleRevealPhase extends GamePhase {
  const RoleRevealPhase();
  @override
  String get id => 'roleReveal';
  @override
  String get nameKey => 'phaseRoleReveal';
}

/// Combined Night phase containing multiple moves
class NightGamePhase extends GamePhase {
  final List<GameMove> moves;
  
  const NightGamePhase({required this.moves});
  
  @override
  String get id => 'night';
  
  @override
  String get nameKey => 'phaseNight'; // General "Night" label if needed
}

/// Combined Day phase containing multiple moves
class DayGamePhase extends GamePhase {
  final List<GameMove> moves;
  
  const DayGamePhase({required this.moves});
  
  @override
  String get id => 'day';
  
  @override
  String get nameKey => 'phaseDay'; // General "Day" label if needed
}

/// Game ended (victory or manual stop)
class GameOverPhase extends GamePhase {
  const GameOverPhase();
  @override
  String get id => 'gameOver';
  @override
  String get nameKey => 'phaseGameOver';
}
