import 'package:freezed_annotation/freezed_annotation.dart';
import 'game_phase.dart';
import 'player.dart';
import 'game_config.dart';
import 'player_action.dart';

part 'game_state.freezed.dart';
part 'game_state.g.dart';

/// Complete snapshot of the game state
@freezed
abstract class GameState with _$GameState {
  const factory GameState({
    required GamePhase phase,
    required List<Player> players,
    required GameConfig config,
    @Default(false) bool isPaused,
    int? timerSecondsRemaining,
    int? currentNightNumber,
    int? currentDayNumber,
    Map<String, String>? currentVotes,  // performerId -> targetId
    @Default([]) List<PlayerAction> pendingActions,
    @Default([]) List<String> publicEventLog,
    @Default([]) List<String> detailedLog,
  }) = _GameState;
  
  factory GameState.fromJson(Map<String, dynamic> json) => 
      _$GameStateFromJson(json);
}
