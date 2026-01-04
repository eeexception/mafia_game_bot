import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/providers.dart';
import '../../../core/models/game_state.dart';
import '../../../core/models/role.dart';
import '../../../core/models/game_phase.dart';
import '../../../core/models/game_config.dart';
import 'lobby_screen.dart';

class VictoryScreen extends ConsumerWidget {
  const VictoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
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
                winResult?.message.toUpperCase() ?? 'GAME OVER',
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
                      // Reset game state
                      ref.read(gameStateProvider.notifier).updateState(
                        const GameState(
                          phase: GamePhase.lobby, 
                          players: [], 
                          config: GameConfig(themeId: 'classic_chicago')
                        )
                      );
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LobbyScreen()),
                        (route) => false,
                      );
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('NEW GAME'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                    ),
                  ),
                  const SizedBox(width: 24),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final path = await ref.read(gameLoggerProvider).exportLog();
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(path != null ? 'Log exported to: $path' : 'Failed to export log'),
                            backgroundColor: path != null ? Colors.amber : Colors.red,
                            duration: const Duration(seconds: 5),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.download),
                    label: const Text('EXPORT LOG'),
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
    return Container(
      width: 800,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: DataTable(
        columns: const [
          DataColumn(label: Text('NO.')),
          DataColumn(label: Text('NICKNAME')),
          DataColumn(label: Text('ROLE')),
          DataColumn(label: Text('STATUS')),
        ],
        rows: state.players.map((p) {
          return DataRow(cells: [
            DataCell(Text('${p.number}')),
            DataCell(Text(p.nickname, style: const TextStyle(fontWeight: FontWeight.bold))),
            DataCell(Text(p.role.name, style: TextStyle(color: _getRoleColor(p.role)))),
            DataCell(Text(p.isAlive ? 'ALIVE' : 'ELIMINATED', 
              style: TextStyle(color: p.isAlive ? Colors.green : Colors.redAccent))),
          ]);
        }).toList(),
      ),
    );
  }

  Color _getRoleColor(Role role) {
    if (role is MafiaRole) return Colors.red;
    if (role is ManiacRole) return Colors.purple;
    if (role is CommissarRole) return Colors.blue;
    if (role is DoctorRole) return Colors.green;
    return Colors.white70;
  }
}
