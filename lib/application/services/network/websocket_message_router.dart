import '../../../domain/models/players/player_action.dart';

/// Routes incoming WebSocket payloads to typed handlers.
class WebSocketMessageRouter {
  /// Creates a router with optional message handlers.
  WebSocketMessageRouter({
    this.onPlayerJoined,
    this.onPlayerReconnect,
    this.onPlayerAction,
    this.onHeartbeat,
  });

  final void Function(String senderId, Map<String, dynamic> message)?
      onPlayerJoined;
  final void Function(String senderId, Map<String, dynamic> message)?
      onPlayerReconnect;
  final void Function(String senderId, PlayerAction action)? onPlayerAction;
  final void Function(String senderId)? onHeartbeat;

  /// Routes a decoded message based on its `type`.
  void route(String senderId, Map<String, dynamic> message) {
    final type = message['type'] as String?;
    switch (type) {
      case 'player_joined':
        onPlayerJoined?.call(senderId, message);
        break;
      case 'player_reconnect':
        onPlayerReconnect?.call(senderId, message);
        break;
      case 'player_action':
        final rawAction = message['action'];
        if (rawAction is Map) {
          final actionMap = Map<String, dynamic>.from(rawAction);
          actionMap['performerId'] = senderId;
          onPlayerAction?.call(
            senderId,
            PlayerAction.fromJson(actionMap),
          );
        }
        break;
      case 'heartbeat':
        onHeartbeat?.call(senderId);
        break;
    }
  }
}
