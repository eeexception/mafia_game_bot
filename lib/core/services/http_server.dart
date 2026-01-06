import 'dart:io';
import 'dart:developer' as developer;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';

class HttpServerService {
  HttpServer? _server;
  
  /// Start HTTP server on specified port
  Future<String> start({int port = 8080}) async {
    final cwd = Directory.current.path;
    developer.log('📂 Current Working Directory: $cwd', name: 'HttpServer');

    // 1. Try to get from environment (dart-define)
    String webRoot = const String.fromEnvironment('WEB_ROOT');
    if (webRoot.isNotEmpty) {
      if (Directory(webRoot).existsSync()) {
        developer.log('✅ Found web root from environment: $webRoot', name: 'HttpServer');
      } else {
        developer.log('⚠️ WEB_ROOT from environment not found: $webRoot', name: 'HttpServer');
        webRoot = '';
      }
    }

    // 2. Default to local path or relative to CWD
    if (webRoot.isEmpty) {
      webRoot = 'build/web';
      if (!Directory(webRoot).existsSync()) {
        developer.log('⚠️ $webRoot not found in CWD. Checking alternatives...', name: 'HttpServer');
        final altPath = '${Directory.current.parent.path}/build/web';
        if (Directory(altPath).existsSync()) {
          webRoot = altPath;
        } else {
          developer.log('❌ Could not find build/web directory!', name: 'HttpServer');
        }
      }
    }

    final absoluteWebRoot = Directory(webRoot).absolute.path;
    developer.log('✅ Using absolute web root: $absoluteWebRoot', name: 'HttpServer');

    try {
      final handler = createStaticHandler(absoluteWebRoot, defaultDocument: 'index.html');
      _server = await io.serve(handler, InternetAddress.anyIPv4, port);
      
      final ip = await _getLocalIp();
      return 'http://$ip:$port';
    } catch (e) {
      throw Exception('Failed to start HTTP server on port $port (CWD: $cwd): $e');
    }
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
