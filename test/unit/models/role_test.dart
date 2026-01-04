import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/core/models/role.dart';

void main() {
  group('Role', () {
    test('CivilianRole has correct properties', () {
      const role = CivilianRole();
      expect(role.type, equals(RoleType.civilian));
      expect(role.faction, equals(Faction.town));
      expect(role.hasNightAction, isFalse);
    });

    test('MafiaRole has correct properties', () {
      const role = MafiaRole();
      expect(role.type, equals(RoleType.mafia));
      expect(role.faction, equals(Faction.mafia));
      expect(role.hasNightAction, isTrue);
      expect(role.isDon, isFalse);
    });

    test('MafiaRole with Don mechanics has correct properties', () {
      const role = MafiaRole(isDon: true);
      expect(role.isDon, isTrue);
    });

    test('CommissarRole has correct properties', () {
      const role = CommissarRole();
      expect(role.type, equals(RoleType.commissar));
      expect(role.faction, equals(Faction.town));
      expect(role.hasNightAction, isTrue);
    });

    test('DoctorRole has correct properties', () {
      const role = DoctorRole();
      expect(role.type, equals(RoleType.doctor));
      expect(role.faction, equals(Faction.town));
      expect(role.hasNightAction, isTrue);
    });

    test('ProstituteRole has correct properties', () {
      const role = ProstituteRole();
      expect(role.type, equals(RoleType.prostitute));
      expect(role.faction, equals(Faction.town));
      expect(role.hasNightAction, isTrue);
    });

    test('ManiacRole has correct properties', () {
      const role = ManiacRole();
      expect(role.type, equals(RoleType.maniac));
      expect(role.faction, equals(Faction.neutral));
      expect(role.hasNightAction, isTrue);
    });

    test('getDisplayName uses theme names if available', () {
      const themeNames = {
        'civilian': 'Мирный',
        'mafia': 'Мафия',
      };
      
      expect(const CivilianRole().getDisplayName(themeNames), equals('Мирный'));
      expect(const MafiaRole().getDisplayName(themeNames), equals('Мафия'));
      expect(const CommissarRole().getDisplayName(themeNames), equals('Commissar'));
    });
  });
}
