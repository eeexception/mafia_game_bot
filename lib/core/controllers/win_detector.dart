import '../models/player.dart';
import '../models/role.dart';
import '../models/player_action.dart';

class WinDetector {
  WinResult? checkWinCondition(List<Player> players) {
    final alive = players.where((p) => p.isAlive).toList();
    final mafiaCount = alive.where((p) => p.role.type == RoleType.mafia).length;
    final civilianCount = alive.where((p) => p.role.faction == Faction.town).length;
    final maniacAlive = alive.any((p) => p.role.type == RoleType.maniac);
    
    // Maniac victory: Last player OR 1v1 with any player
    // Note: In 1v1 Maniac vs Mafia, Maniac usually wins in many rules, 
    // but here we follow the simple 2 player limit.
    if (maniacAlive && alive.length <= 2) {
      return const WinResult(faction: Faction.neutral, message: 'Maniac Wins!');
    }
    
    // Mafia victory: Mafia >= Civilians AND Maniac dead
    if (mafiaCount >= civilianCount && !maniacAlive) {
      return const WinResult(faction: Faction.mafia, message: 'Mafia Wins!');
    }
    
    // Town victory: All Mafia AND Maniac dead
    if (mafiaCount == 0 && !maniacAlive) {
      return const WinResult(faction: Faction.town, message: 'Town Wins!');
    }
    
    return null;  // Game continues
  }
}
