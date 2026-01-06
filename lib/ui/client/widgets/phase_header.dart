import 'package:flutter/material.dart';
import '../../../core/models/game_state.dart';
import '../../../core/models/player.dart';

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
                state.phase.name.toUpperCase().replaceAll('_', ' '),
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
}
