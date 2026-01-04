import 'dart:async';
import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketConnection {
  final WebSocketChannel channel;
  final String ip;

  WebSocketConnection(this.channel, this.ip);
}

class WebSocketServerService {
  HttpServer? _server;
  final _connectionController = StreamController<WebSocketConnection>.broadcast();
  
  Stream<WebSocketConnection> get onConnection => _connectionController.stream;

  /// Start WebSocket server
  Future<void> start(int port) async {
    final handler = webSocketHandler((WebSocketChannel webSocket, String? protocol) {
      _connectionController.add(WebSocketConnection(webSocket, 'unknown'));
    });

    _server = await io.serve(handler, InternetAddress.anyIPv4, port);
  }

  /// Stop server
  Future<void> stop() async {
    await _server?.close();
    await _connectionController.close();
  }
}
