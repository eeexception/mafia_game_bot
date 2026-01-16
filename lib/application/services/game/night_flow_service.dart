import '../../../domain/models/game/game_config.dart';
import '../../../domain/models/game/game_state.dart';
import '../../../domain/models/players/player.dart';
import '../../../domain/models/players/player_action.dart';
import '../../../domain/models/roles/role.dart';

/// Night action messages to send to specific recipients.
class NightMessage {
  /// Recipients for the message.
  final Set<String> recipientIds;

  /// Message payload.
  final Map<String, dynamic> payload;

  const NightMessage({
    required this.recipientIds,
    required this.payload,
  });
}

/// Immediate night action side effects.
class NightImmediateResult {
  final List<NightMessage> messages;
  final List<String> detailedLogs;
  final int? timerSecondsOverride;
  final bool advancePhase;
  final bool shouldCheckAdvance;
  final bool stopProcessing;

  const NightImmediateResult({
    required this.messages,
    required this.detailedLogs,
    required this.timerSecondsOverride,
    required this.advancePhase,
    required this.shouldCheckAdvance,
    required this.stopProcessing,
  });

  const NightImmediateResult.empty()
      : messages = const [],
        detailedLogs = const [],
        timerSecondsOverride = null,
        advancePhase = false,
        shouldCheckAdvance = false,
        stopProcessing = false;
}

/// Result of resolving night actions into outcomes.
class NightResolutionResult {
  final List<Player> players;
  final Set<String> blockedIds;
  final Set<String> healedIds;
  final Set<String> killedIds;
  final Set<String> actualKilledIds;
  final Set<String> trapVictimIds;
  final Set<String> killedByManiacIds;
  final Set<String> killedByPoisonIds;
  final Set<String> killedByTrapIds;
  final String? poisonedTargetId;
  final String? poisonerId;
  final String? currentNightDoctorTargetId;
  final bool mafiaMissed;
  final bool mafiaNoConsensus;
  final List<String> publicLogs;
  final List<String> detailedLogs;
  final List<String> missedEventKeys;

  const NightResolutionResult({
    required this.players,
    required this.blockedIds,
    required this.healedIds,
    required this.killedIds,
    required this.actualKilledIds,
    required this.trapVictimIds,
    required this.killedByManiacIds,
    required this.killedByPoisonIds,
    required this.killedByTrapIds,
    required this.poisonedTargetId,
    required this.poisonerId,
    required this.currentNightDoctorTargetId,
    required this.mafiaMissed,
    required this.mafiaNoConsensus,
    required this.publicLogs,
    required this.detailedLogs,
    required this.missedEventKeys,
  });
}

/// Announcements derived from night resolution results.
class NightAnnouncementResult {
  final List<List<String>> compositeEvents;
  final List<String> audioEvents;
  final List<String> publicLogs;

  const NightAnnouncementResult({
    required this.compositeEvents,
    required this.audioEvents,
    required this.publicLogs,
  });
}

/// Orchestrates night phase validation, resolution, and announcements.
class NightFlowService {
  /// Error message when self-heal is disallowed.
  static const String selfHealError = 'You cannot heal yourself!';

  /// Error message when healing the same target twice is disallowed.
  static const String repeatHealError =
      'You cannot heal the same person twice in a row!';

  String? validateDoctorHeal({
    required GameState state,
    required String senderId,
    required String? targetId,
  }) {
    if (!state.config.doctorCanHealSelf && targetId == senderId) {
      return selfHealError;
    }
    if (!state.config.doctorCanHealSameTargetConsecutively &&
        targetId == state.lastDoctorTargetId) {
      return repeatHealError;
    }
    return null;
  }

  bool canMafiaKill({
    required GameState state,
    required String senderId,
  }) {
    if (!state.config.donMechanicsEnabled ||
        state.config.donAction != DonAction.kill) {
      return true;
    }

    final livingDon = state.players.firstWhere(
      (p) => p.isAlive && p.role is MafiaRole && (p.role as MafiaRole).isDon,
      orElse: () => _noPlayer,
    );
    if (livingDon.id.isEmpty) {
      return true;
    }
    return senderId == livingDon.id;
  }

  bool isReadyToAdvance(GameState state) {
    if (state.phase.id != 'night') {
      return false;
    }
    final moveId = state.currentMoveId;
    if (moveId == null) {
      return false;
    }
    final livingPlayers = state.players.where((p) => p.isAlive).toList();

    if (moveId == 'night_mafia') {
      final mafiaFamily =
          livingPlayers.where((p) => p.role.faction == Faction.mafia).toList();
      return mafiaFamily.every((p) => p.hasActed);
    }
    if (moveId == 'night_prostitute') {
      return _allActed(livingPlayers, RoleType.prostitute);
    }
    if (moveId == 'night_maniac') {
      return _allActed(livingPlayers, RoleType.maniac);
    }
    if (moveId == 'night_doctor') {
      return _allActed(livingPlayers, RoleType.doctor);
    }
    if (moveId == 'night_poisoner') {
      return _allActed(livingPlayers, RoleType.poisoner);
    }
    if (moveId == 'night_commissar') {
      final police = livingPlayers
          .where(
            (p) =>
                p.role.type == RoleType.commissar ||
                p.role.type == RoleType.sergeant,
          )
          .toList();
      return police.every((p) => p.hasActed);
    }
    return false;
  }

  NightImmediateResult handleImmediateAction({
    required List<Player> players,
    required GameState state,
    required Player sender,
    required PlayerAction action,
    required int? timerSecondsRemaining,
  }) {
    if (action.type == 'commissar_check' || action.type == 'commissar_kill') {
      final isSergeant = sender.role.type == RoleType.sergeant;
      final isCommissar = sender.role.type == RoleType.commissar;
      final sergeantExists =
          players.any((p) => p.role.type == RoleType.sergeant);

      if (isSergeant && action.type != 'commissar_check') {
        return _stop();
      }
      if (isCommissar &&
          action.type != 'commissar_kill' &&
          sergeantExists) {
        return _stop();
      }

      if (action.type == 'commissar_check') {
        final target = players.firstWhere(
          (p) => p.id == action.targetId,
          orElse: () => _noPlayer,
        );
        if (target.id.isEmpty) {
          return const NightImmediateResult.empty();
        }

        final isMafia = target.role.faction == Faction.mafia;
        final police = players
            .where(
              (p) =>
                  p.role.type == RoleType.commissar ||
                  p.role.type == RoleType.sergeant,
            )
            .map((p) => p.id)
            .toSet();

        final timerOverride =
            (timerSecondsRemaining ?? 0) > 30 ? 30 : null;

        return NightImmediateResult(
          messages: [
            NightMessage(
              recipientIds: police,
              payload: {
                'type': 'check_result',
                'target_id': action.targetId,
                'is_mafia': isMafia,
              },
            ),
          ],
          detailedLogs: [
            'Commissar/Sergeant investigated Player ${target.number}',
          ],
          timerSecondsOverride: timerOverride,
          advancePhase: false,
          shouldCheckAdvance: false,
          stopProcessing: false,
        );
      }

      if (action.type == 'commissar_kill') {
        final target = players.firstWhere(
          (p) => p.id == action.targetId,
          orElse: () => _noPlayer,
        );
        final targetNumber =
            target.id.isEmpty ? 'unknown' : target.number.toString();
        return NightImmediateResult(
          messages: const [],
          detailedLogs: [
            'Commissar targeted Player $targetNumber for kill. Ending phase.',
          ],
          timerSecondsOverride: null,
          advancePhase: true,
          shouldCheckAdvance: false,
          stopProcessing: true,
        );
      }
    }

    if (action.type == 'lawyer_check') {
      if (sender.role.type != RoleType.lawyer) {
        return _stop();
      }
      final target = players.firstWhere(
        (p) => p.id == action.targetId,
        orElse: () => _noPlayer,
      );
      if (target.id.isEmpty) {
        return _stop();
      }
      final isActiveTown = target.role.type == RoleType.commissar ||
          target.role.type == RoleType.sergeant;
      final mafia = players
          .where((p) => p.role.faction == Faction.mafia)
          .map((p) => p.id)
          .toSet();

      return NightImmediateResult(
        messages: [
          NightMessage(
            recipientIds: mafia,
            payload: {
              'type': 'lawyer_check_result',
              'target_id': action.targetId,
              'is_active_town': isActiveTown,
            },
          ),
        ],
        detailedLogs: [
          'Lawyer investigated Player ${target.number} (Result: $isActiveTown)',
        ],
        timerSecondsOverride: null,
        advancePhase: false,
        shouldCheckAdvance: true,
        stopProcessing: true,
      );
    }

    if (action.type == 'don_check') {
      final isDon =
          sender.role is MafiaRole && (sender.role as MafiaRole).isDon;
      if (!isDon || state.config.donAction != DonAction.search) {
        return _stop();
      }

      final target = players.firstWhere(
        (p) => p.id == action.targetId,
        orElse: () => _noPlayer,
      );
      if (target.id.isEmpty) {
        return _stop();
      }

      final isCommissar = target.role.type == RoleType.commissar;
      final mafia = players
          .where((p) => p.role.faction == Faction.mafia)
          .map((p) => p.id)
          .toSet();

      return NightImmediateResult(
        messages: [
          NightMessage(
            recipientIds: mafia,
            payload: {
              'type': 'don_check_result',
              'target_id': action.targetId,
              'is_commissar': isCommissar,
            },
          ),
        ],
        detailedLogs: [
          'Don investigated Player ${target.number} (Result: $isCommissar)',
        ],
        timerSecondsOverride: null,
        advancePhase: false,
        shouldCheckAdvance: false,
        stopProcessing: true,
      );
    }

    return const NightImmediateResult.empty();
  }

  NightResolutionResult resolve({
    required List<Player> players,
    required List<PlayerAction> actions,
    required GameConfig config,
  }) {
    final updatedPlayers = List<Player>.from(players);
    final healedIds = <String>{};
    final blockedIds = <String>{};
    final killedIds = <String>{};
    final trapVictimIds = <String>{};
    final publicLogs = <String>[];
    final detailedLogs = <String>[];
    final missedEventKeys = <String>[];

    for (final action in actions.where((a) => a.type == 'prostitute_block')) {
      if (action.targetId != null) {
        blockedIds.add(action.targetId!);
      }
    }

    String? poisonedTargetId;
    String? poisonerId;
    final poisonAction = actions.firstWhere(
      (a) => a.type == 'poison',
      orElse: () => _noAction,
    );
    if (poisonAction.type == 'poison' &&
        !blockedIds.contains(poisonAction.performerId)) {
      poisonedTargetId = poisonAction.targetId;
      poisonerId = poisonAction.performerId;
      if (poisonedTargetId != null) {
        killedIds.add(poisonedTargetId);
        final target = players.firstWhere(
          (p) => p.id == poisonedTargetId,
          orElse: () => _noPlayer,
        );
        if (target.id.isNotEmpty) {
          detailedLogs.add(
            'Player ${target.number} was poisoned (Likho target).',
          );
        }
      }
    }

    if (poisonedTargetId != null) {
      for (final action in actions) {
        if (action.targetId == poisonedTargetId &&
            action.performerId != poisonerId) {
          killedIds.add(action.performerId);
          trapVictimIds.add(action.performerId);
          final toucher = players.firstWhere(
            (p) => p.id == action.performerId,
            orElse: () => _noPlayer,
          );
          if (toucher.id.isNotEmpty) {
            detailedLogs.add(
              'Player ${toucher.number} touched the poisoned target and also died.',
            );
          }
        }
      }
    }

    var mafiaMissed = false;
    var mafiaNoConsensus = false;
    final mafiaActions = actions.where((a) => a.type == 'mafia_kill').toList();
    final livingMafia =
        players.where((p) => p.isAlive && p.role.type == RoleType.mafia).toList();

    if (mafiaActions.isNotEmpty) {
      var mafiaBlocked = false;
      if (config.donMechanicsEnabled) {
        final don = livingMafia.firstWhere(
          (p) => p.role is MafiaRole && (p.role as MafiaRole).isDon,
          orElse: () => _noPlayer,
        );
        if (don.id.isNotEmpty && blockedIds.contains(don.id)) {
          mafiaBlocked = true;
          detailedLogs.add(
            'Mafia blocked: Don ${don.nickname} was visited by Prostitute.',
          );
        }
      }

      if (!mafiaBlocked) {
        if (!config.donMechanicsEnabled || config.donAction == DonAction.search) {
          final targetCounts = <String, int>{};
          for (final action in mafiaActions) {
            if (!blockedIds.contains(action.performerId) &&
                action.targetId != null) {
              targetCounts[action.targetId!] =
                  (targetCounts[action.targetId!] ?? 0) + 1;
            }
          }

          final consensus = targetCounts.entries.firstWhere(
            (e) => e.value == livingMafia.length,
            orElse: () => _noEntry,
          );
          if (consensus.key.isNotEmpty) {
            killedIds.add(consensus.key);
          } else {
            mafiaMissed = true;
            mafiaNoConsensus = true;
          }
        } else {
          var anyAction = false;
          for (final action in mafiaActions) {
            if (!blockedIds.contains(action.performerId) &&
                action.targetId != null) {
              killedIds.add(action.targetId!);
              anyAction = true;
              break;
            }
          }
          if (!anyAction && livingMafia.isNotEmpty) {
            mafiaMissed = true;
          }
        }
      }
    } else if (livingMafia.isNotEmpty) {
      mafiaMissed = true;
    }

    for (final action in actions.where((a) => a.type == 'maniac_kill')) {
      if (!blockedIds.contains(action.performerId) && action.targetId != null) {
        killedIds.add(action.targetId!);
      }
    }

    if (config.commissarKills) {
      for (final action in actions.where((a) => a.type == 'commissar_kill')) {
        if (!blockedIds.contains(action.performerId) &&
            action.targetId != null) {
          killedIds.add(action.targetId!);
          final target = players.firstWhere(
            (p) => p.id == action.targetId,
            orElse: () => _noPlayer,
          );
          if (target.id.isNotEmpty) {
            detailedLogs.add(
              'Commissar killed Player ${target.number}',
            );
          }
        }
      }
    }

    String? currentNightDoctorTargetId;
    for (final action in actions.where((a) => a.type == 'doctor_heal')) {
      if (!blockedIds.contains(action.performerId) && action.targetId != null) {
        healedIds.add(action.targetId!);
        currentNightDoctorTargetId = action.targetId;
      }
    }

    final actualKilledIds =
        killedIds.where((id) => !healedIds.contains(id)).toSet();

    for (var i = 0; i < updatedPlayers.length; i++) {
      if (actualKilledIds.contains(updatedPlayers[i].id)) {
        updatedPlayers[i] = updatedPlayers[i].copyWith(isAlive: false);
        final log =
            'Morning begins. ${updatedPlayers[i].nickname} was found dead.';
        publicLogs.add(log);
      }
    }

    if (actualKilledIds.isEmpty) {
      publicLogs.add('Morning begins. Everyone is alive.');
    }

    final killedByManiacIds = actions
        .where((a) =>
            a.type == 'maniac_kill' &&
            !blockedIds.contains(a.performerId) &&
            a.targetId != null)
        .map((a) => a.targetId!)
        .toSet();

    final killedByPoisonIds = <String>{};
    if (poisonAction.type == 'poison' &&
        !blockedIds.contains(poisonAction.performerId) &&
        poisonAction.targetId != null) {
      killedByPoisonIds.add(poisonAction.targetId!);
    }

    final killedByTrapIds = Set<String>.from(trapVictimIds);

    _collectMissedEvents(
      players: updatedPlayers,
      actions: actions,
      missedEventKeys: missedEventKeys,
    );

    return NightResolutionResult(
      players: updatedPlayers,
      blockedIds: blockedIds,
      healedIds: healedIds,
      killedIds: killedIds,
      actualKilledIds: actualKilledIds,
      trapVictimIds: trapVictimIds,
      killedByManiacIds: killedByManiacIds,
      killedByPoisonIds: killedByPoisonIds,
      killedByTrapIds: killedByTrapIds,
      poisonedTargetId: poisonedTargetId,
      poisonerId: poisonerId,
      currentNightDoctorTargetId: currentNightDoctorTargetId,
      mafiaMissed: mafiaMissed,
      mafiaNoConsensus: mafiaNoConsensus,
      publicLogs: publicLogs,
      detailedLogs: detailedLogs,
      missedEventKeys: missedEventKeys,
    );
  }

  NightAnnouncementResult buildAnnouncements({
    required List<Player> players,
    required List<PlayerAction> actions,
    required NightResolutionResult resolution,
  }) {
    final compositeEvents = <List<String>>[];
    final audioEvents = <String>[];
    final publicLogs = <String>[];

    for (final action in actions.where((a) => a.type == 'prostitute_block')) {
      if (action.targetId != null) {
        final target = players.firstWhere((p) => p.id == action.targetId);
        compositeEvents.add(
          ['prostitute_visit', 'role_name_${target.role.type.name}'],
        );
      }
    }

    if (resolution.poisonedTargetId != null &&
        resolution.poisonerId != null &&
        !resolution.blockedIds.contains(resolution.poisonerId)) {
      final target =
          players.firstWhere((p) => p.id == resolution.poisonedTargetId);
      compositeEvents.add(['poisoner_visit', 'player_${target.number}']);
      publicLogs.add('The Poisoner visited Player ${target.number}.');
    }

    for (final action in actions) {
      if (resolution.blockedIds.contains(action.performerId)) continue;
      final target = players.firstWhere(
        (p) => p.id == action.targetId,
        orElse: () => _noPlayer,
      );
      if (target.id.isEmpty) continue;

      if (action.type == 'lawyer_check') {
        compositeEvents.add(['lawyer_visit', 'player_${target.number}']);
        publicLogs.add('Lawyer investigated Player ${target.number}');
      } else if (action.type == 'don_check') {
        compositeEvents.add(['don_visit', 'player_${target.number}']);
        publicLogs.add('Don investigated Player ${target.number}');
      }
    }

    for (final action in actions) {
      if (resolution.blockedIds.contains(action.performerId)) continue;
      final target = players.firstWhere(
        (p) => p.id == action.targetId,
        orElse: () => _noPlayer,
      );
      if (target.id.isEmpty) continue;

      if (action.type == 'commissar_check') {
        final performer =
            players.firstWhere((p) => p.id == action.performerId);
        final isSergeant = performer.role.type == RoleType.sergeant;
        final event = isSergeant ? 'sergeant_visit' : 'commissar_visit';
        compositeEvents.add([event, 'player_${target.number}']);
        publicLogs.add(
          '${isSergeant ? 'Sergeant' : 'Commissar'} investigated Player ${target.number}',
        );
      }
    }

    for (final healId in resolution.healedIds) {
      final target = players.firstWhere((p) => p.id == healId);
      if (resolution.killedIds.contains(healId)) {
        compositeEvents
            .add(['doctor_heal_success', 'player_${target.number}']);
        publicLogs.add('Doctor saved ${target.nickname}!');
      } else {
        audioEvents.add('doctor_heal_fail');
      }
    }

    return NightAnnouncementResult(
      compositeEvents: compositeEvents,
      audioEvents: audioEvents,
      publicLogs: publicLogs,
    );
  }

  bool _allActed(List<Player> players, RoleType roleType) {
    return players.where((p) => p.role.type == roleType).every(
          (p) => p.hasActed,
        );
  }

  void _collectMissedEvents({
    required List<Player> players,
    required List<PlayerAction> actions,
    required List<String> missedEventKeys,
  }) {
    final livingCommissar =
        players.any((p) => p.isAlive && p.role.type == RoleType.commissar);
    if (livingCommissar &&
        !actions.any((a) => a.type == 'commissar_check')) {
      missedEventKeys.add('commissar_miss');
    }

    final livingDoctor =
        players.any((p) => p.isAlive && p.role.type == RoleType.doctor);
    if (livingDoctor && !actions.any((a) => a.type == 'doctor_heal')) {
      missedEventKeys.add('doctor_miss');
    }

    final livingProstitute =
        players.any((p) => p.isAlive && p.role.type == RoleType.prostitute);
    if (livingProstitute &&
        !actions.any((a) => a.type == 'prostitute_block')) {
      missedEventKeys.add('prostitute_miss');
    }

    final livingManiac =
        players.any((p) => p.isAlive && p.role.type == RoleType.maniac);
    if (livingManiac && !actions.any((a) => a.type == 'maniac_kill')) {
      missedEventKeys.add('maniac_miss');
    }

    final livingPoisoner =
        players.any((p) => p.isAlive && p.role.type == RoleType.poisoner);
    if (livingPoisoner && !actions.any((a) => a.type == 'poison')) {
      missedEventKeys.add('poisoner_miss');
    }

    final livingLawyer =
        players.any((p) => p.isAlive && p.role.type == RoleType.lawyer);
    if (livingLawyer && !actions.any((a) => a.type == 'lawyer_check')) {
      missedEventKeys.add('lawyer_miss');
    }

    final livingSergeant =
        players.any((p) => p.isAlive && p.role.type == RoleType.sergeant);
    if (livingSergeant &&
        !actions.any((a) => a.type == 'commissar_check')) {
      missedEventKeys.add('sergeant_miss');
    }
  }

  NightImmediateResult _stop() {
    return const NightImmediateResult(
      messages: [],
      detailedLogs: [],
      timerSecondsOverride: null,
      advancePhase: false,
      shouldCheckAdvance: false,
      stopProcessing: true,
    );
  }
}

final PlayerAction _noAction = const PlayerAction(
  type: '',
  performerId: '',
);

final Player _noPlayer = Player(
  id: '',
  number: 0,
  nickname: '',
  role: const CivilianRole(),
);

final MapEntry<String, int> _noEntry = const MapEntry('', -1);
