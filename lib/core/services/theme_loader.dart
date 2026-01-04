import 'dart:io';
import 'package:yaml/yaml.dart';
import '../models/theme_config.dart';

class ThemeLoader {
  /// Load theme configuration from file
  Future<ThemeConfig> loadThemeConfig(String themePath) async {
    final file = File(themePath);
    if (!await file.exists()) {
      throw FileSystemException('Theme config not found', themePath);
    }
    final content = await file.readAsString();
    final yaml = loadYaml(content) as YamlMap;
    return parseYaml(yaml);
  }
  
  /// Parse YAML to ThemeConfig object
  ThemeConfig parseYaml(YamlMap yaml) {
    // 1. Roles: yaml['roles'][role]['display_name'] -> roles[role]
    final rolesMap = yaml['roles'] as YamlMap? ?? {};
    final roles = <String, String>{};
    rolesMap.forEach((key, value) {
      if (value is YamlMap) {
        roles[key as String] = value['display_name']?.toString() ?? key.toString();
      } else if (value is String) {
        roles[key as String] = value;
      }
    });

    // 2. Audio
    final audio = yaml['audio'] as YamlMap?;
    
    // Events: yaml['audio']['events'][key] -> List<Map> -> List<String> (filenames)
    final eventsMap = audio?['events'] as YamlMap? ?? {};
    final eventAudio = <String, List<String>>{};
    
    eventsMap.forEach((key, value) {
      final k = key as String;
      if (value is YamlList) {
        // List of variants
        eventAudio[k] = value.map((item) {
          if (item is YamlMap) {
            return item['file']?.toString() ?? '';
          }
           return item?.toString() ?? '';
        }).where((s) => s.isNotEmpty).toList();
      } else if (value is YamlMap) {
         // Handle nested maps like "countdown" -> {ten: "...", nine: "..."}
         // Spec: countdown: {ten: "path"}
         // Flatten them to countdown_ten: ["path"]
         value.forEach((subKey, subVal) {
           final path = subVal?.toString() ?? '';
           if (path.isNotEmpty) {
             eventAudio['${k}_$subKey'] = [path];
           }
         });
      }
    });

    // Background: yaml['audio']['background'][key] -> List<Map> -> String (first filename)
    final bgMap = audio?['background'] as YamlMap? ?? {};
    final backgroundAudio = <String, String>{};
    
    bgMap.forEach((key, value) {
      final k = key as String;
      if (value is YamlList && value.isNotEmpty) {
        final firstItem = value.first;
         if (firstItem is YamlMap) {
            backgroundAudio[k] = firstItem['file']?.toString() ?? '';
         } else {
            backgroundAudio[k] = firstItem?.toString() ?? '';
         }
      } else if (value is String) {
        backgroundAudio[k] = value;
      }
    });

    // Mixing
    final mixing = yaml['audio_mixing'] as YamlMap?;
    
    // Meta (support both root-level and nested meta)
    final meta = yaml['meta'] as YamlMap?;
    final id = meta?['id']?.toString() ?? yaml['id']?.toString() ?? 'unknown';
    final name = meta?['name']?.toString() ?? yaml['name']?.toString() ?? 'Unknown Theme';
    final author = meta?['author']?.toString() ?? yaml['author']?.toString() ?? 'Unknown Author';

    return ThemeConfig(
      id: id,
      name: name,
      author: author,
      roles: roles,
      eventAudio: eventAudio,
      backgroundAudio: backgroundAudio,
      announcementVolume: (mixing?['background_volume'] as num?)?.toDouble() ?? 1.0, // Spec says background_volume in mixing block
      backgroundDuckVolume: (mixing?['ducking_volume'] as num?)?.toDouble() ?? 0.1,
      backgroundNormalVolume: (mixing?['background_volume'] as num?)?.toDouble() ?? 0.3,
    );
  }
  
  /// Validate theme structure
  void validateTheme(ThemeConfig theme) {
    // Check if critical audio files are specified
    // This could be more detailed
  }
  
  /// Get asset file path
  String getAssetPath(String themeId, String relativePath) {
    return 'themes/$themeId/assets/$relativePath';
  }
}
