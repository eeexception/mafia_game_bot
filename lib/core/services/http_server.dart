import 'dart:io';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

class HttpServerService {
  HttpServer? _server;
  
  /// Start HTTP server on specified port
  Future<String> start({int port = 8080}) async {
    final handler = createStaticHandler('build/web', defaultDocument: 'index.html');
    _server = await io.serve(handler, InternetAddress.anyIPv4, port);
    
    final ip = await _getLocalIp();
    return 'http://$ip:$port';
  }
  
  /// Get local IP for QR code
  Future<String> _getLocalIp() async {
    for (var interface in await NetworkInterface.list()) {
      for (var addr in interface.addresses) {
        if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
          return addr.address;
        }
      }
    }
    return '127.0.0.1';
  }
  
  /// Stop server
  Future<void> stop() async {
    await _server?.close();
  }
}
