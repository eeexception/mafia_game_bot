import '../models/theme_config.dart';
import '../models/role.dart';
import '../services/theme_loader.dart';

class ThemeController {
  ThemeController(this._loader);

  final ThemeLoader _loader;
  ThemeConfig? _currentTheme;
  List<ThemeMeta> _availableThemes = [];

  ThemeConfig? get currentTheme => _currentTheme;
  List<ThemeMeta> get availableThemes => _availableThemes;

  /// Load theme by ID
  Future<ThemeConfig> selectTheme(String themeId) async {
    // In a real app, you'd find the path for the ID
    final path = 'themes/$themeId/config.yaml';
    _currentTheme = await _loader.loadThemeConfig(path);
    return _currentTheme!;
  }
  
  /// Get role display name
  String getRoleDisplayName(RoleType role) {
    if (_currentTheme == null) return role.name;
    return _currentTheme!.roles[role.name] ?? role.name;
  }

  void setAvailableThemes(List<ThemeMeta> themes) {
    _availableThemes = themes;
  }
}
