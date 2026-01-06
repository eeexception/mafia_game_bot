import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'core/state/providers.dart';
import 'core/services/storage_service.dart';
import 'core/services/http_server.dart';
import 'core/services/websocket_server.dart';
import 'ui/host/screens/lobby_screen.dart';
import 'ui/shared/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    developer.log('🚀 Starting Host Application Initialization...', name: 'HostInit', level: 800);

    // Initialize storage
    developer.log('📦 Initializing Storage...', name: 'HostInit', level: 800);
    final appDir = await getApplicationDocumentsDirectory();
    final storage = StorageService();
    await storage.init(appDir.path);
    developer.log('✅ Storage initialized at ${appDir.path}', name: 'HostInit', level: 800);

    // Initialize server
    developer.log('🌐 Starting HTTP Server...', name: 'HostInit', level: 800);
    final httpServer = HttpServerService();
    final url = await httpServer.start(port: 8080);
    developer.log('✅ HTTP Server started at $url', name: 'HostInit', level: 800);

    developer.log('🔌 Starting WebSocket Server...', name: 'HostInit', level: 800);
    final wsServer = WebSocketServerService();
    await wsServer.start(8081);
    developer.log('✅ WebSocket Server started on port 8081', name: 'HostInit', level: 800);

    final container = ProviderContainer(
      overrides: [
        storageServiceProvider.overrideWithValue(storage),
        httpServerServiceProvider.overrideWithValue(httpServer),
        webSocketServerServiceProvider.overrideWithValue(wsServer),
        serverUrlProvider.overrideWith((ref) => url),
      ],
    );

    final wsController = container.read(webSocketControllerProvider);
    final gameController = container.read(gameControllerProvider);
    await gameController.init();

    wsServer.onConnection.listen((conn) {
      final tempId = const Uuid().v4();
      wsController.addConnection(tempId, conn.channel);
    });

    developer.log('🎬 Running Host App...', name: 'HostInit', level: 800);
    runApp(
      UncontrolledProviderScope(
        container: container,
        child: const MafiaHostApp(),
      ),
    );
  } catch (e, stack) {
    developer.log('❌ Host Initialization Failed', name: 'HostInit', error: e, stackTrace: stack, level: 1000);
    runApp(ErrorApp(error: e.toString()));
  }
}

class ErrorApp extends StatelessWidget {
  final String error;
  const ErrorApp({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 80),
                const SizedBox(height: 24),
                const Text(
                  'INITIALIZATION FAILED',
                  style: TextStyle(color: Colors.red, fontSize: 32, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text(
                  error,
                  style: const TextStyle(color: Colors.white70, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: () {
                    // Logic to retry or restart could go here
                  },
                  child: const Text('RETRY'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class MafiaHostApp extends ConsumerWidget {
  const MafiaHostApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    return MaterialApp(
      title: 'Mafia Game Host',
      theme: AppTheme.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: locale,
      home: const LobbyScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
