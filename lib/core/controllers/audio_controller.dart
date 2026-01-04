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
    await playCompositeEvent([eventKey]);
  }

  /// Play multiple events in sequence (e.g. "Player killed" + "Player 5")
  Future<void> playCompositeEvent(List<String> eventKeys) async {
    if (_currentTheme == null) return;
    
    final tracks = <String>[];
    for (final key in eventKeys) {
      final variants = _currentTheme!.eventAudio[key];
      if (variants != null && variants.isNotEmpty) {
        tracks.add(variants[DateTime.now().millisecond % variants.length]);
      }
    }
    
    if (tracks.isEmpty) return;

    await _audioManager.setBackgroundVolume(_currentTheme!.backgroundDuckVolume);
    await _audioManager.playSequence(tracks);
    // Restoration handled by listener
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
