import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../core/state/providers.dart';
import 'setup_screen.dart';
import 'statistics_screen.dart';

class LobbyScreen extends ConsumerWidget {
  const LobbyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameState = ref.watch(gameStateProvider);
    final players = gameState.players;
    final serverUrl = ref.watch(serverUrlProvider);

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
                  data: serverUrl,
                  version: QrVersions.auto,
                  size: 250.0,
                ),
              ),
              const SizedBox(height: 24),
              Text('Scan to Join', style: Theme.of(context).textTheme.displayMedium),
              const SizedBox(height: 48),
              Text('Connected Players: ${players.length}', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 24),
              SizedBox(
                height: 200,
                width: 600,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(child: Text('${player.number}')),
                            const SizedBox(height: 8),
                            Text(player.nickname),
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
                    child: const Text('VIEW STATISTICS'),
                  ),
                  const SizedBox(width: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const SetupScreen()),
                      );
                    },
                    child: const Text('SETUP GAME'),
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
