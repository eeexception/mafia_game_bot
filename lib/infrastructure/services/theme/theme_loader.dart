import 'dart:io';
import 'package:yaml/yaml.dart';
import '../../../domain/models/themes/theme_config.dart';

class ThemeLoader {
  /// Load theme configuration from file
  Future<ThemeConfig> loadThemeConfig(String themePath) async {
    final file = File(themePath).absolute;
    if (!await file.exists()) {
      throw FileSystemException('Theme config not found', themePath);
    }
    final content = await file.readAsString();
    final yaml = loadYaml(content) as YamlMap;
    final themeDir = file.parent.path;
    return parseYaml(yaml, basePath: themeDir);
  }
  
  /// Parse YAML to ThemeConfig object
  ThemeConfig parseYaml(YamlMap yaml, {String basePath = ''}) {
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
    
    // Events: yaml['audio']['events'][key] -> List<Map> -> List<AudioVariant>
    final eventsMap = audio?['events'] as YamlMap? ?? {};
    final eventAudio = <String, List<AudioVariant>>{};
    
    final assetsPath = basePath.isEmpty ? '' : '$basePath/assets/';

    eventsMap.forEach((key, value) {
      final k = key as String;
      if (value is YamlList) {
        // List of variants
        eventAudio[k] = value.map((item) {
          if (item is YamlMap) {
            String filePath = item['file']?.toString() ?? '';
            if (filePath.isNotEmpty && !filePath.startsWith('http') && !filePath.startsWith('/')) {
              filePath = assetsPath + filePath;
            }
            return AudioVariant(
              file: filePath,
              text: item['text']?.toString(),
            );
          }
          String filePath = item?.toString() ?? '';
          if (filePath.isNotEmpty && !filePath.startsWith('http') && !filePath.startsWith('/')) {
            filePath = assetsPath + filePath;
          }
          return AudioVariant(file: filePath);
        }).where((v) => v.file.isNotEmpty).toList();
      } else if (value is YamlMap) {
         // Handle nested maps like "countdown" -> {ten: "...", nine: "..."}
          value.forEach((subKey, subVal) {
           AudioVariant variant;
           if (subVal is YamlMap) {
             String filePath = subVal['file']?.toString() ?? '';
             if (filePath.isNotEmpty && !filePath.startsWith('http') && !filePath.startsWith('/')) {
                filePath = assetsPath + filePath;
             }
             variant = AudioVariant(
               file: filePath,
               text: subVal['text']?.toString(),
             );
           } else {
             String filePath = subVal?.toString() ?? '';
             if (filePath.isNotEmpty && !filePath.startsWith('http') && !filePath.startsWith('/')) {
                filePath = assetsPath + filePath;
             }
             variant = AudioVariant(file: filePath);
           }
           
           if (variant.file.isNotEmpty) {
             eventAudio['${k}_$subKey'] = [variant];
           }
         });
      }
    });

    // 3. Background: yaml['audio']['background'][key] -> List<Map> -> String (first filename)
    final bgMap = audio?['background'] as YamlMap? ?? {};
    final backgroundAudio = <String, String>{};
    
    bgMap.forEach((key, value) {
      final k = key as String;
      String filePath = '';
      if (value is YamlList && value.isNotEmpty) {
        final firstItem = value.first;
         if (firstItem is YamlMap) {
            filePath = firstItem['file']?.toString() ?? '';
         } else {
            filePath = firstItem?.toString() ?? '';
         }
      } else if (value is String) {
        filePath = value;
      }

      if (filePath.isNotEmpty && !filePath.startsWith('http') && !filePath.startsWith('/')) {
        filePath = assetsPath + filePath;
      }
      backgroundAudio[k] = filePath;
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
      locale: meta?['locale']?.toString() ?? yaml['locale']?.toString() ?? 'en',
      basePath: basePath,
      roles: roles,
      eventAudio: eventAudio,
      backgroundAudio: backgroundAudio,
      announcementVolume: (mixing?['background_volume'] as num?)?.toDouble() ?? 1.0, 
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

  /// Discover all available themes in the themes/ directory
  Future<List<ThemeMeta>> discoverThemes() async {
    final themesDir = Directory('themes').absolute;
    if (!await themesDir.exists()) return [];

    final themes = <ThemeMeta>[];
    await for (final entity in themesDir.list()) {
      if (entity is Directory) {
        final configFile = File('${entity.path}/config.yaml');
        if (await configFile.exists()) {
          try {
            final content = await configFile.readAsString();
            final yaml = loadYaml(content) as YamlMap;
            
            final meta = yaml['meta'] as YamlMap?;
            final id = meta?['id']?.toString() ?? yaml['id']?.toString() ?? entity.uri.pathSegments.lastWhere((s) => s.isNotEmpty);
            final name = meta?['name']?.toString() ?? yaml['name']?.toString() ?? id;
            final author = meta?['author']?.toString() ?? yaml['author']?.toString() ?? 'Unknown';
            final locale = meta?['locale']?.toString() ?? yaml['locale']?.toString() ?? 'en';

            themes.add(ThemeMeta(id: id, name: name, author: author, locale: locale));
          } catch (e) {
            // Skip invalid themes
            stderr.writeln('Error loading theme at ${entity.path}: $e');
          }
        }
      }
    }
    return themes;
  }
}
