import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClientService {
  WebSocketChannel? _channel;
  Timer? _heartbeatTimer;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  Future<void> connect(String url) async {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    await _channel!.ready; // Wait for connection to be established
    
    // Start heartbeat
    _heartbeatTimer?.cancel();
    _heartbeatTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_channel != null) {
        send({'type': 'heartbeat'});
      }
    });

    _channel!.stream.listen((message) {
      final decoded = jsonDecode(message as String);
      _messageController.add(decoded as Map<String, dynamic>);
    }, onError: (err) {
      _messageController.addError(err);
      _stopHeartbeat();
    }, onDone: () {
      _stopHeartbeat();
    });
  }

  void send(Map<String, dynamic> message) {
    if (_channel == null) return;
    try {
      _channel?.sink.add(jsonEncode(message));
    } catch (e) {
      // Channel might be closed
      _stopHeartbeat();
    }
  }

  void _stopHeartbeat() {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;
  }

  Future<void> disconnect() async {
    _stopHeartbeat();
    await _channel?.sink.close();
    _channel = null;
  }
}
