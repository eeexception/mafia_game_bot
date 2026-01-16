import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_manager.dart';
import '../services/theme_loader.dart';
import '../services/storage_service.dart';
import '../services/http_server.dart';
import '../services/websocket_server.dart';
import '../services/websocket_client.dart';
import '../services/wakelock_service.dart';
import '../services/game_logger.dart';
import '../controllers/audio_controller.dart';
import '../controllers/theme_controller.dart';
import '../controllers/websocket_controller.dart';
import '../controllers/game_controller.dart';
import '../controllers/vote_counter.dart';
import 'package:mafia_game/core/state/game_state_notifier.dart';
import 'package:mafia_game/core/models/game_state.dart';
import 'package:mafia_game/core/models/theme_config.dart';
import 'package:mafia_game/core/models/vote_tally.dart';

import '../controllers/win_detector.dart';

// Services
final winDetectorProvider = Provider((ref) => WinDetector());
final voteCounterProvider = Provider((ref) => const VoteCounter());
final audioManagerProvider = Provider((ref) => AudioManager());
final themeLoaderProvider = Provider((ref) => ThemeLoader());
final storageServiceProvider = Provider((ref) => StorageService());
final httpServerServiceProvider = Provider((ref) => HttpServerService());
final webSocketServerServiceProvider = Provider((ref) => WebSocketServerService());
final webSocketClientServiceProvider = Provider((ref) => WebSocketClientService());
final wakeLockServiceProvider = Provider((ref) => WakeLockService());
final gameLoggerProvider = Provider((ref) => GameLogger());

final serverUrlProvider = StateProvider<String>((ref) => 'http://localhost:8080');
final clientPlayerIdProvider = StateProvider<String?>((ref) => null);
final missingAudioEventProvider = StateProvider<String?>((ref) => null);

final clientGameStateProvider = Provider<GameState?>((ref) {
  return ref.watch(gameStateProvider);
});

final gameLogsProvider = StateProvider<List<String>>((ref) => []);
final voteTallyProvider = Provider<VoteTally>((ref) {
  final state = ref.watch(gameStateProvider);
  final counter = ref.watch(voteCounterProvider);
  final livingPlayers = state.players.where((p) => p.isAlive).length;
  return counter.tally(
    state.currentVotes,
    livingPlayersCount: livingPlayers,
  );
});

// A provider that handles global WebSocket signal listening for the client
final clientWebSocketListenerProvider = Provider((ref) {
  final client = ref.watch(webSocketClientServiceProvider);
  
  client.messages.listen((msg) {
    if (msg['type'] == 'state_update') {
      final stateJson = msg['state'] as Map<String, dynamic>;
      final newState = GameState.fromJson(stateJson);
      ref.read(gameStateProvider.notifier).updateState(newState);
    } else if (msg['type'] == 'game_over') {
      if (msg['logs'] != null) {
        final logs = List<String>.from(msg['logs'] as List);
        ref.read(gameLogsProvider.notifier).state = logs;
      }
    } else if (msg['type'] == 'phase_changed') {
       // Optional: could trigger specific local UI events or sounds here
    }
  });
  return null;
});
final audioControllerProvider = Provider((ref) {
  return AudioController(
    ref.watch(audioManagerProvider),
    onMissingAudio: (path) {
      ref.read(missingAudioEventProvider.notifier).state = path;
      // Reset after a short delay so same error can trigger again
      Future.delayed(const Duration(seconds: 2), () {
        if (ref.read(missingAudioEventProvider) == path) {
          ref.read(missingAudioEventProvider.notifier).state = null;
        }
      });
    },
  );
});

final themeControllerProvider = Provider((ref) {
  return ThemeController(ref.watch(themeLoaderProvider));
});

final themesProvider = FutureProvider<List<ThemeMeta>>((ref) async {
  final loader = ref.watch(themeLoaderProvider);
  return loader.discoverThemes();
});

final webSocketControllerProvider = Provider((ref) {
  return WebSocketController();
});

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  final storage = ref.watch(storageServiceProvider);
  return LocaleNotifier(storage);
});

class LocaleNotifier extends StateNotifier<Locale> {
  final StorageService _storage;
  
  LocaleNotifier(this._storage) : super(const Locale('en')) {
    final savedLocale = _storage.getSetting('locale');
    if (savedLocale != null) {
      state = Locale(savedLocale as String);
    }
  }
  
  void setLocale(String languageCode) {
    state = Locale(languageCode);
    _storage.saveSetting('locale', languageCode);
  }
}

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier();
});

final gameControllerProvider = Provider((ref) {
  return GameController(
    audioController: ref.watch(audioControllerProvider),
    websocketController: ref.watch(webSocketControllerProvider),
    winDetector: ref.watch(winDetectorProvider),
    gameLogger: ref.watch(gameLoggerProvider),
    stateNotifier: ref.watch(gameStateProvider.notifier),
    storageService: ref.watch(storageServiceProvider),
    themeController: ref.watch(themeControllerProvider),
  );
});
