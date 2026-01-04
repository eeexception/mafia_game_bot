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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize storage
  final appDir = await getApplicationDocumentsDirectory();
  final storage = StorageService();
  await storage.init(appDir.path);

  // Initialize server
  final httpServer = HttpServerService();
  final url = await httpServer.start(port: 8080);

  final wsServer = WebSocketServerService();
  await wsServer.start(8081);

  final container = ProviderContainer(
    overrides: [
      storageServiceProvider.overrideWithValue(storage),
      httpServerServiceProvider.overrideWithValue(httpServer),
      webSocketServerServiceProvider.overrideWithValue(wsServer),
      serverUrlProvider.overrideWith((ref) => url),
    ],
  );

  final wsController = container.read(webSocketControllerProvider);
  wsServer.onConnection.listen((conn) {
    final tempId = const Uuid().v4();
    wsController.addConnection(tempId, conn.channel);
  });

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MafiaHostApp(),
    ),
  );
}

class MafiaHostApp extends StatelessWidget {
  const MafiaHostApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mafia Game Host',
      theme: AppTheme.darkTheme,
      home: const LobbyScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
