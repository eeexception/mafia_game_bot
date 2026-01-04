import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/providers.dart';
import '../../../core/models/game_state.dart';
import '../../../core/models/player.dart';
import '../../../core/models/game_phase.dart';
import 'victory_screen.dart';

class HostGameScreen extends ConsumerStatefulWidget {
  const HostGameScreen({super.key});

  @override
  ConsumerState<HostGameScreen> createState() => _HostGameScreenState();
}

class _HostGameScreenState extends ConsumerState<HostGameScreen> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
    // Start music for current phase
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final phase = ref.read(gameStateProvider).phase;
      ref.read(audioControllerProvider).playBackgroundMusic(phase);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  void _showStopConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('STOP GAME?'),
        content: const Text('Are you sure you want to stop the game? This will reveal all roles.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(gameControllerProvider).stopGame();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('STOP'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final audio = ref.watch(audioControllerProvider);

    // Listen for phase changes to update music and handle navigation
    ref.listen(gameStateProvider.select((s) => s.phase), (previous, next) {
      if (previous != next) {
        audio.playBackgroundMusic(next);
        
        if (next == GamePhase.gameOver) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const VictoryScreen()),
          );
        }
      }
    });

    return KeyboardListener(
      focusNode: _focusNode,
      onKeyEvent: (event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.space) {
            ref.read(gameControllerProvider).pauseGame();
          } else if (event.logicalKey == LogicalKeyboardKey.escape) {
            _showStopConfirmation(context);
          }
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: Row(
              children: [
                // Left Side: Player Grid and Phase Info
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildPhaseHeader(context, gameState),
                      Expanded(child: _buildPlayerGrid(context, gameState)),
                    ],
                  ),
                ),
                
                // Right Side: Event Log
                Container(
                  width: 400,
                  decoration: const BoxDecoration(
                    color: Colors.black26,
                    border: Border(left: BorderSide(color: Colors.white10)),
                  ),
                  child: _buildEventLog(context, gameState),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => ref.read(gameControllerProvider).advancePhase(),
              label: const Text('ADVANCE PHASE'),
              icon: const Icon(Icons.skip_next),
              backgroundColor: Colors.amber,
            ),
          ),
          if (gameState.isPaused)
            Container(
              color: Colors.black87,
              child: const Center(
                child: Text(
                  'GAME PAUSED',
                  style: TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.amber, decoration: TextDecoration.none),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhaseHeader(BuildContext context, GameState state) {
    final isNight = state.phase.name.contains('night');
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isNight 
            ? [Colors.indigo.shade900, Colors.black] 
            : [Colors.orange.shade900, Colors.deepOrange.shade700],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Icon(
            isNight ? Icons.nightlight_round : Icons.wb_sunny,
            size: 64,
            color: Colors.white70,
          ),
          const SizedBox(height: 16),
          Text(
            state.phase.name.toUpperCase().replaceAll('_', ' '),
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: Colors.white,
              letterSpacing: 4,
            ),
          ),
          if (state.timerSecondsRemaining != null)
            Text(
              '${state.timerSecondsRemaining}s',
              style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.white),
            ),
        ],
      ),
    );
  }

  Widget _buildPlayerGrid(BuildContext context, GameState state) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 0.8,
        ),
        itemCount: state.players.length,
        itemBuilder: (context, index) {
          final player = state.players[index];
          return _PlayerCard(player: player);
        },
      ),
    );
  }

  Widget _buildEventLog(BuildContext context, GameState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(24.0),
          child: Text(
            'EVENT LOG',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
        ),
        const Divider(color: Colors.white12),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            reverse: true,
            itemCount: state.publicEventLog.length,
            itemBuilder: (context, index) {
              final log = state.publicEventLog[state.publicEventLog.length - 1 - index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  log,
                  style: const TextStyle(fontSize: 18, color: Colors.white70),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final Player player;
  const _PlayerCard({required this.player});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: player.isAlive ? 8 : 0,
      color: player.isAlive ? Colors.grey.shade900 : Colors.black45,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: player.isAlive ? Colors.amber.withValues(alpha: 0.3) : Colors.transparent,
          width: 2,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: player.isAlive ? Colors.amber : Colors.grey,
              shape: BoxShape.circle,
            ),
            child: Text(
              '${player.number}',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 24),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            player.nickname,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: player.isAlive ? Colors.white : Colors.white24,
            ),
            textAlign: TextAlign.center,
          ),
          if (!player.isAlive)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                children: [
                   const Text(
                    'ELIMINATED',
                    style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    player.role.name.toUpperCase(),
                    style: const TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
