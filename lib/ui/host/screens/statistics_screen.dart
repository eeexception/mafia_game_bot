import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/providers.dart';
import '../../../../l10n/app_localizations.dart';

class StatisticsScreen extends ConsumerWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final storage = ref.watch(storageServiceProvider);
    
    final l10n = AppLocalizations.of(context)!;
    
    final gamesPlayed = storage.getStat('games_played', defaultValue: 0);
    final winsTown = storage.getStat('wins_town', defaultValue: 0);
    final winsMafia = storage.getStat('wins_mafia', defaultValue: 0);
    final winsNeutral = storage.getStat('wins_neutral', defaultValue: 0);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.gameStatistics),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: 600,
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStatRow(l10n.totalGamesPlayed, '$gamesPlayed'),
              const Divider(height: 48, color: Colors.white10),
              _buildStatRow(l10n.townWins, '$winsTown', color: Colors.blueAccent),
              _buildStatRow(l10n.mafiaWins, '$winsMafia', color: Colors.redAccent),
              _buildStatRow(l10n.maniacWins, '$winsNeutral', color: Colors.purpleAccent),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () async {
                  await storage.clear();
                  if (context.mounted) {
                    Navigator.pop(context);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.withValues(alpha: 0.2),
                  foregroundColor: Colors.redAccent,
                ),
                child: Text(l10n.resetAllStatistics),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 18, letterSpacing: 1.5, color: Colors.white70)),
          Text(value, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: color ?? Colors.white)),
        ],
      ),
    );
  }
}
