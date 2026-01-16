import 'package:freezed_annotation/freezed_annotation.dart';
import 'game_phase.dart';
import '../players/player.dart';
import 'game_config.dart';
import '../players/player_action.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

/// Complete snapshot of the game state
@freezed
abstract class GameState with _$GameState {
  const factory GameState({
    @GamePhaseConverter() required GamePhase phase,
    @Default(0) int currentMoveIndex,
    String? currentMoveId,
    required List<Player> players,
    required GameConfig config,
    @Default(false) bool isPaused,
    int? timerSecondsRemaining,
    int? currentNightNumber,
    int? currentDayNumber,
    Map<String, String>? currentVotes,  // performerId -> targetId
    Map<String, bool>? currentVerdicts, // performerId -> isExecute (true=execute, false=pardon)
    String? verdictTargetId,
    @Default([]) List<String> defenseQueue,
    String? speakerId,
    String? lastDoctorTargetId,
    @Default([]) List<PlayerAction> pendingActions,
    @Default([]) List<String> publicEventLog,
    @Default([]) List<String> detailedLog,
    String? sessionId,
    String? statusMessage,
  }) = _GameState;
  
  factory GameState.fromJson(Map<String, dynamic> json) => 
      _$GameStateFromJson(json);
}
