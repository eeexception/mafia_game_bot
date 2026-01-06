import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import '../../../core/models/game_state.dart';
import '../../../core/models/player.dart';
import '../../../core/models/game_phase.dart';
import '../../../core/models/role.dart';
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
      if (state.phase == GamePhase.nightCommissar && !state.config.commissarKills && me.role is CommissarRole) {
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

    final availableActions = <Map<String, dynamic>>[];
    
    if (state.phase == GamePhase.nightMafia && me.role is MafiaRole) {
        final role = me.role as MafiaRole;
        if (role.isDon && state.config.donMechanicsEnabled) {
          availableActions.add({
            'type': 'mafia_kill',
            'label': l10n.donKillAction,
            'selectedId': selectedTargetId,
            'onSelect': (id) => onTargetSelected(id),
          });
          availableActions.add({
            'type': 'don_check',
            'label': l10n.donSearch,
            'selectedId': selectedDonTargetId,
            'onSelect': (id) => onDonTargetSelected(id),
          });
        } else if (state.config.donMechanicsEnabled) {
          final livingDon = state.players.firstWhereOrNull((p) => p.isAlive && p.role is MafiaRole && (p.role as MafiaRole).isDon);
          if (livingDon == null) {
              // Don is dead, everyone votes
              availableActions.add({
                'type': 'vote',
                'label': l10n.mafiaTeamVote,
                'selectedId': selectedTargetId,
                'onSelect': (id) => onTargetSelected(id),
              });
          }
        } else {
          // Don mechanics disabled
          availableActions.add({
            'type': 'vote',
            'label': l10n.mafiaTeamVote,
            'selectedId': selectedTargetId,
            'onSelect': (id) => onTargetSelected(id),
          });
        }
    } else if (state.phase == GamePhase.nightMafia && me.role is LawyerRole) {
        availableActions.add({
          'type': 'lawyer_check',
          'label': l10n.lawyerInvestigation,
          'selectedId': selectedTargetId,
          'onSelect': (id) => onTargetSelected(id),
        });
    } else if (state.phase == GamePhase.nightPoisoner && me.role is PoisonerRole) {
        availableActions.add({
          'type': 'poison',
          'label': l10n.poisonerAction,
          'selectedId': selectedTargetId,
          'onSelect': (id) => onTargetSelected(id),
        });
    } else if (state.phase == GamePhase.nightDoctor && me.role is DoctorRole) {
        final lastDoctorTargetId = state.lastDoctorTargetId;
        final canHealSelf = state.config.doctorCanHealSelf;
        final canHealConsecutively = state.config.doctorCanHealSameTargetConsecutively;

        availableActions.add({
          'type': 'doctor_heal',
          'label': l10n.doctorAction,
          'selectedId': selectedTargetId,
          'onSelect': (id) => onTargetSelected(id),
          'filter': (Player p) {
            if (p.id == me.id && !canHealSelf) return false;
            if (p.id == lastDoctorTargetId && !canHealConsecutively) return false;
            return true;
          },
        });
    } else if (state.phase == GamePhase.nightCommissar && (me.role is CommissarRole || me.role is SergeantRole)) {
        final isSergeant = me.role is SergeantRole;
        final hasSergeant = state.players.any((p) => p.role.type == RoleType.sergeant);
        
        // If sergeant is in game, duties are strictly separated
        String actionType;
        if (hasSergeant) {
            actionType = isSergeant ? 'commissar_check' : 'commissar_kill';
        } else {
            // Traditional mode
            actionType = state.config.commissarKills ? 'commissar_kill' : 'commissar_check';
        }

        availableActions.add({
          'type': actionType,
          'label': actionType == 'commissar_kill' ? l10n.commissarActionKill : l10n.commissarActionInvestigate,
          'selectedId': selectedTargetId,
          'onSelect': (id) => onTargetSelected(id),
        });
    }
    
    if (availableActions.isEmpty) {
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
      children: availableActions
          .map((action) => _buildActionRow(context, action))
          .toList(),
    );
  }

  Widget _buildActionRow(BuildContext context, Map<String, dynamic> action) {
    final actionType = action['type'] as String;
    final label = action['label'] as String;
    final selectedId = action['selectedId'] as String?;
    final onSelect = action['onSelect'] as Function(String);
    final filter = action['filter'] as bool Function(Player)? ?? (p) => p.id != me.id;

    final targets = state.players
        .where((p) => p.isAlive && filter(p))
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
                        if (actionType == 'mafia_kill' || actionType == 'vote')
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
