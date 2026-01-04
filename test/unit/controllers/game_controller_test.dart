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

import 'package:mafia_game/core/state/game_state_notifier.dart';

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
  });
}
