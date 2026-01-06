import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/providers.dart';
import '../../../core/models/game_state.dart';
import '../../../core/models/role.dart';
import '../../../core/models/game_phase.dart';
import 'lobby_screen.dart';
import '../../../../l10n/app_localizations.dart';

class VictoryScreen extends ConsumerWidget {
  const VictoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final l10n = AppLocalizations.of(context)!;
    final winDetector = ref.watch(winDetectorProvider);
    final winResult = winDetector.checkWinCondition(gameState.players);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.emoji_events, size: 100, color: Colors.amber),
              const SizedBox(height: 24),
              Text(
                winResult?.message.toUpperCase() ?? l10n.phaseGameOver.toUpperCase(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: Colors.white,
                  letterSpacing: 4,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              _buildRoleTable(context, gameState),
              const SizedBox(height: 64),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(gameControllerProvider).resetGame();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LobbyScreen()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.newGameKeepPlayers),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      ref.read(gameControllerProvider).terminateSession();
                      // Full reset and return to lobby for new players
                      ref.read(gameStateProvider.notifier).updateState(
                        GameState(
                          phase: GamePhase.lobby, 
                          players: [], 
                          config: gameState.config,
                          sessionId: '' // Will be set in next startGame
                        )
                      );
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LobbyScreen()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.exit_to_app),
                    label: Text(l10n.exitToMainMenu),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final path = await ref.read(gameLoggerProvider).exportLog();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(path != null ? l10n.logExportedTo(path) : l10n.failedToExportLog),
                            backgroundColor: path != null ? Colors.amber : Colors.red,
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.download),
                    label: Text(l10n.exportLog),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                      side: const BorderSide(color: Colors.white24),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleTable(BuildContext context, GameState state) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      width: 800,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: DataTable(
        columns: [
          DataColumn(label: Text(l10n.no)),
          DataColumn(label: Text(l10n.nickname)),
          DataColumn(label: Text(l10n.role)),
          DataColumn(label: Text(l10n.status)),
        ],
        rows: state.players.map((p) {
          return DataRow(cells: [
            DataCell(Text('${p.number}')),
            DataCell(Text(p.nickname, style: const TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text(p.role.getDisplayName({}), style: TextStyle(color: _getRoleColor(p.role)))),
            DataCell(Text(p.isAlive ? l10n.alive : l10n.eliminated, 
              style: TextStyle(color: p.isAlive ? Colors.green : Colors.redAccent))),
          ]);
        }).toList(),
      ),
    );
  }

  Color _getRoleColor(Role role) {
    if (role is MafiaRole) return Colors.red;
    if (role is LawyerRole) return Colors.deepOrange;
    if (role is ManiacRole) return Colors.purple;
    if (role is PoisonerRole) return Colors.greenAccent;
    if (role is CommissarRole) return Colors.blue;
    if (role is SergeantRole) return Colors.lightBlueAccent;
    if (role is DoctorRole) return Colors.green;
    return Colors.white70;
  }
}
