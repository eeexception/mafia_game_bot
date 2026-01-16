import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/application/services/game/game_controller.dart';
import 'package:mafia_game/domain/models/game/game_state.dart';
import 'package:mafia_game/domain/models/game/game_phase.dart';
import 'package:mafia_game/domain/models/players/player_action.dart';
import 'package:mafia_game/presentation/state/game/game_state_notifier.dart';
import 'package:mockito/mockito.dart';
import 'game_controller_test.mocks.dart';

import 'package:mafia_game/domain/models/roles/role.dart';
import 'package:mafia_game/domain/models/players/player.dart';
import 'package:mafia_game/domain/models/game/game_config.dart';
import 'package:mafia_game/domain/models/game/game_move.dart';

void main() {
  group('Day Defense Logic', () {
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
      
      // Default stub for win detector to avoid null errors
      when(mockWin.checkWinCondition(any)).thenReturn(null);

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

    test('Tie in dayVoting should trigger dayDefense and set speaker', () async {
      final players = [
        Player(id: 'p1', number: 1, nickname: 'P1', role: const CivilianRole(), isAlive: true),
        Player(id: 'p2', number: 2, nickname: 'P2', role: const CivilianRole(), isAlive: true),
        Player(id: 'p3', number: 3, nickname: 'P3', role: const CivilianRole(), isAlive: true),
        Player(id: 'p4', number: 4, nickname: 'P4', role: const CivilianRole(), isAlive: true),
      ];

      final List<GameMove> dayMoves = [
        const MorningMove(),
        const DiscussionMove(),
        const VotingMove(),
        const DefenseMove(),
        const VerdictMove(),
      ];

      stateNotifier.updateState(GameState(
        players: players,
        phase: DayGamePhase(moves: dayMoves),
        currentMoveId: 'day_voting',
        currentMoveIndex: 2,
        config: const GameConfig(themeId: 'default'),
      ));
      
      // Make a tie between p3 and p4
      stateNotifier.updateState(stateNotifier.currentState.copyWith(
        currentVotes: {
          'p1': 'p3',
          'p2': 'p4',
        }
      ));

      await controller.advancePhase();

      expect(stateNotifier.currentState.phase, isA<DayGamePhase>());
      expect(stateNotifier.currentState.currentMoveId, 'day_defense');
      expect(stateNotifier.currentState.defenseQueue, containsAll(['p3', 'p4']));
      expect(stateNotifier.currentState.speakerId, isNotNull);
      expect(['p3', 'p4'], contains(stateNotifier.currentState.speakerId));
    });

    test('end_speech action should move to next speaker or verdict', () async {
      final players = [
        Player(id: 'p1', number: 1, nickname: 'P1', role: const CivilianRole(), isAlive: true),
        Player(id: 'p2', number: 2, nickname: 'P2', role: const CivilianRole(), isAlive: true),
      ];

      final List<GameMove> dayMoves = [
        const MorningMove(),
        const DiscussionMove(),
        const VotingMove(),
        const DefenseMove(),
        const VerdictMove(),
      ];

      stateNotifier.updateState(GameState(
        players: players,
        phase: DayGamePhase(moves: dayMoves),
        currentMoveId: 'day_defense',
        currentMoveIndex: 3,
        config: const GameConfig(themeId: 'default'),
        defenseQueue: ['p1', 'p2'],
        speakerId: 'p1',
      ));

      // Act: p1 ends speech
      await controller.handlePlayerAction('p1', const PlayerAction(type: 'end_speech', performerId: 'p1', targetId: null));

      // Assert: Should still be in dayDefense but speaker is p2
      expect(stateNotifier.currentState.currentMoveId, 'day_defense');
      expect(stateNotifier.currentState.speakerId, 'p2');
      expect(stateNotifier.currentState.defenseQueue, ['p2']);

      // Act: p2 ends speech
      await controller.handlePlayerAction('p2', const PlayerAction(type: 'end_speech', performerId: 'p2', targetId: null));

      // Assert: Should move to dayVerdict
      expect(stateNotifier.currentState.currentMoveId, 'day_verdict');
    });
  });
}
