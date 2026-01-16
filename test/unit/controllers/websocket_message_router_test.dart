import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/application/services/network/websocket_message_router.dart';
import 'package:mafia_game/domain/models/players/player_action.dart';

void main() {
  test('routes player_joined to handler', () {
    // Arrange
    var called = false;
    final router = WebSocketMessageRouter(
      onPlayerJoined: (senderId, message) => called = true,
    );

    // Act
    router.route('sender', {'type': 'player_joined'});

    // Assert
    expect(called, true);
  });

  test('routes player_action and injects performerId', () {
    // Arrange
    PlayerAction? received;
    final router = WebSocketMessageRouter(
      onPlayerAction: (_, action) => received = action,
    );

    // Act
    router.route('sender', {
      'type': 'player_action',
      'action': {
        'type': 'vote',
        'targetId': 'p2',
      },
    });

    // Assert
    expect(received, isNotNull);
    expect(received!.performerId, 'sender');
    expect(received!.type, 'vote');
    expect(received!.targetId, 'p2');
  });

  test('routes heartbeat to handler', () {
    // Arrange
    String? receivedId;
    final router = WebSocketMessageRouter(
      onHeartbeat: (senderId) => receivedId = senderId,
    );

    // Act
    router.route('sender', {'type': 'heartbeat'});

    // Assert
    expect(receivedId, 'sender');
  });
}
