import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/core/controllers/game_controller.dart';
import 'package:mafia_game/core/models/player.dart';
import 'package:mafia_game/core/models/role.dart';
import 'package:mafia_game/core/models/player_action.dart';
import 'package:mafia_game/core/models/game_config.dart';
import 'package:mafia_game/core/state/game_state_notifier.dart';
import 'package:mockito/mockito.dart';
import 'night_actions_test.mocks.dart';

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
    
    // Stub audio events
    when(mockAudio.playEvent(any)).thenAnswer((_) async => null);
    when(mockAudio.playCompositeEvent(any)).thenAnswer((_) async => null);
    when(mockAudio.restoreBackground()).thenAnswer((_) async => {});
    when(mockAudio.stopBackgroundMusic()).thenReturn(null);
    when(mockAudio.stopAll()).thenAnswer((_) async => {});
    
    // Stub WS
    when(mockWs.broadcast(any)).thenReturn(null);
    when(mockWs.sendToClient(any, any)).thenReturn(null);

    gameController = GameController(
      audioController: mockAudio,
      websocketController: mockWs,
      winDetector: mockWin,
      gameLogger: mockLogger,
      stateNotifier: stateNotifier,
      storageService: mockStorage,
      themeController: mockTheme,
    );
  });

  test('Don in KILL mode: only Don target is killed', () async {
    final players = [
      const Player(id: 'v1', number: 1, nickname: 'V1', role: CivilianRole()),
      const Player(id: 'v2', number: 2, nickname: 'V2', role: CivilianRole()),
      const Player(id: 'don', number: 3, nickname: 'Don', role: MafiaRole(isDon: true)),
      const Player(id: 'm1', number: 4, nickname: 'Mafia', role: MafiaRole()),
    ];
    
    stateNotifier.updateState(stateNotifier.currentState.copyWith(
      players: players,
      config: const GameConfig(themeId: 'test', donMechanicsEnabled: true, donAction: DonAction.kill),
      pendingActions: [
        const PlayerAction(type: 'mafia_kill', performerId: 'don', targetId: 'v1'),
        const PlayerAction(type: 'mafia_kill', performerId: 'm1', targetId: 'v2'), // Should be ignored in KILL mode
      ],
    ));

    await gameController.resolveNightActions();

    final newState = stateNotifier.currentState;
    expect(newState.players.firstWhere((p) => p.id == 'v1').isAlive, false);
    expect(newState.players.firstWhere((p) => p.id == 'v2').isAlive, true);
  });

  test('Don in SEARCH mode: Mafia requires consensus', () async {
    final players = [
      const Player(id: 'v1', number: 1, nickname: 'V1', role: CivilianRole()),
      const Player(id: 'don', number: 3, nickname: 'Don', role: MafiaRole(isDon: true)),
      const Player(id: 'm1', number: 4, nickname: 'Mafia', role: MafiaRole()),
    ];
    
    stateNotifier.updateState(stateNotifier.currentState.copyWith(
      players: players,
      config: const GameConfig(themeId: 'test', donMechanicsEnabled: true, donAction: DonAction.search),
      pendingActions: [
        const PlayerAction(type: 'mafia_kill', performerId: 'don', targetId: 'v1'),
        const PlayerAction(type: 'mafia_kill', performerId: 'm1', targetId: 'v1'), // Consensus reached
      ],
    ));

    await gameController.resolveNightActions();

    final newState = stateNotifier.currentState;
    expect(newState.players.firstWhere((p) => p.id == 'v1').isAlive, false);
  });

  test('Don in SEARCH mode: No consensus = no kill', () async {
    final players = [
      const Player(id: 'v1', number: 1, nickname: 'V1', role: CivilianRole()),
      const Player(id: 'v2', number: 2, nickname: 'V2', role: CivilianRole()),
      const Player(id: 'don', number: 3, nickname: 'Don', role: MafiaRole(isDon: true)),
      const Player(id: 'm1', number: 4, nickname: 'Mafia', role: MafiaRole()),
    ];
    
    stateNotifier.updateState(stateNotifier.currentState.copyWith(
      players: players,
      config: const GameConfig(themeId: 'test', donMechanicsEnabled: true, donAction: DonAction.search),
      pendingActions: [
        const PlayerAction(type: 'mafia_kill', performerId: 'don', targetId: 'v1'),
        const PlayerAction(type: 'mafia_kill', performerId: 'm1', targetId: 'v2'), // No consensus
      ],
    ));

    await gameController.resolveNightActions();

    final newState = stateNotifier.currentState;
    expect(newState.players.firstWhere((p) => p.id == 'v1').isAlive, true);
    expect(newState.players.firstWhere((p) => p.id == 'v2').isAlive, true);
  });
}
