import 'game_config.dart';

/// Base class for all role-specific night actions
abstract class RoleAction {
  final String type;
  final String labelKey;
  final String confirmLabelKey;

  const RoleAction({
    required this.type,
    required this.labelKey,
    required this.confirmLabelKey,
  });

  /// Filter for eligible targets for this action
  bool isEligibleTarget(dynamic target, dynamic performer, dynamic state);

  /// Whether this action requires a confirmation button
  bool get requiresConfirmation => true;
}

class MafiaKillAction extends RoleAction {
  const MafiaKillAction() : super(
    type: 'mafia_kill',
    labelKey: 'donKillAction',
    confirmLabelKey: 'confirmAction',
  );

  @override
  bool isEligibleTarget(target, performer, state) => 
      target.id != performer.id && target.isAlive;
}

class MafiaVoteAction extends RoleAction {
  const MafiaVoteAction() : super(
    type: 'vote',
    labelKey: 'mafiaTeamVote',
    confirmLabelKey: 'confirmAction',
  );

  @override
  bool isEligibleTarget(target, performer, state) => 
      target.id != performer.id && target.isAlive;
}

class DonCheckAction extends RoleAction {
  const DonCheckAction() : super(
    type: 'don_check',
    labelKey: 'donSearch',
    confirmLabelKey: 'confirmDonCheck',
  );

  @override
  bool isEligibleTarget(target, performer, state) => 
      target.id != performer.id && target.isAlive;
}

class DoctorHealAction extends RoleAction {
  const DoctorHealAction() : super(
    type: 'doctor_heal',
    labelKey: 'doctorAction',
    confirmLabelKey: 'confirmAction',
  );

  @override
  bool isEligibleTarget(target, performer, state) {
    if (!target.isAlive) return false;
    final config = state.config as GameConfig;
    final lastDoctorTargetId = state.lastDoctorTargetId as String?;
    
    final canHealSelf = config.doctorCanHealSelf;
    final canHealConsecutively = config.doctorCanHealSameTargetConsecutively;
    
    if (target.id == performer.id && !canHealSelf) return false;
    if (target.id == lastDoctorTargetId && !canHealConsecutively) return false;
    
    return true;
  }
}

class CommissarCheckAction extends RoleAction {
  const CommissarCheckAction() : super(
    type: 'commissar_check',
    labelKey: 'commissarActionInvestigate',
    confirmLabelKey: 'confirmAction',
  );

  @override
  bool isEligibleTarget(target, performer, state) => 
      target.id != performer.id && target.isAlive;
}

class CommissarKillAction extends RoleAction {
  const CommissarKillAction() : super(
    type: 'commissar_kill',
    labelKey: 'commissarActionKill',
    confirmLabelKey: 'confirmAction',
  );

  @override
  bool isEligibleTarget(target, performer, state) => 
      target.id != performer.id && target.isAlive;
}

class ProstituteBlockAction extends RoleAction {
  const ProstituteBlockAction() : super(
    type: 'prostitute_block',
    labelKey: 'prostituteAction',
    confirmLabelKey: 'confirmAction',
  );

  @override
  bool isEligibleTarget(target, performer, state) => 
      target.id != performer.id && target.isAlive;
}

class ManiacKillAction extends RoleAction {
  const ManiacKillAction() : super(
    type: 'maniac_kill',
    labelKey: 'maniacAction',
    confirmLabelKey: 'confirmAction',
  );

  @override
  bool isEligibleTarget(target, performer, state) => 
      target.id != performer.id && target.isAlive;
}

class PoisonAction extends RoleAction {
  const PoisonAction() : super(
    type: 'poison',
    labelKey: 'poisonerAction',
    confirmLabelKey: 'confirmAction',
  );

  @override
  bool isEligibleTarget(target, performer, state) => 
      target.id != performer.id && target.isAlive;
}

class LawyerCheckAction extends RoleAction {
  const LawyerCheckAction() : super(
    type: 'lawyer_check',
    labelKey: 'lawyerInvestigation',
    confirmLabelKey: 'confirmAction',
  );

  @override
  bool isEligibleTarget(target, performer, state) => 
      target.id != performer.id && target.isAlive;
}

class VoteAction extends RoleAction {
  const VoteAction() : super(
    type: 'vote',
    labelKey: 'voteAction',
    confirmLabelKey: 'confirmVote',
  );

  @override
  bool isEligibleTarget(target, performer, state) => 
      target.id != performer.id && target.isAlive;
}

class VerdictAction extends RoleAction {
  const VerdictAction() : super(
    type: 'verdict',
    labelKey: 'verdictAction',
    confirmLabelKey: 'confirmVerdict',
  );

  @override
  bool isEligibleTarget(target, performer, state) => true; // Target choice is handled by VerdictPanel or similar
}

/// All available role types
enum RoleType {
  civilian,
  mafia,
  commissar,
  doctor,
  prostitute,
  maniac,
  sergeant,
  lawyer,
  poisoner,
}

/// Factions players belong to
enum Faction {
  town,
  mafia,
  neutral,
}

/// Base class for all roles
sealed class Role {
  const Role({
    required this.type,
    required this.faction,
    required this.hasNightAction,
  });
  
  final RoleType type;
  final Faction faction;
  final bool hasNightAction;
  
  String get name => type.name;

  /// Display name from theme configuration
  String getDisplayName(Map<String, String> themeNames);

  /// Get available actions based on game state
  List<RoleAction> getActions(dynamic state, dynamic me) {
    if (state.currentMoveId == 'day_voting') {
      return [const VoteAction()];
    }
    if (state.currentMoveId == 'day_verdict') {
      return [const VerdictAction()];
    }
    return getNightActions(state, me);
  }

  /// Get available night actions for this role
  List<RoleAction> getNightActions(dynamic state, dynamic me) => [];
}

/// Civilian role: Basic town member
class CivilianRole extends Role {
  const CivilianRole() : super(
    type: RoleType.civilian,
    faction: Faction.town,
    hasNightAction: false,
  );
  
  @override
  String getDisplayName(Map<String, String> themeNames) =>
      themeNames['civilian'] ?? 'Civilian';
}

/// Mafia role: Team member, can kill at night
class MafiaRole extends Role {
  const MafiaRole({this.isDon = false}) : super(
    type: RoleType.mafia,
    faction: Faction.mafia,
    hasNightAction: true,
  );
  
  final bool isDon;
  
  @override
  String getDisplayName(Map<String, String> themeNames) =>
      themeNames['mafia'] ?? 'Mafia';

  @override
  List<RoleAction> getNightActions(state, me) {
    if (state.currentMoveId != 'night_mafia') return [];
    
    final actions = <RoleAction>[];
    final config = state.config as GameConfig;
    final isDonMechanics = isDon && config.donMechanicsEnabled;
    final mode = config.donAction;

    if (isDonMechanics) {
      if (mode == DonAction.kill) {
        actions.add(const MafiaKillAction());
      } else {
        actions.add(const MafiaVoteAction());
        actions.add(const DonCheckAction());
      }
    } else {
      // Regular Mafia or Don mechanics disabled
      // But if Don is dead and mechanics enabled, someone might inherit or we fall back to consensus
      // Check if this player is the effective Don if mechanics enabled
      final livingDon = state.players.firstWhereOrNull((p) => 
        p.isAlive && p.role is MafiaRole && (p.role as MafiaRole).isDon);
      
      if (livingDon == null || !config.donMechanicsEnabled || mode == DonAction.search) {
        actions.add(const MafiaVoteAction());
      }
    }
    return actions;
  }
}

/// Commissar role: Investigates players at night
class CommissarRole extends Role {
  const CommissarRole() : super(
    type: RoleType.commissar,
    faction: Faction.town,
    hasNightAction: true,
  );
  
  @override
  String getDisplayName(Map<String, String> themeNames) =>
      themeNames['commissar'] ?? 'Commissar';

  @override
  List<RoleAction> getNightActions(state, me) {
    if (state.currentMoveId != 'night_commissar') return [];
    
    final config = state.config as GameConfig;
    final hasSergeant = state.players.any((p) => p.isAlive && p.role.type == RoleType.sergeant);
    
    if (hasSergeant) {
      // If sergeant is alive, commissar strictly kills
      return [const CommissarKillAction()];
    } else {
      return [config.commissarKills ? const CommissarKillAction() : const CommissarCheckAction()];
    }
  }
}

/// Doctor role: Heals players at night
class DoctorRole extends Role {
  const DoctorRole() : super(
    type: RoleType.doctor,
    faction: Faction.town,
    hasNightAction: true,
  );
  
  @override
  String getDisplayName(Map<String, String> themeNames) =>
      themeNames['doctor'] ?? 'Doctor';

  @override
  List<RoleAction> getNightActions(state, me) {
    if (state.currentMoveId != 'night_doctor') return [];
    return [const DoctorHealAction()];
  }
}

/// Prostitute role: Blocks night actions
class ProstituteRole extends Role {
  const ProstituteRole() : super(
    type: RoleType.prostitute,
    faction: Faction.town,
    hasNightAction: true,
  );
  
  @override
  String getDisplayName(Map<String, String> themeNames) =>
      themeNames['prostitute'] ?? 'Prostitute';

  @override
  List<RoleAction> getNightActions(state, me) {
    if (state.currentMoveId != 'night_prostitute') return [];
    return [const ProstituteBlockAction()];
  }
}

/// Maniac role: Neutral player who kills everyone
class ManiacRole extends Role {
  const ManiacRole() : super(
    type: RoleType.maniac,
    faction: Faction.neutral,
    hasNightAction: true,
  );
  
  @override
  String getDisplayName(Map<String, String> themeNames) =>
      themeNames['maniac'] ?? 'Maniac';

  @override
  List<RoleAction> getNightActions(state, me) {
    if (state.currentMoveId != 'night_maniac') return [];
    return [const ManiacKillAction()];
  }
}

/// Sergeant role: Assistant to the Commissar
class SergeantRole extends Role {
  const SergeantRole() : super(
    type: RoleType.sergeant,
    faction: Faction.town,
    hasNightAction: true,
  );
  
  @override
  String getDisplayName(Map<String, String> themeNames) =>
      themeNames['sergeant'] ?? 'Sergeant';

  @override
  List<RoleAction> getNightActions(state, me) {
    if (state.currentMoveId != 'night_commissar') return [];
    // Sergeant always investigates
    return [const CommissarCheckAction()];
  }
}

/// Lawyer role: Mafia investigation role
class LawyerRole extends Role {
  const LawyerRole() : super(
    type: RoleType.lawyer,
    faction: Faction.mafia,
    hasNightAction: true,
  );
  
  @override
  String getDisplayName(Map<String, String> themeNames) =>
      themeNames['lawyer'] ?? 'Lawyer';

  @override
  List<RoleAction> getNightActions(state, me) {
    if (state.currentMoveId != 'night_mafia') return [];
    return [const LawyerCheckAction()];
  }
}

/// Poisoner role: Neutral role with delayed kill
class PoisonerRole extends Role {
  const PoisonerRole() : super(
    type: RoleType.poisoner,
    faction: Faction.neutral,
    hasNightAction: true,
  );
  
  @override
  String getDisplayName(Map<String, String> themeNames) =>
      themeNames['poisoner'] ?? 'Poisoner';

  @override
  List<RoleAction> getNightActions(state, me) {
    if (state.currentMoveId != 'night_poisoner') return [];
    return [const PoisonAction()];
  }
}
