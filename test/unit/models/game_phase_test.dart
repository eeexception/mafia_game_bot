import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/core/models/game_phase.dart';

void main() {
  group('GamePhase Hierarchy', () {
    test('Static constants exist and have correct IDs', () {
      expect(GamePhase.lobby.id, equals('lobby'));
      expect(GamePhase.setup.id, equals('setup'));
      expect(GamePhase.roleReveal.id, equals('roleReveal'));
      expect(GamePhase.night.id, equals('night'));
      expect(GamePhase.day.id, equals('day'));
      expect(GamePhase.gameOver.id, equals('gameOver'));
    });

    test('LobbyPhase properties', () {
      const phase = LobbyPhase();
      expect(phase.id, equals('lobby'));
      expect(phase.nameKey, equals('phaseLobby'));
    });

    test('NightGamePhase properties', () {
      const phase = NightGamePhase(moves: []);
      expect(phase.id, equals('night'));
      expect(phase.nameKey, equals('phaseNight'));
    });

    test('DayGamePhase properties', () {
      const phase = DayGamePhase(moves: []);
      expect(phase.id, equals('day'));
      expect(phase.nameKey, equals('phaseDay'));
    });

    test('GamePhaseConverter works for basic phases', () {
      const converter = GamePhaseConverter();
      
      expect(converter.fromJson('lobby'), isA<LobbyPhase>());
      expect(converter.fromJson('night'), isA<NightGamePhase>());
      expect(converter.fromJson('day'), isA<DayGamePhase>());
      expect(converter.fromJson('gameOver'), isA<GameOverPhase>());
      
      expect(converter.toJson(const LobbyPhase()), equals('lobby'));
      expect(converter.toJson(const NightGamePhase(moves: [])), equals('night'));
    });
  });
}
