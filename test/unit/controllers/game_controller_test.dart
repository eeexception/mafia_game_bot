import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/core/controllers/game_controller.dart';
import 'package:mafia_game/core/controllers/audio_controller.dart';
import 'package:mafia_game/core/controllers/websocket_controller.dart';
import 'package:mafia_game/core/controllers/win_detector.dart';
import 'package:mafia_game/core/services/game_logger.dart';
import 'package:mafia_game/core/services/storage_service.dart';
import 'package:mafia_game/core/models/game_config.dart';
import 'package:mafia_game/core/models/role.dart';
import 'package:mafia_game/core/models/player.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mafia_game/core/controllers/win_detector.dart';

import 'package:mafia_game/core/state/game_state_notifier.dart';
import 'package:mafia_game/core/models/game_state.dart';
import 'package:mafia_game/core/models/game_phase.dart';
import 'package:mafia_game/core/models/player_action.dart';

import 'game_controller_test.mocks.dart';

@GenerateMocks([AudioController, WebSocketController, WinDetector, GameLogger, StorageService])
void main() {
  group('GameController', () {
    late GameController controller;
    late MockAudioController mockAudio;
    late MockWebSocketController mockWs;
    late MockWinDetector mockWin;
    late MockGameLogger mockLogger;
    late MockStorageService mockStorage;
    late GameStateNotifier stateNotifier;

    setUp(() {
      mockAudio = MockAudioController();
      mockWs = MockWebSocketController();
      mockWin = MockWinDetector();
      mockLogger = MockGameLogger();
      mockStorage = MockStorageService();
      stateNotifier = GameStateNotifier();
      
      controller = GameController(
        audioController: mockAudio,
        websocketController: mockWs,
        winDetector: mockWin,
        gameLogger: mockLogger,
        stateNotifier: stateNotifier,
        storageService: mockStorage,
      );
    });

    test('distributeRoles returns correct number of roles', () {
      const config = GameConfig(themeId: 'test');
      final roles = controller.distributeRoles(8, config);
      expect(roles.length, equals(8));
      expect(roles.whereType<MafiaRole>().length, equals(2)); 
    });
    
    test('addPlayer updates state', () {
      final player = Player(
        id: 'p1', 
        number: 1, 
        nickname: 'P1', 
        role: const CivilianRole()
      );
      controller.addPlayer(player);
      expect(stateNotifier.currentState.players.length, 1);
    });
    test('checkWinCondition triggers audio on win', () {
      // Arrange
      // Setup state with some players
      final players = [
        Player(id: 'p1', number: 1, nickname: 'P1', role: const MafiaRole(), isAlive: true),
        Player(id: 'p2', number: 2, nickname: 'P2', role: const CivilianRole(), isAlive: false), // Dead civ
      ];
      
      // Inject state
      // We can't set _state directly easily as it is private setter via stateNotifier, 
      // but we can assume controller uses stateNotifier.currentState.
      // We need to use reflection or just call a method that updates state.
      // `startGame` updates state. Or `addPlayer`.
      // Actually `stateNotifier` is accessible in test.
      // But GameController uses `stateNotifier.currentState` getter.
      // We can brute force update by `stateNotifier.updateState(...)` if GameController reads from it.
      // GameController constructor takes `stateNotifier`.
      
      stateNotifier.updateState(GameState(players: players, phase: GamePhase.dayVerdict, config: const GameConfig(themeId: 'default')));

      // Mock WinDetector to return Mafia Win
      when(mockWin.checkWinCondition(any)).thenReturn(const WinResult(faction: Faction.mafia, message: 'Mafia Wins'));

      // Act
      // advancePhase triggers checkWinCondition at the end
      controller.advancePhase();

      // Assert
      verify(mockAudio.playEvent('mafia_win')).called(1);
    });
    test('resolveNightActions triggers miss audio when no action', () async {
      // Arrange
      final players = [
        Player(id: 'p1', number: 1, nickname: 'Civ', role: const CivilianRole(), isAlive: true),
        Player(id: 'p2', number: 2, nickname: 'Mafia', role: const MafiaRole(), isAlive: true),
        Player(id: 'p3', number: 3, nickname: 'Doc', role: const DoctorRole(), isAlive: true),
      ];
      
      stateNotifier.updateState(GameState(
        players: players, 
        phase: GamePhase.morning, // Logic runs just before morning but check is in resolveNightActions
        config: const GameConfig(themeId: 'default'),
        pendingActions: [], // No actions!
      ));

      // Act
      await controller.resolveNightActions();

      // Assert
      // Mafia missed (p2 is alive, no action)
      verify(mockAudio.playEvent('mafia_miss')).called(1);
      // Doctor missed (p3 is alive, no action)
      verify(mockAudio.playEvent('doctor_miss')).called(1);
    });
  });
}
