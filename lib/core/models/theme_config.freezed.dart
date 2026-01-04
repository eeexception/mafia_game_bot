// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'theme_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ThemeConfig {

 String get id; String get name; String get author; Map<String, String> get roles; Map<String, List<String>> get eventAudio; Map<String, String> get backgroundAudio; double get announcementVolume; double get backgroundDuckVolume; double get backgroundNormalVolume;
/// Create a copy of ThemeConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThemeConfigCopyWith<ThemeConfig> get copyWith => _$ThemeConfigCopyWithImpl<ThemeConfig>(this as ThemeConfig, _$identity);

  /// Serializes this ThemeConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other.roles, roles)&&const DeepCollectionEquality().equals(other.eventAudio, eventAudio)&&const DeepCollectionEquality().equals(other.backgroundAudio, backgroundAudio)&&(identical(other.announcementVolume, announcementVolume) || other.announcementVolume == announcementVolume)&&(identical(other.backgroundDuckVolume, backgroundDuckVolume) || other.backgroundDuckVolume == backgroundDuckVolume)&&(identical(other.backgroundNormalVolume, backgroundNormalVolume) || other.backgroundNormalVolume == backgroundNormalVolume));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,author,const DeepCollectionEquality().hash(roles),const DeepCollectionEquality().hash(eventAudio),const DeepCollectionEquality().hash(backgroundAudio),announcementVolume,backgroundDuckVolume,backgroundNormalVolume);

@override
String toString() {
  return 'ThemeConfig(id: $id, name: $name, author: $author, roles: $roles, eventAudio: $eventAudio, backgroundAudio: $backgroundAudio, announcementVolume: $announcementVolume, backgroundDuckVolume: $backgroundDuckVolume, backgroundNormalVolume: $backgroundNormalVolume)';
}


}

/// @nodoc
abstract mixin class $ThemeConfigCopyWith<$Res>  {
  factory $ThemeConfigCopyWith(ThemeConfig value, $Res Function(ThemeConfig) _then) = _$ThemeConfigCopyWithImpl;
@useResult
$Res call({
 String id, String name, String author, Map<String, String> roles, Map<String, List<String>> eventAudio, Map<String, String> backgroundAudio, double announcementVolume, double backgroundDuckVolume, double backgroundNormalVolume
});




}
/// @nodoc
class _$ThemeConfigCopyWithImpl<$Res>
    implements $ThemeConfigCopyWith<$Res> {
  _$ThemeConfigCopyWithImpl(this._self, this._then);

  final ThemeConfig _self;
  final $Res Function(ThemeConfig) _then;

/// Create a copy of ThemeConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? author = null,Object? roles = null,Object? eventAudio = null,Object? backgroundAudio = null,Object? announcementVolume = null,Object? backgroundDuckVolume = null,Object? backgroundNormalVolume = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,roles: null == roles ? _self.roles : roles // ignore: cast_nullable_to_non_nullable
as Map<String, String>,eventAudio: null == eventAudio ? _self.eventAudio : eventAudio // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,backgroundAudio: null == backgroundAudio ? _self.backgroundAudio : backgroundAudio // ignore: cast_nullable_to_non_nullable
as Map<String, String>,announcementVolume: null == announcementVolume ? _self.announcementVolume : announcementVolume // ignore: cast_nullable_to_non_nullable
as double,backgroundDuckVolume: null == backgroundDuckVolume ? _self.backgroundDuckVolume : backgroundDuckVolume // ignore: cast_nullable_to_non_nullable
as double,backgroundNormalVolume: null == backgroundNormalVolume ? _self.backgroundNormalVolume : backgroundNormalVolume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}

}


/// Adds pattern-matching-related methods to [ThemeConfig].
extension ThemeConfigPatterns on ThemeConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThemeConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThemeConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThemeConfig value)  $default,){
final _that = this;
switch (_that) {
case _ThemeConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThemeConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ThemeConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String author,  Map<String, String> roles,  Map<String, List<String>> eventAudio,  Map<String, String> backgroundAudio,  double announcementVolume,  double backgroundDuckVolume,  double backgroundNormalVolume)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThemeConfig() when $default != null:
return $default(_that.id,_that.name,_that.author,_that.roles,_that.eventAudio,_that.backgroundAudio,_that.announcementVolume,_that.backgroundDuckVolume,_that.backgroundNormalVolume);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String author,  Map<String, String> roles,  Map<String, List<String>> eventAudio,  Map<String, String> backgroundAudio,  double announcementVolume,  double backgroundDuckVolume,  double backgroundNormalVolume)  $default,) {final _that = this;
switch (_that) {
case _ThemeConfig():
return $default(_that.id,_that.name,_that.author,_that.roles,_that.eventAudio,_that.backgroundAudio,_that.announcementVolume,_that.backgroundDuckVolume,_that.backgroundNormalVolume);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String author,  Map<String, String> roles,  Map<String, List<String>> eventAudio,  Map<String, String> backgroundAudio,  double announcementVolume,  double backgroundDuckVolume,  double backgroundNormalVolume)?  $default,) {final _that = this;
switch (_that) {
case _ThemeConfig() when $default != null:
return $default(_that.id,_that.name,_that.author,_that.roles,_that.eventAudio,_that.backgroundAudio,_that.announcementVolume,_that.backgroundDuckVolume,_that.backgroundNormalVolume);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ThemeConfig implements ThemeConfig {
  const _ThemeConfig({required this.id, required this.name, required this.author, required final  Map<String, String> roles, required final  Map<String, List<String>> eventAudio, required final  Map<String, String> backgroundAudio, this.announcementVolume = 1.0, this.backgroundDuckVolume = 0.1, this.backgroundNormalVolume = 0.3}): _roles = roles,_eventAudio = eventAudio,_backgroundAudio = backgroundAudio;
  factory _ThemeConfig.fromJson(Map<String, dynamic> json) => _$ThemeConfigFromJson(json);

@override final  String id;
@override final  String name;
@override final  String author;
 final  Map<String, String> _roles;
@override Map<String, String> get roles {
  if (_roles is EqualUnmodifiableMapView) return _roles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_roles);
}

 final  Map<String, List<String>> _eventAudio;
@override Map<String, List<String>> get eventAudio {
  if (_eventAudio is EqualUnmodifiableMapView) return _eventAudio;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_eventAudio);
}

 final  Map<String, String> _backgroundAudio;
@override Map<String, String> get backgroundAudio {
  if (_backgroundAudio is EqualUnmodifiableMapView) return _backgroundAudio;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_backgroundAudio);
}

@override@JsonKey() final  double announcementVolume;
@override@JsonKey() final  double backgroundDuckVolume;
@override@JsonKey() final  double backgroundNormalVolume;

/// Create a copy of ThemeConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThemeConfigCopyWith<_ThemeConfig> get copyWith => __$ThemeConfigCopyWithImpl<_ThemeConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ThemeConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThemeConfig&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author)&&const DeepCollectionEquality().equals(other._roles, _roles)&&const DeepCollectionEquality().equals(other._eventAudio, _eventAudio)&&const DeepCollectionEquality().equals(other._backgroundAudio, _backgroundAudio)&&(identical(other.announcementVolume, announcementVolume) || other.announcementVolume == announcementVolume)&&(identical(other.backgroundDuckVolume, backgroundDuckVolume) || other.backgroundDuckVolume == backgroundDuckVolume)&&(identical(other.backgroundNormalVolume, backgroundNormalVolume) || other.backgroundNormalVolume == backgroundNormalVolume));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,author,const DeepCollectionEquality().hash(_roles),const DeepCollectionEquality().hash(_eventAudio),const DeepCollectionEquality().hash(_backgroundAudio),announcementVolume,backgroundDuckVolume,backgroundNormalVolume);

@override
String toString() {
  return 'ThemeConfig(id: $id, name: $name, author: $author, roles: $roles, eventAudio: $eventAudio, backgroundAudio: $backgroundAudio, announcementVolume: $announcementVolume, backgroundDuckVolume: $backgroundDuckVolume, backgroundNormalVolume: $backgroundNormalVolume)';
}


}

/// @nodoc
abstract mixin class _$ThemeConfigCopyWith<$Res> implements $ThemeConfigCopyWith<$Res> {
  factory _$ThemeConfigCopyWith(_ThemeConfig value, $Res Function(_ThemeConfig) _then) = __$ThemeConfigCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String author, Map<String, String> roles, Map<String, List<String>> eventAudio, Map<String, String> backgroundAudio, double announcementVolume, double backgroundDuckVolume, double backgroundNormalVolume
});




}
/// @nodoc
class __$ThemeConfigCopyWithImpl<$Res>
    implements _$ThemeConfigCopyWith<$Res> {
  __$ThemeConfigCopyWithImpl(this._self, this._then);

  final _ThemeConfig _self;
  final $Res Function(_ThemeConfig) _then;

/// Create a copy of ThemeConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? author = null,Object? roles = null,Object? eventAudio = null,Object? backgroundAudio = null,Object? announcementVolume = null,Object? backgroundDuckVolume = null,Object? backgroundNormalVolume = null,}) {
  return _then(_ThemeConfig(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,roles: null == roles ? _self._roles : roles // ignore: cast_nullable_to_non_nullable
as Map<String, String>,eventAudio: null == eventAudio ? _self._eventAudio : eventAudio // ignore: cast_nullable_to_non_nullable
as Map<String, List<String>>,backgroundAudio: null == backgroundAudio ? _self._backgroundAudio : backgroundAudio // ignore: cast_nullable_to_non_nullable
as Map<String, String>,announcementVolume: null == announcementVolume ? _self.announcementVolume : announcementVolume // ignore: cast_nullable_to_non_nullable
as double,backgroundDuckVolume: null == backgroundDuckVolume ? _self.backgroundDuckVolume : backgroundDuckVolume // ignore: cast_nullable_to_non_nullable
as double,backgroundNormalVolume: null == backgroundNormalVolume ? _self.backgroundNormalVolume : backgroundNormalVolume // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}


/// @nodoc
mixin _$ThemeMeta {

 String get id; String get name; String get author;
/// Create a copy of ThemeMeta
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ThemeMetaCopyWith<ThemeMeta> get copyWith => _$ThemeMetaCopyWithImpl<ThemeMeta>(this as ThemeMeta, _$identity);

  /// Serializes this ThemeMeta to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ThemeMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,author);

@override
String toString() {
  return 'ThemeMeta(id: $id, name: $name, author: $author)';
}


}

/// @nodoc
abstract mixin class $ThemeMetaCopyWith<$Res>  {
  factory $ThemeMetaCopyWith(ThemeMeta value, $Res Function(ThemeMeta) _then) = _$ThemeMetaCopyWithImpl;
@useResult
$Res call({
 String id, String name, String author
});




}
/// @nodoc
class _$ThemeMetaCopyWithImpl<$Res>
    implements $ThemeMetaCopyWith<$Res> {
  _$ThemeMetaCopyWithImpl(this._self, this._then);

  final ThemeMeta _self;
  final $Res Function(ThemeMeta) _then;

/// Create a copy of ThemeMeta
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? author = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ThemeMeta].
extension ThemeMetaPatterns on ThemeMeta {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ThemeMeta value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ThemeMeta() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ThemeMeta value)  $default,){
final _that = this;
switch (_that) {
case _ThemeMeta():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ThemeMeta value)?  $default,){
final _that = this;
switch (_that) {
case _ThemeMeta() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String author)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ThemeMeta() when $default != null:
return $default(_that.id,_that.name,_that.author);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String author)  $default,) {final _that = this;
switch (_that) {
case _ThemeMeta():
return $default(_that.id,_that.name,_that.author);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String author)?  $default,) {final _that = this;
switch (_that) {
case _ThemeMeta() when $default != null:
return $default(_that.id,_that.name,_that.author);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ThemeMeta implements ThemeMeta {
  const _ThemeMeta({required this.id, required this.name, required this.author});
  factory _ThemeMeta.fromJson(Map<String, dynamic> json) => _$ThemeMetaFromJson(json);

@override final  String id;
@override final  String name;
@override final  String author;

/// Create a copy of ThemeMeta
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ThemeMetaCopyWith<_ThemeMeta> get copyWith => __$ThemeMetaCopyWithImpl<_ThemeMeta>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ThemeMetaToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ThemeMeta&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.author, author) || other.author == author));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,author);

@override
String toString() {
  return 'ThemeMeta(id: $id, name: $name, author: $author)';
}


}

/// @nodoc
abstract mixin class _$ThemeMetaCopyWith<$Res> implements $ThemeMetaCopyWith<$Res> {
  factory _$ThemeMetaCopyWith(_ThemeMeta value, $Res Function(_ThemeMeta) _then) = __$ThemeMetaCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String author
});




}
/// @nodoc
class __$ThemeMetaCopyWithImpl<$Res>
    implements _$ThemeMetaCopyWith<$Res> {
  __$ThemeMetaCopyWithImpl(this._self, this._then);

  final _ThemeMeta _self;
  final $Res Function(_ThemeMeta) _then;

/// Create a copy of ThemeMeta
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? author = null,}) {
  return _then(_ThemeMeta(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
