import 'dart:async';
import 'dart:math';
import '../audio/audio_controller.dart';
import '../network/websocket_controller.dart';
import '../theme/theme_controller.dart';
import '../../../domain/models/game/game_state.dart';
import '../../../domain/models/game/game_phase.dart';
import '../../../domain/models/game/game_config.dart';
import '../../../domain/models/players/player.dart';
import '../../../domain/models/roles/role.dart';
import '../session/heartbeat_monitor.dart';
import 'win_detector.dart';
import '../network/websocket_message_router.dart';
import '../actions/mafia_sync_service.dart';
import '../actions/commissar_ready_service.dart';
import '../actions/action_buffer_service.dart';
import '../roles/role_distribution_service.dart';
import 'night_flow_service.dart';
import '../session/session_service.dart';
import '../voting/voting_service.dart';
import '../../../domain/models/game/game_move.dart';
import '../../../domain/models/players/player_action.dart';
import '../../../infrastructure/services/logging/game_logger.dart';
import '../../../infrastructure/services/storage/storage_service.dart';

import '../../../presentation/state/game/game_state_notifier.dart';

class GameController {
  GameController({
    required this.audioController,
    required this.websocketController,
    required this.winDetector,
    required this.gameLogger,
    required this.stateNotifier,
    required this.storageService,
    required this.themeController,
    HeartbeatMonitor? heartbeatMonitor,
    WebSocketMessageRouter? messageRouter,
    MafiaSyncService? mafiaSyncService,
    CommissarReadyService? commissarReadyService,
    ActionBufferService? actionBufferService,
    RoleDistributionService? roleDistributionService,
    NightFlowService? nightFlowService,
    SessionService? sessionService,
    VotingService? votingService,
  }) {
    _heartbeatMonitor = heartbeatMonitor ?? HeartbeatMonitor();
    _mafiaSyncService = mafiaSyncService ?? MafiaSyncService();
    _commissarReadyService =
        commissarReadyService ?? CommissarReadyService();
    _actionBufferService = actionBufferService ?? ActionBufferService();
    _roleDistributionService =
        roleDistributionService ?? RoleDistributionService();
    _nightFlowService = nightFlowService ?? NightFlowService();
    _sessionService = sessionService ?? SessionService();
    _votingService = votingService ?? VotingService();
    _messageRouter = messageRouter ??
        WebSocketMessageRouter(
          onPlayerJoined: _handlePlayerJoin,
          onPlayerReconnect: _handlePlayerReconnect,
          onPlayerAction: handlePlayerAction,
          onHeartbeat: _handleHeartbeat,
        );
    websocketController.onMessageReceived = _messageRouter.route;
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
      final result = _heartbeatMonitor.updatePlayers(
        players: _state.players,
        now: now,
        timeout: const Duration(seconds: 20),
      );

      if (result.timedOutPlayers.isNotEmpty) {
        for (final player in result.timedOutPlayers) {
          gameLogger.logDetailed(
            'Player ${player.nickname} timed out (No heartbeat).',
          );
        }
        _state = _state.copyWith(players: result.players);
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
  late final HeartbeatMonitor _heartbeatMonitor;
  late final WebSocketMessageRouter _messageRouter;
  late final MafiaSyncService _mafiaSyncService;
  late final CommissarReadyService _commissarReadyService;
  late final ActionBufferService _actionBufferService;
  late final RoleDistributionService _roleDistributionService;
  late final NightFlowService _nightFlowService;
  late final SessionService _sessionService;
  late final VotingService _votingService;

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

  /// Process incoming player action relative to current phase
  Future<void> handlePlayerAction(String senderId, PlayerAction action) async {
    final sender = _state.players.firstWhere((p) => p.id == senderId);
    if (!sender.isAlive) return;

    if (action.type == 'mafia_vote_sync') {
      if (_state.phase.id != 'night' || _currentMove?.id != 'night_mafia') return;
      final votes = Map<String, String>.from(_state.currentVotes ?? {});
      if (action.targetId != null) {
        votes[senderId] = action.targetId!;
      } else {
        votes.remove(senderId);
      }
      _state = _state.copyWith(currentVotes: votes);
      
      final mafiaFamily = _state.players.where((p) => p.role.faction == Faction.mafia).toList();
      for (var member in mafiaFamily) {
        websocketController.sendToClient(member.id, {
          'type': 'team_votes_update',
          'votes': votes,
        });
      }
      return;
    }

    const bypassLock = ['mafia_vote_sync', 'toggle_ready', 'ready_to_vote', 'commissar_ready'];
    if (sender.hasActed && !bypassLock.contains(action.type)) {
      gameLogger.logDetailed('Blocked action ${action.type} from Player ${sender.number} because they already acted.');
      return;
    }

    if (action.type == 'ready_to_vote' || action.type == 'toggle_ready') {
      final result = _votingService.toggleReady(
        players: _state.players,
        senderId: senderId,
      );
      _state = _state.copyWith(players: result.players);

      if (result.allReady) {
        gameLogger.logPublic('All players are ready.');
        advancePhase();
      } else {
        websocketController.broadcast(
          {'type': 'state_update', 'state': _state.toJson()},
        );
      }
      return;
    }

    if (action.type == 'vote') {
      final result = _votingService.applyVote(
        players: _state.players,
        currentVotes: _state.currentVotes ?? {},
        senderId: senderId,
        targetId: action.targetId,
      );

      _state = _state.copyWith(
        currentVotes: result.votes,
        players: result.players,
      );

      // Visibility for Mafia team
      if (_state.currentMoveId == 'night_mafia') {
          final mafiaFamily = result.players
              .where((p) => p.role.faction == Faction.mafia)
              .toList();
          for (var member in mafiaFamily) {
              websocketController.sendToClient(member.id, {
                  'type': 'team_votes_update',
                  'votes': result.votes,
              });
          }
      }
      return;
    }

    if (action.type == 'verdict') {
      if (_state.phase.id != 'day' || _currentMove?.id != 'day_verdict') return;
      final decision = action.targetId == 'execute';
      final result = _votingService.applyVerdict(
        players: _state.players,
        currentVerdicts: _state.currentVerdicts ?? {},
        senderId: senderId,
        decision: decision,
      );

      _state = _state.copyWith(
        currentVerdicts: result.verdicts,
        players: result.players,
      );
      return;
    }

    if (action.type == 'end_speech') {
      if (_state.currentMoveId != 'day_defense') return;
      if (_state.speakerId != senderId) return;
      
      gameLogger.logPublic('Player ${sender.nickname} ended their speech early.');
      advancePhase();
      return;
    }

    if (action.type == 'doctor_heal') {
      final error = _nightFlowService.validateDoctorHeal(
        state: _state,
        senderId: senderId,
        targetId: action.targetId,
      );
      if (error != null) {
        websocketController.sendToClient(senderId, {
          'type': 'error',
          'message': error,
        });
        return;
      }
    }

    if (action.type == 'mafia_kill') {
      final allowed = _nightFlowService.canMafiaKill(
        state: _state,
        senderId: senderId,
      );
      if (!allowed) {
        return;
      }
    }

    final buffered = _actionBufferService.bufferAction(
      players: _state.players,
      pendingActions: _state.pendingActions,
      action: action.copyWith(performerId: senderId),
    );

    _state = _state.copyWith(
      pendingActions: buffered.pendingActions,
      players: buffered.players,
    );

    final nightResult = _nightFlowService.handleImmediateAction(
      players: _state.players,
      state: _state,
      sender: sender,
      action: action,
      timerSecondsRemaining: _state.timerSecondsRemaining,
    );

    for (final log in nightResult.detailedLogs) {
      gameLogger.logDetailed(log);
    }

    for (final message in nightResult.messages) {
      for (final recipientId in message.recipientIds) {
        websocketController.sendToClient(recipientId, message.payload);
      }
    }

    if (nightResult.timerSecondsOverride != null) {
      _state = _state.copyWith(
        timerSecondsRemaining: nightResult.timerSecondsOverride,
      );
      websocketController.broadcast({
        'type': 'timer_update',
        'seconds': nightResult.timerSecondsOverride,
      });
    }

    if (nightResult.advancePhase) {
      advancePhase();
      return;
    }

    if (nightResult.shouldCheckAdvance) {
      _checkAndAdvanceNightPhase();
      return;
    }

    if (nightResult.stopProcessing) {
      return;
    }

    if (action.type == 'commissar_ready') {
      if (!_commissarReadyService.isReadyEarly(
        currentMoveId: _state.currentMoveId,
      )) {
        return;
      }
      gameLogger.logDetailed('Police are ready. Ending phase early.');
      advancePhase();
      return;
    }


    // Sync Mode Support: Broadcast Mafia votes to other Mafia members
    // If Don mechanics are DISABLED or Don is in SEARCH mode, we always sync Mafia votes for consensus
    if (action.type == 'mafia_kill' && (!_state.config.donMechanicsEnabled || _state.config.donAction == DonAction.search)) {
      final mafiaMembers = _state.players.where((p) => p.role.type == RoleType.mafia).map((p) => p.id).toSet();
      final payload = _mafiaSyncService.buildSyncPayload(_state.pendingActions);
      for (var memberId in mafiaMembers) {
        websocketController.sendToClient(memberId, {
          ...payload,
        });
      }
    }

    // Set hasActed for the player and check for early phase advancement
    _checkAndAdvanceNightPhase();
  }

  void _checkAndAdvanceNightPhase() {
    if (!_nightFlowService.isReadyToAdvance(_state)) {
      return;
    }
    final moveId = _state.currentMoveId ?? 'unknown';
    gameLogger.logDetailed(
      'All required players for $moveId have acted. Advancing phase.',
    );
    advancePhase();
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

  void resetGame() {
    audioController.stopBackgroundMusic();
    audioController.playBackgroundMusic(GamePhase.lobby);
    
    _state = GameState(
      sessionId: _sessionService.generateSessionId(),
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

    final roles =
        _roleDistributionService.distributeRoles(_state.players.length, config);
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
    final sid = message['game_session_id'] as String?;
    final nickname = message['nickname'] as String? ?? 'Unknown';
    final result = _sessionService.handleJoin(
      state: _state,
      senderId: senderId,
      nickname: nickname,
      providedSessionId: sid,
    );

    if (result.rejected) {
      websocketController.sendToClient(senderId, {
        'type': 'error',
        'message': result.errorMessage ?? 'Join rejected',
      });
      return;
    }

    _state = _state.copyWith(players: result.updatedPlayers);
    if (result.sessionToken != null) {
      websocketController.registerSession(senderId, result.sessionToken!);
    }
    websocketController.sendToClient(senderId, {
      'type': 'join_success',
      'player_id': senderId,
      'session_token': result.sessionToken,
    });
  }

  Future<void> advancePhase() async {
    _phaseTimer?.cancel();
    
    // Reset player readiness
    final players = _state.players.map((p) => p.copyWith(isReadyToVote: false)).toList();
    _state = _state.copyWith(players: players);

    gameLogger.logDetailed('Advancing game state from ${_state.phase.id} (Move: ${_currentMove?.id})');
    
    final currentMove = _currentMove;
    
    if (currentMove is VotingMove) {
      final tiedIds = _getTiedPlayers();
      if (tiedIds.isEmpty) {
        gameLogger.logPublic('NO VOTES: Nobody accused.');
        _moveToPhase(NightGamePhase(moves: _buildNightMoves()));
        return advancePhase();
      }
      _state = _state.copyWith(
        defenseQueue: tiedIds,
        speakerId: tiedIds.first,
        verdictTargetId: tiedIds.length == 1 ? tiedIds.first : null,
      );
    } else if (currentMove is VerdictMove) {
      await _executeVotedPlayer();
    }

    // Check if we are in a multi-move phase and can advance moves
    final currentPhase = _state.phase;
    if (currentPhase is NightGamePhase || currentPhase is DayGamePhase) {
      final moves = (currentPhase is NightGamePhase) ? currentPhase.moves : (currentPhase as DayGamePhase).moves;
      
      // Special logic for DefenseMove loop
      if (currentMove is DefenseMove && _state.defenseQueue.isNotEmpty) {
         final queue = List<String>.from(_state.defenseQueue);
         queue.removeAt(0);
         if (queue.isNotEmpty) {
           _state = _state.copyWith(
             defenseQueue: queue,
             speakerId: queue.first,
           );
           await _startMove(_currentMove!);
           return;
         }
      }

      // Normal move progression
      if (_state.currentMoveIndex < moves.length - 1) {
        _state = _state.copyWith(currentMoveIndex: _state.currentMoveIndex + 1);
        final nextMove = moves[_state.currentMoveIndex];
        
        if (nextMove.shouldSkip(_state)) {
          gameLogger.logDetailed('Skipping move: ${nextMove.id}');
          return advancePhase();
        }
        
        await _startMove(nextMove);
        return;
      }
    }

    // Phase transition logic

    if (currentPhase == GamePhase.lobby || currentPhase == GamePhase.setup) {
      _moveToPhase(GamePhase.roleReveal);
    } else if (currentPhase == GamePhase.roleReveal) {
      _moveToPhase(NightGamePhase(moves: _buildNightMoves()));
    } else if (currentPhase is NightGamePhase) {
      _moveToPhase(DayGamePhase(moves: _buildDayMoves()));
    } else if (currentPhase is DayGamePhase) {
       // After Day moves are done, we usually go to Night
       _moveToPhase(NightGamePhase(moves: _buildNightMoves()));
    } else {
       gameLogger.logDetailed('No further phase transitions defined for ${currentPhase.id}');
       return;
    }

    gameLogger.logDetailed('New phase: ${_state.phase.id} (Move: ${_currentMove?.id})');

    // Only check win condition if we are NOT reveal part of the day
    if (_currentMove?.id != 'morning') {
      if (await _checkWinCondition()) return;
    }

    await _startMove(_currentMove!);
    
    if (_currentMove?.id == 'morning') {
      await resolveNightActions();
    }
  }

  Future<void> _startMove(GameMove move) async {
    _state = _state.copyWith(
      statusMessage: move.nameKey,
      currentMoveId: move.id,
    );

    // Audio
    if (move.audioEvent != null) {
      await audioController.playEvent(move.audioEvent!);
    }
    
    // Timer
    _startTimerForMove(move);

    // Sync state
    websocketController.broadcast({'type': 'phase_changed', 'phase': move.id});
    websocketController.broadcast({'type': 'state_update', 'state': _state.toJson()});
  }

  List<GameMove> _buildNightMoves() {
    return [
      const NightStartMove(),
      const RoleMove(RoleType.prostitute),
      const RoleMove(RoleType.poisoner),
      const MafiaMove(),
      const RoleMove(RoleType.commissar),
      const RoleMove(RoleType.maniac),
      const RoleMove(RoleType.doctor),
    ];
  }

  List<GameMove> _buildDayMoves() {
    return [
      const MorningMove(),
      const DiscussionMove(),
      const VotingMove(),
      const DefenseMove(),
      const VerdictMove(),
    ];
  }

  GameMove? get _currentMove {
    final phase = _state.phase;
    if (phase is NightGamePhase) {
      if (_state.currentMoveIndex >= 0 && _state.currentMoveIndex < phase.moves.length) {
        return phase.moves[_state.currentMoveIndex];
      }
    } else if (phase is DayGamePhase) {
      if (_state.currentMoveIndex >= 0 && _state.currentMoveIndex < phase.moves.length) {
        return phase.moves[_state.currentMoveIndex];
      }
    }
    // For singular phases, we might want a virtual move? 
    // Or just return null. Singular phases like Lobby don't have moves.
    return null;
  }

  void _moveToPhase(GamePhase phase) {
    _state = _state.copyWith(
      phase: phase,
      currentMoveIndex: 0,
      players: _state.players.map((p) => p.copyWith(hasActed: false)).toList(),
      currentVotes: {},
      currentVerdicts: {},
    );
    
    if (phase is NightGamePhase || phase is DayGamePhase) {
       // Increment Night/Day counters when entering
       if (phase is NightGamePhase) {
          _state = _state.copyWith(currentNightNumber: (_state.currentNightNumber ?? 0) + 1);
       } else {
          _state = _state.copyWith(currentDayNumber: (_state.currentDayNumber ?? 0) + 1);
       }
    }
  }

  void _startTimerForMove(GameMove move) {
    _phaseTimer?.cancel();
    int duration = move.getDuration(_state.config);
    
    _state = _state.copyWith(timerSecondsRemaining: duration);
    _phaseTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_state.isPaused) return;
      
      final remaining = (_state.timerSecondsRemaining ?? 0) - 1;
      _state = _state.copyWith(timerSecondsRemaining: remaining);
      
      // Audio announcements for last 10 seconds
      if (remaining <= 10 && remaining > 0) {
        audioController.playEvent('timer_tick');
      }

      if (remaining <= 0) {
        timer.cancel();
        // If it's a voting move, calculate results before advancing
        if (move is VotingMove) {
           _handleVotingFinalization();
        } else if (move is VerdictMove) {
           _handleVerdictFinalization();
        } else {
           advancePhase();
        }
      }
    });
  }

  Future<void> _handleVotingFinalization() async {
    final tiedIds = _getTiedPlayers();
    if (tiedIds.isEmpty) {
      gameLogger.logPublic('NO VOTES: Nobody accused.');
      _moveToPhase(NightGamePhase(moves: _buildNightMoves()));
      await advancePhase();
    } else {
      // If 1 or more tied, go to defense
      _state = _state.copyWith(
        defenseQueue: tiedIds,
        speakerId: tiedIds.first,
        verdictTargetId: tiedIds.length == 1 ? tiedIds.first : null, // Set verdict target only if exactly one
      );
      advancePhase(); // This will move from Voting to Defense
    }
  }

  Future<void> _handleVerdictFinalization() async {
     await _executeVotedPlayer();
     advancePhase(); // Go to Night
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

  Future<void> resolveNightActions() async {
    final actions = _state.pendingActions;
    gameLogger.logDetailed(
      'Resolving night actions: ${actions.length} received',
    );
    final result = _nightFlowService.resolve(
      players: _state.players,
      actions: actions,
      config: _state.config,
    );
    final players = result.players;
    final trapVictimIds = result.trapVictimIds;

    for (final log in result.detailedLogs) {
      gameLogger.logDetailed(log);
    }

    if (result.mafiaNoConsensus) {
      gameLogger.logPublic('Mafia could not reach a consensus tonight.');
    }
    if (result.mafiaMissed) {
      await _playEvent('mafia_miss');
    }

    final announcements = _nightFlowService.buildAnnouncements(
      players: players,
      actions: actions,
      resolution: result,
    );
    for (final event in announcements.compositeEvents) {
      await _playCompositeEvent(event);
    }
    for (final event in announcements.audioEvents) {
      await _playEvent(event);
    }
    for (final log in announcements.publicLogs) {
      gameLogger.logPublic(log);
    }

    // 8. Deaths
    final eventLogs = List<String>.from(result.publicLogs);
    for (final log in eventLogs) {
      gameLogger.logPublic(log);
    }

    for (var i = 0; i < players.length; i++) {
      if (result.actualKilledIds.contains(players[i].id)) {
        final killedByManiac =
            result.killedByManiacIds.contains(players[i].id);
        final killedByPoison =
            result.killedByPoisonIds.contains(players[i].id);
        final killedByTrap = trapVictimIds.contains(players[i].id);

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

    if (result.actualKilledIds.isEmpty) {
      await _playEvent('nobody_killed');
    }

    _transferDonRoleIfNecessary(players);

    // Check for missed actions (Alive but no action)
    for (final eventKey in result.missedEventKeys) {
      await _playEvent(eventKey);
    }

    _state = _state.copyWith(
      players: players,
      pendingActions: [],
      lastDoctorTargetId: result.currentNightDoctorTargetId,
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
    return _roleDistributionService.distributeRoles(playerCount, config);
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
