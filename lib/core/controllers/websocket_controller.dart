import 'dart:convert';
import 'dart:async';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../models/game_state.dart';

class WebSocketController {
  final Map<String, WebSocketChannel> _connections = {};
  final Map<String, StreamSubscription> _subscriptions = {};
  final Map<WebSocketChannel, String> _channelToPlayerId = {}; // Maps channel to current active playerId
  final Map<String, String> _playerSessions = {}; // playerId -> sessionToken
  void Function(String, Map<String, dynamic>)? onMessageReceived;
  void Function(String)? onConnectionLost;

  void addConnection(String playerId, WebSocketChannel channel) {
    _connections[playerId] = channel;
    _channelToPlayerId[channel] = playerId;
    
    final subscription = channel.stream.listen((message) {
      final activeId = _channelToPlayerId[channel];
      if (activeId != null && onMessageReceived != null) {
        try {
          final decoded = jsonDecode(message as String);
          onMessageReceived!(activeId, decoded as Map<String, dynamic>);
        } catch (e) {
          // Ignore malformed messages
        }
      }
    }, onDone: () {
      final activeId = _channelToPlayerId[channel];
      if (activeId != null && _connections[activeId] == channel) {
        removeConnection(activeId);
        if (onConnectionLost != null) {
          onConnectionLost!(activeId);
        }
      }
    }, onError: (e) {
      final activeId = _channelToPlayerId[channel];
      if (activeId != null && _connections[activeId] == channel) {
        removeConnection(activeId);
        if (onConnectionLost != null) {
          onConnectionLost!(activeId);
        }
      }
    });
    _subscriptions[playerId] = subscription;
  }

  void removeConnection(String playerId) {
    final channel = _connections.remove(playerId);
    if (channel != null) {
      _channelToPlayerId.remove(channel);
    }
    _subscriptions.remove(playerId)?.cancel();
  }

  /// Send message to specific client
  void sendToClient(String playerId, Map<String, dynamic> message) {
    final channel = _connections[playerId];
    if (channel != null) {
      channel.sink.add(jsonEncode(message));
    }
  }

  WebSocketChannel? getConnection(String playerId) {
    return _connections[playerId];
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

  /// Safely rebinds an existing channel to a new player ID
  void rebindConnection(String oldId, String newId, WebSocketChannel channel) {
    final subscription = _subscriptions.remove(oldId);
    _connections.remove(oldId);
    _channelToPlayerId.remove(channel);

    if (subscription != null) {
      _connections[newId] = channel;
      _subscriptions[newId] = subscription;
      _channelToPlayerId[channel] = newId;
    }
  }
}
