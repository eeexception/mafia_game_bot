import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/application/services/game/win_detector.dart';
import 'package:mafia_game/domain/models/players/player.dart';
import 'package:mafia_game/domain/models/roles/role.dart';

void main() {
  group('WinDetector', () {
    final detector = WinDetector();

    Player createPlayer(int number, Role role, {bool isAlive = true}) {
      return Player(
        id: 'uuid-$number',
        number: number,
        nickname: 'Player $number',
        role: role,
        isAlive: isAlive,
      );
    }

    test('Town wins when all Mafia and Maniac are dead', () {
      final players = [
        createPlayer(1, const CivilianRole()),
        createPlayer(2, const MafiaRole(), isAlive: false),
        createPlayer(3, const ManiacRole(), isAlive: false),
      ];
      
      final result = detector.checkWinCondition(players);
      expect(result?.faction, equals(Faction.town));
    });

    test('Mafia wins when they equal or outnumber Town (and Maniac is dead)', () {
      final players = [
        createPlayer(1, const CivilianRole()),
        createPlayer(2, const MafiaRole()),
        createPlayer(3, const MafiaRole()),
        createPlayer(4, const ManiacRole(), isAlive: false),
      ];
      
      final result = detector.checkWinCondition(players);
      expect(result?.faction, equals(Faction.mafia));
    });

    test('Maniac wins in 1v1 or last man standing', () {
      final players = [
        createPlayer(1, const CivilianRole()),
        createPlayer(2, const ManiacRole()),
      ];
      
      final result = detector.checkWinCondition(players);
      expect(result?.faction, equals(Faction.neutral));
    });
  });
}
