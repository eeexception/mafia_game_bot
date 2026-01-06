import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/state/providers.dart';
import 'setup_screen.dart';
import 'statistics_screen.dart';
import '../../../../l10n/app_localizations.dart';

class LobbyScreen extends ConsumerWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final players = gameState.players;
    final serverUrl = ref.watch(serverUrlProvider);

    final l10n = AppLocalizations.of(context)!;

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

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 48),
              Text('MAFIA GAME', style: Theme.of(context).textTheme.displayLarge),
              const SizedBox(height: 48),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: QrImageView(
                  data: '$serverUrl?sid=${gameState.sessionId}',
                  version: QrVersions.auto,
                  size: 250.0,
                ),
              ),
              const SizedBox(height: 24),
              Text(l10n.scanToJoin, style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 48),
              const SizedBox(height: 48),
              Text(
                l10n.connectedPlayersCount(players.where((p) => p.isConnected).length), 
                style: Theme.of(context).textTheme.displaySmall?.copyWith(color: Colors.amber)
              ),
              if (players.any((p) => !p.isConnected))
                Text(
                  l10n.totalPlayersRegistered(players.length), 
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white54)
                ),
              const SizedBox(height: 24),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                width: 600,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return Opacity(
                      opacity: player.isConnected ? 1.0 : 0.5,
                      child: Card(
                        margin: const EdgeInsets.symmetric(horizontal: 8),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CircleAvatar(
                                    backgroundColor: player.isConnected ? Colors.amber : Colors.grey,
                                    child: Text('${player.number}', style: const TextStyle(color: Colors.black)),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    player.nickname,
                                    style: TextStyle(
                                      fontWeight: player.isConnected ? FontWeight.bold : FontWeight.normal,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (!player.isConnected)
                              Positioned(
                                top: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(Icons.close, size: 18, color: Colors.redAccent),
                                  onPressed: () {
                                    ref.read(gameControllerProvider).removePlayer(player.id);
                                  },
                                  tooltip: l10n.removeDisconnectedPlayer,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 48),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const StatisticsScreen()),
                      );
                    },
                    child: Text(l10n.viewStatistics),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SetupScreen()),
                      );
                    },
                    child: Text(l10n.setupGame),
                  ),
                ],
              ),
              const SizedBox(height: 48),
            ],
          ),
        ),
      ),
    );
  }
}
