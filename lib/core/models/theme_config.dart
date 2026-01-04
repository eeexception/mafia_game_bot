import 'package:freezed_annotation/freezed_annotation.dart';

part 'theme_config.freezed.dart';
part 'theme_config.g.dart';

@freezed
abstract class ThemeConfig with _$ThemeConfig {
  const factory ThemeConfig({
    required String id,
    required String name,
    required String author,
    required Map<String, String> roles,
    required Map<String, List<String>> eventAudio,
    required Map<String, String> backgroundAudio,
    @Default(1.0) double announcementVolume,
    @Default(0.1) double backgroundDuckVolume,
    @Default(0.3) double backgroundNormalVolume,
  }) = _ThemeConfig;

  factory ThemeConfig.fromJson(Map<String, dynamic> json) =>
      _$ThemeConfigFromJson(json);
}

@freezed
abstract class ThemeMeta with _$ThemeMeta {
  const factory ThemeMeta({
    required String id,
    required String name,
    required String author,
  }) = _ThemeMeta;

  factory ThemeMeta.fromJson(Map<String, dynamic> json) =>
      _$ThemeMetaFromJson(json);
}
