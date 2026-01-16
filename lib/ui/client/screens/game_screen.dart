import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../../core/state/providers.dart';
import '../../../core/models/game_state.dart';
import '../../../core/models/player.dart';
import '../../../core/models/game_phase.dart';
import '../../../core/models/role.dart';
import '../widgets/phase_header.dart';
import '../widgets/role_viewer.dart';
import '../widgets/voting_grid.dart';
import '../widgets/verdict_panel.dart';
import '../widgets/night_action_panel.dart';
import 'connection_screen.dart';
import 'victory_screen.dart';
import '../../../../l10n/app_localizations.dart';

class ClientGameScreen extends ConsumerStatefulWidget {
  const ClientGameScreen({super.key});

  @override
  ConsumerState<ClientGameScreen> createState() => _ClientGameScreenState();
}

class _ClientGameScreenState extends ConsumerState<ClientGameScreen> {
  String? _selectedTargetId;
  String? _selectedDonTargetId;
  Map<String, String> _mafiaVotes = {}; // performerId -> targetId

  @override
  void initState() {
    super.initState();
    // Enable WakeLock to prevent screen from sleeping during the game
    ref.read(wakeLockServiceProvider).enable();

    // Listen for commissar check results and mafia sync
    ref.read(webSocketClientServiceProvider).messages.listen((msg) {
      if (msg['type'] == 'check_result') {
        final isMafia = msg['is_mafia'] as bool;
        final targetId = msg['target_id'] as String;
        final target = ref.read(clientGameStateProvider)?.players.firstWhereOrNull((p) => p.id == targetId);
        
        if (mounted && target != null) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: Colors.indigo.shade900,
              title: const Text('INVESTIGATION RESULT'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   CircleAvatar(child: Text('${target.number}')),
                   const SizedBox(height: 16),
                   Text('${target.nickname} is ${isMafia ? "MAFIA" : "PEACEFUL"}', 
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: isMafia ? Colors.redAccent : Colors.greenAccent
                    ),
                   ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
              ],
            ),
          );
        }
      } else if (msg['type'] == 'lawyer_check_result') {
        final isActiveTown = msg['is_active_town'] as bool;
        final targetId = msg['target_id'] as String;
        final target = ref.read(clientGameStateProvider)?.players.firstWhereOrNull((p) => p.id == targetId);
        
        if (mounted && target != null) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: Colors.purple.shade900,
              title: const Text('LAWYER INVESTIGATION'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   CircleAvatar(child: Text('${target.number}')),
                   const SizedBox(height: 16),
                   Text('${target.nickname} is ${isActiveTown ? "AN ACTIVE TOWN ROLE" : "NOT AN ACTIVE TOWN ROLE"}', 
                    style: TextStyle(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold, 
                      color: isActiveTown ? Colors.amberAccent : Colors.white70
                    ),
                    textAlign: TextAlign.center,
                   ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
              ],
            ),
          );
        }
      } else if (msg['type'] == 'don_check_result') {
        final isCommissar = msg['is_commissar'] as bool;
        final targetId = msg['target_id'] as String;
        final target = ref.read(clientGameStateProvider)?.players.firstWhereOrNull((p) => p.id == targetId);
        
        if (mounted && target != null) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              backgroundColor: Colors.red.shade900,
              title: const Text('DON INVESTIGATION'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                   CircleAvatar(child: Text('${target.number}')),
                   const SizedBox(height: 16),
                   Text('${target.nickname} is ${isCommissar ? "COMMISSAR!" : "NOT COMMISSAR"}', 
                    style: TextStyle(
                      fontSize: 20, 
                      fontWeight: FontWeight.bold, 
                      color: isCommissar ? Colors.amberAccent : Colors.white70
                    ),
                   ),
                ],
              ),
              actions: [
                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('OK')),
              ],
            ),
          );
        }
      } else if (msg['type'] == 'team_votes_update' || msg['type'] == 'mafia_sync_update') {
        final votesMap = msg['votes'] as Map<String, dynamic>;
        final newVotes = <String, String>{};
        votesMap.forEach((key, value) {
            newVotes[key] = value as String;
        });
        if (mounted) {
          setState(() {
            _mafiaVotes = newVotes;
          });
        }
      }
    });

    // Clear selection on phase change or if player dies
    ref.listenManual(clientGameStateProvider, (previous, next) {
      if (next == null) return;
      final playerId = ref.read(clientPlayerIdProvider);
      if (playerId == null) return;
      
      final me = next.players.firstWhereOrNull((p) => p.id == playerId);
      final prevMe = previous?.players.firstWhereOrNull((p) => p.id == playerId);

      // Transition to Victory Screen
      if (previous?.phase is! GameOverPhase && next.phase is GameOverPhase) {
        _recordPersonalStats(next, playerId);
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ClientVictoryScreen()),
        );
      }
      
      if (previous?.phase != next.phase || (prevMe?.isAlive == true && me?.isAlive == false)) {
        setState(() {
          _selectedTargetId = null;
          _selectedDonTargetId = null;
          _mafiaVotes = {};
        });
      }
    });
  }

  void _recordPersonalStats(GameState state, String myId) {
    final storage = ref.read(storageServiceProvider);
    final winDetector = ref.read(winDetectorProvider);
    final winResult = winDetector.checkWinCondition(state.players);
    if (winResult == null) return;

    final me = state.players.firstWhereOrNull((p) => p.id == myId);
    if (me == null) return;

    // Increment games played
    storage.incrementStat('personal_games_played');

    // Check if I won
    final myFaction = me.role.faction;
    if (myFaction == winResult.winner) {
      storage.incrementStat('personal_games_won');
    }
  }

  @override
  void dispose() {
    // Disable WakeLock when leaving the game screen
    ref.read(wakeLockServiceProvider).disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(clientGameStateProvider);
    final playerId = ref.watch(clientPlayerIdProvider);

    // Watch for phase changes to automatically return to lobby
    ref.listen(gameStateProvider.select((s) => s.phase), (previous, next) {
      if (next is LobbyPhase) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WaitingScreen()),
        );
      }
    });

    if (gameState == null || playerId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final me = gameState.players.firstWhere((p) => p.id == playerId);
    final isNight = gameState.phase.id == 'night';

    return Stack(
      children: [
        Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isNight 
                  ? [Colors.indigo.shade900, Colors.black] 
                  : [Colors.blueGrey.shade900, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  PhaseHeader(me: me, state: gameState),
                  const Spacer(),
                  if (me.isAlive) RoleViewer(me: me),
                  if (!me.isAlive) _buildDeadMessage(),
                  const Spacer(),
                  if (me.isAlive) _buildActionPanel(context, me, gameState),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ),
        if (gameState.isPaused)
          Positioned.fill(
            child: AbsorbPointer(
              child: Container(
                color: Colors.black87,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pause_circle_filled, color: Colors.amber, size: 80),
                      SizedBox(height: 16),
                      Text(
                        'GAME PAUSED',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'WAITING FOR HOST...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white54,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDeadMessage() {
    return const Column(
      children: [
        Icon(Icons.person_off, size: 100, color: Colors.redAccent),
        SizedBox(height: 24),
        Text(
          'YOU ARE ELIMINATED',
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.redAccent, letterSpacing: 1),
        ),
        SizedBox(height: 8),
        Text(
          'Please stay silent and watch the game.', 
          style: TextStyle(color: Colors.white38, fontSize: 16)
        ),
      ],
    );
  }

  Widget _buildActionPanel(BuildContext context, Player me, GameState state) {
    final actions = me.role.getActions(state, me);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          if (state.phase is RoleRevealPhase)
            Column(
              children: [
                const Text(
                  'VIEW YOUR ROLE ABOVE', 
                  style: TextStyle(color: Colors.white38, fontStyle: FontStyle.italic, fontSize: 18)
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _sendAction('toggle_ready'),
                  icon: Icon(
                    me.isReadyToVote ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: me.isReadyToVote ? Colors.greenAccent : Colors.white,
                  ),
                  label: Text(
                    me.isReadyToVote ? 'READY' : 'GO TO NIGHT?',
                    style: TextStyle(
                      color: me.isReadyToVote ? Colors.greenAccent : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: me.isReadyToVote ? Colors.greenAccent : Colors.white24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          if (state.currentMoveId == 'day_voting') 
            VotingGrid(
              me: me, 
              state: state, 
              selectedTargetId: _selectedTargetId, 
              onTargetSelected: (id) => setState(() => _selectedTargetId = id),
            ),
          if (state.currentMoveId == 'day_verdict') 
            VerdictPanel(
              me: me, 
              state: state, 
              selectedTargetId: _selectedTargetId, 
              onTargetSelected: (id) => setState(() => _selectedTargetId = id),
            ),
          if (state.phase.id == 'night') 
            NightActionPanel(
              me: me, 
              state: state, 
              selectedTargetId: _selectedTargetId, 
              selectedDonTargetId: _selectedDonTargetId, 
              mafiaVotes: _mafiaVotes, 
              onTargetSelected: (id) {
                if (id == 'commissar_ready_signal') {
                  _sendAction('commissar_ready');
                } else {
                  setState(() => _selectedTargetId = id);
                  // Sync Mafia votes in real-time
                  if (state.currentMoveId == 'night_mafia' && me.role.faction == Faction.mafia) {
                    _sendAction('mafia_vote_sync', targetId: id);
                  }
                }
              },
              onDonTargetSelected: (id) => setState(() => _selectedDonTargetId = id),
            ),
          
          if (state.currentMoveId == 'day_discussion') 
            Column(
              children: [
                const Text(
                  'LEAD THE DISCUSSION...', 
                  style: TextStyle(color: Colors.white38, fontStyle: FontStyle.italic, fontSize: 18)
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _sendAction('ready_to_vote'),
                  icon: Icon(
                    me.isReadyToVote ? Icons.check_circle : Icons.radio_button_unchecked,
                    color: me.isReadyToVote ? Colors.greenAccent : Colors.white,
                  ),
                  label: Text(
                    me.isReadyToVote ? 'READY TO VOTE' : 'VOTE EARLY?',
                    style: TextStyle(
                      color: me.isReadyToVote ? Colors.greenAccent : Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: me.isReadyToVote ? Colors.greenAccent : Colors.white24,
                      ),
                    ),
                  ),
                ),
              ],
            ),

          if (state.currentMoveId == 'day_defense')
            Column(
              children: [
                if (state.speakerId == me.id) ...[
                  const Text(
                    'YOUR DEFENSE SPEECH', 
                    style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 18)
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _sendAction('end_speech'),
                    icon: const Icon(Icons.stop_circle, color: Colors.white),
                    label: const Text(
                      'END SPEECH EARLY',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withValues(alpha: 0.6),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                        side: const BorderSide(color: Colors.redAccent),
                      ),
                    ),
                  ),
                ] else ...[
                  Text(
                    'WAITING FOR PLAYER #${state.players.firstWhereOrNull((p) => p.id == state.speakerId)?.number ?? "?"}...', 
                    style: const TextStyle(color: Colors.white38, fontStyle: FontStyle.italic, fontSize: 18)
                  ),
                ],
              ],
            ),

          // Dynamic action buttons
          if (!me.hasActed)
            ...actions.map((action) {
              final isDonCheck = action.type == 'don_check';
              final selectedId = isDonCheck ? _selectedDonTargetId : _selectedTargetId;
              final l10n = AppLocalizations.of(context)!;
              final confirmLabel = _getLocalizedConfirmLabel(l10n, action.confirmLabelKey);

              if (selectedId == null && action.requiresConfirmation) return const SizedBox();

              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ElevatedButton(
                  onPressed: () => _sendAction(action.type, targetId: selectedId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDonCheck ? Colors.redAccent : Colors.amber,
                    foregroundColor: isDonCheck ? Colors.white : Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 8,
                  ),
                  child: Text(
                    confirmLabel, 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
              );
            }),
          
          if (!me.hasActed && actions.any((a) => a.requiresConfirmation) && 
              _selectedTargetId == null && _selectedDonTargetId == null &&
              (state.currentMoveId == 'day_voting' || state.currentMoveId == 'day_verdict' || state.phase.id == 'night'))
            Padding(
              padding: const EdgeInsets.all(32),
              child: Text(
                'SELECT A TARGET...', 
                style: const TextStyle(color: Colors.white38, fontStyle: FontStyle.italic, fontSize: 18)
              ),
            ),
          
          if (me.hasActed && state.phase.id != 'night')
            const Padding(
              padding: EdgeInsets.all(32),
              child: Column(
                children: [
                  Icon(Icons.check_circle, color: Colors.greenAccent, size: 48),
                  SizedBox(height: 8),
                  Text('ACTION CONFIRMED', style: TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  void _sendAction(String type, {String? targetId}) {
    final gameState = ref.read(clientGameStateProvider);
    final playerId = ref.read(clientPlayerIdProvider);
    if (gameState == null || playerId == null) return;
    
    final me = gameState.players.firstWhereOrNull((p) => p.id == playerId);
    if (me == null || !me.isAlive) {
      debugPrint('Blocked action $type from dead or invalid player.');
      return;
    }

    ref.read(webSocketClientServiceProvider).send({
      'type': 'player_action',
      'action': {
        'type': type,
        'targetId': targetId,
      }
    });

    if (mounted && targetId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Action $type submitted!'),
          backgroundColor: Colors.amber,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  String _getLocalizedConfirmLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'confirmAction': return l10n.confirmAction;
      case 'confirmDonCheck': return l10n.confirmDonCheck;
      case 'confirmVote': return l10n.confirmVote;
      case 'confirmVerdict': return l10n.confirmVerdict;
      default: return key;
    }
  }
}
