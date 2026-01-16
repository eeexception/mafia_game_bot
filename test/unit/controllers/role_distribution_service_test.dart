import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/core/controllers/role_distribution_service.dart';
import 'package:mafia_game/core/models/game_config.dart';
import 'package:mafia_game/core/models/role.dart';

void main() {
  test('assigns mafia count based on player count by default', () {
    // Arrange
    final service = RoleDistributionService();
    const config = GameConfig(themeId: 'default');

    // Act
    final roles = service.distributeRoles(8, config);

    // Assert
    expect(roles.length, 8);
    expect(roles.whereType<MafiaRole>().length, 2);
  });

  test('respects explicit mafia count', () {
    // Arrange
    final service = RoleDistributionService();
    const config = GameConfig(themeId: 'default', mafiaCount: 3);

    // Act
    final roles = service.distributeRoles(8, config);

    // Assert
    expect(roles.whereType<MafiaRole>().length, 3);
  });
}
