import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/providers.dart';
import '../../../core/models/game_state.dart';
import '../../../core/models/player.dart';
import '../../../core/models/game_phase.dart';
import '../../../core/models/role.dart';

class ClientGameScreen extends ConsumerStatefulWidget {
  const ClientGameScreen({super.key});

  @override
  ConsumerState<ClientGameScreen> createState() => _ClientGameScreenState();
}

class _ClientGameScreenState extends ConsumerState<ClientGameScreen> {
  bool _roleVisible = false;

  @override
  void initState() {
    super.initState();
    // Enable WakeLock to prevent screen from sleeping during the game
    ref.read(wakeLockServiceProvider).enable();

    // Listen for commissar check results
    ref.read(webSocketClientServiceProvider).messages.listen((msg) {
      if (msg['type'] == 'check_result') {
        final isMafia = msg['is_mafia'] as bool;
        final targetId = msg['target_id'] as String;
        final target = ref.read(clientGameStateProvider)?.players.firstWhere((p) => p.id == targetId);
        
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
      }
    });
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

    if (gameState == null || playerId == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final me = gameState.players.firstWhere((p) => p.id == playerId);
    final isNight = gameState.phase.name.contains('night');

    return Scaffold(
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
              _buildHeader(me, gameState),
              const Spacer(),
              if (me.isAlive) _buildRoleViewer(me),
              if (!me.isAlive) _buildDeadMessage(),
              const Spacer(),
              if (me.isAlive) _buildActionPanel(context, me, gameState),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(Player me, GameState state) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 24,
            child: Text(
              '${me.number}', 
              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20)
            ),
          ),
          Column(
            children: [
              Text(
                state.phase.name.toUpperCase().replaceAll('_', ' '),
                style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, fontSize: 16),
              ),
              if (state.timerSecondsRemaining != null)
                Text(
                  '${state.timerSecondsRemaining}s', 
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.amber)
                ),
            ],
          ),
          const Opacity(
            opacity: 0.3,
            child: Icon(Icons.settings, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleViewer(Player me) {
    return Column(
      children: [
        GestureDetector(
          onLongPressStart: (_) => setState(() => _roleVisible = true),
          onLongPressEnd: (_) => setState(() => _roleVisible = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: _roleVisible ? Colors.amber.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: _roleVisible ? Colors.amber : Colors.white24, 
                width: 3
              ),
              boxShadow: _roleVisible ? [
                BoxShadow(color: Colors.amber.withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 5)
              ] : [],
            ),
            child: Icon(
              _roleVisible ? Icons.visibility : Icons.visibility_off,
              size: 80,
              color: _roleVisible ? Colors.amber : Colors.white38,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _roleVisible ? me.role.name.toUpperCase() : 'PRESS AND HOLD TO REVEAL ROLE',
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: _roleVisible ? Colors.amber : Colors.white54,
            letterSpacing: 2,
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
    if (state.phase == GamePhase.dayVoting) {
       return _buildVotingGrid(me, state);
    }
    
    if (state.phase.name.contains('night')) {
        return _buildNightActionPanel(me, state);
    }

    if (state.phase == GamePhase.dayDiscussion) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
      );
    }

    return Container(
      padding: const EdgeInsets.all(32),
      child: const Text(
        'WAITING...', 
        style: TextStyle(color: Colors.white38, fontStyle: FontStyle.italic, fontSize: 18)
      ),
    );
  }

  Widget _buildVotingGrid(Player me, GameState state) {
    final alivePlayers = state.players.where((p) => p.isAlive && p.id != me.id).toList();
    return Column(
      children: [
        const Text(
          'VOTE TO EXECUTE', 
          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2, color: Colors.redAccent)
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: alivePlayers.length,
            itemBuilder: (context, index) {
              final p = alivePlayers[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: () => _sendAction('vote', targetId: p.id),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.red.shade900.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade700),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${p.number}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text(p.nickname, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildNightActionPanel(Player me, GameState state) {
    bool canAct = false;
    String actionType = '';
    
    if (state.phase == GamePhase.nightMafia && me.role is MafiaRole) {
        canAct = true;
        actionType = 'mafia_kill';
    } else if (state.phase == GamePhase.nightProstitute && me.role is ProstituteRole) {
        canAct = true;
        actionType = 'prostitute_block';
    } else if (state.phase == GamePhase.nightManiac && me.role is ManiacRole) {
        canAct = true;
        actionType = 'maniac_kill';
    } else if (state.phase == GamePhase.nightDoctor && me.role is DoctorRole) {
        canAct = true;
        actionType = 'doctor_heal';
    } else if (state.phase == GamePhase.nightCommissar && me.role is CommissarRole) {
        canAct = true;
        actionType = 'commissar_check';
    }
    
    if (!canAct) {
        return const Padding(
          padding: EdgeInsets.all(32.0),
          child: Text(
            'THE CITY IS SLEEPING...', 
            style: TextStyle(color: Colors.white38, fontStyle: FontStyle.italic, fontSize: 18)
          ),
        );
    }

    final targets = state.players.where((p) => p.isAlive && p.id != me.id).toList();

    return Column(
      children: [
        Text(
          actionType.toUpperCase().replaceAll('_', ' '), 
          style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, letterSpacing: 2)
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: targets.length,
            itemBuilder: (context, index) {
              final p = targets[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: () => _sendAction(actionType, targetId: p.id),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade900.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.indigo.shade700),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('${p.number}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text(p.nickname, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _sendAction(String type, {String? targetId}) {
    ref.read(webSocketClientServiceProvider).send({
      'type': 'player_action',
      'action': {
        'type': type,
        'targetId': targetId,
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Action $type sent!'),
        backgroundColor: Colors.amber,
        duration: const Duration(seconds: 1),
      )
    );
  }
}
