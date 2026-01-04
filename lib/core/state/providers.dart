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
import 'game_state_notifier.dart';
import '../models/game_state.dart';

import '../controllers/win_detector.dart';

// Services
final winDetectorProvider = Provider((ref) => WinDetector());
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

final clientGameStateProvider = StateProvider<GameState?>((ref) {
  final client = ref.watch(webSocketClientServiceProvider);
  client.messages.listen((msg) {
    if (msg['type'] == 'state_update') {
      final stateJson = msg['state'] as Map<String, dynamic>;
      ref.read(gameStateProvider.notifier).updateState(GameState.fromJson(stateJson));
    }
  });
  return null;
});
final audioControllerProvider = Provider((ref) {
  return AudioController(ref.watch(audioManagerProvider));
});

final themeControllerProvider = Provider((ref) {
  return ThemeController(ref.watch(themeLoaderProvider));
});

final webSocketControllerProvider = Provider((ref) {
  return WebSocketController();
});

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
  );
});
