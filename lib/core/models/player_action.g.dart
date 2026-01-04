// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_action.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PlayerAction _$PlayerActionFromJson(Map<String, dynamic> json) =>
    _PlayerAction(
      type: json['type'] as String,
      performerId: json['performerId'] as String,
      targetId: json['targetId'] as String?,
      value: json['value'] as String?,
    );

Map<String, dynamic> _$PlayerActionToJson(_PlayerAction instance) =>
    <String, dynamic>{
      'type': instance.type,
      'performerId': instance.performerId,
      'targetId': instance.targetId,
      'value': instance.value,
    };
