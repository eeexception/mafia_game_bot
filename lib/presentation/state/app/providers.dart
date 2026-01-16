import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../infrastructure/services/audio/audio_manager.dart';
import '../../../infrastructure/services/theme/theme_loader.dart';
import '../../../infrastructure/services/storage/storage_service.dart';
import '../../../infrastructure/services/network/http_server.dart';
import '../../../infrastructure/services/network/websocket_server.dart';
import '../../../infrastructure/services/network/websocket_client.dart';
import '../../../infrastructure/services/device/wakelock_service.dart';
import '../../../infrastructure/services/logging/game_logger.dart';
import '../../../application/services/audio/audio_controller.dart';
import '../../../application/services/theme/theme_controller.dart';
import '../../../application/services/network/websocket_controller.dart';
import '../../../application/services/game/game_controller.dart';
import '../../../application/services/voting/vote_counter.dart';
import 'package:mafia_game/presentation/state/game/game_state_notifier.dart';
import 'package:mafia_game/domain/models/game/game_state.dart';
import 'package:mafia_game/domain/models/themes/theme_config.dart';
import 'package:mafia_game/domain/models/voting/vote_tally.dart';

import '../../../application/services/game/win_detector.dart';

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
