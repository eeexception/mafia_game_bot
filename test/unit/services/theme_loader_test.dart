import 'package:flutter_test/flutter_test.dart';
import 'package:mafia_game/infrastructure/services/theme/theme_loader.dart';

import 'dart:io';

void main() {
  test('ThemeLoader loads default theme correctly', () async {
    final loader = ThemeLoader();
    final configPath = 'themes/default/config.yaml';
    
    // Ensure file exists (sanity check for test environment)
    expect(File(configPath).existsSync(), true, reason: 'Default theme config not found at $configPath');

    final theme = await loader.loadThemeConfig(configPath);

    expect(theme.id, 'default');
    expect(theme.name, 'Default Theme');
    expect(theme.roles['mafia'], 'Mafia');
    
    // Check audio events flattening
    expect(theme.eventAudio.containsKey('game_start'), true);
    expect(theme.eventAudio['game_start']?.first.file.contains('themes/default/assets/game_start.mp3'), true);
    
    // Check nested keys if any (countdown)
    expect(theme.eventAudio.containsKey('countdown_ten'), true);
    expect(theme.eventAudio['countdown_ten']?.first.file.contains('themes/default/assets/countdown_10.mp3'), true);
  });
}
