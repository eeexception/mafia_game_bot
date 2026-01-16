import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/core/controllers/commissar_ready_service.dart';

void main() {
  test('isReadyEarly returns true only for night_commissar move', () {
    // Arrange
    final service = CommissarReadyService();

    // Act
    final isReady = service.isReadyEarly(currentMoveId: 'night_commissar');
    final notReady = service.isReadyEarly(currentMoveId: 'night_mafia');

    // Assert
    expect(isReady, true);
    expect(notReady, false);
  });
}
