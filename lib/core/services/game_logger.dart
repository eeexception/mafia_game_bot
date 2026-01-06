import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'dart:developer' as developer;

class GameLogger {
  final List<String> _publicLog = [];
  final List<String> _detailedLog = [];

  List<String> get publicLog => List.unmodifiable(_publicLog);
  List<String> get detailedLog => List.unmodifiable(_detailedLog);

  /// Add public event (visible during game)
  void logPublic(String message) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final entry = '[$timestamp] $message';
    _publicLog.add(entry);
    _detailedLog.add('[PUBLIC] $entry');
  }

  /// Add detailed event (hidden until game end)
  void logDetailed(String message, {int level = 800}) {
    final timestamp = DateTime.now().toIso8601String().substring(11, 19);
    final entry = '[$timestamp] $message';
    _detailedLog.add('[SECRET] $entry');
    developer.log(message, level: level);
  }

  /// Export logs to a .txt file
  Future<String?> exportLog() async {
    try {
      final directory = await getDownloadsDirectory() ?? await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').substring(0, 19);
      final file = File('${directory.path}/mafia_game_log_$timestamp.txt');
      
      final content = StringBuffer();
      content.writeln('=== MAFIA GAME LOG ===');
      content.writeln('Generated: ${DateTime.now()}');
      content.writeln('\n--- DETAILED HISTORY ---');
      for (var entry in _detailedLog) {
        content.writeln(entry);
      }
      
      await file.writeAsString(content.toString());
      developer.log('Log exported to: ${file.path}');
      return file.path;
    } catch (e, st) {
      developer.log('Failed to export log', error: e, stackTrace: st);
      return null;
    }
  }

  /// Reset logs for a new game
  void reset() {
    _publicLog.clear();
    _detailedLog.clear();
  }
}
