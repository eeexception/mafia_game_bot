import 'package:flutter/material.dart';
import '../../../domain/models/game/game_state.dart';
import '../../../domain/models/players/player.dart';
import '../../../../l10n/app_localizations.dart';

/// Header widget for the Client PWA showing player info and game status.
class PhaseHeader extends StatelessWidget {
  final Player me;
  final GameState state;

  const PhaseHeader({
    super.key,
    required this.me,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.amber,
            radius: 24,
            child: Text(
              '${me.number}', 
              style: const TextStyle(
                color: Colors.black, 
                fontWeight: FontWeight.bold, 
                fontSize: 20,
              ),
            ),
          ),
          Column(
            children: [
              Text(
                _getPhaseName(state, l10n).toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold, 
                  letterSpacing: 2, 
                  fontSize: 16,
                ),
              ),
              if (state.timerSecondsRemaining != null)
                Text(
                  '${state.timerSecondsRemaining}s', 
                  style: const TextStyle(
                    fontSize: 28, 
                    fontWeight: FontWeight.bold, 
                    color: Colors.amber,
                  ),
                ),
            ],
          ),
          const Opacity(
            opacity: 0.3,
            child: Icon(Icons.settings, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }

  String _getPhaseName(GameState state, AppLocalizations l10n) {
    final key = state.currentMoveId ?? state.phase.id;
    switch (key) {
      case 'lobby': return l10n.phaseLobby;
      case 'setup': return l10n.phaseSetup;
      case 'roleReveal': return l10n.phaseRoleReveal;
      case 'night_start': return l10n.phaseNightStart;
      case 'night_mafia': return l10n.phaseNightMafia;
      case 'night_prostitute': return l10n.phaseNightProstitute;
      case 'night_maniac': return l10n.phaseNightManiac;
      case 'night_doctor': return l10n.phaseNightDoctor;
      case 'night_poisoner': return l10n.phaseNightPoisoner;
      case 'night_commissar': return l10n.phaseNightCommissar;
      case 'morning': return l10n.phaseMorning;
      case 'day_discussion': return l10n.phaseDayDiscussion;
      case 'day_voting': return l10n.phaseDayVoting;
      case 'day_defense': return l10n.phaseDayDefense;
      case 'day_verdict': return l10n.phaseDayVerdict;
      case 'gameOver': return l10n.phaseGameOver;
      default: return key;
    }
  }
}
