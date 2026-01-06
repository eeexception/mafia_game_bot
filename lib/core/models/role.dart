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
}
