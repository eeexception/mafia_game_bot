import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
import 'audio_controller.dart';
import 'websocket_controller.dart';
import '../models/game_state.dart';
import '../models/game_phase.dart';
import '../models/game_config.dart';
import '../models/player.dart';
import '../models/role.dart';
import '../models/player_action.dart';
import 'win_detector.dart';
import '../services/game_logger.dart';
import '../services/storage_service.dart';

import '../state/game_state_notifier.dart';

class GameController {
  GameController({
    required this.audioController,
    required this.websocketController,
    required this.winDetector,
    required this.gameLogger,
    required this.stateNotifier,
    required this.storageService,
  }) {
    websocketController.onMessageReceived = _handleMessage;
  }
  
  final AudioController audioController;
  final WebSocketController websocketController;
  final WinDetector winDetector;
  final GameLogger gameLogger;
  final GameStateNotifier stateNotifier;
  final StorageService storageService;

  void _handleMessage(String senderId, Map<String, dynamic> message) {
    final type = message['type'] as String?;
    switch (type) {
      case 'player_joined':
        _handlePlayerJoin(senderId, message);
        break;
      case 'player_action':
        handlePlayerAction(senderId, PlayerAction.fromJson(message['action']));
        break;
    }
  }

  void handlePlayerAction(String senderId, PlayerAction action) {
    final sender = _state.players.firstWhere((p) => p.id == senderId);
    if (!sender.isAlive) return;

    if (action.type == 'ready_to_vote') {
      final players = List<Player>.from(_state.players);
      final index = players.indexWhere((p) => p.id == senderId);
      if (index != -1) {
        players[index] = players[index].copyWith(isReadyToVote: !players[index].isReadyToVote);
        _state = _state.copyWith(players: players);
        
        final livingPlayers = players.where((p) => p.isAlive).toList();
        final readyPlayers = livingPlayers.where((p) => p.isReadyToVote).toList();
        
        if (readyPlayers.length == livingPlayers.length) {
          gameLogger.logPublic('All players are ready to vote early.');
          advancePhase();
        }
      }
      return;
    }

    if (action.type == 'vote') {
      final votes = Map<String, String>.from(_state.currentVotes ?? {});
      if (action.targetId != null) {
        votes[senderId] = action.targetId!;
      } else {
        votes.remove(senderId);
      }
      _state = _state.copyWith(currentVotes: votes);
      return;
    }

    _state = _state.copyWith(
      pendingActions: [..._state.pendingActions, action.copyWith(performerId: senderId)],
    );
  }

  void _handlePlayerJoin(String senderId, Map<String, dynamic> message) {
    final nickname = message['nickname'] as String? ?? 'Unknown';
    final newPlayer = Player(
      id: senderId,
      number: _state.players.length + 1,
      nickname: nickname,
      role: const CivilianRole(), 
    );
    addPlayer(newPlayer);
    
    final token = 'token-${Random().nextInt(10000)}';
    websocketController.registerSession(senderId, token);
    websocketController.sendToClient(senderId, {
      'type': 'join_success',
      'player_id': senderId,
      'session_token': token,
    });
  }
  
  GameState get _state => stateNotifier.currentState;
  set _state(GameState newState) => stateNotifier.updateState(newState);
  
  Timer? _phaseTimer;
  
  void addPlayer(Player player) {
    _state = _state.copyWith(players: [..._state.players, player]);
  }

  Future<void> startGame(GameConfig config) async {
    gameLogger.reset();
    gameLogger.logDetailed('Game started with ${_state.players.length} players');
    gameLogger.logDetailed('Config: $config');

    final roles = distributeRoles(_state.players.length, config);
    final shuffledRoles = List<Role>.from(roles)..shuffle();
    
    final updatedPlayers = <Player>[];
    for (var i = 0; i < _state.players.length; i++) {
        updatedPlayers.add(_state.players[i].copyWith(role: shuffledRoles[i]));
        gameLogger.logDetailed('Assigned ${shuffledRoles[i].name} to ${_state.players[i].nickname}');
    }
    
    _state = _state.copyWith(
        phase: GamePhase.setup,
        players: updatedPlayers,
        config: config,
        currentNightNumber: 1,
        currentDayNumber: 1,
    );
    
    websocketController.broadcast({'type': 'state_update', 'state': _state.toJson()});
  }
  
  Future<void> advancePhase() async {
    _phaseTimer?.cancel();
    
    // Reset player readiness
    final players = _state.players.map((p) => p.copyWith(isReadyToVote: false)).toList();
    _state = _state.copyWith(players: players);

    gameLogger.logDetailed('Advancing phase from ${_state.phase} to ...');
    switch (_state.phase) {
      case GamePhase.lobby:
      case GamePhase.setup:
        _state = _state.copyWith(phase: GamePhase.nightMafia);
        break;
      case GamePhase.nightMafia:
        _state = _state.copyWith(phase: GamePhase.nightProstitute);
        break;
      case GamePhase.nightProstitute:
        _state = _state.copyWith(phase: GamePhase.nightManiac);
        break;
      case GamePhase.nightManiac:
        _state = _state.copyWith(phase: GamePhase.nightDoctor);
        break;
      case GamePhase.nightDoctor:
        _state = _state.copyWith(phase: GamePhase.nightCommissar);
        break;
      case GamePhase.nightCommissar:
        _state = _state.copyWith(phase: GamePhase.morning);
        resolveNightActions();
        break;
      case GamePhase.morning:
        _state = _state.copyWith(phase: GamePhase.dayDiscussion);
        break;
      case GamePhase.dayDiscussion:
        _state = _state.copyWith(phase: GamePhase.dayVoting);
        break;
      case GamePhase.dayVoting:
        final tiedIds = _getTiedPlayers();
        if (tiedIds.length > 1) {
          gameLogger.logPublic('VOTES TIED: Players ${tiedIds.join(", ")}');
          _state = _state.copyWith(phase: GamePhase.dayDefense);
        } else {
          _state = _state.copyWith(phase: GamePhase.dayVerdict);
        }
        break;
      case GamePhase.dayDefense:
        _state = _state.copyWith(phase: GamePhase.dayVerdict);
        break;
      case GamePhase.dayVerdict:
        _executeVotedPlayer();
        _state = _state.copyWith(
          phase: GamePhase.nightMafia,
          currentNightNumber: (_state.currentNightNumber ?? 1) + 1,
          currentDayNumber: (_state.currentDayNumber ?? 1) + 1,
        );
        break;
      case GamePhase.gameOver:
        return;
    }
    gameLogger.logDetailed('New phase: ${_state.phase}');
    
    if (_checkWinCondition()) return;
    
    _triggerPhaseAudio();
    _startTimerForPhase();
    websocketController.broadcast({'type': 'phase_changed', 'phase': _state.phase.name});
    websocketController.broadcast({'type': 'state_update', 'state': _state.toJson()});
  }

  void _triggerPhaseAudio() {
    switch (_state.phase) {
      case GamePhase.nightMafia:
        audioController.playEvent('night_start');
        audioController.playEvent('mafia_wake');
        break;
      case GamePhase.nightProstitute:
        audioController.playEvent('prostitute_wake');
        break;
      case GamePhase.nightManiac:
        audioController.playEvent('maniac_wake');
        break;
      case GamePhase.nightDoctor:
        audioController.playEvent('doctor_wake');
        break;
      case GamePhase.nightCommissar:
        audioController.playEvent('commissar_wake');
        break;
      case GamePhase.morning:
        audioController.playEvent('day_start');
        break;
      case GamePhase.dayVoting:
        audioController.playEvent('vote_start');
        break;
      default:
        break;
    }
  }

  List<String> _getTiedPlayers() {
    final votes = _state.currentVotes;
    if (votes == null || votes.isEmpty) return [];

    final counts = <String, int>{};
    for (var targetId in votes.values) {
      counts[targetId] = (counts[targetId] ?? 0) + 1;
    }

    int maxVotes = 0;
    counts.forEach((id, count) {
      if (count > maxVotes) maxVotes = count;
    });

    if (maxVotes == 0) return [];

    return counts.entries
        .where((e) => e.value == maxVotes)
        .map((e) => e.key)
        .toList();
  }

  bool _checkWinCondition() {
    final winResult = winDetector.checkWinCondition(_state.players);
    if (winResult != null) {
      _state = _state.copyWith(phase: GamePhase.gameOver);
      
      _recordStats(winResult.winner);
      
      websocketController.broadcast({
        'type': 'game_over',
        'result': winResult.message,
      });
      return true;
    }
    return false;
  }

  void _recordStats(Faction winner) {
    storageService.incrementStat('games_played');
    storageService.incrementStat('wins_${winner.name}');
  }

  void _startTimerForPhase() {
    int duration = 60; 
    switch (_state.phase) {
      case GamePhase.dayDiscussion:
        duration = _state.config.discussionTime;
        break;
      case GamePhase.dayVoting:
        duration = _state.config.votingTime;
        break;
      case GamePhase.dayDefense:
        duration = _state.config.defenseTime;
        break;
      case GamePhase.nightMafia:
        duration = _state.config.mafiaActionTime;
        break;
      default:
        duration = _state.config.otherActionTime;
    }
    
    _state = _state.copyWith(timerSecondsRemaining: duration);
    _state = _state.copyWith(timerSecondsRemaining: duration);
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state.isPaused) return;
      
      final remaining = (_state.timerSecondsRemaining ?? 0) - 1;
      _state = _state.copyWith(timerSecondsRemaining: remaining);
      
      // Audio announcements
      if (remaining == 30) {
        audioController.playEvent('timer_30sec');
      } else if (remaining == 20) {
        audioController.playEvent('timer_20sec');
      } else if (remaining == 10) {
        audioController.playEvent('timer_10sec');
      } else if (remaining <= 10 && remaining > 0) {
        final keyMap = {
          10: 'ten', 9: 'nine', 8: 'eight', 7: 'seven', 6: 'six',
          5: 'five', 4: 'four', 3: 'three', 2: 'two', 1: 'one'
        };
        if (keyMap.containsKey(remaining)) {
          audioController.playEvent('countdown_${keyMap[remaining]}');
        }
      }

      if (remaining <= 0) {
        timer.cancel();
        advancePhase();
      } else {
        websocketController.broadcast({'type': 'timer_update', 'seconds': remaining});
      }
    });
  }

  void resolveNightActions() {
    final actions = _state.pendingActions;
    gameLogger.logDetailed('Resolving night actions: ${actions.length} received');
    final players = List<Player>.from(_state.players);
    final blockedIds = <String>{};
    final killedIds = <String>{};
    final healedIds = <String>{};

    for (var action in actions.where((a) => a.type == 'prostitute_block')) {
      if (action.targetId != null) blockedIds.add(action.targetId!);
    }

    // 2. Mafia kill (with Don and Blind Mode logic)
    final mafiaActions = actions.where((a) => a.type == 'mafia_kill').toList();
    if (mafiaActions.isNotEmpty) {
      final livingMafia = players.where((p) => p.isAlive && p.role.type == RoleType.mafia).toList();
      
      bool mafiaBlocked = false;
      if (_state.config.donMechanicsEnabled) {
        final don = livingMafia.firstWhereOrNull((p) => (p.role as MafiaRole).isDon);
        if (don != null && blockedIds.contains(don.id)) {
          mafiaBlocked = true;
          gameLogger.logDetailed('Mafia blocked: Don ${don.nickname} was visited by Prostitute.');
        }
      }

      if (!mafiaBlocked) {
        if (_state.config.mafiaBlindMode) {
          final targetCounts = <String, int>{};
          for (var action in mafiaActions) {
            if (!blockedIds.contains(action.performerId) && action.targetId != null) {
              targetCounts[action.targetId!] = (targetCounts[action.targetId!] ?? 0) + 1;
            }
          }
          
          final consensusTargetId = targetCounts.entries.firstWhereOrNull((e) => e.value == livingMafia.length)?.key;
          if (consensusTargetId != null) {
            killedIds.add(consensusTargetId);
          } else {
            gameLogger.logPublic('Mafia could not reach a consensus tonight.');
          }
        } else {
          for (var action in mafiaActions) {
            if (!blockedIds.contains(action.performerId) && action.targetId != null) {
              killedIds.add(action.targetId!);
              break;
            }
          }
        }
      }
    }

    for (var action in actions.where((a) => a.type == 'maniac_kill')) {
      if (!blockedIds.contains(action.performerId) && action.targetId != null) {
        killedIds.add(action.targetId!);
      }
    }

    for (var action in actions.where((a) => a.type == 'doctor_heal')) {
      if (!blockedIds.contains(action.performerId) && action.targetId != null) {
        healedIds.add(action.targetId!);
      }
    }

    final actualKilledIds = killedIds.where((id) => !healedIds.contains(id)).toSet();
    final eventLogs = <String>[];

    for (var i = 0; i < players.length; i++) {
      if (actualKilledIds.contains(players[i].id)) {
        players[i] = players[i].copyWith(isAlive: false);
        final log = "Morning begins. ${players[i].nickname} was found dead.";
        eventLogs.add(log);
        gameLogger.logPublic(log);
        gameLogger.logDetailed('Player ${players[i].nickname} died.');
      }
    }

    if (actualKilledIds.isEmpty) {
      final log = "Morning begins. Everyone is alive.";
      eventLogs.add(log);
      gameLogger.logPublic(log);
      gameLogger.logDetailed('No one died tonight.');
    }

    for (var action in actions.where((a) => a.type == 'commissar_check')) {
      if (!blockedIds.contains(action.performerId) && action.targetId != null) {
        final target = players.firstWhere((p) => p.id == action.targetId);
        final isMafia = target.role.faction == Faction.mafia;
        websocketController.sendToClient(action.performerId, {
          'type': 'check_result',
          'target_id': action.targetId,
          'is_mafia': isMafia,
        });
      }
    }

    _state = _state.copyWith(
      players: players,
      pendingActions: [],
      publicEventLog: [..._state.publicEventLog, ...eventLogs],
    );
  }

  void _executeVotedPlayer() {
    final votes = _state.currentVotes;
    if (votes == null || votes.isEmpty) {
        _state = _state.copyWith(
            publicEventLog: [..._state.publicEventLog, "The town did not vote. Nobody was executed."],
            currentVotes: {},
        );
        return;
    }

    final counts = <String, int>{};
    for (var targetId in votes.values) {
        counts[targetId] = (counts[targetId] ?? 0) + 1;
    }

    int maxVotes = 0;
    String? targetId;
    bool isTie = false;

    counts.forEach((id, count) {
        if (count > maxVotes) {
            maxVotes = count;
            targetId = id;
            isTie = false;
        } else if (count == maxVotes) {
            isTie = true;
        }
    });

    if (!isTie && targetId != null) {
        final players = List<Player>.from(_state.players);
        final index = players.indexWhere((p) => p.id == targetId);
        if (index != -1) {
            players[index] = players[index].copyWith(isAlive: false);
            final log = "${players[index].nickname} was executed by the town.";
            gameLogger.logPublic(log);
            gameLogger.logDetailed('Execution: ${players[index].nickname} dead.');
            _state = _state.copyWith(
                players: players,
                publicEventLog: [..._state.publicEventLog, log],
                currentVotes: {},
            );
        }
    } else {
        const log = "The town reached a tie. Nobody was executed.";
        gameLogger.logPublic(log);
        gameLogger.logDetailed('No execution (Tie).');
        _state = _state.copyWith(
            publicEventLog: [..._state.publicEventLog, log],
            currentVotes: {},
        );
    }
  }

  List<Role> distributeRoles(int playerCount, GameConfig config) {
    final roles = <Role>[];
    int mafiaCount = config.mafiaCount ?? (playerCount / 4).floor();
    if (mafiaCount < 1) mafiaCount = 1;
    
    for (var i = 0; i < mafiaCount; i++) {
      roles.add(MafiaRole(isDon: config.donMechanicsEnabled && i == 0));
    }
    
    roles.add(const CommissarRole());
    if (config.prostituteEnabled) roles.add(const ProstituteRole());
    if (config.maniacEnabled) roles.add(const ManiacRole());
    roles.add(const DoctorRole());
    
    final remaining = playerCount - roles.length;
    for (var i = 0; i < remaining; i++) {
      roles.add(const CivilianRole());
    }
    
    return roles;
  }

  void pauseGame() {
    _state = _state.copyWith(isPaused: !_state.isPaused);
    gameLogger.logPublic(_state.isPaused ? 'Game paused.' : 'Game resumed.');
    websocketController.broadcast({
      'type': _state.isPaused ? 'game_paused' : 'game_resumed',
    });
  }

  void stopGame() {
    _phaseTimer?.cancel();
    _state = _state.copyWith(phase: GamePhase.gameOver);
    gameLogger.logPublic('Game stopped by host.');
    websocketController.broadcast({'type': 'game_over', 'result': 'Stopped by host'});
  }
}
