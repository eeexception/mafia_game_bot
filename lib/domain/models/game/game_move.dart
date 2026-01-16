import 'game_config.dart';
import '../roles/role.dart';
import 'game_state.dart';

/// Represents a single interactive step within a game phase.
abstract class GameMove {
  const GameMove();

  String get id;
  
  /// Localization key for the move name/description
  String get nameKey;
  
  /// Duration in seconds for this move
  int getDuration(GameConfig config);
  
  /// Optional audio event to play when this move starts
  String? get audioEvent => null;

  /// Whether this move should be skipped based on current game state
  bool shouldSkip(GameState state) => false;
}

/// Initial night move: "City falls asleep"
class NightStartMove extends GameMove {
  const NightStartMove();
  @override
  String get id => 'night_start';
  @override
  String get nameKey => 'phaseNightStart';
  @override
  int getDuration(GameConfig config) => 15;
  @override
  String? get audioEvent => 'night_start';
}

/// Generic move for a specific role at night
class RoleMove extends GameMove {
  final RoleType roleType;
  
  const RoleMove(this.roleType);

  @override
  String get id {
    switch (roleType) {
      case RoleType.prostitute: return 'night_prostitute';
      case RoleType.poisoner: return 'night_poisoner';
      case RoleType.commissar: return 'night_commissar';
      case RoleType.maniac: return 'night_maniac';
      case RoleType.doctor: return 'night_doctor';
      default: return 'night_${roleType.name}';
    }
  }

  @override
  String get nameKey {
    switch (roleType) {
      case RoleType.prostitute: return 'phaseNightProstitute';
      case RoleType.poisoner: return 'phaseNightPoisoner';
      case RoleType.commissar: return 'phaseNightCommissar';
      case RoleType.maniac: return 'phaseNightManiac';
      case RoleType.doctor: return 'phaseNightDoctor';
      default: return 'phaseNight${roleType.name[0].toUpperCase()}${roleType.name.substring(1)}';
    }
  }

  @override
  int getDuration(GameConfig config) => config.otherActionTime;

  @override
  String? get audioEvent {
    switch (roleType) {
      case RoleType.prostitute: return 'prostitute_wake';
      case RoleType.poisoner: return 'poisoner_wake';
      case RoleType.commissar: return 'commissar_wake';
      case RoleType.maniac: return 'maniac_wake';
      case RoleType.doctor: return 'doctor_wake';
      default: return null;
    }
  }

  @override
  bool shouldSkip(GameState state) {
    // Skip if no alive players have this role
    // Special case: Commissar move includes Sergeant
    if (roleType == RoleType.commissar) {
      return !state.players.any((p) => p.isAlive && (p.role.type == RoleType.commissar || p.role.type == RoleType.sergeant));
    }
    return !state.players.any((p) => p.isAlive && p.role.type == roleType);
  }
}

/// Mafia kill move
class MafiaMove extends GameMove {
  const MafiaMove();
  @override
  String get id => 'night_mafia';
  @override
  String get nameKey => 'phaseNightMafia';
  @override
  int getDuration(GameConfig config) => config.mafiaActionTime;
  @override
  String? get audioEvent => 'mafia_wake';
  @override
  bool shouldSkip(GameState state) => !state.players.any((p) => p.isAlive && p.role.faction == Faction.mafia);
}

/// Morning announcements move (results of the night)
class MorningMove extends GameMove {
  const MorningMove();
  @override
  String get id => 'morning';
  @override
  String get nameKey => 'phaseMorning';
  @override
  int getDuration(GameConfig config) => 15;
  @override
  String? get audioEvent => 'day_start';
}

/// Public discussion move
class DiscussionMove extends GameMove {
  const DiscussionMove();
  @override
  String get id => 'day_discussion';
  @override
  String get nameKey => 'phaseDayDiscussion';
  @override
  int getDuration(GameConfig config) => config.discussionTime;
  @override
  String? get audioEvent => 'discussion_start';
}

/// Voting move
class VotingMove extends GameMove {
  const VotingMove();
  @override
  String get id => 'day_voting';
  @override
  String get nameKey => 'phaseDayVoting';
  @override
  int getDuration(GameConfig config) => config.votingTime;
  @override
  String? get audioEvent => 'voting_start';
}

/// Defense speech move
class DefenseMove extends GameMove {
  const DefenseMove();
  @override
  String get id => 'day_defense';
  @override
  String get nameKey => 'phaseDayDefense';
  @override
  int getDuration(GameConfig config) => config.defenseTime;
  @override
  String? get audioEvent => 'defense_start';
}

/// Final verdict move
class VerdictMove extends GameMove {
  const VerdictMove();
  @override
  String get id => 'day_verdict';
  @override
  String get nameKey => 'phaseDayVerdict';
  @override
  int getDuration(GameConfig config) => config.verdictTime;
  @override
  String? get audioEvent => 'verdict_start';
}
