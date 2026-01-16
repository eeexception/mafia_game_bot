import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/domain/models/players/player.dart';
import 'package:mafia_game/domain/models/roles/role.dart';

void main() {
  group('Player', () {
    const testRole = CivilianRole();
    
    test('Player creation with default values', () {
      const player = Player(
        id: 'uuid-1',
        number: 1,
        nickname: 'Alice',
        role: testRole,
      );

      expect(player.id, equals('uuid-1'));
      expect(player.number, equals(1));
      expect(player.nickname, equals('Alice'));
      expect(player.role, equals(testRole));
      expect(player.isAlive, isTrue);
      expect(player.isConnected, isTrue);
    });

    test('Json serialization', () {
      const player = Player(
        id: 'uuid-1',
        number: 1,
        nickname: 'Alice',
        role: testRole,
      );

      final json = player.toJson();
      expect(json['id'], equals('uuid-1'));
      expect(json['nickname'], equals('Alice'));
      // Role serialization needs to be handled. Since Role is sealed,
      // handled via custom logic or just checking type for now if plan implies it.
    });

    test('State transition (immutability)', () {
      const player = Player(
        id: 'uuid-1',
        number: 1,
        nickname: 'Alice',
        role: testRole,
      );

      final deadPlayer = player.copyWith(isAlive: false);
      
      expect(player.isAlive, isTrue);
      expect(deadPlayer.isAlive, isFalse);
      expect(deadPlayer.id, equals(player.id));
    });
  });
}
