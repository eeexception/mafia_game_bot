import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';
import '../../../presentation/state/app/providers.dart';
import '../../../domain/models/game/game_state.dart';
import '../../../domain/models/roles/role.dart';

class ClientVictoryScreen extends ConsumerStatefulWidget {
  const ClientVictoryScreen({super.key});

  @override
  ConsumerState<ClientVictoryScreen> createState() => _ClientVictoryScreenState();
}

class _ClientVictoryScreenState extends ConsumerState<ClientVictoryScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(wakeLockServiceProvider).enable();
  }

  @override
  void dispose() {
    ref.read(wakeLockServiceProvider).disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(clientGameStateProvider);
    final playerId = ref.watch(clientPlayerIdProvider);
    final storage = ref.watch(storageServiceProvider);

    if (gameState == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final winDetector = ref.watch(winDetectorProvider);
    final winResult = winDetector.checkWinCondition(gameState.players);
    final me = gameState.players.firstWhereOrNull((p) => p.id == playerId);

    final gamesPlayed = storage.getStat('personal_games_played', defaultValue: 0) as int;
    final gamesWon = storage.getStat('personal_games_won', defaultValue: 0) as int;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.grey.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 32),
              const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
              const SizedBox(height: 16),
              Text(
                winResult?.message.toUpperCase() ?? 'GAME OVER',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              if (me != null) ...[
                const SizedBox(height: 8),
                Text(
                  'YOUR ROLE: ${me.role.name.toUpperCase()}',
                  style: TextStyle(
                    fontSize: 16,
                    color: _getRoleColor(me.role),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
              const SizedBox(height: 32),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildPlayerList(gameState),
                ),
              ),
              _buildPersonalStats(gamesPlayed, gamesWon),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () => _showLogDialog(context, ref),
                        icon: const Icon(Icons.history_edu, size: 18),
                        label: const Text('VIEW FULL LOG'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white24),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Clear only the session/token/playerId to allow joining a new game
                      // but keep stats and nickname as preferred in storage if possible.
                      // Actually, ConnectionScreen handles auto-join if nickname is in URL.
                      final currentNickname = me?.nickname;
                      
                      // Close current connection
                      ref.read(webSocketClientServiceProvider).disconnect();
                      
                      // Navigate to ConnectionScreen with preserved nickname if possible
                      if (currentNickname != null && mounted) {
                        // Using a simple navigation for now, 
                        // as ConnectionScreen will handle the rest based on storage/URL
                         Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                      } else {
                         Navigator.of(context).pop();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('JOIN NEXT GAME', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogDialog(BuildContext context, WidgetRef ref) {
    final logs = ref.read(gameLogsProvider);
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('GAME HISTORY', style: TextStyle(color: Colors.amber)),
        content: SizedBox(
          width: double.maxFinite,
          child: logs.isEmpty 
            ? const Center(child: Text('No logs available.', style: TextStyle(color: Colors.white54)))
            : ListView.builder(
                shrinkWrap: true,
                itemCount: logs.length,
                itemBuilder: (context, index) {
                  final log = logs[index];
                  final isSecret = log.startsWith('[SECRET]');
                  final cleanedLog = log.replaceFirst('[SECRET] ', '').replaceFirst('[PUBLIC] ', '');
                  
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          isSecret ? Icons.visibility_off : Icons.visibility,
                          size: 12,
                          color: isSecret ? Colors.redAccent.withValues(alpha: 0.5) : Colors.greenAccent.withValues(alpha: 0.5),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cleanedLog,
                            style: TextStyle(
                              color: isSecret ? Colors.white70 : Colors.white,
                              fontSize: 13,
                              fontStyle: isSecret ? FontStyle.italic : FontStyle.normal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('CLOSE', style: TextStyle(color: Colors.amber)),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerList(GameState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(8),
        itemCount: state.players.length,
        separatorBuilder: (context, index) => const Divider(color: Colors.white10, height: 1),
        itemBuilder: (context, index) {
          final p = state.players[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: p.isAlive ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
              child: Text('${p.number}', style: const TextStyle(color: Colors.white, fontSize: 14)),
            ),
            title: Text(p.nickname, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(p.role.name, style: TextStyle(color: _getRoleColor(p.role), fontSize: 12)),
            trailing: Text(
              p.isAlive ? 'ALIVE' : 'DEAD',
              style: TextStyle(
                color: p.isAlive ? Colors.green : Colors.redAccent,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPersonalStats(int played, int won) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn('GAMES', '$played'),
          Container(width: 1, height: 40, color: Colors.amber.withValues(alpha: 0.2)),
          _buildStatColumn('WINS', '$won'),
          Container(width: 1, height: 40, color: Colors.amber.withValues(alpha: 0.2)),
          _buildStatColumn('WIN RATE', played > 0 ? '${(won / played * 100).toStringAsFixed(0)}%' : '0%'),
        ],
      ),
    );
  }

  Widget _buildStatColumn(String label, String value) {
    return Column(
      children: [
        Text(label, style: const TextStyle(color: Colors.amber, fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Color _getRoleColor(Role role) {
    if (role is MafiaRole) return Colors.redAccent;
    if (role is ManiacRole) return Colors.purpleAccent;
    if (role is CommissarRole) return Colors.blueAccent;
    if (role is DoctorRole) return Colors.greenAccent;
    return Colors.white70;
  }
}
