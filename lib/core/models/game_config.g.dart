// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameConfig _$GameConfigFromJson(Map<String, dynamic> json) => _GameConfig(
  themeId: json['themeId'] as String,
  autoPruningEnabled: json['autoPruningEnabled'] as bool? ?? true,
  donMechanicsEnabled: json['donMechanicsEnabled'] as bool? ?? false,
  commissarEnabled: json['commissarEnabled'] as bool? ?? true,
  doctorEnabled: json['doctorEnabled'] as bool? ?? true,
  prostituteEnabled: json['prostituteEnabled'] as bool? ?? false,
  maniacEnabled: json['maniacEnabled'] as bool? ?? false,
  commissarKills: json['commissarKills'] as bool? ?? false,
  sergeantEnabled: json['sergeantEnabled'] as bool? ?? false,
  lawyerEnabled: json['lawyerEnabled'] as bool? ?? false,
  poisonerEnabled: json['poisonerEnabled'] as bool? ?? false,
  doctorCanHealSelf: json['doctorCanHealSelf'] as bool? ?? true,
  doctorCanHealSameTargetConsecutively:
      json['doctorCanHealSameTargetConsecutively'] as bool? ?? false,
  locale: json['locale'] as String? ?? 'en',
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
      'autoPruningEnabled': instance.autoPruningEnabled,
      'donMechanicsEnabled': instance.donMechanicsEnabled,
      'commissarEnabled': instance.commissarEnabled,
      'doctorEnabled': instance.doctorEnabled,
      'prostituteEnabled': instance.prostituteEnabled,
      'maniacEnabled': instance.maniacEnabled,
      'commissarKills': instance.commissarKills,
      'sergeantEnabled': instance.sergeantEnabled,
      'lawyerEnabled': instance.lawyerEnabled,
      'poisonerEnabled': instance.poisonerEnabled,
      'doctorCanHealSelf': instance.doctorCanHealSelf,
      'doctorCanHealSameTargetConsecutively':
          instance.doctorCanHealSameTargetConsecutively,
      'locale': instance.locale,
      'discussionTime': instance.discussionTime,
      'votingTime': instance.votingTime,
      'defenseTime': instance.defenseTime,
      'mafiaActionTime': instance.mafiaActionTime,
      'otherActionTime': instance.otherActionTime,
      'mafiaCount': instance.mafiaCount,
      'commissarCount': instance.commissarCount,
      'doctorCount': instance.doctorCount,
    };
