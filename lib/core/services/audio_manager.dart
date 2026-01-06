import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'dart:developer' as developer;

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
  
  /// Callback for missing audio files
  void Function(String path)? onMissingAudio;

  Stream<void> get onAnnouncementComplete => _announcementPlayer.onPlayerComplete;
  
  /// Play background music with loop
  Future<void> playBackground(String filePath, {bool loop = true}) async {
    try {
      await _backgroundPlayer.setReleaseMode(loop ? ReleaseMode.loop : ReleaseMode.release);
      await _backgroundPlayer.play(DeviceFileSource(filePath));
    } catch (e, stack) {
      developer.log('⚠️ Audio Player Error (Background): $e', name: 'AudioManager', error: e, stackTrace: stack, level: 900);
      onMissingAudio?.call(filePath);
    }
  }
  
  Future<void> stopBackground() async {
    await _backgroundPlayer.stop();
  }
  
  /// Play one-shot announcement
  Future<void> playAnnouncement(String assetPath) async {
    if (!await _exists(assetPath)) {
      onMissingAudio?.call(assetPath);
      return;
    }
    try {
      await _announcementPlayer.play(DeviceFileSource(assetPath));
    } catch (e, stack) {
      developer.log('⚠️ Audio Player Error (Announcement): $e', name: 'AudioManager', error: e, stackTrace: stack, level: 900);
      onMissingAudio?.call(assetPath);
    }
  }

  Future<void> stopAnnouncement() async {
      await _announcementPlayer.stop();
  }

  Future<bool> _exists(String path) async {
    return File(path).exists();
  }

  /// Play sequence of announcements
  Future<void> playSequence(List<String> assetPaths) async {
    for (final path in assetPaths) {
      if (!await _exists(path)) {
        onMissingAudio?.call(path);
        continue;
      }
      try {
        await _announcementPlayer.play(DeviceFileSource(path));
        await _announcementPlayer.onPlayerComplete.first;
      } catch (e, stack) {
        developer.log('⚠️ Audio Player Error (Sequence): $e', name: 'AudioManager', error: e, stackTrace: stack, level: 900);
        onMissingAudio?.call(path);
      }
    }
  }
  
  /// Set background volume (0.0 - 1.0)
  Future<void> setBackgroundVolume(double volume) async {
    await _backgroundPlayer.setVolume(volume);
  }

  Future<void> setAnnouncementVolume(double volume) async {
    await _announcementPlayer.setVolume(volume);
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
