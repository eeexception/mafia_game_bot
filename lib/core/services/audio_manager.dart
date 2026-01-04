import 'package:audioplayers/audioplayers.dart';

class AudioManager {
  AudioManager() : 
    _backgroundPlayer = AudioPlayer(),
    _announcementPlayer = AudioPlayer();

  AudioManager.withPlayers({
    required AudioPlayer backgroundPlayer,
    required AudioPlayer announcementPlayer,
  }) : 
    _backgroundPlayer = backgroundPlayer,
    _announcementPlayer = announcementPlayer;

  final AudioPlayer _backgroundPlayer;
  final AudioPlayer _announcementPlayer;
  
  Stream<void> get onAnnouncementComplete => _announcementPlayer.onPlayerComplete;
  
  /// Play background music with loop
  Future<void> playBackground(String assetPath, {bool loop = true}) async {
    await _backgroundPlayer.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.release);
    await _backgroundPlayer.play(AssetSource(assetPath));
  }
  
  /// Play one-shot announcement
  Future<void> playAnnouncement(String assetPath) async {
    await _announcementPlayer.play(AssetSource(assetPath));
  }

  /// Play sequence of announcements
  Future<void> playSequence(List<String> assetPaths) async {
    for (final path in assetPaths) {
      await _announcementPlayer.play(AssetSource(path));
      await _announcementPlayer.onPlayerComplete.first;
    }
  }
  
  /// Set background volume (0.0 - 1.0)
  Future<void> setBackgroundVolume(double volume) async {
    await _backgroundPlayer.setVolume(volume);
  }
  
  /// Pause all players
  Future<void> pauseAll() async {
    await _backgroundPlayer.pause();
    await _announcementPlayer.pause();
  }
  
  /// Resume all players
  Future<void> resumeAll() async {
    await _backgroundPlayer.resume();
    await _announcementPlayer.resume();
  }
  
  /// Dispose resources
  Future<void> dispose() async {
    await _backgroundPlayer.dispose();
    await _announcementPlayer.dispose();
  }
}
