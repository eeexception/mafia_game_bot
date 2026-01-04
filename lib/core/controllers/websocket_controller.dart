import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/game_state.dart';

class WebSocketController {
  final Map<String, WebSocketChannel> _connections = {};
  final Map<String, String> _playerSessions = {}; // playerId -> sessionToken
  void Function(String, Map<String, dynamic>)? onMessageReceived;

  void addConnection(String playerId, WebSocketChannel channel) {
    _connections[playerId] = channel;
    channel.stream.listen((message) {
      if (onMessageReceived != null) {
        final decoded = jsonDecode(message as String);
        onMessageReceived!(playerId, decoded as Map<String, dynamic>);
      }
    }, onDone: () => removeConnection(playerId));
  }

  void removeConnection(String playerId) {
    _connections.remove(playerId);
  }

  /// Send message to specific client
  void sendToClient(String playerId, Map<String, dynamic> message) {
    final channel = _connections[playerId];
    if (channel != null) {
      channel.sink.add(jsonEncode(message));
    }
  }
  
  /// Broadcast to all connected clients
  void broadcast(Map<String, dynamic> message) {
    final encoded = jsonEncode(message);
    for (final channel in _connections.values) {
      channel.sink.add(encoded);
    }
  }
  
  /// Update client state (for reconnection)
  void syncClientState(String playerId, GameState state) {
    sendToClient(playerId, {
      'type': 'state_update',
      'state': state.toJson(),
    });
  }

  bool validateSession(String playerId, String token) {
    return _playerSessions[playerId] == token;
  }

  void registerSession(String playerId, String token) {
    _playerSessions[playerId] = token;
  }
}
