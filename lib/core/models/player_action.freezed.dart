// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_action.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerAction {

 String get type; String get performerId; String? get targetId; String? get value;
/// Create a copy of PlayerAction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PlayerActionCopyWith<PlayerAction> get copyWith => _$PlayerActionCopyWithImpl<PlayerAction>(this as PlayerAction, _$identity);

  /// Serializes this PlayerAction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PlayerAction&&(identical(other.type, type) || other.type == type)&&(identical(other.performerId, performerId) || other.performerId == performerId)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,performerId,targetId,value);

@override
String toString() {
  return 'PlayerAction(type: $type, performerId: $performerId, targetId: $targetId, value: $value)';
}


}

/// @nodoc
abstract mixin class $PlayerActionCopyWith<$Res>  {
  factory $PlayerActionCopyWith(PlayerAction value, $Res Function(PlayerAction) _then) = _$PlayerActionCopyWithImpl;
@useResult
$Res call({
 String type, String performerId, String? targetId, String? value
});




}
/// @nodoc
class _$PlayerActionCopyWithImpl<$Res>
    implements $PlayerActionCopyWith<$Res> {
  _$PlayerActionCopyWithImpl(this._self, this._then);

  final PlayerAction _self;
  final $Res Function(PlayerAction) _then;

/// Create a copy of PlayerAction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? type = null,Object? performerId = null,Object? targetId = freezed,Object? value = freezed,}) {
  return _then(_self.copyWith(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,performerId: null == performerId ? _self.performerId : performerId // ignore: cast_nullable_to_non_nullable
as String,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PlayerAction].
extension PlayerActionPatterns on PlayerAction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PlayerAction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PlayerAction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PlayerAction value)  $default,){
final _that = this;
switch (_that) {
case _PlayerAction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PlayerAction value)?  $default,){
final _that = this;
switch (_that) {
case _PlayerAction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String type,  String performerId,  String? targetId,  String? value)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PlayerAction() when $default != null:
return $default(_that.type,_that.performerId,_that.targetId,_that.value);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String type,  String performerId,  String? targetId,  String? value)  $default,) {final _that = this;
switch (_that) {
case _PlayerAction():
return $default(_that.type,_that.performerId,_that.targetId,_that.value);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String type,  String performerId,  String? targetId,  String? value)?  $default,) {final _that = this;
switch (_that) {
case _PlayerAction() when $default != null:
return $default(_that.type,_that.performerId,_that.targetId,_that.value);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PlayerAction implements PlayerAction {
  const _PlayerAction({required this.type, required this.performerId, this.targetId, this.value});
  factory _PlayerAction.fromJson(Map<String, dynamic> json) => _$PlayerActionFromJson(json);

@override final  String type;
@override final  String performerId;
@override final  String? targetId;
@override final  String? value;

/// Create a copy of PlayerAction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PlayerActionCopyWith<_PlayerAction> get copyWith => __$PlayerActionCopyWithImpl<_PlayerAction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PlayerActionToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PlayerAction&&(identical(other.type, type) || other.type == type)&&(identical(other.performerId, performerId) || other.performerId == performerId)&&(identical(other.targetId, targetId) || other.targetId == targetId)&&(identical(other.value, value) || other.value == value));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,type,performerId,targetId,value);

@override
String toString() {
  return 'PlayerAction(type: $type, performerId: $performerId, targetId: $targetId, value: $value)';
}


}

/// @nodoc
abstract mixin class _$PlayerActionCopyWith<$Res> implements $PlayerActionCopyWith<$Res> {
  factory _$PlayerActionCopyWith(_PlayerAction value, $Res Function(_PlayerAction) _then) = __$PlayerActionCopyWithImpl;
@override @useResult
$Res call({
 String type, String performerId, String? targetId, String? value
});




}
/// @nodoc
class __$PlayerActionCopyWithImpl<$Res>
    implements _$PlayerActionCopyWith<$Res> {
  __$PlayerActionCopyWithImpl(this._self, this._then);

  final _PlayerAction _self;
  final $Res Function(_PlayerAction) _then;

/// Create a copy of PlayerAction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? type = null,Object? performerId = null,Object? targetId = freezed,Object? value = freezed,}) {
  return _then(_PlayerAction(
type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String,performerId: null == performerId ? _self.performerId : performerId // ignore: cast_nullable_to_non_nullable
as String,targetId: freezed == targetId ? _self.targetId : targetId // ignore: cast_nullable_to_non_nullable
as String?,value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc
mixin _$WinResult {

 Faction get faction; String get message;
/// Create a copy of WinResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WinResultCopyWith<WinResult> get copyWith => _$WinResultCopyWithImpl<WinResult>(this as WinResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WinResult&&(identical(other.faction, faction) || other.faction == faction)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,faction,message);

@override
String toString() {
  return 'WinResult(faction: $faction, message: $message)';
}


}

/// @nodoc
abstract mixin class $WinResultCopyWith<$Res>  {
  factory $WinResultCopyWith(WinResult value, $Res Function(WinResult) _then) = _$WinResultCopyWithImpl;
@useResult
$Res call({
 Faction faction, String message
});




}
/// @nodoc
class _$WinResultCopyWithImpl<$Res>
    implements $WinResultCopyWith<$Res> {
  _$WinResultCopyWithImpl(this._self, this._then);

  final WinResult _self;
  final $Res Function(WinResult) _then;

/// Create a copy of WinResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? faction = null,Object? message = null,}) {
  return _then(_self.copyWith(
faction: null == faction ? _self.faction : faction // ignore: cast_nullable_to_non_nullable
as Faction,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [WinResult].
extension WinResultPatterns on WinResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WinResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WinResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WinResult value)  $default,){
final _that = this;
switch (_that) {
case _WinResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WinResult value)?  $default,){
final _that = this;
switch (_that) {
case _WinResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Faction faction,  String message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WinResult() when $default != null:
return $default(_that.faction,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Faction faction,  String message)  $default,) {final _that = this;
switch (_that) {
case _WinResult():
return $default(_that.faction,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Faction faction,  String message)?  $default,) {final _that = this;
switch (_that) {
case _WinResult() when $default != null:
return $default(_that.faction,_that.message);case _:
  return null;

}
}

}

/// @nodoc


class _WinResult extends WinResult {
  const _WinResult({required this.faction, required this.message}): super._();
  

@override final  Faction faction;
@override final  String message;

/// Create a copy of WinResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WinResultCopyWith<_WinResult> get copyWith => __$WinResultCopyWithImpl<_WinResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WinResult&&(identical(other.faction, faction) || other.faction == faction)&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,faction,message);

@override
String toString() {
  return 'WinResult(faction: $faction, message: $message)';
}


}

/// @nodoc
abstract mixin class _$WinResultCopyWith<$Res> implements $WinResultCopyWith<$Res> {
  factory _$WinResultCopyWith(_WinResult value, $Res Function(_WinResult) _then) = __$WinResultCopyWithImpl;
@override @useResult
$Res call({
 Faction faction, String message
});




}
/// @nodoc
class __$WinResultCopyWithImpl<$Res>
    implements _$WinResultCopyWith<$Res> {
  __$WinResultCopyWithImpl(this._self, this._then);

  final _WinResult _self;
  final $Res Function(_WinResult) _then;

/// Create a copy of WinResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? faction = null,Object? message = null,}) {
  return _then(_WinResult(
faction: null == faction ? _self.faction : faction // ignore: cast_nullable_to_non_nullable
as Faction,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
