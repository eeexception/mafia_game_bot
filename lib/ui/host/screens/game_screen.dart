import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:collection/collection.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/providers.dart';
import '../../../core/models/game_state.dart';
import '../../../core/models/player.dart';
import '../../../core/models/game_phase.dart';
import 'victory_screen.dart';
import '../../../../l10n/app_localizations.dart';

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
        title: Text(AppLocalizations.of(context)!.stopGame),
        content: Text(AppLocalizations.of(context)!.stopGameConfirm),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(AppLocalizations.of(context)!.cancel)),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(gameControllerProvider).stopGame();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(AppLocalizations.of(context)!.stop),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);
    final l10n = AppLocalizations.of(context)!;
    final audio = ref.read(audioControllerProvider);

    // Listen for phase changes to update music and handle navigation
    ref.listen(gameStateProvider.select((s) => s.phase), (previous, next) {
      if (previous != next) {
        audio.playBackgroundMusic(next);
        
        if (next is GameOverPhase) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const VictoryScreen()),
          );
        }
      }
    });

    // Listen for missing audio
    ref.listen(missingAudioEventProvider, (prev, next) {
      if (next != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.audioNotFound(next)),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 4),
          ),
        );
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
                  child: Stack(
                    children: [
                      _buildEventLog(context, gameState),
                      Positioned(
                        top: 24,
                        right: 24,
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(gameState.isPaused ? Icons.play_arrow : Icons.pause, color: Colors.amber),
                              onPressed: () => ref.read(gameControllerProvider).pauseGame(),
                              tooltip: gameState.isPaused ? l10n.resumeSpace : l10n.pauseSpace,
                            ),
                            IconButton(
                              icon: const Icon(Icons.stop, color: Colors.redAccent),
                              onPressed: () => _showStopConfirmation(context),
                              tooltip: l10n.stopGameEsc,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => ref.read(gameControllerProvider).advancePhase(),
              label: Text(l10n.advancePhase),
              icon: const Icon(Icons.skip_next),
              backgroundColor: Colors.amber,
            ),
          ),
          if (gameState.isPaused)
            Container(
              color: Colors.black87,
              child: Center(
                child: Text(
                  l10n.gamePausedLarge,
                  style: const TextStyle(fontSize: 72, fontWeight: FontWeight.bold, color: Colors.amber, decoration: TextDecoration.none),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPhaseHeader(BuildContext context, GameState state) {
    final l10n = AppLocalizations.of(context)!;
    final isNight = state.phase.id == 'night';
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
            _getPhaseName(state, l10n).toUpperCase(),
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
          
          if (state.statusMessage != null && state.statusMessage!.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(top: 24, left: 48, right: 48),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.amber.withValues(alpha: 0.5), width: 2),
              ),
              child: Text(
                state.statusMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28, 
                  color: Colors.amber, 
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  shadows: [
                    Shadow(color: Colors.black, blurRadius: 4, offset: Offset(2, 2)),
                  ],
                ),
              ),
            ),

          if ((state.currentMoveId == 'day_verdict') && state.verdictTargetId != null) ...[
              const SizedBox(height: 24),
              Text(
                l10n.judgingPlayer(state.players.firstWhere((p) => p.id == state.verdictTargetId).number),
                style: const TextStyle(fontSize: 24, color: Colors.amber, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                    _VerdictTally(
                      label: l10n.execute, 
                      count: state.currentVerdicts?.values.where((v) => v == true).length ?? 0,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 48),
                    _VerdictTally(
                      label: l10n.pardon, 
                      count: state.currentVerdicts?.values.where((v) => v == false).length ?? 0,
                      color: Colors.greenAccent,
                    ),
                ],
              )
          ],
          if (state.currentMoveId == 'day_voting') ...[
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _VerdictTally(
                  label: l10n.votesCast, 
                  count: state.currentVotes?.length ?? 0,
                  color: Colors.amberAccent,
                ),
                const SizedBox(width: 48),
                _VerdictTally(
                  label: l10n.remaining, 
                  count: state.players.where((p) => p.isAlive).length - (state.currentVotes?.length ?? 0),
                  color: Colors.white24,
                ),
              ],
            )
          ],
        ],
      ),
    );
  }

  Widget _buildPlayerGrid(BuildContext context, GameState state) {
    final votes = state.currentVotes ?? {};
    final voteCounts = <String, int>{};
    votes.forEach((voterId, targetId) {
      voteCounts[targetId] = (voteCounts[targetId] ?? 0) + 1;
    });

    int maxVotes = 0;
    for (final count in voteCounts.values) {
      if (count > maxVotes) maxVotes = count;
    }

    final topAccusedIds = maxVotes > 0 
        ? voteCounts.entries.where((e) => e.value == maxVotes).map((e) => e.key).toSet() 
        : <String>{};

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
          final targetId = votes[player.id];
          final target = targetId != null ? state.players.firstWhereOrNull((p) => p.id == targetId) : null;
          final accusedCount = voteCounts[player.id] ?? 0;
          final isTopAccused = topAccusedIds.contains(player.id);

          return _PlayerCard(
            player: player,
            votingFor: target?.number,
            votesAgainst: accusedCount,
            isHighlighted: isTopAccused && state.currentMoveId == 'day_voting',
          );
        },
      ),
    );
  }

  Widget _buildEventLog(BuildContext context, GameState state) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            l10n.eventLog,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
        ),
        const Divider(color: Colors.white12),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(left: 24, right: 24, bottom: 100),
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

  String _getPhaseName(GameState state, AppLocalizations l10n) {
    final key = state.currentMoveId ?? state.phase.id;
    switch (key) {
      case 'lobby': return l10n.phaseLobby;
      case 'setup': return l10n.phaseSetup;
      case 'roleReveal': return l10n.phaseRoleReveal;
      case 'night_start': return l10n.phaseNightStart;
      case 'night_mafia': return l10n.phaseNightMafia;
      case 'night_prostitute': return l10n.phaseNightProstitute;
      case 'night_maniac': return l10n.phaseNightManiac;
      case 'night_doctor': return l10n.phaseNightDoctor;
      case 'night_poisoner': return l10n.phaseNightPoisoner;
      case 'night_commissar': return l10n.phaseNightCommissar;
      case 'morning': return l10n.phaseMorning;
      case 'day_discussion': return l10n.phaseDayDiscussion;
      case 'day_voting': return l10n.phaseDayVoting;
      case 'day_defense': return l10n.phaseDayDefense;
      case 'day_verdict': return l10n.phaseDayVerdict;
      case 'gameOver': return l10n.phaseGameOver;
      default: return key;
    }
  }
}

class _PlayerCard extends StatelessWidget {
  final Player player;
  final int? votingFor;
  final int votesAgainst;
  final bool isHighlighted;

  const _PlayerCard({
    required this.player,
    this.votingFor,
    this.votesAgainst = 0,
    this.isHighlighted = false,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final cardColor = player.isAlive 
        ? (isHighlighted ? Colors.amber.withValues(alpha: 0.1) : Colors.grey.shade900)
        : Colors.black45;

    return Card(
      elevation: player.isAlive ? (isHighlighted ? 12 : 8) : 0,
      color: cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isHighlighted 
              ? Colors.amber 
              : (player.isAlive ? Colors.amber.withValues(alpha: 0.3) : Colors.transparent),
          width: isHighlighted ? 3 : 2,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: player.isAlive ? Colors.amber : Colors.grey,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${player.number}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: Text(
                player.nickname,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: player.isAlive ? Colors.white : Colors.white24,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (!player.isAlive)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  children: [
                    Text(
                      l10n.eliminated,
                      style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      player.role.name.toUpperCase(),
                      style: const TextStyle(color: Colors.white54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            if (player.isAlive && votesAgainst > 0)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                  ),
                  child: Text(
                    l10n.votesCount(votesAgainst),
                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
            if (player.isAlive && votingFor != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  l10n.votingFor(votingFor!),
                  style: const TextStyle(color: Colors.white38, fontSize: 13, fontStyle: FontStyle.italic),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
class _VerdictTally extends StatelessWidget {
    final String label;
    final int count;
    final Color color;

    const _VerdictTally({required this.label, required this.count, required this.color});

    @override
    Widget build(BuildContext context) {
        return Column(
            children: [
                Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, letterSpacing: 1)),
                Text('$count', style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w900, color: Colors.white)),
            ],
        );
    }
}
