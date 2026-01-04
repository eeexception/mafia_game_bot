import 'dart:async';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketClientService {
  WebSocketChannel? _channel;
  final _messageController = StreamController<Map<String, dynamic>>.broadcast();
  
  Stream<Map<String, dynamic>> get messages => _messageController.stream;

  Future<void> connect(String url) async {
    _channel = WebSocketChannel.connect(Uri.parse(url));
    _channel!.stream.listen((message) {
      final decoded = jsonDecode(message as String);
      _messageController.add(decoded as Map<String, dynamic>);
    });
  }

  void send(Map<String, dynamic> message) {
    _channel?.sink.add(jsonEncode(message));
  }

  Future<void> disconnect() async {
    await _channel?.sink.close();
  }
}
