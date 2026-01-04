import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/state/providers.dart';

class ConnectionScreen extends ConsumerStatefulWidget {
  const ConnectionScreen({super.key});

  @override
  ConsumerState<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends ConsumerState<ConnectionScreen> {
  final _nicknameController = TextEditingController();

  Future<void> _join(String nickname) async {
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);
    final client = ref.read(webSocketClientServiceProvider);
    
    // In PWA, we might want to get the IP from URL
    // For local dev, we use localhost
    final port = 8081; 
    final url = 'ws://localhost:$port';

    try {
      await client.connect(url);
      client.send({
        'type': 'player_joined',
        'nickname': nickname,
      });

      // Listen for success
      client.messages.firstWhere((m) => m['type'] == 'join_success').then((m) {
        if (!mounted) return;
        ref.read(clientPlayerIdProvider.notifier).state = m['player_id'];
        navigator.pushReplacement(
          MaterialPageRoute(builder: (_) => const WaitingScreen()),
        );
      });
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  _join(nickname);
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

// Dummy WaitingScreen for now
class WaitingScreen extends StatelessWidget {
  const WaitingScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text('Waiting for game to start...')));
}
