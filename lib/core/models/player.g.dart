// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Player _$PlayerFromJson(Map<String, dynamic> json) => _Player(
  id: json['id'] as String,
  number: (json['number'] as num).toInt(),
  nickname: json['nickname'] as String,
  role: const RoleConverter().fromJson(json['role'] as Map<String, dynamic>),
  isAlive: json['isAlive'] as bool? ?? true,
  isConnected: json['isConnected'] as bool? ?? true,
  isReadyToVote: json['isReadyToVote'] as bool? ?? false,
  hasActed: json['hasActed'] as bool? ?? false,
  isPoisoned: json['isPoisoned'] as bool? ?? false,
  sessionToken: json['sessionToken'] as String?,
  lastHeartbeat: json['lastHeartbeat'] == null
      ? null
      : DateTime.parse(json['lastHeartbeat'] as String),
);

Map<String, dynamic> _$PlayerToJson(_Player instance) => <String, dynamic>{
  'id': instance.id,
  'number': instance.number,
  'nickname': instance.nickname,
  'role': const RoleConverter().toJson(instance.role),
  'isAlive': instance.isAlive,
  'isConnected': instance.isConnected,
  'isReadyToVote': instance.isReadyToVote,
  'hasActed': instance.hasActed,
  'isPoisoned': instance.isPoisoned,
  'sessionToken': instance.sessionToken,
  'lastHeartbeat': instance.lastHeartbeat?.toIso8601String(),
};
