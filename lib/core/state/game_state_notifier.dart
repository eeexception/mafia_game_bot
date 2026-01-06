import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../models/game_state.dart';
import '../models/game_phase.dart';
import '../models/game_config.dart';

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier() : super(GameState(
    phase: GamePhase.lobby,
    players: [],
    config: const GameConfig(themeId: 'default'),
    sessionId: const Uuid().v4(),
  ));

  GameState get currentState => state;

  void updateState(GameState newState) {
    state = newState;
  }

  void setPhase(GamePhase phase) {
    state = state.copyWith(phase: phase);
  }

  // Add more granular update methods as needed
}
