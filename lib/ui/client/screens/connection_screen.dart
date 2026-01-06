import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/providers.dart';
import '../../../core/models/game_phase.dart';
import 'game_screen.dart';

class ConnectionScreen extends ConsumerStatefulWidget {
  const ConnectionScreen({super.key});

  @override
  ConsumerState<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends ConsumerState<ConnectionScreen> {
  final _nicknameController = TextEditingController();
  bool _isAutoJoining = false;

  @override
  void initState() {
    super.initState();
    _checkReconnection();
  }

  Future<void> _checkReconnection() async {
    final storage = ref.read(storageServiceProvider);
    final playerId = storage.getSetting('player_id') as String?;
    final token = storage.getSetting('session_token') as String?;
    final sidFromUrl = Uri.base.queryParameters['sid'];
    final savedSid = storage.getSetting('game_session_id') as String?;

    if (playerId != null && token != null && (sidFromUrl == null || sidFromUrl == savedSid)) {
      debugPrint('Found saved session for $playerId. Attempting reconnection...');
      await _reconnect(playerId, token, sidFromUrl ?? savedSid);
    } else {
      if (sidFromUrl != null && sidFromUrl != savedSid) {
        debugPrint('New game session detected ($sidFromUrl). Clearing old session.');
        await storage.saveSetting('player_id', null);
        await storage.saveSetting('session_token', null);
        await storage.saveSetting('game_session_id', sidFromUrl);
      }
      
      // Use addPostFrameCallback to handle query parameters after the first build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final nickname = Uri.base.queryParameters['nickname'];
        if (nickname != null && nickname.isNotEmpty && !_isAutoJoining) {
          _nicknameController.text = nickname;
          _isAutoJoining = true;
          _join(nickname, sidFromUrl);
        }
      });
    }
  }

  Future<void> _reconnect(String playerId, String token, String? sessionId) async {
    final client = ref.read(webSocketClientServiceProvider);
    final navigator = Navigator.of(context);

    final port = 8081; 
    final host = Uri.base.host.isEmpty ? '127.0.0.1' : Uri.base.host;
    final url = 'ws://$host:$port';
    
    try {
      await client.connect(url);
      debugPrint('✅ Connected! Sending player_reconnect...');
      
      client.send({
        'type': 'player_reconnect',
        'player_id': playerId,
        'session_token': token,
        'game_session_id': sessionId,
      });

      // Listen for success (same message type as join for simplicity or could be different)
      client.messages.firstWhere((m) => m['type'] == 'join_success').then((m) {
        debugPrint('🎉 Reconnect success received for player: ${m['player_id']}');
        if (!mounted) return;
        ref.read(clientPlayerIdProvider.notifier).state = m['player_id'];
        navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const WaitingScreen()),
        );
      });
    } catch (e) {
      debugPrint('❌ Reconnection error: $e');
      // Clear invalid session
      final storage = ref.read(storageServiceProvider);
      storage.saveSetting('player_id', null);
      storage.saveSetting('session_token', null);
    }
  }

  Future<void> _join(String nickname, String? sessionId) async {
    final client = ref.read(webSocketClientServiceProvider);
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final storage = ref.read(storageServiceProvider);

    // Use the host from which the PWA was loaded
    final port = 8081; 
    final host = Uri.base.host.isEmpty ? '127.0.0.1' : Uri.base.host;
    final url = 'ws://$host:$port';
    
    debugPrint('🔌 Connecting to WebSocket at $url...');

    try {
      await client.connect(url);
      debugPrint('✅ Connected! Sending player_joined...');
      
      client.send({
        'type': 'player_joined',
        'nickname': nickname,
        'game_session_id': sessionId,
      });

      // Listen for success
      client.messages.firstWhere((m) => m['type'] == 'join_success').then((m) async {
        debugPrint('🎉 Join success received for player: ${m['player_id']}');
        if (!mounted) return;
        
        // Save session info
        await storage.saveSetting('player_id', m['player_id']);
        await storage.saveSetting('session_token', m['session_token']);
        await storage.saveSetting('game_session_id', sessionId);
        
        ref.read(clientPlayerIdProvider.notifier).state = m['player_id'];
        navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const WaitingScreen()),
        );
      });
    } catch (e) {
      debugPrint('❌ Connection error: $e');
      if (mounted) {
        messenger.showSnackBar(SnackBar(
          content: Text('Connection Error: $e'),
          backgroundColor: Colors.redAccent,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Start listening for global state updates
    ref.watch(clientWebSocketListenerProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Join Mafia',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 48),
            TextField(
              controller: _nicknameController,
              decoration: const InputDecoration(
                labelText: 'Enter Nickname',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final nickname = _nicknameController.text.trim();
                if (nickname.isNotEmpty) {
                  final sid = Uri.base.queryParameters['sid'];
                  _join(nickname, sid);
                }
              },
              child: const Text('JOIN GAME'),
            ),
          ],
        ),
      ),
    );
  }
}

class WaitingScreen extends ConsumerStatefulWidget {
  const WaitingScreen({super.key});

  @override
  ConsumerState<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends ConsumerState<WaitingScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(wakeLockServiceProvider).enable();
  }

  @override
  void dispose() {
    ref.read(wakeLockServiceProvider).disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch for phase changes to automatically enter the game
    final phase = ref.watch(gameStateProvider.select((s) => s.phase));
    final currentState = ref.watch(clientGameStateProvider);

    // If the host has moved past the lobby, transition to the game screen
    if (phase != GamePhase.lobby && currentState != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const ClientGameScreen()),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.amber),
            const SizedBox(height: 24),
            const Text(
              'WAITING FOR GAME TO START...',
              style: TextStyle(
                color: Colors.amber, 
                fontSize: 18, 
                letterSpacing: 2, 
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'You are connected. The host will start soon.',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
            ),
          ],
        ),
      ),
    );
  }
}
