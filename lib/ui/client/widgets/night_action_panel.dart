import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../../domain/models/game/game_state.dart';
import '../../../domain/models/players/player.dart';
import '../../../domain/models/roles/role.dart';
import '../../../../l10n/app_localizations.dart';

/// Panel for Night Actions (Kill, Block, Heal, Investigate, Don Search).
class NightActionPanel extends StatelessWidget {
  final Player me;
  final GameState state;
  final String? selectedTargetId;
  final String? selectedDonTargetId;
  final Map<String, String> mafiaVotes;
  final Function(String? targetId) onTargetSelected;
  final Function(String? targetId) onDonTargetSelected;

  const NightActionPanel({
    super.key,
    required this.me,
    required this.state,
    required this.selectedTargetId,
    required this.selectedDonTargetId,
    required this.mafiaVotes,
    required this.onTargetSelected,
    required this.onDonTargetSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    if (me.hasActed) {
      // Special case for Commissar after inspection
      if (state.currentMoveId == 'night_commissar' && !state.config.commissarKills && me.role is CommissarRole) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              const Icon(Icons.remove_red_eye, color: Colors.blueAccent, size: 64),
              const SizedBox(height: 16),
              Text(
                l10n.resultsViewing, 
                style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => onTargetSelected('commissar_ready_signal'),
                icon: const Icon(Icons.bedtime, color: Colors.white),
                label: Text(l10n.fallAsleep, style: const TextStyle(fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        );
      }

      return Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          children: [
            const Icon(Icons.check_circle, color: Colors.greenAccent, size: 64),
            const SizedBox(height: 16),
            Text(
              l10n.actionConfirmed, 
              style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.waitingForOthers, 
              style: const TextStyle(color: Colors.white38, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      );
    }

    final actions = me.role.getActions(state, me);
    
    if (actions.isEmpty) {
        return Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text(
            l10n.cityIsSleeping, 
            style: const TextStyle(
              color: Colors.white38, 
              fontStyle: FontStyle.italic, 
              fontSize: 18,
            ),
          ),
        );
    }

    return Column(
      children: actions
          .map((action) => _buildActionRow(context, action))
          .toList(),
    );
  }

  Widget _buildActionRow(BuildContext context, RoleAction action) {
    final l10n = AppLocalizations.of(context)!;
    final label = _getLocalizedLabel(l10n, action.labelKey);
    final isDonCheck = action.type == 'don_check';
    final selectedId = isDonCheck ? selectedDonTargetId : selectedTargetId;
    final onSelect = isDonCheck ? onDonTargetSelected : onTargetSelected;

    final targets = state.players
        .where((p) => p.isAlive && action.isEligibleTarget(p, me, state))
        .toList();

    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          label, 
          style: const TextStyle(
            color: Colors.amber, 
            fontWeight: FontWeight.bold, 
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: targets.length,
            itemBuilder: (context, index) {
              final p = targets[index];
              final isSelected = selectedId == p.id;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: InkWell(
                  onTap: () => onSelect(p.id),
                  child: Container(
                    width: 100,
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? Colors.indigo.shade700 
                          : Colors.indigo.shade900.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected ? Colors.amber : Colors.indigo.shade700,
                        width: isSelected ? 3 : 1,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.amber.withValues(alpha: 0.3), 
                          blurRadius: 10,
                        )
                      ] : [],
                    ),
                    child: Stack(
                      children: [
                        Center(
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
                        if (action.type == 'mafia_kill' || action.type == 'vote')
                          Positioned(
                            top: 4,
                            right: 4,
                            child: _buildMafiaVoteIndicators(p.id),
                          ),
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

  String _getLocalizedLabel(AppLocalizations l10n, String key) {
    switch (key) {
      case 'donKillAction': return l10n.donKillAction;
      case 'donSearch': return l10n.donSearch;
      case 'mafiaTeamVote': return l10n.mafiaTeamVote;
      case 'lawyerInvestigation': return l10n.lawyerInvestigation;
      case 'poisonerAction': return l10n.poisonerAction;
      case 'doctorAction': return l10n.doctorAction;
      case 'commissarActionKill': return l10n.commissarActionKill;
      case 'commissarActionInvestigate': return l10n.commissarActionInvestigate;
      case 'maniacAction': return l10n.maniacAction;
      default: return key;
    }
  }


  Widget _buildMafiaVoteIndicators(String targetId) {
    final voters = mafiaVotes.entries
        .where((e) => e.value == targetId)
        .map((e) => state.players.firstWhereOrNull((p) => p.id == e.key))
        .nonNulls
        .toList();

    if (voters.isEmpty) return const SizedBox();

    final livingMafiaCount = state.players
        .where((p) => p.isAlive && p.role.type == RoleType.mafia)
        .length;
    final isConsensus = voters.length == livingMafiaCount;

    return Column(
      children: [
        if (isConsensus)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'KILL', 
              style: TextStyle(
                fontSize: 8, 
                fontWeight: FontWeight.bold, 
                color: Colors.black,
              ),
            ),
          ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: voters.map((v) => Container(
            margin: const EdgeInsets.only(left: 2),
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isConsensus ? Colors.red : Colors.white24,
            ),
            child: Text(
              '${v.number}', 
              style: const TextStyle(
                fontSize: 8, 
                fontWeight: FontWeight.bold,
              ),
            ),
          )).toList(),
        ),
      ],
    );
  }
}
