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

 GamePhase get phase; List<Player> get players; GameConfig get config; bool get isPaused; int? get timerSecondsRemaining; int? get currentNightNumber; int? get currentDayNumber; Map<String, String>? get currentVotes;// performerId -> targetId
 List<PlayerAction> get pendingActions; List<String> get publicEventLog; List<String> get detailedLog;
/// Create a copy of GameState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameStateCopyWith<GameState> get copyWith => _$GameStateCopyWithImpl<GameState>(this as GameState, _$identity);

  /// Serializes this GameState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameState&&(identical(other.phase, phase) || other.phase == phase)&&const DeepCollectionEquality().equals(other.players, players)&&(identical(other.config, config) || other.config == config)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.timerSecondsRemaining, timerSecondsRemaining) || other.timerSecondsRemaining == timerSecondsRemaining)&&(identical(other.currentNightNumber, currentNightNumber) || other.currentNightNumber == currentNightNumber)&&(identical(other.currentDayNumber, currentDayNumber) || other.currentDayNumber == currentDayNumber)&&const DeepCollectionEquality().equals(other.currentVotes, currentVotes)&&const DeepCollectionEquality().equals(other.pendingActions, pendingActions)&&const DeepCollectionEquality().equals(other.publicEventLog, publicEventLog)&&const DeepCollectionEquality().equals(other.detailedLog, detailedLog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phase,const DeepCollectionEquality().hash(players),config,isPaused,timerSecondsRemaining,currentNightNumber,currentDayNumber,const DeepCollectionEquality().hash(currentVotes),const DeepCollectionEquality().hash(pendingActions),const DeepCollectionEquality().hash(publicEventLog),const DeepCollectionEquality().hash(detailedLog));

@override
String toString() {
  return 'GameState(phase: $phase, players: $players, config: $config, isPaused: $isPaused, timerSecondsRemaining: $timerSecondsRemaining, currentNightNumber: $currentNightNumber, currentDayNumber: $currentDayNumber, currentVotes: $currentVotes, pendingActions: $pendingActions, publicEventLog: $publicEventLog, detailedLog: $detailedLog)';
}


}

/// @nodoc
abstract mixin class $GameStateCopyWith<$Res>  {
  factory $GameStateCopyWith(GameState value, $Res Function(GameState) _then) = _$GameStateCopyWithImpl;
@useResult
$Res call({
 GamePhase phase, List<Player> players, GameConfig config, bool isPaused, int? timerSecondsRemaining, int? currentNightNumber, int? currentDayNumber, Map<String, String>? currentVotes, List<PlayerAction> pendingActions, List<String> publicEventLog, List<String> detailedLog
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
@pragma('vm:prefer-inline') @override $Res call({Object? phase = null,Object? players = null,Object? config = null,Object? isPaused = null,Object? timerSecondsRemaining = freezed,Object? currentNightNumber = freezed,Object? currentDayNumber = freezed,Object? currentVotes = freezed,Object? pendingActions = null,Object? publicEventLog = null,Object? detailedLog = null,}) {
  return _then(_self.copyWith(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as GamePhase,players: null == players ? _self.players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as GameConfig,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,timerSecondsRemaining: freezed == timerSecondsRemaining ? _self.timerSecondsRemaining : timerSecondsRemaining // ignore: cast_nullable_to_non_nullable
as int?,currentNightNumber: freezed == currentNightNumber ? _self.currentNightNumber : currentNightNumber // ignore: cast_nullable_to_non_nullable
as int?,currentDayNumber: freezed == currentDayNumber ? _self.currentDayNumber : currentDayNumber // ignore: cast_nullable_to_non_nullable
as int?,currentVotes: freezed == currentVotes ? _self.currentVotes : currentVotes // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,pendingActions: null == pendingActions ? _self.pendingActions : pendingActions // ignore: cast_nullable_to_non_nullable
as List<PlayerAction>,publicEventLog: null == publicEventLog ? _self.publicEventLog : publicEventLog // ignore: cast_nullable_to_non_nullable
as List<String>,detailedLog: null == detailedLog ? _self.detailedLog : detailedLog // ignore: cast_nullable_to_non_nullable
as List<String>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GamePhase phase,  List<Player> players,  GameConfig config,  bool isPaused,  int? timerSecondsRemaining,  int? currentNightNumber,  int? currentDayNumber,  Map<String, String>? currentVotes,  List<PlayerAction> pendingActions,  List<String> publicEventLog,  List<String> detailedLog)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.phase,_that.players,_that.config,_that.isPaused,_that.timerSecondsRemaining,_that.currentNightNumber,_that.currentDayNumber,_that.currentVotes,_that.pendingActions,_that.publicEventLog,_that.detailedLog);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GamePhase phase,  List<Player> players,  GameConfig config,  bool isPaused,  int? timerSecondsRemaining,  int? currentNightNumber,  int? currentDayNumber,  Map<String, String>? currentVotes,  List<PlayerAction> pendingActions,  List<String> publicEventLog,  List<String> detailedLog)  $default,) {final _that = this;
switch (_that) {
case _GameState():
return $default(_that.phase,_that.players,_that.config,_that.isPaused,_that.timerSecondsRemaining,_that.currentNightNumber,_that.currentDayNumber,_that.currentVotes,_that.pendingActions,_that.publicEventLog,_that.detailedLog);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GamePhase phase,  List<Player> players,  GameConfig config,  bool isPaused,  int? timerSecondsRemaining,  int? currentNightNumber,  int? currentDayNumber,  Map<String, String>? currentVotes,  List<PlayerAction> pendingActions,  List<String> publicEventLog,  List<String> detailedLog)?  $default,) {final _that = this;
switch (_that) {
case _GameState() when $default != null:
return $default(_that.phase,_that.players,_that.config,_that.isPaused,_that.timerSecondsRemaining,_that.currentNightNumber,_that.currentDayNumber,_that.currentVotes,_that.pendingActions,_that.publicEventLog,_that.detailedLog);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameState implements GameState {
  const _GameState({required this.phase, required final  List<Player> players, required this.config, this.isPaused = false, this.timerSecondsRemaining, this.currentNightNumber, this.currentDayNumber, final  Map<String, String>? currentVotes, final  List<PlayerAction> pendingActions = const [], final  List<String> publicEventLog = const [], final  List<String> detailedLog = const []}): _players = players,_currentVotes = currentVotes,_pendingActions = pendingActions,_publicEventLog = publicEventLog,_detailedLog = detailedLog;
  factory _GameState.fromJson(Map<String, dynamic> json) => _$GameStateFromJson(json);

@override final  GamePhase phase;
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
 final  List<PlayerAction> _pendingActions;
// performerId -> targetId
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameState&&(identical(other.phase, phase) || other.phase == phase)&&const DeepCollectionEquality().equals(other._players, _players)&&(identical(other.config, config) || other.config == config)&&(identical(other.isPaused, isPaused) || other.isPaused == isPaused)&&(identical(other.timerSecondsRemaining, timerSecondsRemaining) || other.timerSecondsRemaining == timerSecondsRemaining)&&(identical(other.currentNightNumber, currentNightNumber) || other.currentNightNumber == currentNightNumber)&&(identical(other.currentDayNumber, currentDayNumber) || other.currentDayNumber == currentDayNumber)&&const DeepCollectionEquality().equals(other._currentVotes, _currentVotes)&&const DeepCollectionEquality().equals(other._pendingActions, _pendingActions)&&const DeepCollectionEquality().equals(other._publicEventLog, _publicEventLog)&&const DeepCollectionEquality().equals(other._detailedLog, _detailedLog));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,phase,const DeepCollectionEquality().hash(_players),config,isPaused,timerSecondsRemaining,currentNightNumber,currentDayNumber,const DeepCollectionEquality().hash(_currentVotes),const DeepCollectionEquality().hash(_pendingActions),const DeepCollectionEquality().hash(_publicEventLog),const DeepCollectionEquality().hash(_detailedLog));

@override
String toString() {
  return 'GameState(phase: $phase, players: $players, config: $config, isPaused: $isPaused, timerSecondsRemaining: $timerSecondsRemaining, currentNightNumber: $currentNightNumber, currentDayNumber: $currentDayNumber, currentVotes: $currentVotes, pendingActions: $pendingActions, publicEventLog: $publicEventLog, detailedLog: $detailedLog)';
}


}

/// @nodoc
abstract mixin class _$GameStateCopyWith<$Res> implements $GameStateCopyWith<$Res> {
  factory _$GameStateCopyWith(_GameState value, $Res Function(_GameState) _then) = __$GameStateCopyWithImpl;
@override @useResult
$Res call({
 GamePhase phase, List<Player> players, GameConfig config, bool isPaused, int? timerSecondsRemaining, int? currentNightNumber, int? currentDayNumber, Map<String, String>? currentVotes, List<PlayerAction> pendingActions, List<String> publicEventLog, List<String> detailedLog
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
@override @pragma('vm:prefer-inline') $Res call({Object? phase = null,Object? players = null,Object? config = null,Object? isPaused = null,Object? timerSecondsRemaining = freezed,Object? currentNightNumber = freezed,Object? currentDayNumber = freezed,Object? currentVotes = freezed,Object? pendingActions = null,Object? publicEventLog = null,Object? detailedLog = null,}) {
  return _then(_GameState(
phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as GamePhase,players: null == players ? _self._players : players // ignore: cast_nullable_to_non_nullable
as List<Player>,config: null == config ? _self.config : config // ignore: cast_nullable_to_non_nullable
as GameConfig,isPaused: null == isPaused ? _self.isPaused : isPaused // ignore: cast_nullable_to_non_nullable
as bool,timerSecondsRemaining: freezed == timerSecondsRemaining ? _self.timerSecondsRemaining : timerSecondsRemaining // ignore: cast_nullable_to_non_nullable
as int?,currentNightNumber: freezed == currentNightNumber ? _self.currentNightNumber : currentNightNumber // ignore: cast_nullable_to_non_nullable
as int?,currentDayNumber: freezed == currentDayNumber ? _self.currentDayNumber : currentDayNumber // ignore: cast_nullable_to_non_nullable
as int?,currentVotes: freezed == currentVotes ? _self._currentVotes : currentVotes // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,pendingActions: null == pendingActions ? _self._pendingActions : pendingActions // ignore: cast_nullable_to_non_nullable
as List<PlayerAction>,publicEventLog: null == publicEventLog ? _self._publicEventLog : publicEventLog // ignore: cast_nullable_to_non_nullable
as List<String>,detailedLog: null == detailedLog ? _self._detailedLog : detailedLog // ignore: cast_nullable_to_non_nullable
as List<String>,
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
