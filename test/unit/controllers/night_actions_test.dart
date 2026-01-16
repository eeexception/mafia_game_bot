import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/application/services/game/game_controller.dart';
import 'package:mafia_game/application/services/audio/audio_controller.dart';
import 'package:mafia_game/application/services/network/websocket_controller.dart';
import 'package:mafia_game/application/services/game/win_detector.dart';
import 'package:mafia_game/application/services/theme/theme_controller.dart';
import 'package:mafia_game/infrastructure/services/logging/game_logger.dart';
import 'package:mafia_game/domain/models/players/player.dart';
import 'package:mafia_game/domain/models/roles/role.dart';
import 'package:mafia_game/domain/models/players/player_action.dart';
import 'package:mafia_game/infrastructure/services/storage/storage_service.dart';
import 'package:mafia_game/presentation/state/game/game_state_notifier.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'night_actions_test.mocks.dart';

@GenerateMocks([AudioController, WebSocketController, WinDetector, GameLogger, StorageService, ThemeController])
void main() {
  late GameController gameController;
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
    
    gameController = GameController(
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
  });

  test('resolveNightActions kills player not healed', () async {
    // Arrange
    final players = [
      const Player(id: 'p1', number: 1, nickname: 'P1', role: CivilianRole()),
      const Player(id: 'p2', number: 2, nickname: 'P2', role: MafiaRole()),
    ];
    stateNotifier.updateState(stateNotifier.currentState.copyWith(
      players: players,
      pendingActions: [
        const PlayerAction(type: 'mafia_kill', performerId: 'p2', targetId: 'p1'),
      ],
    ));

    // Act
    await gameController.resolveNightActions();

    // Assert
    final newState = stateNotifier.currentState;
    expect(newState.players[0].isAlive, false);
    expect(newState.publicEventLog.last, contains('P1 was found dead'));
  });

  test('resolveNightActions heal saves player', () async {
    // Arrange
    final players = [
      const Player(id: 'p1', number: 1, nickname: 'P1', role: CivilianRole()),
      const Player(id: 'p2', number: 2, nickname: 'P2', role: MafiaRole()),
      const Player(id: 'p3', number: 3, nickname: 'P3', role: DoctorRole()),
    ];
    stateNotifier.updateState(stateNotifier.currentState.copyWith(
      players: players,
      pendingActions: [
        const PlayerAction(type: 'mafia_kill', performerId: 'p2', targetId: 'p1'),
        const PlayerAction(type: 'doctor_heal', performerId: 'p3', targetId: 'p1'),
      ],
    ));

    // Act
    await gameController.resolveNightActions();

    // Assert
    final newState = stateNotifier.currentState;
    expect(newState.players[0].isAlive, true);
    expect(newState.publicEventLog.last, contains('Everyone is alive'));
  });

  test('resolveNightActions prostitute blocks killer', () async {
     // Arrange
    final players = [
      const Player(id: 'p1', number: 1, nickname: 'P1', role: CivilianRole()),
      const Player(id: 'p2', number: 2, nickname: 'P2', role: MafiaRole()),
      const Player(id: 'p3', number: 3, nickname: 'P3', role: ProstituteRole()),
    ];
    stateNotifier.updateState(stateNotifier.currentState.copyWith(
      players: players,
      pendingActions: [
        const PlayerAction(type: 'mafia_kill', performerId: 'p2', targetId: 'p1'),
        const PlayerAction(type: 'prostitute_block', performerId: 'p3', targetId: 'p2'),
      ],
    ));

    // Act
    await gameController.resolveNightActions();

    // Assert
    final newState = stateNotifier.currentState;
    expect(newState.players[0].isAlive, true);
    expect(newState.publicEventLog.last, contains('Everyone is alive'));
  });
}
