// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'game_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GameConfig {

 String get themeId; bool get autoPruningEnabled; bool get donMechanicsEnabled; bool get commissarEnabled; bool get doctorEnabled; bool get prostituteEnabled; bool get maniacEnabled; bool get commissarKills; bool get sergeantEnabled; bool get lawyerEnabled; bool get poisonerEnabled; bool get doctorCanHealSelf; bool get doctorCanHealSameTargetConsecutively; String get locale;// Timer durations in seconds
 int get discussionTime; int get votingTime; int get defenseTime; int get mafiaActionTime; int get otherActionTime;// Role distribution (null = auto-balance)
 int? get mafiaCount; int? get commissarCount; int? get doctorCount;
/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GameConfigCopyWith<GameConfig> get copyWith => _$GameConfigCopyWithImpl<GameConfig>(this as GameConfig, _$identity);

  /// Serializes this GameConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GameConfig&&(identical(other.themeId, themeId) || other.themeId == themeId)&&(identical(other.autoPruningEnabled, autoPruningEnabled) || other.autoPruningEnabled == autoPruningEnabled)&&(identical(other.donMechanicsEnabled, donMechanicsEnabled) || other.donMechanicsEnabled == donMechanicsEnabled)&&(identical(other.commissarEnabled, commissarEnabled) || other.commissarEnabled == commissarEnabled)&&(identical(other.doctorEnabled, doctorEnabled) || other.doctorEnabled == doctorEnabled)&&(identical(other.prostituteEnabled, prostituteEnabled) || other.prostituteEnabled == prostituteEnabled)&&(identical(other.maniacEnabled, maniacEnabled) || other.maniacEnabled == maniacEnabled)&&(identical(other.commissarKills, commissarKills) || other.commissarKills == commissarKills)&&(identical(other.sergeantEnabled, sergeantEnabled) || other.sergeantEnabled == sergeantEnabled)&&(identical(other.lawyerEnabled, lawyerEnabled) || other.lawyerEnabled == lawyerEnabled)&&(identical(other.poisonerEnabled, poisonerEnabled) || other.poisonerEnabled == poisonerEnabled)&&(identical(other.doctorCanHealSelf, doctorCanHealSelf) || other.doctorCanHealSelf == doctorCanHealSelf)&&(identical(other.doctorCanHealSameTargetConsecutively, doctorCanHealSameTargetConsecutively) || other.doctorCanHealSameTargetConsecutively == doctorCanHealSameTargetConsecutively)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.discussionTime, discussionTime) || other.discussionTime == discussionTime)&&(identical(other.votingTime, votingTime) || other.votingTime == votingTime)&&(identical(other.defenseTime, defenseTime) || other.defenseTime == defenseTime)&&(identical(other.mafiaActionTime, mafiaActionTime) || other.mafiaActionTime == mafiaActionTime)&&(identical(other.otherActionTime, otherActionTime) || other.otherActionTime == otherActionTime)&&(identical(other.mafiaCount, mafiaCount) || other.mafiaCount == mafiaCount)&&(identical(other.commissarCount, commissarCount) || other.commissarCount == commissarCount)&&(identical(other.doctorCount, doctorCount) || other.doctorCount == doctorCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,themeId,autoPruningEnabled,donMechanicsEnabled,commissarEnabled,doctorEnabled,prostituteEnabled,maniacEnabled,commissarKills,sergeantEnabled,lawyerEnabled,poisonerEnabled,doctorCanHealSelf,doctorCanHealSameTargetConsecutively,locale,discussionTime,votingTime,defenseTime,mafiaActionTime,otherActionTime,mafiaCount,commissarCount,doctorCount]);

@override
String toString() {
  return 'GameConfig(themeId: $themeId, autoPruningEnabled: $autoPruningEnabled, donMechanicsEnabled: $donMechanicsEnabled, commissarEnabled: $commissarEnabled, doctorEnabled: $doctorEnabled, prostituteEnabled: $prostituteEnabled, maniacEnabled: $maniacEnabled, commissarKills: $commissarKills, sergeantEnabled: $sergeantEnabled, lawyerEnabled: $lawyerEnabled, poisonerEnabled: $poisonerEnabled, doctorCanHealSelf: $doctorCanHealSelf, doctorCanHealSameTargetConsecutively: $doctorCanHealSameTargetConsecutively, locale: $locale, discussionTime: $discussionTime, votingTime: $votingTime, defenseTime: $defenseTime, mafiaActionTime: $mafiaActionTime, otherActionTime: $otherActionTime, mafiaCount: $mafiaCount, commissarCount: $commissarCount, doctorCount: $doctorCount)';
}


}

/// @nodoc
abstract mixin class $GameConfigCopyWith<$Res>  {
  factory $GameConfigCopyWith(GameConfig value, $Res Function(GameConfig) _then) = _$GameConfigCopyWithImpl;
@useResult
$Res call({
 String themeId, bool autoPruningEnabled, bool donMechanicsEnabled, bool commissarEnabled, bool doctorEnabled, bool prostituteEnabled, bool maniacEnabled, bool commissarKills, bool sergeantEnabled, bool lawyerEnabled, bool poisonerEnabled, bool doctorCanHealSelf, bool doctorCanHealSameTargetConsecutively, String locale, int discussionTime, int votingTime, int defenseTime, int mafiaActionTime, int otherActionTime, int? mafiaCount, int? commissarCount, int? doctorCount
});




}
/// @nodoc
class _$GameConfigCopyWithImpl<$Res>
    implements $GameConfigCopyWith<$Res> {
  _$GameConfigCopyWithImpl(this._self, this._then);

  final GameConfig _self;
  final $Res Function(GameConfig) _then;

/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeId = null,Object? autoPruningEnabled = null,Object? donMechanicsEnabled = null,Object? commissarEnabled = null,Object? doctorEnabled = null,Object? prostituteEnabled = null,Object? maniacEnabled = null,Object? commissarKills = null,Object? sergeantEnabled = null,Object? lawyerEnabled = null,Object? poisonerEnabled = null,Object? doctorCanHealSelf = null,Object? doctorCanHealSameTargetConsecutively = null,Object? locale = null,Object? discussionTime = null,Object? votingTime = null,Object? defenseTime = null,Object? mafiaActionTime = null,Object? otherActionTime = null,Object? mafiaCount = freezed,Object? commissarCount = freezed,Object? doctorCount = freezed,}) {
  return _then(_self.copyWith(
themeId: null == themeId ? _self.themeId : themeId // ignore: cast_nullable_to_non_nullable
as String,autoPruningEnabled: null == autoPruningEnabled ? _self.autoPruningEnabled : autoPruningEnabled // ignore: cast_nullable_to_non_nullable
as bool,donMechanicsEnabled: null == donMechanicsEnabled ? _self.donMechanicsEnabled : donMechanicsEnabled // ignore: cast_nullable_to_non_nullable
as bool,commissarEnabled: null == commissarEnabled ? _self.commissarEnabled : commissarEnabled // ignore: cast_nullable_to_non_nullable
as bool,doctorEnabled: null == doctorEnabled ? _self.doctorEnabled : doctorEnabled // ignore: cast_nullable_to_non_nullable
as bool,prostituteEnabled: null == prostituteEnabled ? _self.prostituteEnabled : prostituteEnabled // ignore: cast_nullable_to_non_nullable
as bool,maniacEnabled: null == maniacEnabled ? _self.maniacEnabled : maniacEnabled // ignore: cast_nullable_to_non_nullable
as bool,commissarKills: null == commissarKills ? _self.commissarKills : commissarKills // ignore: cast_nullable_to_non_nullable
as bool,sergeantEnabled: null == sergeantEnabled ? _self.sergeantEnabled : sergeantEnabled // ignore: cast_nullable_to_non_nullable
as bool,lawyerEnabled: null == lawyerEnabled ? _self.lawyerEnabled : lawyerEnabled // ignore: cast_nullable_to_non_nullable
as bool,poisonerEnabled: null == poisonerEnabled ? _self.poisonerEnabled : poisonerEnabled // ignore: cast_nullable_to_non_nullable
as bool,doctorCanHealSelf: null == doctorCanHealSelf ? _self.doctorCanHealSelf : doctorCanHealSelf // ignore: cast_nullable_to_non_nullable
as bool,doctorCanHealSameTargetConsecutively: null == doctorCanHealSameTargetConsecutively ? _self.doctorCanHealSameTargetConsecutively : doctorCanHealSameTargetConsecutively // ignore: cast_nullable_to_non_nullable
as bool,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,discussionTime: null == discussionTime ? _self.discussionTime : discussionTime // ignore: cast_nullable_to_non_nullable
as int,votingTime: null == votingTime ? _self.votingTime : votingTime // ignore: cast_nullable_to_non_nullable
as int,defenseTime: null == defenseTime ? _self.defenseTime : defenseTime // ignore: cast_nullable_to_non_nullable
as int,mafiaActionTime: null == mafiaActionTime ? _self.mafiaActionTime : mafiaActionTime // ignore: cast_nullable_to_non_nullable
as int,otherActionTime: null == otherActionTime ? _self.otherActionTime : otherActionTime // ignore: cast_nullable_to_non_nullable
as int,mafiaCount: freezed == mafiaCount ? _self.mafiaCount : mafiaCount // ignore: cast_nullable_to_non_nullable
as int?,commissarCount: freezed == commissarCount ? _self.commissarCount : commissarCount // ignore: cast_nullable_to_non_nullable
as int?,doctorCount: freezed == doctorCount ? _self.doctorCount : doctorCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [GameConfig].
extension GameConfigPatterns on GameConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GameConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GameConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GameConfig value)  $default,){
final _that = this;
switch (_that) {
case _GameConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GameConfig value)?  $default,){
final _that = this;
switch (_that) {
case _GameConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String themeId,  bool autoPruningEnabled,  bool donMechanicsEnabled,  bool commissarEnabled,  bool doctorEnabled,  bool prostituteEnabled,  bool maniacEnabled,  bool commissarKills,  bool sergeantEnabled,  bool lawyerEnabled,  bool poisonerEnabled,  bool doctorCanHealSelf,  bool doctorCanHealSameTargetConsecutively,  String locale,  int discussionTime,  int votingTime,  int defenseTime,  int mafiaActionTime,  int otherActionTime,  int? mafiaCount,  int? commissarCount,  int? doctorCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GameConfig() when $default != null:
return $default(_that.themeId,_that.autoPruningEnabled,_that.donMechanicsEnabled,_that.commissarEnabled,_that.doctorEnabled,_that.prostituteEnabled,_that.maniacEnabled,_that.commissarKills,_that.sergeantEnabled,_that.lawyerEnabled,_that.poisonerEnabled,_that.doctorCanHealSelf,_that.doctorCanHealSameTargetConsecutively,_that.locale,_that.discussionTime,_that.votingTime,_that.defenseTime,_that.mafiaActionTime,_that.otherActionTime,_that.mafiaCount,_that.commissarCount,_that.doctorCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String themeId,  bool autoPruningEnabled,  bool donMechanicsEnabled,  bool commissarEnabled,  bool doctorEnabled,  bool prostituteEnabled,  bool maniacEnabled,  bool commissarKills,  bool sergeantEnabled,  bool lawyerEnabled,  bool poisonerEnabled,  bool doctorCanHealSelf,  bool doctorCanHealSameTargetConsecutively,  String locale,  int discussionTime,  int votingTime,  int defenseTime,  int mafiaActionTime,  int otherActionTime,  int? mafiaCount,  int? commissarCount,  int? doctorCount)  $default,) {final _that = this;
switch (_that) {
case _GameConfig():
return $default(_that.themeId,_that.autoPruningEnabled,_that.donMechanicsEnabled,_that.commissarEnabled,_that.doctorEnabled,_that.prostituteEnabled,_that.maniacEnabled,_that.commissarKills,_that.sergeantEnabled,_that.lawyerEnabled,_that.poisonerEnabled,_that.doctorCanHealSelf,_that.doctorCanHealSameTargetConsecutively,_that.locale,_that.discussionTime,_that.votingTime,_that.defenseTime,_that.mafiaActionTime,_that.otherActionTime,_that.mafiaCount,_that.commissarCount,_that.doctorCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String themeId,  bool autoPruningEnabled,  bool donMechanicsEnabled,  bool commissarEnabled,  bool doctorEnabled,  bool prostituteEnabled,  bool maniacEnabled,  bool commissarKills,  bool sergeantEnabled,  bool lawyerEnabled,  bool poisonerEnabled,  bool doctorCanHealSelf,  bool doctorCanHealSameTargetConsecutively,  String locale,  int discussionTime,  int votingTime,  int defenseTime,  int mafiaActionTime,  int otherActionTime,  int? mafiaCount,  int? commissarCount,  int? doctorCount)?  $default,) {final _that = this;
switch (_that) {
case _GameConfig() when $default != null:
return $default(_that.themeId,_that.autoPruningEnabled,_that.donMechanicsEnabled,_that.commissarEnabled,_that.doctorEnabled,_that.prostituteEnabled,_that.maniacEnabled,_that.commissarKills,_that.sergeantEnabled,_that.lawyerEnabled,_that.poisonerEnabled,_that.doctorCanHealSelf,_that.doctorCanHealSameTargetConsecutively,_that.locale,_that.discussionTime,_that.votingTime,_that.defenseTime,_that.mafiaActionTime,_that.otherActionTime,_that.mafiaCount,_that.commissarCount,_that.doctorCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GameConfig implements GameConfig {
  const _GameConfig({required this.themeId, this.autoPruningEnabled = true, this.donMechanicsEnabled = false, this.commissarEnabled = true, this.doctorEnabled = true, this.prostituteEnabled = false, this.maniacEnabled = false, this.commissarKills = false, this.sergeantEnabled = false, this.lawyerEnabled = false, this.poisonerEnabled = false, this.doctorCanHealSelf = true, this.doctorCanHealSameTargetConsecutively = false, this.locale = 'en', this.discussionTime = 120, this.votingTime = 60, this.defenseTime = 60, this.mafiaActionTime = 90, this.otherActionTime = 60, this.mafiaCount, this.commissarCount, this.doctorCount});
  factory _GameConfig.fromJson(Map<String, dynamic> json) => _$GameConfigFromJson(json);

@override final  String themeId;
@override@JsonKey() final  bool autoPruningEnabled;
@override@JsonKey() final  bool donMechanicsEnabled;
@override@JsonKey() final  bool commissarEnabled;
@override@JsonKey() final  bool doctorEnabled;
@override@JsonKey() final  bool prostituteEnabled;
@override@JsonKey() final  bool maniacEnabled;
@override@JsonKey() final  bool commissarKills;
@override@JsonKey() final  bool sergeantEnabled;
@override@JsonKey() final  bool lawyerEnabled;
@override@JsonKey() final  bool poisonerEnabled;
@override@JsonKey() final  bool doctorCanHealSelf;
@override@JsonKey() final  bool doctorCanHealSameTargetConsecutively;
@override@JsonKey() final  String locale;
// Timer durations in seconds
@override@JsonKey() final  int discussionTime;
@override@JsonKey() final  int votingTime;
@override@JsonKey() final  int defenseTime;
@override@JsonKey() final  int mafiaActionTime;
@override@JsonKey() final  int otherActionTime;
// Role distribution (null = auto-balance)
@override final  int? mafiaCount;
@override final  int? commissarCount;
@override final  int? doctorCount;

/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GameConfigCopyWith<_GameConfig> get copyWith => __$GameConfigCopyWithImpl<_GameConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GameConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GameConfig&&(identical(other.themeId, themeId) || other.themeId == themeId)&&(identical(other.autoPruningEnabled, autoPruningEnabled) || other.autoPruningEnabled == autoPruningEnabled)&&(identical(other.donMechanicsEnabled, donMechanicsEnabled) || other.donMechanicsEnabled == donMechanicsEnabled)&&(identical(other.commissarEnabled, commissarEnabled) || other.commissarEnabled == commissarEnabled)&&(identical(other.doctorEnabled, doctorEnabled) || other.doctorEnabled == doctorEnabled)&&(identical(other.prostituteEnabled, prostituteEnabled) || other.prostituteEnabled == prostituteEnabled)&&(identical(other.maniacEnabled, maniacEnabled) || other.maniacEnabled == maniacEnabled)&&(identical(other.commissarKills, commissarKills) || other.commissarKills == commissarKills)&&(identical(other.sergeantEnabled, sergeantEnabled) || other.sergeantEnabled == sergeantEnabled)&&(identical(other.lawyerEnabled, lawyerEnabled) || other.lawyerEnabled == lawyerEnabled)&&(identical(other.poisonerEnabled, poisonerEnabled) || other.poisonerEnabled == poisonerEnabled)&&(identical(other.doctorCanHealSelf, doctorCanHealSelf) || other.doctorCanHealSelf == doctorCanHealSelf)&&(identical(other.doctorCanHealSameTargetConsecutively, doctorCanHealSameTargetConsecutively) || other.doctorCanHealSameTargetConsecutively == doctorCanHealSameTargetConsecutively)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.discussionTime, discussionTime) || other.discussionTime == discussionTime)&&(identical(other.votingTime, votingTime) || other.votingTime == votingTime)&&(identical(other.defenseTime, defenseTime) || other.defenseTime == defenseTime)&&(identical(other.mafiaActionTime, mafiaActionTime) || other.mafiaActionTime == mafiaActionTime)&&(identical(other.otherActionTime, otherActionTime) || other.otherActionTime == otherActionTime)&&(identical(other.mafiaCount, mafiaCount) || other.mafiaCount == mafiaCount)&&(identical(other.commissarCount, commissarCount) || other.commissarCount == commissarCount)&&(identical(other.doctorCount, doctorCount) || other.doctorCount == doctorCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hashAll([runtimeType,themeId,autoPruningEnabled,donMechanicsEnabled,commissarEnabled,doctorEnabled,prostituteEnabled,maniacEnabled,commissarKills,sergeantEnabled,lawyerEnabled,poisonerEnabled,doctorCanHealSelf,doctorCanHealSameTargetConsecutively,locale,discussionTime,votingTime,defenseTime,mafiaActionTime,otherActionTime,mafiaCount,commissarCount,doctorCount]);

@override
String toString() {
  return 'GameConfig(themeId: $themeId, autoPruningEnabled: $autoPruningEnabled, donMechanicsEnabled: $donMechanicsEnabled, commissarEnabled: $commissarEnabled, doctorEnabled: $doctorEnabled, prostituteEnabled: $prostituteEnabled, maniacEnabled: $maniacEnabled, commissarKills: $commissarKills, sergeantEnabled: $sergeantEnabled, lawyerEnabled: $lawyerEnabled, poisonerEnabled: $poisonerEnabled, doctorCanHealSelf: $doctorCanHealSelf, doctorCanHealSameTargetConsecutively: $doctorCanHealSameTargetConsecutively, locale: $locale, discussionTime: $discussionTime, votingTime: $votingTime, defenseTime: $defenseTime, mafiaActionTime: $mafiaActionTime, otherActionTime: $otherActionTime, mafiaCount: $mafiaCount, commissarCount: $commissarCount, doctorCount: $doctorCount)';
}


}

/// @nodoc
abstract mixin class _$GameConfigCopyWith<$Res> implements $GameConfigCopyWith<$Res> {
  factory _$GameConfigCopyWith(_GameConfig value, $Res Function(_GameConfig) _then) = __$GameConfigCopyWithImpl;
@override @useResult
$Res call({
 String themeId, bool autoPruningEnabled, bool donMechanicsEnabled, bool commissarEnabled, bool doctorEnabled, bool prostituteEnabled, bool maniacEnabled, bool commissarKills, bool sergeantEnabled, bool lawyerEnabled, bool poisonerEnabled, bool doctorCanHealSelf, bool doctorCanHealSameTargetConsecutively, String locale, int discussionTime, int votingTime, int defenseTime, int mafiaActionTime, int otherActionTime, int? mafiaCount, int? commissarCount, int? doctorCount
});




}
/// @nodoc
class __$GameConfigCopyWithImpl<$Res>
    implements _$GameConfigCopyWith<$Res> {
  __$GameConfigCopyWithImpl(this._self, this._then);

  final _GameConfig _self;
  final $Res Function(_GameConfig) _then;

/// Create a copy of GameConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeId = null,Object? autoPruningEnabled = null,Object? donMechanicsEnabled = null,Object? commissarEnabled = null,Object? doctorEnabled = null,Object? prostituteEnabled = null,Object? maniacEnabled = null,Object? commissarKills = null,Object? sergeantEnabled = null,Object? lawyerEnabled = null,Object? poisonerEnabled = null,Object? doctorCanHealSelf = null,Object? doctorCanHealSameTargetConsecutively = null,Object? locale = null,Object? discussionTime = null,Object? votingTime = null,Object? defenseTime = null,Object? mafiaActionTime = null,Object? otherActionTime = null,Object? mafiaCount = freezed,Object? commissarCount = freezed,Object? doctorCount = freezed,}) {
  return _then(_GameConfig(
themeId: null == themeId ? _self.themeId : themeId // ignore: cast_nullable_to_non_nullable
as String,autoPruningEnabled: null == autoPruningEnabled ? _self.autoPruningEnabled : autoPruningEnabled // ignore: cast_nullable_to_non_nullable
as bool,donMechanicsEnabled: null == donMechanicsEnabled ? _self.donMechanicsEnabled : donMechanicsEnabled // ignore: cast_nullable_to_non_nullable
as bool,commissarEnabled: null == commissarEnabled ? _self.commissarEnabled : commissarEnabled // ignore: cast_nullable_to_non_nullable
as bool,doctorEnabled: null == doctorEnabled ? _self.doctorEnabled : doctorEnabled // ignore: cast_nullable_to_non_nullable
as bool,prostituteEnabled: null == prostituteEnabled ? _self.prostituteEnabled : prostituteEnabled // ignore: cast_nullable_to_non_nullable
as bool,maniacEnabled: null == maniacEnabled ? _self.maniacEnabled : maniacEnabled // ignore: cast_nullable_to_non_nullable
as bool,commissarKills: null == commissarKills ? _self.commissarKills : commissarKills // ignore: cast_nullable_to_non_nullable
as bool,sergeantEnabled: null == sergeantEnabled ? _self.sergeantEnabled : sergeantEnabled // ignore: cast_nullable_to_non_nullable
as bool,lawyerEnabled: null == lawyerEnabled ? _self.lawyerEnabled : lawyerEnabled // ignore: cast_nullable_to_non_nullable
as bool,poisonerEnabled: null == poisonerEnabled ? _self.poisonerEnabled : poisonerEnabled // ignore: cast_nullable_to_non_nullable
as bool,doctorCanHealSelf: null == doctorCanHealSelf ? _self.doctorCanHealSelf : doctorCanHealSelf // ignore: cast_nullable_to_non_nullable
as bool,doctorCanHealSameTargetConsecutively: null == doctorCanHealSameTargetConsecutively ? _self.doctorCanHealSameTargetConsecutively : doctorCanHealSameTargetConsecutively // ignore: cast_nullable_to_non_nullable
as bool,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,discussionTime: null == discussionTime ? _self.discussionTime : discussionTime // ignore: cast_nullable_to_non_nullable
as int,votingTime: null == votingTime ? _self.votingTime : votingTime // ignore: cast_nullable_to_non_nullable
as int,defenseTime: null == defenseTime ? _self.defenseTime : defenseTime // ignore: cast_nullable_to_non_nullable
as int,mafiaActionTime: null == mafiaActionTime ? _self.mafiaActionTime : mafiaActionTime // ignore: cast_nullable_to_non_nullable
as int,otherActionTime: null == otherActionTime ? _self.otherActionTime : otherActionTime // ignore: cast_nullable_to_non_nullable
as int,mafiaCount: freezed == mafiaCount ? _self.mafiaCount : mafiaCount // ignore: cast_nullable_to_non_nullable
as int?,commissarCount: freezed == commissarCount ? _self.commissarCount : commissarCount // ignore: cast_nullable_to_non_nullable
as int?,doctorCount: freezed == doctorCount ? _self.doctorCount : doctorCount // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
