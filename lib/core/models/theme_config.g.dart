// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ThemeConfig _$ThemeConfigFromJson(Map<String, dynamic> json) => _ThemeConfig(
  id: json['id'] as String,
  name: json['name'] as String,
  author: json['author'] as String,
  roles: Map<String, String>.from(json['roles'] as Map),
  eventAudio: (json['eventAudio'] as Map<String, dynamic>).map(
    (k, e) =>
        MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
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
      'roles': instance.roles,
      'eventAudio': instance.eventAudio,
      'backgroundAudio': instance.backgroundAudio,
      'announcementVolume': instance.announcementVolume,
      'backgroundDuckVolume': instance.backgroundDuckVolume,
      'backgroundNormalVolume': instance.backgroundNormalVolume,
    };

_ThemeMeta _$ThemeMetaFromJson(Map<String, dynamic> json) => _ThemeMeta(
  id: json['id'] as String,
  name: json['name'] as String,
  author: json['author'] as String,
);

Map<String, dynamic> _$ThemeMetaToJson(_ThemeMeta instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'author': instance.author,
    };
