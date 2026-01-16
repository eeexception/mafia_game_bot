import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/core/controllers/night_flow_service.dart';
import 'package:mafia_game/core/models/game_config.dart';
import 'package:mafia_game/core/models/game_phase.dart';
import 'package:mafia_game/core/models/game_state.dart';
import 'package:mafia_game/core/models/player.dart';
import 'package:mafia_game/core/models/player_action.dart';
import 'package:mafia_game/core/models/role.dart';

void main() {
  test('validates doctor self-heal rule', () {
    // Arrange
    final service = NightFlowService();
    const config = GameConfig(
      themeId: 'default',
      doctorCanHealSelf: false,
    );
    final state = _stateWithConfig(config);

    // Act
    final error = service.validateDoctorHeal(
      state: state,
      senderId: 'p1',
      targetId: 'p1',
    );

    // Assert
    expect(error, NightFlowService.selfHealError);
  });

  test('blocks non-don mafia kill when don is alive in kill mode', () {
    // Arrange
    final service = NightFlowService();
    const config = GameConfig(
      themeId: 'default',
      donMechanicsEnabled: true,
      donAction: DonAction.kill,
    );
    final state = _stateWithConfig(
      config,
      players: [
        _player('don', MafiaRole(isDon: true)),
        _player('m1', const MafiaRole()),
      ],
    );

    // Act
    final allowed = service.canMafiaKill(
      state: state,
      senderId: 'm1',
    );

    // Assert
    expect(allowed, false);
  });

  test('night readiness checks mafia action completion', () {
    // Arrange
    final service = NightFlowService();
    final state = GameState(
      phase: const NightGamePhase(moves: []),
      currentMoveId: 'night_mafia',
      players: [
        _player('m1', const MafiaRole(), hasActed: true),
        _player('m2', const MafiaRole(), hasActed: true),
      ],
      config: const GameConfig(themeId: 'default'),
    );

    // Act
    final ready = service.isReadyToAdvance(state);

    // Assert
    expect(ready, true);
  });

  test('immediate commissar check sends result and timer override', () {
    // Arrange
    final service = NightFlowService();
    final players = [
      _player('c1', const CommissarRole()),
      _player('m1', const MafiaRole()),
    ];
    final action = PlayerAction(
      type: 'commissar_check',
      performerId: 'c1',
      targetId: 'm1',
    );

    // Act
    final result = service.handleImmediateAction(
      players: players,
      state: _stateWithConfig(const GameConfig(themeId: 'default')),
      sender: players.first,
      action: action,
      timerSecondsRemaining: 60,
    );

    // Assert
    expect(result.timerSecondsOverride, 30);
    expect(result.messages.first.payload['type'], 'check_result');
  });

  test('resolution handles mafia consensus and poison trap', () {
    // Arrange
    final service = NightFlowService();
    final players = [
      _player('m1', const MafiaRole()),
      _player('m2', const MafiaRole()),
      _player('p1', const PoisonerRole()),
      _player('d1', const DoctorRole()),
      _player('c1', const CivilianRole()),
    ];
    final actions = [
      const PlayerAction(
        type: 'mafia_kill',
        performerId: 'm1',
        targetId: 'c1',
      ),
      const PlayerAction(
        type: 'mafia_kill',
        performerId: 'm2',
        targetId: 'c1',
      ),
      const PlayerAction(
        type: 'poison',
        performerId: 'p1',
        targetId: 'c1',
      ),
      const PlayerAction(
        type: 'doctor_heal',
        performerId: 'd1',
        targetId: 'c1',
      ),
    ];

    // Act
    final result = service.resolve(
      players: players,
      actions: actions,
      config: const GameConfig(themeId: 'default'),
    );

    // Assert
    expect(result.killedIds.contains('c1'), true);
    expect(result.trapVictimIds.contains('d1'), true);
  });

  test('builds announcements and doctor success log', () {
    // Arrange
    final service = NightFlowService();
    final players = [
      _player('p1', const DoctorRole(), number: 1),
      _player('p2', const CivilianRole(), number: 2),
    ];
    final actions = [
      const PlayerAction(
        type: 'prostitute_block',
        performerId: 'x1',
        targetId: 'p2',
      ),
    ];
    final resolution = NightResolutionResult(
      players: players,
      blockedIds: const {},
      healedIds: {'p2'},
      killedIds: {'p2'},
      actualKilledIds: const {},
      trapVictimIds: const {},
      killedByManiacIds: const {},
      killedByPoisonIds: const {},
      killedByTrapIds: const {},
      poisonedTargetId: null,
      poisonerId: null,
      currentNightDoctorTargetId: 'p2',
      mafiaMissed: false,
      mafiaNoConsensus: false,
      publicLogs: const [],
      detailedLogs: const [],
      missedEventKeys: const [],
    );

    // Act
    final result = service.buildAnnouncements(
      players: players,
      actions: actions,
      resolution: resolution,
    );

    // Assert
    expect(
      result.compositeEvents.any((e) => e.contains('prostitute_visit')),
      true,
    );
    expect(
      result.publicLogs.any((log) => log.contains('Doctor saved')),
      true,
    );
  });
}

GameState _stateWithConfig(
  GameConfig config, {
  List<Player> players = const [],
}) {
  return GameState(
    phase: GamePhase.lobby,
    players: players,
    config: config,
  );
}

Player _player(
  String id,
  Role role, {
  bool hasActed = false,
  int number = 1,
}) {
  return Player(
    id: id,
    number: number,
    nickname: id,
    role: role,
    hasActed: hasActed,
  );
}
