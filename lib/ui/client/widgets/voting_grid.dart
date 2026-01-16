import 'package:flutter/material.dart';
import '../../../core/models/game_state.dart';
import '../../../core/models/player.dart';

/// Horizontal grid for Day Voting (selection of suspect).
class VotingGrid extends StatelessWidget {
  final Player me;
  final GameState state;
  final String? selectedTargetId;
  final ValueChanged<String?> onTargetSelected;

  const VotingGrid({
    super.key,
    required this.me,
    required this.state,
    required this.selectedTargetId,
    required this.onTargetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final alivePlayers = state.players
        .where((p) => p.isAlive && p.id != me.id)
        .toList();

    return Column(
      children: [
        const Text(
          'VOTE TO EXECUTE', 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            letterSpacing: 2, 
            color: Colors.redAccent,
          ),
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
              final isSelected = selectedTargetId == p.id;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: me.hasActed ? null : () => onTargetSelected(p.id),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Colors.red.shade700 
                          : Colors.red.shade900.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.amber : Colors.red.shade700,
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.amber.withValues(alpha: 0.3), 
                          blurRadius: 10,
                        )
                      ] : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${p.number}', 
                          style: const TextStyle(
                            fontSize: 24, 
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
}
