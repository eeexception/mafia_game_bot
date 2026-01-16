import 'package:flutter/material.dart';
import '../../../domain/models/game/game_state.dart';
import '../../../domain/models/players/player.dart';

/// Panel for Day Verdict (Pardon or Execute choice).
class VerdictPanel extends StatelessWidget {
  final Player me;
  final GameState state;
  final String? selectedTargetId;
  final ValueChanged<String?> onTargetSelected;

  const VerdictPanel({
    super.key,
    required this.me,
    required this.state,
    required this.selectedTargetId,
    required this.onTargetSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (state.verdictTargetId == null) return const SizedBox();
    final target = state.players.firstWhere((p) => p.id == state.verdictTargetId);
    
    return Column(
      children: [
        const Text(
          'LAST VERDICT', 
          style: TextStyle(
            fontWeight: FontWeight.bold, 
            letterSpacing: 2, 
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Should we execute ${target.nickname}?',
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildVerdictButton(
              label: 'PARDON',
              icon: Icons.favorite,
              color: Colors.green,
              isSelected: selectedTargetId == 'pardon',
              onTap: me.hasActed ? null : () => onTargetSelected('pardon'),
            ),
            _buildVerdictButton(
              label: 'EXECUTE',
              icon: Icons.gavel,
              color: Colors.red,
              isSelected: selectedTargetId == 'execute',
              onTap: me.hasActed ? null : () => onTargetSelected('execute'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVerdictButton({
    required String label,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? color : color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.white : color, width: 2),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? Colors.white : color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
