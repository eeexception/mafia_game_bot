import '../models/player.dart';
import '../models/role.dart';
import '../models/player_action.dart';

class WinDetector {
  WinResult? checkWinCondition(List<Player> players) {
    final alive = players.where((p) => p.isAlive).toList();
    final mafiaCount = alive.where((p) => p.role.type == RoleType.mafia).length;
    final civilianCount = alive.where((p) => p.role.faction == Faction.town).length;
    final maniacAlive = alive.any((p) => p.role.type == RoleType.maniac);
    final poisonerAlive = alive.any((p) => p.role.type == RoleType.poisoner);
    
    // Maniac/Poisoner victory: Last player OR 1v1 with any player
    // Note: If both are alive and it's 2 players total, return based on who is present
    if (maniacAlive && alive.length <= 2 && !poisonerAlive) {
      return const WinResult(faction: Faction.neutral, message: 'Maniac Wins!');
    }
    if (poisonerAlive && alive.length <= 2 && !maniacAlive) {
      return const WinResult(faction: Faction.neutral, message: 'Poisoner Wins!');
    }
    // If both are alive and it's 2 players, they might both be neutral killers. 
    // Usually game ends if no one can kill each other or they draw. 
    // For simplicity, if they are the only 2, game continues until one kills the other?
    // Actually, Likho dies from interaction. If Maniac kills Poisoner, Poisoner kills Maniac.
    
    // Mafia victory: Mafia >= Civilians AND (Maniac dead AND Poisoner dead)
    if (mafiaCount >= civilianCount && !maniacAlive && !poisonerAlive) {
      return const WinResult(faction: Faction.mafia, message: 'Mafia Wins!');
    }
    
    // Town victory: All Mafia AND (Maniac dead AND Poisoner dead)
    if (mafiaCount == 0 && !maniacAlive && !poisonerAlive) {
      return const WinResult(faction: Faction.town, message: 'Town Wins!');
    }
    
    return null;  // Game continues
  }
}
