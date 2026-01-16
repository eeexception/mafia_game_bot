import '../../../domain/models/game/game_config.dart';
import '../../../domain/models/roles/role.dart';

/// Builds a role list based on player count and configuration.
class RoleDistributionService {
  /// Distributes roles for the given player count and config.
  List<Role> distributeRoles(int playerCount, GameConfig config) {
    final roles = <Role>[];

    var mafiaCount = _defaultMafiaCount(playerCount);
    if (config.mafiaCount != null) {
      mafiaCount = config.mafiaCount!;
    }

    for (var i = 0; i < mafiaCount; i++) {
      roles.add(MafiaRole(isDon: config.donMechanicsEnabled && i == 0));
    }

    bool shouldAdd(bool enabled, int minPlayers) {
      if (!enabled) return false;
      if (!config.autoPruningEnabled) return true;
      return playerCount >= minPlayers;
    }

    if (shouldAdd(config.commissarEnabled, 3)) {
      roles.add(const CommissarRole());
    }
    if (shouldAdd(config.doctorEnabled, 4)) {
      roles.add(const DoctorRole());
    }
    if (shouldAdd(config.prostituteEnabled, 5)) {
      roles.add(const ProstituteRole());
    }
    if (shouldAdd(config.sergeantEnabled, 6)) {
      roles.add(const SergeantRole());
    }
    if (shouldAdd(config.lawyerEnabled, 7)) {
      roles.add(const LawyerRole());
    }
    if (shouldAdd(config.poisonerEnabled, 8)) {
      roles.add(const PoisonerRole());
    }
    if (shouldAdd(config.maniacEnabled, 9)) {
      roles.add(const ManiacRole());
    }

    while (roles.length < playerCount) {
      roles.add(const CivilianRole());
    }

    return roles.take(playerCount).toList();
  }

  int _defaultMafiaCount(int playerCount) {
    if (playerCount <= 5) {
      return 1;
    }
    if (playerCount <= 8) {
      return 2;
    }
    return (playerCount / 3).floor();
  }
}
