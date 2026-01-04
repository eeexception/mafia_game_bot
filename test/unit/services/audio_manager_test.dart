import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/core/services/audio_manager.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:audioplayers/audioplayers.dart';

@GenerateMocks([AudioPlayer])
import 'audio_manager_test.mocks.dart';

void main() {
  group('AudioManager', () {
    late AudioManager manager;
    late MockAudioPlayer mockBackgroundPlayer;
    late MockAudioPlayer mockAnnouncementPlayer;

    setUp(() {
      mockBackgroundPlayer = MockAudioPlayer();
      mockAnnouncementPlayer = MockAudioPlayer();
      manager = AudioManager.withPlayers(
        backgroundPlayer: mockBackgroundPlayer,
        announcementPlayer: mockAnnouncementPlayer,
      );
    });

    test('playBackground calls play on background player', () async {
      when(mockBackgroundPlayer.setReleaseMode(ReleaseMode.loop))
          .thenAnswer((_) async => {});
      when(mockBackgroundPlayer.play(any)).thenAnswer((_) async => {});

      await manager.playBackground('test.mp3');

      verify(mockBackgroundPlayer.setReleaseMode(ReleaseMode.loop)).called(1);
      verify(mockBackgroundPlayer.play(any)).called(1);
    });

    test('playAnnouncement calls play on announcement player', () async {
      when(mockAnnouncementPlayer.play(any)).thenAnswer((_) async => {});

      await manager.playAnnouncement('test.mp3');

      verify(mockAnnouncementPlayer.play(any)).called(1);
    });
  });
}
