// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_GameState _$GameStateFromJson(Map<String, dynamic> json) => _GameState(
  phase: $enumDecode(_$GamePhaseEnumMap, json['phase']),
  players: (json['players'] as List<dynamic>)
      .map((e) => Player.fromJson(e as Map<String, dynamic>))
      .toList(),
  config: GameConfig.fromJson(json['config'] as Map<String, dynamic>),
  isPaused: json['isPaused'] as bool? ?? false,
  timerSecondsRemaining: (json['timerSecondsRemaining'] as num?)?.toInt(),
  currentNightNumber: (json['currentNightNumber'] as num?)?.toInt(),
  currentDayNumber: (json['currentDayNumber'] as num?)?.toInt(),
  currentVotes: (json['currentVotes'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  pendingActions:
      (json['pendingActions'] as List<dynamic>?)
          ?.map((e) => PlayerAction.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  publicEventLog:
      (json['publicEventLog'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  detailedLog:
      (json['detailedLog'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
);

Map<String, dynamic> _$GameStateToJson(_GameState instance) =>
    <String, dynamic>{
      'phase': _$GamePhaseEnumMap[instance.phase]!,
      'players': instance.players,
      'config': instance.config,
      'isPaused': instance.isPaused,
      'timerSecondsRemaining': instance.timerSecondsRemaining,
      'currentNightNumber': instance.currentNightNumber,
      'currentDayNumber': instance.currentDayNumber,
      'currentVotes': instance.currentVotes,
      'pendingActions': instance.pendingActions,
      'publicEventLog': instance.publicEventLog,
      'detailedLog': instance.detailedLog,
    };

const _$GamePhaseEnumMap = {
  GamePhase.lobby: 'lobby',
  GamePhase.setup: 'setup',
  GamePhase.nightMafia: 'nightMafia',
  GamePhase.nightProstitute: 'nightProstitute',
  GamePhase.nightManiac: 'nightManiac',
  GamePhase.nightDoctor: 'nightDoctor',
  GamePhase.nightCommissar: 'nightCommissar',
  GamePhase.morning: 'morning',
  GamePhase.dayDiscussion: 'dayDiscussion',
  GamePhase.dayVoting: 'dayVoting',
  GamePhase.dayDefense: 'dayDefense',
  GamePhase.dayVerdict: 'dayVerdict',
  GamePhase.gameOver: 'gameOver',
};
