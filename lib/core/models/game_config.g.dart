// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameConfig _$GameConfigFromJson(Map<String, dynamic> json) => _GameConfig(
  themeId: json['themeId'] as String,
  mafiaBlindMode: json['mafiaBlindMode'] as bool? ?? true,
  donMechanicsEnabled: json['donMechanicsEnabled'] as bool? ?? false,
  prostituteEnabled: json['prostituteEnabled'] as bool? ?? true,
  maniacEnabled: json['maniacEnabled'] as bool? ?? true,
  discussionTime: (json['discussionTime'] as num?)?.toInt() ?? 120,
  votingTime: (json['votingTime'] as num?)?.toInt() ?? 60,
  defenseTime: (json['defenseTime'] as num?)?.toInt() ?? 60,
  mafiaActionTime: (json['mafiaActionTime'] as num?)?.toInt() ?? 90,
  otherActionTime: (json['otherActionTime'] as num?)?.toInt() ?? 60,
  mafiaCount: (json['mafiaCount'] as num?)?.toInt(),
  commissarCount: (json['commissarCount'] as num?)?.toInt(),
  doctorCount: (json['doctorCount'] as num?)?.toInt(),
);

Map<String, dynamic> _$GameConfigToJson(_GameConfig instance) =>
    <String, dynamic>{
      'themeId': instance.themeId,
      'mafiaBlindMode': instance.mafiaBlindMode,
      'donMechanicsEnabled': instance.donMechanicsEnabled,
      'prostituteEnabled': instance.prostituteEnabled,
      'maniacEnabled': instance.maniacEnabled,
      'discussionTime': instance.discussionTime,
      'votingTime': instance.votingTime,
      'defenseTime': instance.defenseTime,
      'mafiaActionTime': instance.mafiaActionTime,
      'otherActionTime': instance.otherActionTime,
      'mafiaCount': instance.mafiaCount,
      'commissarCount': instance.commissarCount,
      'doctorCount': instance.doctorCount,
    };
