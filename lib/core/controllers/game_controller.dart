import 'dart:async';
import 'dart:math';
import 'package:collection/collection.dart';
import 'audio_controller.dart';
import 'websocket_controller.dart';
import 'theme_controller.dart';
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
    required this.themeController,
  }) {
    websocketController.onMessageReceived = _handleMessage;
    websocketController.onConnectionLost = _handleConnectionLost;
    _startHeartbeatMonitor();
  }

  GameState get _state => stateNotifier.currentState;
  set _state(GameState newState) => stateNotifier.updateState(newState);
  
  Timer? _phaseTimer;

  Future<void> init() async {
    await themeController.initializeThemes();
    try {
      final theme = await themeController.selectTheme('default');
      audioController.loadTheme(theme);
      audioController.playBackgroundMusic(GamePhase.lobby);
    } catch (e) {
      gameLogger.logDetailed('Failed to load default theme: $e');
    }
  }

  void _startHeartbeatMonitor() {
    Timer.periodic(const Duration(seconds: 10), (timer) {
      final now = DateTime.now();
      final players = List<Player>.from(_state.players);
      bool changed = false;

      for (var i = 0; i < players.length; i++) {
        if (players[i].isConnected && players[i].lastHeartbeat != null) {
          final diff = now.difference(players[i].lastHeartbeat!);
          if (diff.inSeconds > 20) {
            players[i] = players[i].copyWith(isConnected: false);
            changed = true;
            gameLogger.logDetailed('Player ${players[i].nickname} timed out (No heartbeat).');
          }
        }
      }

      if (changed) {
        _state = _state.copyWith(players: players);
      }
    });
  }
  
  final AudioController audioController;
  final WebSocketController websocketController;
  final WinDetector winDetector;
  final GameLogger gameLogger;
  final GameStateNotifier stateNotifier;
  final StorageService storageService;
  final ThemeController themeController;

  void _handleMessage(String senderId, Map<String, dynamic> message) {
    final type = message['type'] as String?;
    switch (type) {
      case 'player_joined':
        _handlePlayerJoin(senderId, message);
        break;
      case 'player_reconnect':
        _handlePlayerReconnect(senderId, message);
        break;
      case 'player_action':
        final rawAction = message['action'];
        if (rawAction is Map) {
          final actionMap = Map<String, dynamic>.from(rawAction);
          actionMap['performerId'] = senderId;
          handlePlayerAction(senderId, PlayerAction.fromJson(actionMap));
        }
        break;
      case 'heartbeat':
        _handleHeartbeat(senderId);
        break;
    }
  }

  void _handleHeartbeat(String senderId) {
    final players = List<Player>.from(_state.players);
    final index = players.indexWhere((p) => p.id == senderId);
    if (index != -1) {
      players[index] = players[index].copyWith(
        isConnected: true,
        lastHeartbeat: DateTime.now(),
      );
      _state = _state.copyWith(players: players);
    }
  }

  void _handleConnectionLost(String senderId) {
    final players = List<Player>.from(_state.players);
    final index = players.indexWhere((p) => p.id == senderId);
    if (index != -1) {
      players[index] = players[index].copyWith(isConnected: false);
      _state = _state.copyWith(players: players);
      gameLogger.logDetailed('Connection lost with player: ${players[index].nickname}');
    }
  }

  void _handlePlayerReconnect(String senderId, Map<String, dynamic> message) {
    final oldPlayerId = message['player_id'] as String?;
    final token = message['session_token'] as String?;
    final sid = message['game_session_id'] as String?;

    if (oldPlayerId != null && token != null) {
      if (sid != _state.sessionId) {
        websocketController.sendToClient(senderId, {
          'type': 'error',
          'message': 'Wrong game session',
        });
        return;
      }
      if (websocketController.validateSession(oldPlayerId, token)) {
        gameLogger.logDetailed('Player $oldPlayerId reconnected with new connection $senderId');
        
        final channel = websocketController.getConnection(senderId);
        if (channel != null) {
           websocketController.rebindConnection(senderId, oldPlayerId, channel);
           
           websocketController.sendToClient(oldPlayerId, {
             'type': 'join_success',
             'player_id': oldPlayerId,
             'session_token': token,
           });
           websocketController.syncClientState(oldPlayerId, _state);
           return;
        }
      }
    }
    
    // If reconnection fails, treat as new join or send error?
    websocketController.sendToClient(senderId, {
      'type': 'error',
      'message': 'Reconnection failed',
    });
  }

  Future<void> handlePlayerAction(String senderId, PlayerAction action) async {
    final sender = _state.players.firstWhere((p) => p.id == senderId);
    if (!sender.isAlive) return;

    if (action.type == 'ready_to_vote' || action.type == 'toggle_ready') {
      final players = List<Player>.from(_state.players);
      final index = players.indexWhere((p) => p.id == senderId);
      if (index != -1) {
        players[index] = players[index].copyWith(isReadyToVote: !players[index].isReadyToVote);
        _state = _state.copyWith(players: players);
        
        final livingPlayers = players.where((p) => p.isAlive).toList();
        final readyPlayers = livingPlayers.where((p) => p.isReadyToVote).toList();
        
        if (readyPlayers.length == livingPlayers.length) {
          gameLogger.logPublic('All players are ready.');
          advancePhase();
        } else {
          websocketController.broadcast({'type': 'state_update', 'state': _state.toJson()});
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
      
      final players = List<Player>.from(_state.players);
      final index = players.indexWhere((p) => p.id == senderId);
      if (index != -1) {
        players[index] = players[index].copyWith(hasActed: true);
      }

      _state = _state.copyWith(currentVotes: votes, players: players);

      // Visibility for Mafia team
      if (_state.phase == GamePhase.nightMafia) {
          final mafiaFamily = players.where((p) => p.role.faction == Faction.mafia).toList();
          for (var member in mafiaFamily) {
              websocketController.sendToClient(member.id, {
                  'type': 'team_votes_update',
                  'votes': votes,
              });
          }
      }
      return;
    }

    if (action.type == 'verdict') {
      if (_state.phase != GamePhase.dayVerdict) return;
      final verdicts = Map<String, bool>.from(_state.currentVerdicts ?? {});
      final decision = action.targetId == 'execute';
      verdicts[senderId] = decision;

      final players = List<Player>.from(_state.players);
      final index = players.indexWhere((p) => p.id == senderId);
      if (index != -1) {
        players[index] = players[index].copyWith(hasActed: true);
      }

      _state = _state.copyWith(currentVerdicts: verdicts, players: players);
      return;
    }

    if (action.type == 'end_speech') {
      if (_state.phase != GamePhase.dayDefense) return;
      if (_state.speakerId != senderId) return;
      
      gameLogger.logPublic('Player ${sender.nickname} ended their speech early.');
      advancePhase();
      return;
    }

    if (action.type == 'doctor_heal') {
        if (!_state.config.doctorCanHealSelf && action.targetId == senderId) {
            websocketController.sendToClient(senderId, {
                'type': 'error',
                'message': 'You cannot heal yourself!',
            });
            return;
        }
        if (!_state.config.doctorCanHealSameTargetConsecutively && action.targetId == _state.lastDoctorTargetId) {
             websocketController.sendToClient(senderId, {
                'type': 'error',
                'message': 'You cannot heal the same person twice in a row!',
            });
            return;
        }
    }

    if (action.type == 'mafia_kill') {
        if (_state.config.donMechanicsEnabled) {
            final livingDon = _state.players.firstWhereOrNull((p) => p.isAlive && p.role is MafiaRole && (p.role as MafiaRole).isDon);
            if (livingDon != null && senderId != livingDon.id) {
                // There is a living Don, and this is not him.
                // He cannot choose a target if Don is active and alive.
                return;
            }
        }
    }

    final updatedActions = List<PlayerAction>.from(_state.pendingActions);
    updatedActions.removeWhere((a) => a.performerId == senderId);
    updatedActions.add(action.copyWith(performerId: senderId));

    _state = _state.copyWith(
      pendingActions: updatedActions,
    );

    // Immediate resolution for Commissar/Sergeant checks/kills
    if (action.type == 'commissar_check' || action.type == 'commissar_kill') {
      final isSergeant = sender.role.type == RoleType.sergeant;
      final isCommissar = sender.role.type == RoleType.commissar;
      
      // Strict separation: Sergeant checks, Commissar kills
      if (isSergeant && action.type != 'commissar_check') return;
      if (isCommissar && action.type != 'commissar_kill' && _state.players.any((p) => p.role.type == RoleType.sergeant)) {
          // If Sergeant is in the game (even if dead), Commissar can't check? 
          // User said "When sergeant is in game, he does checks, commissar kills".
          // And "If sergeant or commissar dies, the other doesn't take his role".
          // This implies the restriction remains even after death.
          return;
      }

      // Update hasActed immediately
      final players = List<Player>.from(_state.players);
      final index = players.indexWhere((p) => p.id == senderId);
      if (index != -1) {
        players[index] = players[index].copyWith(hasActed: true);
      }
      _state = _state.copyWith(players: players);

      if (action.type == 'commissar_check') {
        final target = _state.players.firstWhereOrNull((p) => p.id == action.targetId);
        if (target != null) {
          gameLogger.logDetailed("Commissar/Sergeant investigated Player ${target.number}");
          final isMafia = target.role.faction == Faction.mafia;
          final message = {
            'type': 'check_result',
            'target_id': action.targetId,
            'is_mafia': isMafia,
          };
          
          // Send to both Commissar and Sergeant
          final activePolice = _state.players.where((p) => p.role.type == RoleType.commissar || p.role.type == RoleType.sergeant).toList();
          for (var cop in activePolice) {
            websocketController.sendToClient(cop.id, message);
          }
          
          // Reduce timer to 30s for review
          if ((_state.timerSecondsRemaining ?? 0) > 30) {
            _state = _state.copyWith(timerSecondsRemaining: 30);
            websocketController.broadcast({'type': 'timer_update', 'seconds': 30});
          }
        }
      } else if (action.type == 'commissar_kill') {
        final target = _state.players.firstWhereOrNull((p) => p.id == action.targetId);
        gameLogger.logDetailed('Commissar targeted Player ${target?.number ?? "unknown"} for kill. Ending phase.');
        advancePhase();
        return;
      }
    }

    if (action.type == 'lawyer_check') {
      if (sender.role.type != RoleType.lawyer) return;
      
      final target = _state.players.firstWhereOrNull((p) => p.id == action.targetId);
      if (target != null) {
        final isActiveTown = target.role.type == RoleType.commissar || target.role.type == RoleType.sergeant;
        gameLogger.logDetailed("Lawyer investigated Player ${target.number} (Result: $isActiveTown)");
        
        final message = {
          'type': 'lawyer_check_result',
          'target_id': action.targetId,
          'is_active_town': isActiveTown,
        };
        
        // Send to the entire Mafia team
        final mafiaFamily = _state.players.where((p) => p.role.faction == Faction.mafia).toList();
        for (var member in mafiaFamily) {
          websocketController.sendToClient(member.id, message);
        }
        
        // Also update hasActed
        final players = List<Player>.from(_state.players);
        final index = players.indexWhere((p) => p.id == senderId);
        if (index != -1) {
          players[index] = players[index].copyWith(hasActed: true);
        }
        _state = _state.copyWith(players: players);
        _checkAndAdvanceNightPhase();
      }
      return;
    }

    if (action.type == 'don_check') {
      if (!(sender.role is MafiaRole && (sender.role as MafiaRole).isDon)) return;

      final target = _state.players.firstWhereOrNull((p) => p.id == action.targetId);
      if (target != null) {
          final isCommissar = target.role.type == RoleType.commissar;
          gameLogger.logDetailed("Don investigated Player ${target.number} (Result: $isCommissar)");

          final message = {
              'type': 'don_check_result',
              'target_id': action.targetId,
              'is_commissar': isCommissar,
          };

          // Send to the entire Mafia team
          final mafiaFamily = _state.players.where((p) => p.role.faction == Faction.mafia).toList();
          for (var member in mafiaFamily) {
              websocketController.sendToClient(member.id, message);
          }
      }
      return;
    }

    if (action.type == 'commissar_ready') {
      if (_state.phase != GamePhase.nightCommissar) return;
      gameLogger.logDetailed('Police are ready. Ending phase early.');
      advancePhase();
      return;
    }


    // Sync Mode Support: Broadcast Mafia votes to other Mafia members
    // If Don mechanics are DISABLED, we always sync Mafia votes for consensus
    if (action.type == 'mafia_kill' && !_state.config.donMechanicsEnabled) {
      final mafiaMembers = _state.players.where((p) => p.role.type == RoleType.mafia).map((p) => p.id).toSet();
      for (var memberId in mafiaMembers) {
        websocketController.sendToClient(memberId, {
          'type': 'mafia_sync_update',
          'actions': updatedActions.where((a) => a.type == 'mafia_kill').map((a) => a.toJson()).toList(),
        });
      }
    }

    // Set hasActed for the player and check for early phase advancement
    final updatedPlayersWithAction = List<Player>.from(_state.players);
    final senderIndex = updatedPlayersWithAction.indexWhere((p) => p.id == senderId);
    if (senderIndex != -1) {
      updatedPlayersWithAction[senderIndex] = updatedPlayersWithAction[senderIndex].copyWith(hasActed: true);
      _state = _state.copyWith(players: updatedPlayersWithAction);
      _checkAndAdvanceNightPhase();
    }
  }

  void _checkAndAdvanceNightPhase() {
    final phase = _state.phase;
    if (!phase.name.toLowerCase().contains('night')) return;

    final livingPlayers = _state.players.where((p) => p.isAlive).toList();
    
    bool allReady = false;
    if (phase == GamePhase.nightMafia) {
      final mafiaAndLawyer = livingPlayers.where((p) => p.role.faction == Faction.mafia).toList();
      allReady = mafiaAndLawyer.every((p) => p.hasActed);
    } else if (phase == GamePhase.nightProstitute) {
      allReady = livingPlayers.where((p) => p.role.type == RoleType.prostitute).every((p) => p.hasActed);
    } else if (phase == GamePhase.nightManiac) {
      allReady = livingPlayers.where((p) => p.role.type == RoleType.maniac).every((p) => p.hasActed);
    } else if (phase == GamePhase.nightDoctor) {
      allReady = livingPlayers.where((p) => p.role.type == RoleType.doctor).every((p) => p.hasActed);
    } else if (phase == GamePhase.nightPoisoner) {
      allReady = livingPlayers.where((p) => p.role.type == RoleType.poisoner).every((p) => p.hasActed);
    } else if (phase == GamePhase.nightCommissar) {
      final police = livingPlayers.where((p) => p.role.type == RoleType.commissar || p.role.type == RoleType.sergeant).toList();
      allReady = police.every((p) => p.hasActed);
    }

    if (allReady) {
      gameLogger.logDetailed('All required players for $phase have acted. Advancing phase.');
      advancePhase();
    }
  }

  void removePlayer(String playerId) {
    if (_state.phase != GamePhase.lobby) return; // Only allow removing in lobby
    
    final players = List<Player>.from(_state.players);
    players.removeWhere((p) => p.id == playerId);
    
    // Re-index player numbers
    for (var i = 0; i < players.length; i++) {
      players[i] = players[i].copyWith(number: i + 1);
    }
    
    _state = _state.copyWith(players: players);
    gameLogger.logDetailed('Player removed: $playerId');
  }

  void addPlayer(Player player) {
    _state = _state.copyWith(players: [..._state.players, player]);
  }

  String _generateSessionId() {
    final rand = Random();
    return List.generate(6, (_) => (rand.nextInt(10)).toString()).join();
  }

  void resetGame() {
    audioController.stopBackgroundMusic();
    audioController.playBackgroundMusic(GamePhase.lobby);
    
    _state = GameState(
      sessionId: _generateSessionId(),
      phase: GamePhase.lobby,
      config: _state.config,
      players: _state.players.map((p) => p.copyWith(
        isAlive: true,
        hasActed: false,
        isReadyToVote: false,
      )).toList(),
      pendingActions: [],
      currentVotes: {},
      currentVerdicts: {},
    );
    stateNotifier.updateState(_state);
    websocketController.broadcast({'type': 'state_update', 'state': _state.toJson()});
  }

  void terminateSession() {
    audioController.stopBackgroundMusic();
    websocketController.broadcast({'type': 'game_terminated'});
  }

  Future<void> startGame(GameConfig config) async {
    gameLogger.reset();
    gameLogger.logDetailed('Game started with ${_state.players.length} players');
    gameLogger.logDetailed('Config: $config');

    // Load theme
    try {
      String themeId = config.themeId;
      if (themeId == 'default' && config.locale == 'ru') {
        themeId = 'default_rus';
      }
      final theme = await themeController.selectTheme(themeId);
      await audioController.loadTheme(theme);
      gameLogger.logDetailed('Loaded theme: ${theme.name}');
      await _playEvent('game_start');
    } catch (e) {
      gameLogger.logDetailed('Error loading theme: $e', level: 1000);
    }

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
        lastDoctorTargetId: null,
        pendingActions: [],
        currentVotes: {},
        currentVerdicts: {},
        verdictTargetId: null,
        defenseQueue: [],
        speakerId: null,
        publicEventLog: [],
        detailedLog: [],
    );
    
    websocketController.broadcast({'type': 'state_update', 'state': _state.toJson()});
  }
  
  void _handlePlayerJoin(String senderId, Map<String, dynamic> message) {
    if (_state.phase != GamePhase.lobby) {
      websocketController.sendToClient(senderId, {
        'type': 'error',
        'message': 'Game already in progress',
      });
      return;
    }
    
    final sid = message['game_session_id'] as String?;
    if (sid != null && sid != _state.sessionId) {
      websocketController.sendToClient(senderId, {
        'type': 'error',
        'message': 'Wrong game session',
      });
      return;
    }
    
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

  Future<void> advancePhase() async {
    _phaseTimer?.cancel();
    
    // Reset player readiness
    final players = _state.players.map((p) => p.copyWith(isReadyToVote: false)).toList();
    _state = _state.copyWith(players: players);

    gameLogger.logDetailed('Advancing phase from ${_state.phase} to ...');
    
    // Trigger sleep audio for previous phase
    await _triggerSleepAudio(_state.phase);

    switch (_state.phase) {
      case GamePhase.lobby:
      case GamePhase.setup:
        _moveToPhase(GamePhase.roleReveal);
        break;
      case GamePhase.roleReveal:
        _moveToPhase(GamePhase.nightProstitute);
        break;
      case GamePhase.nightProstitute:
        _moveToPhase(GamePhase.nightPoisoner);
        break;
      case GamePhase.nightPoisoner:
        _moveToPhase(GamePhase.nightMafia);
        break;
      case GamePhase.nightMafia:
        _moveToPhase(GamePhase.nightCommissar);
        break;
      case GamePhase.nightCommissar:
        _moveToPhase(GamePhase.nightManiac);
        break;
      case GamePhase.nightManiac:
        _moveToPhase(GamePhase.nightDoctor);
        break;
      case GamePhase.nightDoctor:
        _moveToPhase(GamePhase.morning);
        break;
      case GamePhase.morning:
        _moveToPhase(GamePhase.dayDiscussion);
        break;
      case GamePhase.dayDiscussion:
        _moveToPhase(GamePhase.dayVoting);
        break;
      case GamePhase.dayVoting:
        final tiedIds = _getTiedPlayers();
        if (tiedIds.length > 1) {
          gameLogger.logPublic('VOTES TIED: Players ${tiedIds.map((id) => _state.players.firstWhere((p) => p.id == id).number).join(", ")} will defend.');
          _state = _state.copyWith(
            defenseQueue: tiedIds,
            speakerId: tiedIds.first,
          );
          _moveToPhase(GamePhase.dayDefense);
        } else if (tiedIds.isNotEmpty) {
          _state = _state.copyWith(verdictTargetId: tiedIds.first);
          _moveToPhase(GamePhase.dayVerdict);
        } else {
          gameLogger.logPublic('NO VOTES: Nobody was accused.');
          _moveToPhase(GamePhase.nightMafia);
          _state = _state.copyWith(
            currentNightNumber: (_state.currentNightNumber ?? 1) + 1,
            currentDayNumber: (_state.currentDayNumber ?? 1) + 1,
          );
        }
        break;
      case GamePhase.dayDefense:
        final queue = List<String>.from(_state.defenseQueue);
        if (queue.isNotEmpty) {
          queue.removeAt(0);
        }
        
        if (queue.isNotEmpty) {
          _state = _state.copyWith(
            defenseQueue: queue,
            speakerId: queue.first,
          );
          // Reset timer for the next speaker
          _startTimerForPhase(); 
          websocketController.broadcast({'type': 'state_update', 'state': _state.toJson()});
          return; // Don't advance phase yet, just reset timer and update speaker
        } else {
          _state = _state.copyWith(
            defenseQueue: [],
            speakerId: null,
          );
          _moveToPhase(GamePhase.dayVerdict);
        }
        break;
      case GamePhase.dayVerdict:
        _executeVotedPlayer();
        _moveToPhase(GamePhase.nightMafia);
        _state = _state.copyWith(
          currentNightNumber: (_state.currentNightNumber ?? 1) + 1,
          currentDayNumber: (_state.currentDayNumber ?? 1) + 1,
        );
        break;
      case GamePhase.gameOver:
        return;
    }
    gameLogger.logDetailed('New phase: ${_state.phase}');
    
    // Only check win condition if we are NOT starting the morning.
    // This allows the morning reveal to happen before the game ends.
    if (_state.phase != GamePhase.morning) {
      if (await _checkWinCondition()) return;
    }
    
    await _triggerPhaseAudio();
    if (_state.phase == GamePhase.morning) {
      await resolveNightActions();
    }
    _startTimerForPhase();
    websocketController.broadcast({'type': 'phase_changed', 'phase': _state.phase.name});
    websocketController.broadcast({'type': 'state_update', 'state': _state.toJson()});

    // If we just entered morning, we might want to check win condition 
    // BUT we wait for the next advance before actually ending, 
    // so the host can announce results.
  }

  void _moveToPhase(GamePhase phase) {
    GamePhase next = phase;

    // Phase Skipping Logic: Skip turns of dead active roles
    if (next == GamePhase.nightProstitute &&
        !_state.players.any(
            (p) => p.isAlive && p.role.type == RoleType.prostitute)) {
      _moveToPhase(GamePhase.nightPoisoner);
      return;
    }
    if (next == GamePhase.nightPoisoner &&
        !_state.players.any((p) => p.isAlive && p.role.type == RoleType.poisoner)) {
      _moveToPhase(GamePhase.nightMafia);
      return;
    }
    // Mafia doesn't usually skip unless all dead, but Mafia is mandatory in roles.
    // However, if all mafia are dead, game should be over.
    if (next == GamePhase.nightMafia &&
        !_state.players.any((p) => p.isAlive && p.role.faction == Faction.mafia)) {
      _moveToPhase(GamePhase.nightCommissar);
      return;
    }
    if (next == GamePhase.nightCommissar &&
        !_state.players.any(
            (p) => p.isAlive && (p.role.type == RoleType.commissar || p.role.type == RoleType.sergeant))) {
      _moveToPhase(GamePhase.nightManiac);
      return;
    }
    if (next == GamePhase.nightManiac &&
        !_state.players.any((p) => p.isAlive && p.role.type == RoleType.maniac)) {
      _moveToPhase(GamePhase.nightDoctor);
      return;
    }
    if (next == GamePhase.nightDoctor &&
        !_state.players.any((p) => p.isAlive && p.role.type == RoleType.doctor)) {
      _moveToPhase(GamePhase.morning);
      return;
    }

    _state = _state.copyWith(
      phase: next,
      players: _state.players.map((p) => p.copyWith(hasActed: false)).toList(),
    );

    // Cleanup/Initialization for specific phases
    if (next == GamePhase.dayVoting) {
      _state = _state.copyWith(currentVotes: {});
    }
    if (next == GamePhase.dayVerdict) {
      _state = _state.copyWith(currentVerdicts: {});
    }
  }

  Future<void> _triggerPhaseAudio() async {
    audioController.playBackgroundMusic(_state.phase);
    String? text;
    switch (_state.phase) {
      case GamePhase.roleReveal:
        text = await audioController.playEvent('role_reveal');
        break;
      case GamePhase.nightProstitute:
        text = await audioController.playCompositeEvent(['night_start', 'prostitute_wake', 'prostitute_action']);
        break;
      case GamePhase.nightPoisoner:
        text = await audioController.playCompositeEvent(['poisoner_wake', 'poisoner_action']);
        break;
      case GamePhase.nightMafia:
        List<String> events = [];
        final lawyerAlive = _state.players.any((p) => p.isAlive && p.role.type == RoleType.lawyer);
        final mafiaAlive = _state.players.any((p) => p.isAlive && p.role is MafiaRole); // Includes Don and regular Mafia
        
        if (_state.currentNightNumber == 1) {
          if (mafiaAlive && lawyerAlive) {
            events.add('mafia_lawyer_meet');
          } else {
            events.add('mafia_meet');
          }
        } else {
          if (mafiaAlive && lawyerAlive) {
            events.add('mafia_lawyer_wake');
          } else if (mafiaAlive) {
            events.add('mafia_wake');
          } else if (lawyerAlive) {
            events.add('lawyer_wake');
          }
        }
        
        // Actions
        if (mafiaAlive) {
          if (_state.config.donMechanicsEnabled && _state.players.any((p) => p.isAlive && p.role is MafiaRole && (p.role as MafiaRole).isDon)) {
            events.add('don_action');
          } else {
            events.add('mafia_action');
          }
        }
        
        if (lawyerAlive) {
          events.add('lawyer_action');
        }
        
        text = await audioController.playCompositeEvent(events);
        break;
      case GamePhase.nightCommissar:
        final sergeantAlive = _state.players.any((p) => p.isAlive && p.role.type == RoleType.sergeant);
        final commissarAlive = _state.players.any((p) => p.isAlive && p.role.type == RoleType.commissar);
        
        List<String> events = [];
        if (commissarAlive && sergeantAlive) {
          events.add('commissar_sergeant_wake');
        } else if (commissarAlive) {
          events.add('commissar_wake');
        } else if (sergeantAlive) {
          events.add('sergeant_wake');
        }
        
        if (commissarAlive) {
          events.add('commissar_action');
        }
        if (sergeantAlive) {
          events.add('sergeant_action');
        }
        text = await audioController.playCompositeEvent(events);
        break;
      case GamePhase.nightManiac:
        text = await audioController.playCompositeEvent(['maniac_wake', 'maniac_action']);
        break;
      case GamePhase.nightDoctor:
        text = await audioController.playCompositeEvent(['doctor_wake', 'doctor_action']);
        break;
      case GamePhase.morning:
        text = await audioController.playEvent('day_start');
        break;
      case GamePhase.dayDiscussion:
        text = await audioController.playEvent('discussion_start');
        break;
      case GamePhase.dayVoting:
        text = await audioController.playEvent('voting_start');
        break;
      case GamePhase.dayDefense:
        text = await audioController.playEvent('defense_start');
        break;
      case GamePhase.dayVerdict:
        text = await audioController.playEvent('verdict_start');
        break;
      default:
         break;
    }
    if (text != null) {
      _state = _state.copyWith(statusMessage: text);
    }
  }

  Future<void> _triggerSleepAudio(GamePhase phase) async {
      String? text;
      switch (phase) {
        case GamePhase.nightProstitute:
            text = await audioController.playEvent('prostitute_sleep');
            break;
        case GamePhase.nightPoisoner:
            text = await audioController.playEvent('poisoner_sleep');
            break;
        case GamePhase.nightMafia:
            final lawyerAlive = _state.players.any((p) => p.isAlive && p.role.type == RoleType.lawyer);
            final mafiaAlive = _state.players.any((p) => p.isAlive && p.role is MafiaRole);
            
            if (mafiaAlive && lawyerAlive) {
              text = await audioController.playEvent('mafia_lawyer_sleep');
            } else if (mafiaAlive) {
              text = await audioController.playEvent('mafia_sleep');
            } else if (lawyerAlive) {
              text = await audioController.playEvent('lawyer_sleep');
            }
            break;
        case GamePhase.nightCommissar:
            final sergeantAlive = _state.players.any((p) => p.isAlive && p.role.type == RoleType.sergeant);
            final commissarAlive = _state.players.any((p) => p.isAlive && p.role.type == RoleType.commissar);
            
            if (commissarAlive && sergeantAlive) {
              text = await audioController.playEvent('commissar_sergeant_sleep');
            } else if (commissarAlive) {
              text = await audioController.playEvent('commissar_sleep');
            } else if (sergeantAlive) {
              text = await audioController.playEvent('sergeant_sleep');
            }
            break;
        case GamePhase.nightManiac:
            text = await audioController.playEvent('maniac_sleep');
            break;
        case GamePhase.nightDoctor:
            text = await audioController.playEvent('doctor_sleep');
            break;
        default:
            break; // No sleep audio for other phases
      }
      if (text != null) {
        _state = _state.copyWith(statusMessage: text);
        websocketController.broadcast({'type': 'state_update', 'state': _state.toJson()});
      }
  }

  Future<void> _playEvent(String eventKey) async {
    final text = await audioController.playEvent(eventKey);
    if (text != null) {
      _state = _state.copyWith(statusMessage: text);
      websocketController.broadcast({'type': 'state_update', 'state': _state.toJson()});
    }
  }

  Future<void> _playCompositeEvent(List<String> eventKeys) async {
    final text = await audioController.playCompositeEvent(eventKeys);
    if (text != null) {
      _state = _state.copyWith(statusMessage: text);
      websocketController.broadcast({'type': 'state_update', 'state': _state.toJson()});
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

  Future<bool> _checkWinCondition() async {
    final winResult = winDetector.checkWinCondition(_state.players);
    if (winResult != null) {
      _state = _state.copyWith(phase: GamePhase.gameOver);
      
      switch (winResult.winner) {
        case Faction.town:
          await _playEvent('town_win');
          break;
        case Faction.mafia:
          await _playEvent('mafia_win');
          break;
        case Faction.neutral:
          if (_state.players.any((p) => p.isAlive && p.role.type == RoleType.poisoner)) {
            await _playEvent('poisoner_win');
          } else {
            await _playEvent('maniac_win');
          }
          break;
      }
      
      _recordStats(winResult.winner);
      
      websocketController.broadcast({
        'type': 'game_over',
        'result': winResult.message,
        'logs': gameLogger.detailedLog,
      });
      // CRITICAL: Ensure state_update is sent so PWAs know about the gameOver phase
      websocketController.broadcast({'type': 'state_update', 'state': _state.toJson()});
      return true;
    }
    return false;
  }

  void _recordStats(Faction winner) {
    storageService.incrementStat('games_played');
    if (winner == Faction.neutral) {
        if (_state.players.any((p) => p.isAlive && p.role.type == RoleType.poisoner)) {
            storageService.incrementStat('wins_poisoner');
        } else {
            storageService.incrementStat('wins_maniac');
        }
    } else {
        storageService.incrementStat('wins_${winner.name}');
    }
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
      case GamePhase.roleReveal:
        duration = 60;
        break;
      case GamePhase.morning:
        duration = 15; // Give 15 seconds for morning announcements
        break;
      default:
        duration = _state.config.otherActionTime;
    }
    
    _state = _state.copyWith(timerSecondsRemaining: duration);
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state.isPaused) return;
      
      final remaining = (_state.timerSecondsRemaining ?? 0) - 1;
      _state = _state.copyWith(timerSecondsRemaining: remaining);
      
      // Audio announcements
      if (remaining == 30) {
        _playEvent('timer_30sec'); // Removed await as Timer callback cannot be async
      } else if (remaining == 20) {
        _playEvent('timer_20sec'); // Removed await as Timer callback cannot be async
      } else if (remaining == 10) {
        _playEvent('timer_10sec'); // Removed await as Timer callback cannot be async
      }
      
      if (remaining <= 10 && remaining > 0) {
        final keyMap = {
          9: 'nine', 8: 'eight', 7: 'seven', 6: 'six',
          5: 'five', 4: 'four', 3: 'three', 2: 'two', 1: 'one'
        };
        if (keyMap.containsKey(remaining)) {
          _playEvent('countdown_${keyMap[remaining]}'); // Removed await as Timer callback cannot be async
        }
      }

      if (remaining <= 0) {
        timer.cancel();
        // For morning phase, we might want to stay a bit longer if audio is still playing?
        // But usually advancePhase() will trigger the next step.
        advancePhase();
      } else {
        websocketController.broadcast({'type': 'timer_update', 'seconds': remaining});
      }
    });
  }

  Future<void> resolveNightActions() async {
    // 0. Initial Setup
    final actions = _state.pendingActions;
    gameLogger.logDetailed('Resolving night actions: ${actions.length} received');
    final healedIds = <String>{};
    final blockedIds = <String>{};
    final killedIds = <String>{}; // Stores (targetId)
    final players = List<Player>.from(_state.players);

    // 1. Prostitute blocks
    for (var action in actions.where((a) => a.type == 'prostitute_block')) {
      if (action.targetId != null) blockedIds.add(action.targetId!);
    }

    // 2. Poisoner "Likho" Trap (Immediate Resolution)
    String? poisonedTargetId;
    String? poisonerId;
    final poisonAction = actions.firstWhereOrNull((a) => a.type == 'poison');
    if (poisonAction != null && !blockedIds.contains(poisonAction.performerId)) {
        poisonedTargetId = poisonAction.targetId;
        poisonerId = poisonAction.performerId;
        if (poisonedTargetId != null) {
            killedIds.add(poisonedTargetId);
            gameLogger.logDetailed('Player ${players.firstWhere((p) => p.id == poisonedTargetId).number} was poisoned (Likho target).');
        }
    }

    // 3. Interaction Trap: Check all actions to see if they touched the poisoned target
    final trapVictimIds = <String>{};
    if (poisonedTargetId != null) {
        for (var action in actions) {
            // If someone interacted with the poisoned target, they also die
            if (action.targetId == poisonedTargetId && action.performerId != poisonerId) {
                killedIds.add(action.performerId);
                trapVictimIds.add(action.performerId);
                gameLogger.logDetailed('Player ${players.firstWhere((p) => p.id == action.performerId).number} touched the poisoned target and also died.');
            }
        }
    }

    // 4. Mafia kill
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
        if (!_state.config.donMechanicsEnabled) {
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
            await _playEvent('mafia_miss');
          }
        } else {
          // If NOT blind mode, any kill works, but if there are multiple, usually first one counts or we might need consensus too 
          // depending on exact rules. Assuming "first valid action" applies here as per existing logic.
          // BUT if mafia actions list is empty but mafia are alive, then they missed.
          bool anyAction = false;
          for (var action in mafiaActions) {
            if (!blockedIds.contains(action.performerId) && action.targetId != null) {
              killedIds.add(action.targetId!);
              anyAction = true;
              break;
            }
          }
          if (!anyAction && livingMafia.isNotEmpty) {
             await _playEvent('mafia_miss');
          }
        }
      }
    } else {
       // Mafia actions list empty, but check if mafia are alive
       final livingMafia = players.where((p) => p.isAlive && p.role.type == RoleType.mafia).toList();
       if (livingMafia.isNotEmpty) {
           await _playEvent('mafia_miss');
       }
    }

    for (var action in actions.where((a) => a.type == 'maniac_kill')) {
      if (!blockedIds.contains(action.performerId) && action.targetId != null) {
        killedIds.add(action.targetId!);
      }
    }

    if (_state.config.commissarKills) {
      for (var action in actions.where((a) => a.type == 'commissar_kill')) {
        if (!blockedIds.contains(action.performerId) && action.targetId != null) {
          killedIds.add(action.targetId!);
          gameLogger.logDetailed('Commissar killed Player ${_state.players.firstWhere((p) => p.id == action.targetId).number}');
        }
      }
    }

    String? currentNightDoctorTargetId;
    for (var action in actions.where((a) => a.type == 'doctor_heal')) {
      if (!blockedIds.contains(action.performerId) && action.targetId != null) {
        healedIds.add(action.targetId!);
        currentNightDoctorTargetId = action.targetId;
      }
    }

    // 4. Prostitute Announcements
    for (var action in actions.where((a) => a.type == 'prostitute_block')) {
      if (action.targetId != null) {
        final target = players.firstWhere((p) => p.id == action.targetId);
        await _playCompositeEvent(['prostitute_visit', 'role_name_${target.role.type.name}']);
      }
    }

    // 5. Poisoner Action Announcement (The visit itself)
    if (poisonAction != null && !blockedIds.contains(poisonAction.performerId)) {
        final target = players.firstWhere((p) => p.id == poisonedTargetId);
        await _playCompositeEvent(['poisoner_visit', 'player_${target.number}']);
        gameLogger.logPublic("The Poisoner visited Player ${target.number}.");
    }
    
    // 6. Mafia/Lawyer/Don Checks
    for (var action in actions) {
        if (blockedIds.contains(action.performerId)) continue;
        final target = players.firstWhereOrNull((p) => p.id == action.targetId);
        if (target == null) continue;

        if (action.type == 'lawyer_check') {
            await _playCompositeEvent(['lawyer_visit', 'player_${target.number}']);
            gameLogger.logPublic("Lawyer investigated Player ${target.number}");
        } else if (action.type == 'don_check') {
            await _playCompositeEvent(['don_visit', 'player_${target.number}']);
            gameLogger.logPublic("Don investigated Player ${target.number}");
        }
    }

    // 7. Police Checks (Commissar/Sergeant)
    for (var action in actions) {
        if (blockedIds.contains(action.performerId)) continue;
        final target = players.firstWhereOrNull((p) => p.id == action.targetId);
        if (target == null) continue;

        if (action.type == 'commissar_check') {
            final performer = players.firstWhere((p) => p.id == action.performerId);
            final event = (performer.role.type == RoleType.sergeant) ? 'sergeant_visit' : 'commissar_visit';
            await _playCompositeEvent([event, 'player_${target.number}']);
            gameLogger.logPublic("${performer.role.type == RoleType.sergeant ? 'Sergeant' : 'Commissar'} investigated Player ${target.number}");
        }
    }

    // 8. Maniac Deaths (Announcement of the kill itself if any)
    for (var action in actions.where((a) => a.type == 'maniac_kill')) {
        if (!blockedIds.contains(action.performerId) && action.targetId != null) {
            // We don't reveal the death here yet, just that maniac visited? 
            // Actually usually we just announce deaths at the end.
        }
    }

    // 9. Doctor Announcements
    for (var healId in healedIds) {
        final target = players.firstWhere((p) => p.id == healId);
        if (killedIds.contains(healId)) {
            await _playCompositeEvent(['doctor_heal_success', 'player_${target.number}']);
            gameLogger.logPublic("Doctor saved ${target.nickname}!");
        } else {
            await _playEvent('doctor_heal_fail');
        }
    }

    // 8. Deaths
    final actualKilledIds = killedIds.where((id) => !healedIds.contains(id)).toSet();
    final eventLogs = <String>[];

    for (var i = 0; i < players.length; i++) {
      if (actualKilledIds.contains(players[i].id)) {
        players[i] = players[i].copyWith(isAlive: false);
        final log = "Morning begins. ${players[i].nickname} was found dead.";
        eventLogs.add(log);
        gameLogger.logPublic(log);
        
        bool killedByManiac = actions.any((a) => a.type == 'maniac_kill' && !blockedIds.contains(a.performerId) && a.targetId == players[i].id);
        bool killedByPoison = poisonAction != null && poisonAction.targetId == players[i].id;
        bool killedByTrap = trapVictimIds.contains(players[i].id);

        if (killedByManiac) {
            await _playCompositeEvent(['maniac_kill', 'player_${players[i].number}']);
        } else if (killedByPoison) {
            await _playCompositeEvent(['poison_death', 'player_${players[i].number}']);
        } else if (killedByTrap) {
            await _playCompositeEvent(['role_name_${players[i].role.type.name}', 'poisoner_interaction']);
        } else {
            await _playCompositeEvent(['player_killed', 'player_${players[i].number}']);
        }
      }
    }

    if (actualKilledIds.isEmpty) {
      final log = "Morning begins. Everyone is alive.";
      eventLogs.add(log);
      gameLogger.logPublic(log);
      await _playEvent('nobody_killed');
    }

    _transferDonRoleIfNecessary(players);

    // Check for missed actions (Alive but no action)
    final livingCommissar = players.any((p) => p.isAlive && p.role.type == RoleType.commissar);
    if (livingCommissar) {
        final hasAction = actions.any((a) => a.type == 'commissar_check');
        if (!hasAction) {
            await _playEvent('commissar_miss');
        }
    }

    final livingDoctor = players.any((p) => p.isAlive && p.role.type == RoleType.doctor);
    if (livingDoctor) {
        final hasAction = actions.any((a) => a.type == 'doctor_heal');
        if (!hasAction) {
             await _playEvent('doctor_miss');
        }
    }

    final livingProstitute = players.any((p) => p.isAlive && p.role.type == RoleType.prostitute);
    if (livingProstitute) {
        final hasAction = actions.any((a) => a.type == 'prostitute_block');
        if (!hasAction) {
             await _playEvent('prostitute_miss');
        }
    }

    final livingManiac = players.any((p) => p.isAlive && p.role.type == RoleType.maniac);
    if (livingManiac) {
        final hasAction = actions.any((a) => a.type == 'maniac_kill');
        if (!hasAction) {
             await _playEvent('maniac_miss');
        }
    }

    final livingPoisoner = players.any((p) => p.isAlive && p.role.type == RoleType.poisoner);
    if (livingPoisoner) {
        final hasAction = actions.any((a) => a.type == 'poison');
        if (!hasAction) {
             await _playEvent('poisoner_miss');
        }
    }

    final livingLawyer = players.any((p) => p.isAlive && p.role.type == RoleType.lawyer);
    if (livingLawyer) {
        final hasAction = actions.any((a) => a.type == 'lawyer_check');
        if (!hasAction) {
             await _playEvent('lawyer_miss');
        }
    }

    final livingSergeant = players.any((p) => p.isAlive && p.role.type == RoleType.sergeant);
    if (livingSergeant) {
        final hasAction = actions.any((a) => a.type == 'commissar_check');
        if (!hasAction) {
             await _playEvent('sergeant_miss');
        }
    }

    _state = _state.copyWith(
      players: players,
      pendingActions: [],
      lastDoctorTargetId: currentNightDoctorTargetId,
      publicEventLog: [..._state.publicEventLog, ...eventLogs],
    );
  }

  Future<void> _executeVotedPlayer() async {
    final leaderId = _state.verdictTargetId;
    if (leaderId == null) {
      gameLogger.logDetailed('Execute aborted: No leader identified.');
      return;
    }

    final verdicts = _state.currentVerdicts ?? {};
    final executeVotes = verdicts.values.where((v) => v == true).length;
    final pardonVotes = verdicts.values.where((v) => v == false).length;
    
    final players = List<Player>.from(_state.players);
    final index = players.indexWhere((p) => p.id == leaderId);
    if (index == -1) return;

    if (executeVotes > pardonVotes) {
        // Execute
        players[index] = players[index].copyWith(isAlive: false);
        final log = "${players[index].nickname} was executed by the town ($executeVotes vs $pardonVotes).";
        gameLogger.logPublic(log);
        gameLogger.logDetailed('Execution: ${players[index].nickname} dead.');
        
        await _playCompositeEvent(['execution', 'player_executed', 'player_${players[index].number}']);
        _state = _state.copyWith(
            players: players,
            publicEventLog: [..._state.publicEventLog, log],
            currentVerdicts: {},
            verdictTargetId: null,
        );
        _transferDonRoleIfNecessary(_state.players);
    } else {
        // Pardon
        final log = "${players[index].nickname} was pardoned by the town ($pardonVotes vs $executeVotes).";
        gameLogger.logPublic(log);
        gameLogger.logDetailed('Pardon: ${players[index].nickname} survived.');
        
        await _playEvent('vote_tie'); // Use tie sound for pardon
        _state = _state.copyWith(
            publicEventLog: [..._state.publicEventLog, log],
            currentVerdicts: {},
            verdictTargetId: null,
        );
    }
  }

  List<Role> distributeRoles(int playerCount, GameConfig config) {
    final roles = <Role>[];
    
    // 1. Determine Mafia Count (Classic balance)
    int mafiaCount;
    if (playerCount <= 5) {
      mafiaCount = 1;
    } else if (playerCount <= 8) {
      mafiaCount = 2;
    } else {
      mafiaCount = (playerCount / 3).floor();
    }
    
    if (config.mafiaCount != null) {
      mafiaCount = config.mafiaCount!;
    }
    
    for (var i = 0; i < mafiaCount; i++) {
      roles.add(MafiaRole(isDon: config.donMechanicsEnabled && i == 0));
    }
    
    // Helper to check if role should be added
    bool shouldAdd(bool enabled, int minPlayers) {
      if (!enabled) return false;
      if (!config.autoPruningEnabled) return true;
      return playerCount >= minPlayers;
    }

    // 2. Active Town Roles
    if (shouldAdd(config.commissarEnabled, 3)) {
      roles.add(const CommissarRole());
    }
    
    if (shouldAdd(config.doctorEnabled, 4)) {
      roles.add(const DoctorRole());
    }

    if (shouldAdd(config.prostituteEnabled, 5)) {
      roles.add(const ProstituteRole());
    }

    if (shouldAdd(config.sergeantEnabled, 6)) {
      roles.add(const SergeantRole());
    }

    if (shouldAdd(config.lawyerEnabled, 7)) {
      roles.add(const LawyerRole());
    }

    if (shouldAdd(config.poisonerEnabled, 8)) {
      roles.add(const PoisonerRole());
    }
    
    if (shouldAdd(config.maniacEnabled, 9)) {
      roles.add(const ManiacRole());
    }
    
    // 3. Fill the rest with Civilians (Residents)
    while (roles.length < playerCount) {
      roles.add(const CivilianRole());
    }
    
    // Defensive check: if we somehow exceeded playerCount (e.g. manual counts + fixed roles)
    // We prioritize Mafia > Commissar > Doctor > etc.
    return roles.take(playerCount).toList();
  }

  void pauseGame() {
    _state = _state.copyWith(isPaused: !_state.isPaused);
    gameLogger.logPublic(_state.isPaused ? 'Game paused.' : 'Game resumed.');
    _playEvent(_state.isPaused ? 'game_paused' : 'game_resumed');
    websocketController.broadcast({
      'type': _state.isPaused ? 'game_paused' : 'game_resumed',
    });
  }

  void stopGame() {
    _phaseTimer?.cancel();
    // Reset all players to initial state for registration/lobby
    final resetPlayers = _state.players.map((p) => p.copyWith(
      isAlive: true,
      hasActed: false,
      isReadyToVote: false,
      isPoisoned: false,
      role: const CivilianRole(),
    )).toList();
    
    _state = _state.copyWith(
      phase: GamePhase.lobby,
      players: resetPlayers,
      timerSecondsRemaining: null,
      statusMessage: null,
      currentVotes: {},
      currentVerdicts: {},
      verdictTargetId: null,
      speakerId: null,
      pendingActions: [],
    );
    
    gameLogger.logPublic('Game aborted by host. Returning to lobby.');
    websocketController.broadcast({
      'type': 'game_over', 
      'result': 'Aborted by host',
      'phase': 'lobby',
    });
  }
  
  void _transferDonRoleIfNecessary(List<Player> players) {
    if (!_state.config.donMechanicsEnabled) return;

    final hasLivingDon = players.any((p) => p.isAlive && p.role is MafiaRole && (p.role as MafiaRole).isDon);
    if (hasLivingDon) return;

    final livingMafia = players.where((p) => p.isAlive && p.role.faction == Faction.mafia).toList();
    if (livingMafia.isEmpty) return;

    // Pick a random living Mafia member to become the new Don
    final nextDonIndex = Random().nextInt(livingMafia.length);
    final nextDon = livingMafia[nextDonIndex];
    
    final playerIndex = players.indexWhere((p) => p.id == nextDon.id);
    if (playerIndex != -1) {
      players[playerIndex] = players[playerIndex].copyWith(
        role: MafiaRole(isDon: true),
      );
      gameLogger.logDetailed('Don role transferred to ${players[playerIndex].nickname}');
    }
  }
}
