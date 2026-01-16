import 'package:flutter/material.dart';
import '../../../domain/models/players/player.dart';

/// Widget that allows a player to reveal their role by pressing and holding.
class RoleViewer extends StatefulWidget {
  final Player me;

  const RoleViewer({
    super.key,
    required this.me,
  });

  @override
  State<RoleViewer> createState() => _RoleViewerState();
}

class _RoleViewerState extends State<RoleViewer> {
  bool _roleVisible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onLongPressStart: (_) => setState(() => _roleVisible = true),
          onLongPressEnd: (_) => setState(() => _roleVisible = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(48),
            decoration: BoxDecoration(
              color: _roleVisible 
                  ? Colors.amber.withValues(alpha: 0.2) 
                  : Colors.white.withValues(alpha: 0.05),
              shape: BoxShape.circle,
              border: Border.all(
                color: _roleVisible ? Colors.amber : Colors.white24, 
                width: 3,
              ),
              boxShadow: _roleVisible ? [
                BoxShadow(
                  color: Colors.amber.withValues(alpha: 0.3), 
                  blurRadius: 20, 
                  spreadRadius: 5,
                )
              ] : [],
            ),
            child: Icon(
              _roleVisible ? Icons.visibility : Icons.visibility_off,
              size: 80,
              color: _roleVisible ? Colors.amber : Colors.white38,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          _roleVisible 
              ? widget.me.role.name.toUpperCase() 
              : 'PRESS AND HOLD TO REVEAL ROLE',
          style: TextStyle(
            fontSize: 20, 
            fontWeight: FontWeight.bold, 
            color: _roleVisible ? Colors.amber : Colors.white54,
            letterSpacing: 2,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
