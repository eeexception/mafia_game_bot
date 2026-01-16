import '../models/game_phase.dart';
import '../models/theme_config.dart';
import '../services/audio_manager.dart';

class AudioController {
  AudioController(this._audioManager, {this.onMissingAudio}) {
    _audioManager.onMissingAudio = (path) {
      onMissingAudio?.call(path);
    };
  }

  final AudioManager _audioManager;
  final void Function(String path)? onMissingAudio;
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
    final id = phase.id;

    if (id == 'lobby' || id == 'setup' || id == 'roleReveal') {
      track = _currentTheme!.backgroundAudio['lobby'];
    } else if (id == 'night') {
      track = _currentTheme!.backgroundAudio['night'];
    } else if (id == 'day') {
      _audioManager.stopBackground();
      return;
    } else if (id == 'gameOver') {
      track = _currentTheme!.backgroundAudio['inactive'];
    } else {
      track = _currentTheme!.backgroundAudio['inactive'];
    }
    
    if (track != null) {
      final basePath = _currentTheme!.basePath;
      final fullPath = (basePath.isNotEmpty && track.startsWith(basePath))
          ? track
          : (basePath.isEmpty ? track : '$basePath/$track');
      
      _audioManager.playBackground(fullPath);
      _audioManager.setBackgroundVolume(_currentTheme!.backgroundNormalVolume);
    } else {
      _audioManager.stopBackground();
    }
  }
  
  /// Play event sound (random variant from theme)
  Future<String?> playEvent(String eventKey) async {
    return await playCompositeEvent([eventKey]);
  }

  /// Play multiple events in sequence (e.g. "Player killed" + "Player 5")
  /// Returns the combined text of all events in the sequence
  Future<String?> playCompositeEvent(List<String> eventKeys) async {
    if (_currentTheme == null) return null;
    
    final tracks = <String>[];
    final texts = <String>[];
    for (final key in eventKeys) {
      final variants = _currentTheme!.eventAudio[key];
      if (variants != null && variants.isNotEmpty) {
        final variant = variants[DateTime.now().millisecond % variants.length];
        tracks.add('${_currentTheme!.basePath}/${variant.file}');
        if (variant.text != null) {
          texts.add(variant.text!);
        }
      }
    }
    
    if (tracks.isEmpty) return null;
    
    // Duck
    await _audioManager.setBackgroundVolume(_currentTheme!.backgroundDuckVolume);
    
    // Play
    await _audioManager.playSequence(tracks);
    
    // Restore
    await restoreBackground();

    return texts.isNotEmpty ? texts.join(" ") : null;
  }
  
  /// Restore background volume
  Future<void> restoreBackground() async {
    if (_currentTheme == null) return;
    await _audioManager.setBackgroundVolume(_currentTheme!.backgroundNormalVolume);
  }

  /// Stop background music
  void stopBackgroundMusic() {
    _audioManager.stopBackground();
  }

  /// Stop all audio
  Future<void> stopAll() async {
    await _audioManager.pauseAll();
    _audioManager.stopBackground();
  }
}
