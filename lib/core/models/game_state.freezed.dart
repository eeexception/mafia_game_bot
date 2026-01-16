// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameState {

@GamePhaseConverter() GamePhase get phase; int get currentMoveIndex; String? get currentMoveId; List<Player> get players; GameConfig get config; bool get isPaused; int? get timerSecondsRemaining; int? get currentNightNumber; int? get currentDayNumber; Map<String, String>? get currentVotes;// performerId -> targetId
 Map<String, bool>? get currentVerdicts;// performerId -> isExecute (true=execute, false=pardon)
 String? get verdictTargetId; List<String> get defenseQueue; String? get speakerId; String? get lastDoctorTargetId; List<PlayerAction> get pendingActions; List<String> get publicEventLog; List<String> get detailedLog; String? get sessionId; String? get statusMessage;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.currentMoveIndex, currentMoveIndex) || other.currentMoveIndex == currentMoveIndex)&&(identical(other.currentMoveId, currentMoveId) || other.currentMoveId == currentMoveId)&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.config, config) || other.config == config)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.timerSecondsRemaining, timerSecondsRemaining) || other.timerSecondsRemaining == timerSecondsRemaining)&&(identical(other.currentNightNumber, currentNightNumber) || other.currentNightNumber == currentNightNumber)&&(identical(other.currentDayNumber, currentDayNumber) || other.currentDayNumber == currentDayNumber)&&const DeepCollectionEquality().equals(other.currentVotes, currentVotes)&&const DeepCollectionEquality().equals(other.currentVerdicts, currentVerdicts)&&(identical(other.verdictTargetId, verdictTargetId) || other.verdictTargetId == verdictTargetId)&&const DeepCollectionEquality().equals(other.defenseQueue, defenseQueue)&&(identical(other.speakerId, speakerId) || other.speakerId == speakerId)&&(identical(other.lastDoctorTargetId, lastDoctorTargetId) || other.lastDoctorTargetId == lastDoctorTargetId)&&const DeepCollectionEquality().equals(other.pendingActions, pendingActions)&&const DeepCollectionEquality().equals(other.publicEventLog, publicEventLog)&&const DeepCollectionEquality().equals(other.detailedLog, detailedLog)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,phase,currentMoveIndex,currentMoveId,const DeepCollectionEquality().hash(players),config,isPaused,timerSecondsRemaining,currentNightNumber,currentDayNumber,const DeepCollectionEquality().hash(currentVotes),const DeepCollectionEquality().hash(currentVerdicts),verdictTargetId,const DeepCollectionEquality().hash(defenseQueue),speakerId,lastDoctorTargetId,const DeepCollectionEquality().hash(pendingActions),const DeepCollectionEquality().hash(publicEventLog),const DeepCollectionEquality().hash(detailedLog),sessionId,statusMessage]);

@override
String toString() {
  return 'GameState(phase: $phase, currentMoveIndex: $currentMoveIndex, currentMoveId: $currentMoveId, players: $players, config: $config, isPaused: $isPaused, timerSecondsRemaining: $timerSecondsRemaining, currentNightNumber: $currentNightNumber, currentDayNumber: $currentDayNumber, currentVotes: $currentVotes, currentVerdicts: $currentVerdicts, verdictTargetId: $verdictTargetId, defenseQueue: $defenseQueue, speakerId: $speakerId, lastDoctorTargetId: $lastDoctorTargetId, pendingActions: $pendingActions, publicEventLog: $publicEventLog, detailedLog: $detailedLog, sessionId: $sessionId, statusMessage: $statusMessage)';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
@GamePhaseConverter() GamePhase phase, int currentMoveIndex, String? currentMoveId, List<Player> players, GameConfig config, bool isPaused, int? timerSecondsRemaining, int? currentNightNumber, int? currentDayNumber, Map<String, String>? currentVotes, Map<String, bool>? currentVerdicts, String? verdictTargetId, List<String> defenseQueue, String? speakerId, String? lastDoctorTargetId, List<PlayerAction> pendingActions, List<String> publicEventLog, List<String> detailedLog, String? sessionId, String? statusMessage
});


$GameConfigCopyWith<$Res> get config;

}
/// @nodoc
class _$GameStateCopyWithImpl<$Res>
    implements $GameStateCopyWith<$Res> {
  _$GameStateCopyWithImpl(this._self, this._then);

  final GameState _self;
  final $Res Function(GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? currentMoveIndex = null,Object? currentMoveId = freezed,Object? players = null,Object? config = null,Object? isPaused = null,Object? timerSecondsRemaining = freezed,Object? currentNightNumber = freezed,Object? currentDayNumber = freezed,Object? currentVotes = freezed,Object? currentVerdicts = freezed,Object? verdictTargetId = freezed,Object? defenseQueue = null,Object? speakerId = freezed,Object? lastDoctorTargetId = freezed,Object? pendingActions = null,Object? publicEventLog = null,Object? detailedLog = null,Object? sessionId = freezed,Object? statusMessage = freezed,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as GamePhase,currentMoveIndex: null == currentMoveIndex ? _self.currentMoveIndex : currentMoveIndex // ignore: cast_nullable_to_non_nullable
as int,currentMoveId: freezed == currentMoveId ? _self.currentMoveId : currentMoveId // ignore: cast_nullable_to_non_nullable
as String?,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as GameConfig,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,timerSecondsRemaining: freezed == timerSecondsRemaining ? _self.timerSecondsRemaining : timerSecondsRemaining // ignore: cast_nullable_to_non_nullable
as int?,currentNightNumber: freezed == currentNightNumber ? _self.currentNightNumber : currentNightNumber // ignore: cast_nullable_to_non_nullable
as int?,currentDayNumber: freezed == currentDayNumber ? _self.currentDayNumber : currentDayNumber // ignore: cast_nullable_to_non_nullable
as int?,currentVotes: freezed == currentVotes ? _self.currentVotes : currentVotes // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,currentVerdicts: freezed == currentVerdicts ? _self.currentVerdicts : currentVerdicts // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,verdictTargetId: freezed == verdictTargetId ? _self.verdictTargetId : verdictTargetId // ignore: cast_nullable_to_non_nullable
as String?,defenseQueue: null == defenseQueue ? _self.defenseQueue : defenseQueue // ignore: cast_nullable_to_non_nullable
as List<String>,speakerId: freezed == speakerId ? _self.speakerId : speakerId // ignore: cast_nullable_to_non_nullable
as String?,lastDoctorTargetId: freezed == lastDoctorTargetId ? _self.lastDoctorTargetId : lastDoctorTargetId // ignore: cast_nullable_to_non_nullable
as String?,pendingActions: null == pendingActions ? _self.pendingActions : pendingActions // ignore: cast_nullable_to_non_nullable
as List<PlayerAction>,publicEventLog: null == publicEventLog ? _self.publicEventLog : publicEventLog // ignore: cast_nullable_to_non_nullable
as List<String>,detailedLog: null == detailedLog ? _self.detailedLog : detailedLog // ignore: cast_nullable_to_non_nullable
as List<String>,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,statusMessage: freezed == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameConfigCopyWith<$Res> get config {
  
  return $GameConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}


/// Adds pattern-matching-related methods to [GameState].
extension GameStatePatterns on GameState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameState value)  $default,){
final _that = this;
switch (_that) {
case _GameState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameState value)?  $default,){
final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@GamePhaseConverter()  GamePhase phase,  int currentMoveIndex,  String? currentMoveId,  List<Player> players,  GameConfig config,  bool isPaused,  int? timerSecondsRemaining,  int? currentNightNumber,  int? currentDayNumber,  Map<String, String>? currentVotes,  Map<String, bool>? currentVerdicts,  String? verdictTargetId,  List<String> defenseQueue,  String? speakerId,  String? lastDoctorTargetId,  List<PlayerAction> pendingActions,  List<String> publicEventLog,  List<String> detailedLog,  String? sessionId,  String? statusMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.phase,_that.currentMoveIndex,_that.currentMoveId,_that.players,_that.config,_that.isPaused,_that.timerSecondsRemaining,_that.currentNightNumber,_that.currentDayNumber,_that.currentVotes,_that.currentVerdicts,_that.verdictTargetId,_that.defenseQueue,_that.speakerId,_that.lastDoctorTargetId,_that.pendingActions,_that.publicEventLog,_that.detailedLog,_that.sessionId,_that.statusMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@GamePhaseConverter()  GamePhase phase,  int currentMoveIndex,  String? currentMoveId,  List<Player> players,  GameConfig config,  bool isPaused,  int? timerSecondsRemaining,  int? currentNightNumber,  int? currentDayNumber,  Map<String, String>? currentVotes,  Map<String, bool>? currentVerdicts,  String? verdictTargetId,  List<String> defenseQueue,  String? speakerId,  String? lastDoctorTargetId,  List<PlayerAction> pendingActions,  List<String> publicEventLog,  List<String> detailedLog,  String? sessionId,  String? statusMessage)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.phase,_that.currentMoveIndex,_that.currentMoveId,_that.players,_that.config,_that.isPaused,_that.timerSecondsRemaining,_that.currentNightNumber,_that.currentDayNumber,_that.currentVotes,_that.currentVerdicts,_that.verdictTargetId,_that.defenseQueue,_that.speakerId,_that.lastDoctorTargetId,_that.pendingActions,_that.publicEventLog,_that.detailedLog,_that.sessionId,_that.statusMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@GamePhaseConverter()  GamePhase phase,  int currentMoveIndex,  String? currentMoveId,  List<Player> players,  GameConfig config,  bool isPaused,  int? timerSecondsRemaining,  int? currentNightNumber,  int? currentDayNumber,  Map<String, String>? currentVotes,  Map<String, bool>? currentVerdicts,  String? verdictTargetId,  List<String> defenseQueue,  String? speakerId,  String? lastDoctorTargetId,  List<PlayerAction> pendingActions,  List<String> publicEventLog,  List<String> detailedLog,  String? sessionId,  String? statusMessage)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.phase,_that.currentMoveIndex,_that.currentMoveId,_that.players,_that.config,_that.isPaused,_that.timerSecondsRemaining,_that.currentNightNumber,_that.currentDayNumber,_that.currentVotes,_that.currentVerdicts,_that.verdictTargetId,_that.defenseQueue,_that.speakerId,_that.lastDoctorTargetId,_that.pendingActions,_that.publicEventLog,_that.detailedLog,_that.sessionId,_that.statusMessage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameState implements GameState {
  const _GameState({@GamePhaseConverter() required this.phase, this.currentMoveIndex = 0, this.currentMoveId, required final  List<Player> players, required this.config, this.isPaused = false, this.timerSecondsRemaining, this.currentNightNumber, this.currentDayNumber, final  Map<String, String>? currentVotes, final  Map<String, bool>? currentVerdicts, this.verdictTargetId, final  List<String> defenseQueue = const [], this.speakerId, this.lastDoctorTargetId, final  List<PlayerAction> pendingActions = const [], final  List<String> publicEventLog = const [], final  List<String> detailedLog = const [], this.sessionId, this.statusMessage}): _players = players,_currentVotes = currentVotes,_currentVerdicts = currentVerdicts,_defenseQueue = defenseQueue,_pendingActions = pendingActions,_publicEventLog = publicEventLog,_detailedLog = detailedLog;
  factory _GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);

@override@GamePhaseConverter() final  GamePhase phase;
@override@JsonKey() final  int currentMoveIndex;
@override final  String? currentMoveId;
 final  List<Player> _players;
@override List<Player> get players {
  if (_players is EqualUnmodifiableListView) return _players;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_players);
}

@override final  GameConfig config;
@override@JsonKey() final  bool isPaused;
@override final  int? timerSecondsRemaining;
@override final  int? currentNightNumber;
@override final  int? currentDayNumber;
 final  Map<String, String>? _currentVotes;
@override Map<String, String>? get currentVotes {
  final value = _currentVotes;
  if (value == null) return null;
  if (_currentVotes is EqualUnmodifiableMapView) return _currentVotes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// performerId -> targetId
 final  Map<String, bool>? _currentVerdicts;
// performerId -> targetId
@override Map<String, bool>? get currentVerdicts {
  final value = _currentVerdicts;
  if (value == null) return null;
  if (_currentVerdicts is EqualUnmodifiableMapView) return _currentVerdicts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}

// performerId -> isExecute (true=execute, false=pardon)
@override final  String? verdictTargetId;
 final  List<String> _defenseQueue;
@override@JsonKey() List<String> get defenseQueue {
  if (_defenseQueue is EqualUnmodifiableListView) return _defenseQueue;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_defenseQueue);
}

@override final  String? speakerId;
@override final  String? lastDoctorTargetId;
 final  List<PlayerAction> _pendingActions;
@override@JsonKey() List<PlayerAction> get pendingActions {
  if (_pendingActions is EqualUnmodifiableListView) return _pendingActions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_pendingActions);
}

 final  List<String> _publicEventLog;
@override@JsonKey() List<String> get publicEventLog {
  if (_publicEventLog is EqualUnmodifiableListView) return _publicEventLog;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_publicEventLog);
}

 final  List<String> _detailedLog;
@override@JsonKey() List<String> get detailedLog {
  if (_detailedLog is EqualUnmodifiableListView) return _detailedLog;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_detailedLog);
}

@override final  String? sessionId;
@override final  String? statusMessage;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameStateCopyWith<_GameState> get copyWith => __$GameStateCopyWithImpl<_GameState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameStateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.currentMoveIndex, currentMoveIndex) || other.currentMoveIndex == currentMoveIndex)&&(identical(other.currentMoveId, currentMoveId) || other.currentMoveId == currentMoveId)&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.config, config) || other.config == config)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.timerSecondsRemaining, timerSecondsRemaining) || other.timerSecondsRemaining == timerSecondsRemaining)&&(identical(other.currentNightNumber, currentNightNumber) || other.currentNightNumber == currentNightNumber)&&(identical(other.currentDayNumber, currentDayNumber) || other.currentDayNumber == currentDayNumber)&&const DeepCollectionEquality().equals(other._currentVotes, _currentVotes)&&const DeepCollectionEquality().equals(other._currentVerdicts, _currentVerdicts)&&(identical(other.verdictTargetId, verdictTargetId) || other.verdictTargetId == verdictTargetId)&&const DeepCollectionEquality().equals(other._defenseQueue, _defenseQueue)&&(identical(other.speakerId, speakerId) || other.speakerId == speakerId)&&(identical(other.lastDoctorTargetId, lastDoctorTargetId) || other.lastDoctorTargetId == lastDoctorTargetId)&&const DeepCollectionEquality().equals(other._pendingActions, _pendingActions)&&const DeepCollectionEquality().equals(other._publicEventLog, _publicEventLog)&&const DeepCollectionEquality().equals(other._detailedLog, _detailedLog)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.statusMessage, statusMessage) || other.statusMessage == statusMessage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,phase,currentMoveIndex,currentMoveId,const DeepCollectionEquality().hash(_players),config,isPaused,timerSecondsRemaining,currentNightNumber,currentDayNumber,const DeepCollectionEquality().hash(_currentVotes),const DeepCollectionEquality().hash(_currentVerdicts),verdictTargetId,const DeepCollectionEquality().hash(_defenseQueue),speakerId,lastDoctorTargetId,const DeepCollectionEquality().hash(_pendingActions),const DeepCollectionEquality().hash(_publicEventLog),const DeepCollectionEquality().hash(_detailedLog),sessionId,statusMessage]);

@override
String toString() {
  return 'GameState(phase: $phase, currentMoveIndex: $currentMoveIndex, currentMoveId: $currentMoveId, players: $players, config: $config, isPaused: $isPaused, timerSecondsRemaining: $timerSecondsRemaining, currentNightNumber: $currentNightNumber, currentDayNumber: $currentDayNumber, currentVotes: $currentVotes, currentVerdicts: $currentVerdicts, verdictTargetId: $verdictTargetId, defenseQueue: $defenseQueue, speakerId: $speakerId, lastDoctorTargetId: $lastDoctorTargetId, pendingActions: $pendingActions, publicEventLog: $publicEventLog, detailedLog: $detailedLog, sessionId: $sessionId, statusMessage: $statusMessage)';
}


}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
@GamePhaseConverter() GamePhase phase, int currentMoveIndex, String? currentMoveId, List<Player> players, GameConfig config, bool isPaused, int? timerSecondsRemaining, int? currentNightNumber, int? currentDayNumber, Map<String, String>? currentVotes, Map<String, bool>? currentVerdicts, String? verdictTargetId, List<String> defenseQueue, String? speakerId, String? lastDoctorTargetId, List<PlayerAction> pendingActions, List<String> publicEventLog, List<String> detailedLog, String? sessionId, String? statusMessage
});


@override $GameConfigCopyWith<$Res> get config;

}
/// @nodoc
class __$GameStateCopyWithImpl<$Res>
    implements _$GameStateCopyWith<$Res> {
  __$GameStateCopyWithImpl(this._self, this._then);

  final _GameState _self;
  final $Res Function(_GameState) _then;

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? currentMoveIndex = null,Object? currentMoveId = freezed,Object? players = null,Object? config = null,Object? isPaused = null,Object? timerSecondsRemaining = freezed,Object? currentNightNumber = freezed,Object? currentDayNumber = freezed,Object? currentVotes = freezed,Object? currentVerdicts = freezed,Object? verdictTargetId = freezed,Object? defenseQueue = null,Object? speakerId = freezed,Object? lastDoctorTargetId = freezed,Object? pendingActions = null,Object? publicEventLog = null,Object? detailedLog = null,Object? sessionId = freezed,Object? statusMessage = freezed,}) {
  return _then(_GameState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as GamePhase,currentMoveIndex: null == currentMoveIndex ? _self.currentMoveIndex : currentMoveIndex // ignore: cast_nullable_to_non_nullable
as int,currentMoveId: freezed == currentMoveId ? _self.currentMoveId : currentMoveId // ignore: cast_nullable_to_non_nullable
as String?,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as GameConfig,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,timerSecondsRemaining: freezed == timerSecondsRemaining ? _self.timerSecondsRemaining : timerSecondsRemaining // ignore: cast_nullable_to_non_nullable
as int?,currentNightNumber: freezed == currentNightNumber ? _self.currentNightNumber : currentNightNumber // ignore: cast_nullable_to_non_nullable
as int?,currentDayNumber: freezed == currentDayNumber ? _self.currentDayNumber : currentDayNumber // ignore: cast_nullable_to_non_nullable
as int?,currentVotes: freezed == currentVotes ? _self._currentVotes : currentVotes // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,currentVerdicts: freezed == currentVerdicts ? _self._currentVerdicts : currentVerdicts // ignore: cast_nullable_to_non_nullable
as Map<String, bool>?,verdictTargetId: freezed == verdictTargetId ? _self.verdictTargetId : verdictTargetId // ignore: cast_nullable_to_non_nullable
as String?,defenseQueue: null == defenseQueue ? _self._defenseQueue : defenseQueue // ignore: cast_nullable_to_non_nullable
as List<String>,speakerId: freezed == speakerId ? _self.speakerId : speakerId // ignore: cast_nullable_to_non_nullable
as String?,lastDoctorTargetId: freezed == lastDoctorTargetId ? _self.lastDoctorTargetId : lastDoctorTargetId // ignore: cast_nullable_to_non_nullable
as String?,pendingActions: null == pendingActions ? _self._pendingActions : pendingActions // ignore: cast_nullable_to_non_nullable
as List<PlayerAction>,publicEventLog: null == publicEventLog ? _self._publicEventLog : publicEventLog // ignore: cast_nullable_to_non_nullable
as List<String>,detailedLog: null == detailedLog ? _self._detailedLog : detailedLog // ignore: cast_nullable_to_non_nullable
as List<String>,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,statusMessage: freezed == statusMessage ? _self.statusMessage : statusMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GameConfigCopyWith<$Res> get config {
  
  return $GameConfigCopyWith<$Res>(_self.config, (value) {
    return _then(_self.copyWith(config: value));
  });
}
}

// dart format on
