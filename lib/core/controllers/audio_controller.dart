import '../models/game_phase.dart';
import '../models/theme_config.dart';
import '../services/audio_manager.dart';

class AudioController {
  AudioController(this._audioManager) {
    _audioManager.onAnnouncementComplete.listen((_) {
      restoreBackground();
    });
  }

  final AudioManager _audioManager;
  ThemeConfig? _currentTheme;
  
  /// Load theme audio assets
  Future<void> loadTheme(ThemeConfig theme) async {
    _currentTheme = theme;
    // Preloading logic could go here if AudioManager supports it
  }
  
  /// Play background music for phase
  void playBackgroundMusic(GamePhase phase) {
    if (_currentTheme == null) return;
    
    String? track;
    switch (phase) {
      case GamePhase.nightMafia:
      case GamePhase.nightProstitute:
      case GamePhase.nightManiac:
      case GamePhase.nightDoctor:
      case GamePhase.nightCommissar:
        track = _currentTheme!.backgroundAudio['night'];
        break;
      case GamePhase.dayDiscussion:
      case GamePhase.dayVoting:
      case GamePhase.dayDefense:
      case GamePhase.dayVerdict:
        track = _currentTheme!.backgroundAudio['day'];
        break;
      default:
        break;
    }
    
    if (track != null) {
      _audioManager.playBackground(track);
      _audioManager.setBackgroundVolume(_currentTheme!.backgroundNormalVolume);
    }
  }
  
  /// Play event sound (random variant from theme)
  Future<void> playEvent(String eventKey) async {
    if (_currentTheme == null) return;
    
    final variants = _currentTheme!.eventAudio[eventKey];
    if (variants == null || variants.isEmpty) return;
    
    final track = variants[DateTime.now().millisecond % variants.length];
    
    await _audioManager.setBackgroundVolume(_currentTheme!.backgroundDuckVolume);
    await _audioManager.playAnnouncement(track);
    // Ideally wait for announcement to finish before restoring, 
    // but AudioManager doesn't expose completion yet.
    // Simple workaround: restore after some time or on next event.
  }
  
  /// Restore background volume
  Future<void> restoreBackground() async {
    if (_currentTheme == null) return;
    await _audioManager.setBackgroundVolume(_currentTheme!.backgroundNormalVolume);
  }

  /// Stop all audio
  Future<void> stopAll() async {
    await _audioManager.pauseAll();
  }
}
