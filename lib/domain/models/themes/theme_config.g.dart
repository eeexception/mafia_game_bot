// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ThemeConfig _$ThemeConfigFromJson(Map<String, dynamic> json) => _ThemeConfig(
  id: json['id'] as String,
  name: json['name'] as String,
  author: json['author'] as String,
  locale: json['locale'] as String? ?? 'en',
  basePath: json['basePath'] as String,
  roles: Map<String, String>.from(json['roles'] as Map),
  eventAudio: (json['eventAudio'] as Map<String, dynamic>).map(
    (k, e) => MapEntry(
      k,
      (e as List<dynamic>)
          .map((e) => AudioVariant.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
  ),
  backgroundAudio: Map<String, String>.from(json['backgroundAudio'] as Map),
  announcementVolume: (json['announcementVolume'] as num?)?.toDouble() ?? 1.0,
  backgroundDuckVolume:
      (json['backgroundDuckVolume'] as num?)?.toDouble() ?? 0.1,
  backgroundNormalVolume:
      (json['backgroundNormalVolume'] as num?)?.toDouble() ?? 0.3,
);

Map<String, dynamic> _$ThemeConfigToJson(_ThemeConfig instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'author': instance.author,
      'locale': instance.locale,
      'basePath': instance.basePath,
      'roles': instance.roles,
      'eventAudio': instance.eventAudio,
      'backgroundAudio': instance.backgroundAudio,
      'announcementVolume': instance.announcementVolume,
      'backgroundDuckVolume': instance.backgroundDuckVolume,
      'backgroundNormalVolume': instance.backgroundNormalVolume,
    };

_AudioVariant _$AudioVariantFromJson(Map<String, dynamic> json) =>
    _AudioVariant(file: json['file'] as String, text: json['text'] as String?);

Map<String, dynamic> _$AudioVariantToJson(_AudioVariant instance) =>
    <String, dynamic>{'file': instance.file, 'text': instance.text};

_ThemeMeta _$ThemeMetaFromJson(Map<String, dynamic> json) => _ThemeMeta(
  id: json['id'] as String,
  name: json['name'] as String,
  author: json['author'] as String,
  locale: json['locale'] as String? ?? 'en',
);

Map<String, dynamic> _$ThemeMetaToJson(_ThemeMeta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'author': instance.author,
      'locale': instance.locale,
    };
