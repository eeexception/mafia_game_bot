import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/application/services/game/game_controller.dart';
import 'package:mafia_game/application/services/audio/audio_controller.dart';
import 'package:mafia_game/application/services/network/websocket_controller.dart';
import 'package:mafia_game/application/services/theme/theme_controller.dart';
import 'package:mafia_game/application/services/game/win_detector.dart';
import 'package:mafia_game/infrastructure/services/logging/game_logger.dart';
import 'package:mafia_game/infrastructure/services/storage/storage_service.dart';
import 'package:mafia_game/domain/models/game/game_config.dart';
import 'package:mafia_game/domain/models/roles/role.dart';
import 'package:mafia_game/domain/models/players/player.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:mafia_game/presentation/state/game/game_state_notifier.dart';
import 'package:mafia_game/domain/models/game/game_state.dart';
import 'package:mafia_game/domain/models/game/game_phase.dart';
import 'package:mafia_game/domain/models/players/player_action.dart';

import 'game_controller_test.mocks.dart';

@GenerateMocks([AudioController, WebSocketController, WinDetector, GameLogger, StorageService, ThemeController])
void main() {
  group('GameController', () {
    late GameController controller;
    late MockAudioController mockAudio;
    late MockWebSocketController mockWs;
    late MockWinDetector mockWin;
    late MockGameLogger mockLogger;
    late MockStorageService mockStorage;
    late MockThemeController mockTheme;
    late GameStateNotifier stateNotifier;

    setUp(() {
      mockAudio = MockAudioController();
      mockWs = MockWebSocketController();
      mockWin = MockWinDetector();
      mockLogger = MockGameLogger();
      mockStorage = MockStorageService();
      mockTheme = MockThemeController();
      stateNotifier = GameStateNotifier();
      
      controller = GameController(
        audioController: mockAudio,
        websocketController: mockWs,
        winDetector: mockWin,
        gameLogger: mockLogger,
        stateNotifier: stateNotifier,
        storageService: mockStorage,
        themeController: mockTheme,
      );

      // Default stubs for audio to avoid MissingStubError
      when(mockAudio.playEvent(any)).thenAnswer((_) async => 'Test text');
      when(mockAudio.playCompositeEvent(any)).thenAnswer((_) async => 'Test text');
      
      when(mockLogger.detailedLog).thenReturn([]);
      when(mockLogger.publicLog).thenReturn([]);
    });

    test('distributeRoles returns correct number of roles', () {
      const config = GameConfig(themeId: 'test');
      
      final roles8 = controller.distributeRoles(8, config);
      expect(roles8.length, equals(8));
      expect(roles8.whereType<MafiaRole>().length, equals(2)); 

      final roles3 = controller.distributeRoles(3, config);
      expect(roles3.length, equals(3));
      expect(roles3.whereType<MafiaRole>().length, equals(1));
      expect(roles3.whereType<CommissarRole>().length, equals(1));
      expect(roles3.whereType<CivilianRole>().length, equals(1));
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
    test('checkWinCondition triggers audio on win', () async {
      final players = [
        Player(id: 'p1', number: 1, nickname: 'P1', role: const MafiaRole(), isAlive: true),
        Player(id: 'p2', number: 2, nickname: 'P2', role: const CivilianRole(), isAlive: false), // Dead civ
      ];
      
      stateNotifier.updateState(GameState(
        players: players, 
        phase: GamePhase.day, 
        currentMoveId: 'day_verdict',
        config: const GameConfig(themeId: 'default')
      ));

      // Mock WinDetector to return Mafia Win
      when(mockWin.checkWinCondition(any)).thenReturn(const WinResult(faction: Faction.mafia, message: 'Mafia Wins'));

      // Act
      // advancePhase triggers checkWinCondition at the end
      await controller.advancePhase();

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
        phase: GamePhase.day, 
        currentMoveId: 'morning',
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
