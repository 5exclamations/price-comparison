// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'receipt_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ConsentTextDto {

 String get kind; int get version; String get locale; String get text; String get digest;
/// Create a copy of ConsentTextDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsentTextDtoCopyWith<ConsentTextDto> get copyWith => _$ConsentTextDtoCopyWithImpl<ConsentTextDto>(this as ConsentTextDto, _$identity);

  /// Serializes this ConsentTextDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsentTextDto&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.version, version) || other.version == version)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.text, text) || other.text == text)&&(identical(other.digest, digest) || other.digest == digest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,version,locale,text,digest);

@override
String toString() {
  return 'ConsentTextDto(kind: $kind, version: $version, locale: $locale, text: $text, digest: $digest)';
}


}

/// @nodoc
abstract mixin class $ConsentTextDtoCopyWith<$Res>  {
  factory $ConsentTextDtoCopyWith(ConsentTextDto value, $Res Function(ConsentTextDto) _then) = _$ConsentTextDtoCopyWithImpl;
@useResult
$Res call({
 String kind, int version, String locale, String text, String digest
});




}
/// @nodoc
class _$ConsentTextDtoCopyWithImpl<$Res>
    implements $ConsentTextDtoCopyWith<$Res> {
  _$ConsentTextDtoCopyWithImpl(this._self, this._then);

  final ConsentTextDto _self;
  final $Res Function(ConsentTextDto) _then;

/// Create a copy of ConsentTextDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? version = null,Object? locale = null,Object? text = null,Object? digest = null,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,digest: null == digest ? _self.digest : digest // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsentTextDto].
extension ConsentTextDtoPatterns on ConsentTextDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsentTextDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsentTextDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsentTextDto value)  $default,){
final _that = this;
switch (_that) {
case _ConsentTextDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsentTextDto value)?  $default,){
final _that = this;
switch (_that) {
case _ConsentTextDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kind,  int version,  String locale,  String text,  String digest)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsentTextDto() when $default != null:
return $default(_that.kind,_that.version,_that.locale,_that.text,_that.digest);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kind,  int version,  String locale,  String text,  String digest)  $default,) {final _that = this;
switch (_that) {
case _ConsentTextDto():
return $default(_that.kind,_that.version,_that.locale,_that.text,_that.digest);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kind,  int version,  String locale,  String text,  String digest)?  $default,) {final _that = this;
switch (_that) {
case _ConsentTextDto() when $default != null:
return $default(_that.kind,_that.version,_that.locale,_that.text,_that.digest);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsentTextDto implements ConsentTextDto {
  const _ConsentTextDto({required this.kind, required this.version, required this.locale, required this.text, required this.digest});
  factory _ConsentTextDto.fromJson(Map<String, dynamic> json) => _$ConsentTextDtoFromJson(json);

@override final  String kind;
@override final  int version;
@override final  String locale;
@override final  String text;
@override final  String digest;

/// Create a copy of ConsentTextDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsentTextDtoCopyWith<_ConsentTextDto> get copyWith => __$ConsentTextDtoCopyWithImpl<_ConsentTextDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsentTextDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsentTextDto&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.version, version) || other.version == version)&&(identical(other.locale, locale) || other.locale == locale)&&(identical(other.text, text) || other.text == text)&&(identical(other.digest, digest) || other.digest == digest));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,version,locale,text,digest);

@override
String toString() {
  return 'ConsentTextDto(kind: $kind, version: $version, locale: $locale, text: $text, digest: $digest)';
}


}

/// @nodoc
abstract mixin class _$ConsentTextDtoCopyWith<$Res> implements $ConsentTextDtoCopyWith<$Res> {
  factory _$ConsentTextDtoCopyWith(_ConsentTextDto value, $Res Function(_ConsentTextDto) _then) = __$ConsentTextDtoCopyWithImpl;
@override @useResult
$Res call({
 String kind, int version, String locale, String text, String digest
});




}
/// @nodoc
class __$ConsentTextDtoCopyWithImpl<$Res>
    implements _$ConsentTextDtoCopyWith<$Res> {
  __$ConsentTextDtoCopyWithImpl(this._self, this._then);

  final _ConsentTextDto _self;
  final $Res Function(_ConsentTextDto) _then;

/// Create a copy of ConsentTextDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? version = null,Object? locale = null,Object? text = null,Object? digest = null,}) {
  return _then(_ConsentTextDto(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,locale: null == locale ? _self.locale : locale // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,digest: null == digest ? _self.digest : digest // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ConsentStateDto {

 String get kind;@JsonKey(name: 'current_version') int get currentVersion; bool get granted;@JsonKey(name: 'granted_version') int? get grantedVersion;@JsonKey(name: 'granted_at') DateTime? get grantedAt;
/// Create a copy of ConsentStateDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConsentStateDtoCopyWith<ConsentStateDto> get copyWith => _$ConsentStateDtoCopyWithImpl<ConsentStateDto>(this as ConsentStateDto, _$identity);

  /// Serializes this ConsentStateDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConsentStateDto&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.currentVersion, currentVersion) || other.currentVersion == currentVersion)&&(identical(other.granted, granted) || other.granted == granted)&&(identical(other.grantedVersion, grantedVersion) || other.grantedVersion == grantedVersion)&&(identical(other.grantedAt, grantedAt) || other.grantedAt == grantedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,currentVersion,granted,grantedVersion,grantedAt);

@override
String toString() {
  return 'ConsentStateDto(kind: $kind, currentVersion: $currentVersion, granted: $granted, grantedVersion: $grantedVersion, grantedAt: $grantedAt)';
}


}

/// @nodoc
abstract mixin class $ConsentStateDtoCopyWith<$Res>  {
  factory $ConsentStateDtoCopyWith(ConsentStateDto value, $Res Function(ConsentStateDto) _then) = _$ConsentStateDtoCopyWithImpl;
@useResult
$Res call({
 String kind,@JsonKey(name: 'current_version') int currentVersion, bool granted,@JsonKey(name: 'granted_version') int? grantedVersion,@JsonKey(name: 'granted_at') DateTime? grantedAt
});




}
/// @nodoc
class _$ConsentStateDtoCopyWithImpl<$Res>
    implements $ConsentStateDtoCopyWith<$Res> {
  _$ConsentStateDtoCopyWithImpl(this._self, this._then);

  final ConsentStateDto _self;
  final $Res Function(ConsentStateDto) _then;

/// Create a copy of ConsentStateDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? currentVersion = null,Object? granted = null,Object? grantedVersion = freezed,Object? grantedAt = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,currentVersion: null == currentVersion ? _self.currentVersion : currentVersion // ignore: cast_nullable_to_non_nullable
as int,granted: null == granted ? _self.granted : granted // ignore: cast_nullable_to_non_nullable
as bool,grantedVersion: freezed == grantedVersion ? _self.grantedVersion : grantedVersion // ignore: cast_nullable_to_non_nullable
as int?,grantedAt: freezed == grantedAt ? _self.grantedAt : grantedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [ConsentStateDto].
extension ConsentStateDtoPatterns on ConsentStateDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConsentStateDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConsentStateDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConsentStateDto value)  $default,){
final _that = this;
switch (_that) {
case _ConsentStateDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConsentStateDto value)?  $default,){
final _that = this;
switch (_that) {
case _ConsentStateDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String kind, @JsonKey(name: 'current_version')  int currentVersion,  bool granted, @JsonKey(name: 'granted_version')  int? grantedVersion, @JsonKey(name: 'granted_at')  DateTime? grantedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConsentStateDto() when $default != null:
return $default(_that.kind,_that.currentVersion,_that.granted,_that.grantedVersion,_that.grantedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String kind, @JsonKey(name: 'current_version')  int currentVersion,  bool granted, @JsonKey(name: 'granted_version')  int? grantedVersion, @JsonKey(name: 'granted_at')  DateTime? grantedAt)  $default,) {final _that = this;
switch (_that) {
case _ConsentStateDto():
return $default(_that.kind,_that.currentVersion,_that.granted,_that.grantedVersion,_that.grantedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String kind, @JsonKey(name: 'current_version')  int currentVersion,  bool granted, @JsonKey(name: 'granted_version')  int? grantedVersion, @JsonKey(name: 'granted_at')  DateTime? grantedAt)?  $default,) {final _that = this;
switch (_that) {
case _ConsentStateDto() when $default != null:
return $default(_that.kind,_that.currentVersion,_that.granted,_that.grantedVersion,_that.grantedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConsentStateDto implements ConsentStateDto {
  const _ConsentStateDto({required this.kind, @JsonKey(name: 'current_version') required this.currentVersion, required this.granted, @JsonKey(name: 'granted_version') this.grantedVersion, @JsonKey(name: 'granted_at') this.grantedAt});
  factory _ConsentStateDto.fromJson(Map<String, dynamic> json) => _$ConsentStateDtoFromJson(json);

@override final  String kind;
@override@JsonKey(name: 'current_version') final  int currentVersion;
@override final  bool granted;
@override@JsonKey(name: 'granted_version') final  int? grantedVersion;
@override@JsonKey(name: 'granted_at') final  DateTime? grantedAt;

/// Create a copy of ConsentStateDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConsentStateDtoCopyWith<_ConsentStateDto> get copyWith => __$ConsentStateDtoCopyWithImpl<_ConsentStateDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConsentStateDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConsentStateDto&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.currentVersion, currentVersion) || other.currentVersion == currentVersion)&&(identical(other.granted, granted) || other.granted == granted)&&(identical(other.grantedVersion, grantedVersion) || other.grantedVersion == grantedVersion)&&(identical(other.grantedAt, grantedAt) || other.grantedAt == grantedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,kind,currentVersion,granted,grantedVersion,grantedAt);

@override
String toString() {
  return 'ConsentStateDto(kind: $kind, currentVersion: $currentVersion, granted: $granted, grantedVersion: $grantedVersion, grantedAt: $grantedAt)';
}


}

/// @nodoc
abstract mixin class _$ConsentStateDtoCopyWith<$Res> implements $ConsentStateDtoCopyWith<$Res> {
  factory _$ConsentStateDtoCopyWith(_ConsentStateDto value, $Res Function(_ConsentStateDto) _then) = __$ConsentStateDtoCopyWithImpl;
@override @useResult
$Res call({
 String kind,@JsonKey(name: 'current_version') int currentVersion, bool granted,@JsonKey(name: 'granted_version') int? grantedVersion,@JsonKey(name: 'granted_at') DateTime? grantedAt
});




}
/// @nodoc
class __$ConsentStateDtoCopyWithImpl<$Res>
    implements _$ConsentStateDtoCopyWith<$Res> {
  __$ConsentStateDtoCopyWithImpl(this._self, this._then);

  final _ConsentStateDto _self;
  final $Res Function(_ConsentStateDto) _then;

/// Create a copy of ConsentStateDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? currentVersion = null,Object? granted = null,Object? grantedVersion = freezed,Object? grantedAt = freezed,}) {
  return _then(_ConsentStateDto(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,currentVersion: null == currentVersion ? _self.currentVersion : currentVersion // ignore: cast_nullable_to_non_nullable
as int,granted: null == granted ? _self.granted : granted // ignore: cast_nullable_to_non_nullable
as bool,grantedVersion: freezed == grantedVersion ? _self.grantedVersion : grantedVersion // ignore: cast_nullable_to_non_nullable
as int?,grantedAt: freezed == grantedAt ? _self.grantedAt : grantedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$ReceiptSubmitDto {

 String get url;
/// Create a copy of ReceiptSubmitDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptSubmitDtoCopyWith<ReceiptSubmitDto> get copyWith => _$ReceiptSubmitDtoCopyWithImpl<ReceiptSubmitDto>(this as ReceiptSubmitDto, _$identity);

  /// Serializes this ReceiptSubmitDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptSubmitDto&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'ReceiptSubmitDto(url: $url)';
}


}

/// @nodoc
abstract mixin class $ReceiptSubmitDtoCopyWith<$Res>  {
  factory $ReceiptSubmitDtoCopyWith(ReceiptSubmitDto value, $Res Function(ReceiptSubmitDto) _then) = _$ReceiptSubmitDtoCopyWithImpl;
@useResult
$Res call({
 String url
});




}
/// @nodoc
class _$ReceiptSubmitDtoCopyWithImpl<$Res>
    implements $ReceiptSubmitDtoCopyWith<$Res> {
  _$ReceiptSubmitDtoCopyWithImpl(this._self, this._then);

  final ReceiptSubmitDto _self;
  final $Res Function(ReceiptSubmitDto) _then;

/// Create a copy of ReceiptSubmitDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? url = null,}) {
  return _then(_self.copyWith(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptSubmitDto].
extension ReceiptSubmitDtoPatterns on ReceiptSubmitDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptSubmitDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptSubmitDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptSubmitDto value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptSubmitDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptSubmitDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptSubmitDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String url)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptSubmitDto() when $default != null:
return $default(_that.url);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String url)  $default,) {final _that = this;
switch (_that) {
case _ReceiptSubmitDto():
return $default(_that.url);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String url)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptSubmitDto() when $default != null:
return $default(_that.url);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptSubmitDto implements ReceiptSubmitDto {
  const _ReceiptSubmitDto({required this.url});
  factory _ReceiptSubmitDto.fromJson(Map<String, dynamic> json) => _$ReceiptSubmitDtoFromJson(json);

@override final  String url;

/// Create a copy of ReceiptSubmitDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptSubmitDtoCopyWith<_ReceiptSubmitDto> get copyWith => __$ReceiptSubmitDtoCopyWithImpl<_ReceiptSubmitDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptSubmitDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptSubmitDto&&(identical(other.url, url) || other.url == url));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,url);

@override
String toString() {
  return 'ReceiptSubmitDto(url: $url)';
}


}

/// @nodoc
abstract mixin class _$ReceiptSubmitDtoCopyWith<$Res> implements $ReceiptSubmitDtoCopyWith<$Res> {
  factory _$ReceiptSubmitDtoCopyWith(_ReceiptSubmitDto value, $Res Function(_ReceiptSubmitDto) _then) = __$ReceiptSubmitDtoCopyWithImpl;
@override @useResult
$Res call({
 String url
});




}
/// @nodoc
class __$ReceiptSubmitDtoCopyWithImpl<$Res>
    implements _$ReceiptSubmitDtoCopyWith<$Res> {
  __$ReceiptSubmitDtoCopyWithImpl(this._self, this._then);

  final _ReceiptSubmitDto _self;
  final $Res Function(_ReceiptSubmitDto) _then;

/// Create a copy of ReceiptSubmitDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? url = null,}) {
  return _then(_ReceiptSubmitDto(
url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ReceiptItemDto {

@JsonKey(name: 'line_no') int get lineNo; String get name; double get quantity; String? get unit;@JsonKey(name: 'unit_price_minor') int get unitPriceMinor;@JsonKey(name: 'total_minor') int get totalMinor; String? get ean;
/// Create a copy of ReceiptItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptItemDtoCopyWith<ReceiptItemDto> get copyWith => _$ReceiptItemDtoCopyWithImpl<ReceiptItemDto>(this as ReceiptItemDto, _$identity);

  /// Serializes this ReceiptItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptItemDto&&(identical(other.lineNo, lineNo) || other.lineNo == lineNo)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPriceMinor, unitPriceMinor) || other.unitPriceMinor == unitPriceMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.ean, ean) || other.ean == ean));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lineNo,name,quantity,unit,unitPriceMinor,totalMinor,ean);

@override
String toString() {
  return 'ReceiptItemDto(lineNo: $lineNo, name: $name, quantity: $quantity, unit: $unit, unitPriceMinor: $unitPriceMinor, totalMinor: $totalMinor, ean: $ean)';
}


}

/// @nodoc
abstract mixin class $ReceiptItemDtoCopyWith<$Res>  {
  factory $ReceiptItemDtoCopyWith(ReceiptItemDto value, $Res Function(ReceiptItemDto) _then) = _$ReceiptItemDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'line_no') int lineNo, String name, double quantity, String? unit,@JsonKey(name: 'unit_price_minor') int unitPriceMinor,@JsonKey(name: 'total_minor') int totalMinor, String? ean
});




}
/// @nodoc
class _$ReceiptItemDtoCopyWithImpl<$Res>
    implements $ReceiptItemDtoCopyWith<$Res> {
  _$ReceiptItemDtoCopyWithImpl(this._self, this._then);

  final ReceiptItemDto _self;
  final $Res Function(ReceiptItemDto) _then;

/// Create a copy of ReceiptItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? lineNo = null,Object? name = null,Object? quantity = null,Object? unit = freezed,Object? unitPriceMinor = null,Object? totalMinor = null,Object? ean = freezed,}) {
  return _then(_self.copyWith(
lineNo: null == lineNo ? _self.lineNo : lineNo // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptItemDto].
extension ReceiptItemDtoPatterns on ReceiptItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptItemDto value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'line_no')  int lineNo,  String name,  double quantity,  String? unit, @JsonKey(name: 'unit_price_minor')  int unitPriceMinor, @JsonKey(name: 'total_minor')  int totalMinor,  String? ean)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptItemDto() when $default != null:
return $default(_that.lineNo,_that.name,_that.quantity,_that.unit,_that.unitPriceMinor,_that.totalMinor,_that.ean);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'line_no')  int lineNo,  String name,  double quantity,  String? unit, @JsonKey(name: 'unit_price_minor')  int unitPriceMinor, @JsonKey(name: 'total_minor')  int totalMinor,  String? ean)  $default,) {final _that = this;
switch (_that) {
case _ReceiptItemDto():
return $default(_that.lineNo,_that.name,_that.quantity,_that.unit,_that.unitPriceMinor,_that.totalMinor,_that.ean);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'line_no')  int lineNo,  String name,  double quantity,  String? unit, @JsonKey(name: 'unit_price_minor')  int unitPriceMinor, @JsonKey(name: 'total_minor')  int totalMinor,  String? ean)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptItemDto() when $default != null:
return $default(_that.lineNo,_that.name,_that.quantity,_that.unit,_that.unitPriceMinor,_that.totalMinor,_that.ean);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptItemDto implements ReceiptItemDto {
  const _ReceiptItemDto({@JsonKey(name: 'line_no') required this.lineNo, required this.name, required this.quantity, this.unit, @JsonKey(name: 'unit_price_minor') required this.unitPriceMinor, @JsonKey(name: 'total_minor') required this.totalMinor, this.ean});
  factory _ReceiptItemDto.fromJson(Map<String, dynamic> json) => _$ReceiptItemDtoFromJson(json);

@override@JsonKey(name: 'line_no') final  int lineNo;
@override final  String name;
@override final  double quantity;
@override final  String? unit;
@override@JsonKey(name: 'unit_price_minor') final  int unitPriceMinor;
@override@JsonKey(name: 'total_minor') final  int totalMinor;
@override final  String? ean;

/// Create a copy of ReceiptItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptItemDtoCopyWith<_ReceiptItemDto> get copyWith => __$ReceiptItemDtoCopyWithImpl<_ReceiptItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptItemDto&&(identical(other.lineNo, lineNo) || other.lineNo == lineNo)&&(identical(other.name, name) || other.name == name)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.unitPriceMinor, unitPriceMinor) || other.unitPriceMinor == unitPriceMinor)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.ean, ean) || other.ean == ean));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,lineNo,name,quantity,unit,unitPriceMinor,totalMinor,ean);

@override
String toString() {
  return 'ReceiptItemDto(lineNo: $lineNo, name: $name, quantity: $quantity, unit: $unit, unitPriceMinor: $unitPriceMinor, totalMinor: $totalMinor, ean: $ean)';
}


}

/// @nodoc
abstract mixin class _$ReceiptItemDtoCopyWith<$Res> implements $ReceiptItemDtoCopyWith<$Res> {
  factory _$ReceiptItemDtoCopyWith(_ReceiptItemDto value, $Res Function(_ReceiptItemDto) _then) = __$ReceiptItemDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'line_no') int lineNo, String name, double quantity, String? unit,@JsonKey(name: 'unit_price_minor') int unitPriceMinor,@JsonKey(name: 'total_minor') int totalMinor, String? ean
});




}
/// @nodoc
class __$ReceiptItemDtoCopyWithImpl<$Res>
    implements _$ReceiptItemDtoCopyWith<$Res> {
  __$ReceiptItemDtoCopyWithImpl(this._self, this._then);

  final _ReceiptItemDto _self;
  final $Res Function(_ReceiptItemDto) _then;

/// Create a copy of ReceiptItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? lineNo = null,Object? name = null,Object? quantity = null,Object? unit = freezed,Object? unitPriceMinor = null,Object? totalMinor = null,Object? ean = freezed,}) {
  return _then(_ReceiptItemDto(
lineNo: null == lineNo ? _self.lineNo : lineNo // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,unit: freezed == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as String?,unitPriceMinor: null == unitPriceMinor ? _self.unitPriceMinor : unitPriceMinor // ignore: cast_nullable_to_non_nullable
as int,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ReceiptDto {

 int get id;@JsonKey(name: 'fiscal_id') String get fiscalId;@JsonKey(name: 'merchant_name') String? get merchantName;/// null — магазин не из наших сетей. Чек всё равно сохранён: это
/// бесплатно расширяет покрытие.
@JsonKey(name: 'chain_code') String? get chainCode;@JsonKey(name: 'issued_at') DateTime get issuedAt;@JsonKey(name: 'total_minor') int get totalMinor;@JsonKey(name: 'uploaded_at') DateTime get uploadedAt; String get status; bool get duplicate;@JsonKey(name: 'points_awarded') int get pointsAwarded; List<ReceiptItemDto> get items;
/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptDtoCopyWith<ReceiptDto> get copyWith => _$ReceiptDtoCopyWithImpl<ReceiptDto>(this as ReceiptDto, _$identity);

  /// Serializes this ReceiptDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptDto&&(identical(other.id, id) || other.id == id)&&(identical(other.fiscalId, fiscalId) || other.fiscalId == fiscalId)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.duplicate, duplicate) || other.duplicate == duplicate)&&(identical(other.pointsAwarded, pointsAwarded) || other.pointsAwarded == pointsAwarded)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fiscalId,merchantName,chainCode,issuedAt,totalMinor,uploadedAt,status,duplicate,pointsAwarded,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ReceiptDto(id: $id, fiscalId: $fiscalId, merchantName: $merchantName, chainCode: $chainCode, issuedAt: $issuedAt, totalMinor: $totalMinor, uploadedAt: $uploadedAt, status: $status, duplicate: $duplicate, pointsAwarded: $pointsAwarded, items: $items)';
}


}

/// @nodoc
abstract mixin class $ReceiptDtoCopyWith<$Res>  {
  factory $ReceiptDtoCopyWith(ReceiptDto value, $Res Function(ReceiptDto) _then) = _$ReceiptDtoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'fiscal_id') String fiscalId,@JsonKey(name: 'merchant_name') String? merchantName,@JsonKey(name: 'chain_code') String? chainCode,@JsonKey(name: 'issued_at') DateTime issuedAt,@JsonKey(name: 'total_minor') int totalMinor,@JsonKey(name: 'uploaded_at') DateTime uploadedAt, String status, bool duplicate,@JsonKey(name: 'points_awarded') int pointsAwarded, List<ReceiptItemDto> items
});




}
/// @nodoc
class _$ReceiptDtoCopyWithImpl<$Res>
    implements $ReceiptDtoCopyWith<$Res> {
  _$ReceiptDtoCopyWithImpl(this._self, this._then);

  final ReceiptDto _self;
  final $Res Function(ReceiptDto) _then;

/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fiscalId = null,Object? merchantName = freezed,Object? chainCode = freezed,Object? issuedAt = null,Object? totalMinor = null,Object? uploadedAt = null,Object? status = null,Object? duplicate = null,Object? pointsAwarded = null,Object? items = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fiscalId: null == fiscalId ? _self.fiscalId : fiscalId // ignore: cast_nullable_to_non_nullable
as String,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,chainCode: freezed == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,duplicate: null == duplicate ? _self.duplicate : duplicate // ignore: cast_nullable_to_non_nullable
as bool,pointsAwarded: null == pointsAwarded ? _self.pointsAwarded : pointsAwarded // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptItemDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptDto].
extension ReceiptDtoPatterns on ReceiptDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptDto value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'fiscal_id')  String fiscalId, @JsonKey(name: 'merchant_name')  String? merchantName, @JsonKey(name: 'chain_code')  String? chainCode, @JsonKey(name: 'issued_at')  DateTime issuedAt, @JsonKey(name: 'total_minor')  int totalMinor, @JsonKey(name: 'uploaded_at')  DateTime uploadedAt,  String status,  bool duplicate, @JsonKey(name: 'points_awarded')  int pointsAwarded,  List<ReceiptItemDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptDto() when $default != null:
return $default(_that.id,_that.fiscalId,_that.merchantName,_that.chainCode,_that.issuedAt,_that.totalMinor,_that.uploadedAt,_that.status,_that.duplicate,_that.pointsAwarded,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'fiscal_id')  String fiscalId, @JsonKey(name: 'merchant_name')  String? merchantName, @JsonKey(name: 'chain_code')  String? chainCode, @JsonKey(name: 'issued_at')  DateTime issuedAt, @JsonKey(name: 'total_minor')  int totalMinor, @JsonKey(name: 'uploaded_at')  DateTime uploadedAt,  String status,  bool duplicate, @JsonKey(name: 'points_awarded')  int pointsAwarded,  List<ReceiptItemDto> items)  $default,) {final _that = this;
switch (_that) {
case _ReceiptDto():
return $default(_that.id,_that.fiscalId,_that.merchantName,_that.chainCode,_that.issuedAt,_that.totalMinor,_that.uploadedAt,_that.status,_that.duplicate,_that.pointsAwarded,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'fiscal_id')  String fiscalId, @JsonKey(name: 'merchant_name')  String? merchantName, @JsonKey(name: 'chain_code')  String? chainCode, @JsonKey(name: 'issued_at')  DateTime issuedAt, @JsonKey(name: 'total_minor')  int totalMinor, @JsonKey(name: 'uploaded_at')  DateTime uploadedAt,  String status,  bool duplicate, @JsonKey(name: 'points_awarded')  int pointsAwarded,  List<ReceiptItemDto> items)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptDto() when $default != null:
return $default(_that.id,_that.fiscalId,_that.merchantName,_that.chainCode,_that.issuedAt,_that.totalMinor,_that.uploadedAt,_that.status,_that.duplicate,_that.pointsAwarded,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptDto implements ReceiptDto {
  const _ReceiptDto({required this.id, @JsonKey(name: 'fiscal_id') required this.fiscalId, @JsonKey(name: 'merchant_name') this.merchantName, @JsonKey(name: 'chain_code') this.chainCode, @JsonKey(name: 'issued_at') required this.issuedAt, @JsonKey(name: 'total_minor') required this.totalMinor, @JsonKey(name: 'uploaded_at') required this.uploadedAt, required this.status, this.duplicate = false, @JsonKey(name: 'points_awarded') this.pointsAwarded = 0, final  List<ReceiptItemDto> items = const <ReceiptItemDto>[]}): _items = items;
  factory _ReceiptDto.fromJson(Map<String, dynamic> json) => _$ReceiptDtoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'fiscal_id') final  String fiscalId;
@override@JsonKey(name: 'merchant_name') final  String? merchantName;
/// null — магазин не из наших сетей. Чек всё равно сохранён: это
/// бесплатно расширяет покрытие.
@override@JsonKey(name: 'chain_code') final  String? chainCode;
@override@JsonKey(name: 'issued_at') final  DateTime issuedAt;
@override@JsonKey(name: 'total_minor') final  int totalMinor;
@override@JsonKey(name: 'uploaded_at') final  DateTime uploadedAt;
@override final  String status;
@override@JsonKey() final  bool duplicate;
@override@JsonKey(name: 'points_awarded') final  int pointsAwarded;
 final  List<ReceiptItemDto> _items;
@override@JsonKey() List<ReceiptItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptDtoCopyWith<_ReceiptDto> get copyWith => __$ReceiptDtoCopyWithImpl<_ReceiptDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptDto&&(identical(other.id, id) || other.id == id)&&(identical(other.fiscalId, fiscalId) || other.fiscalId == fiscalId)&&(identical(other.merchantName, merchantName) || other.merchantName == merchantName)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.issuedAt, issuedAt) || other.issuedAt == issuedAt)&&(identical(other.totalMinor, totalMinor) || other.totalMinor == totalMinor)&&(identical(other.uploadedAt, uploadedAt) || other.uploadedAt == uploadedAt)&&(identical(other.status, status) || other.status == status)&&(identical(other.duplicate, duplicate) || other.duplicate == duplicate)&&(identical(other.pointsAwarded, pointsAwarded) || other.pointsAwarded == pointsAwarded)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fiscalId,merchantName,chainCode,issuedAt,totalMinor,uploadedAt,status,duplicate,pointsAwarded,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ReceiptDto(id: $id, fiscalId: $fiscalId, merchantName: $merchantName, chainCode: $chainCode, issuedAt: $issuedAt, totalMinor: $totalMinor, uploadedAt: $uploadedAt, status: $status, duplicate: $duplicate, pointsAwarded: $pointsAwarded, items: $items)';
}


}

/// @nodoc
abstract mixin class _$ReceiptDtoCopyWith<$Res> implements $ReceiptDtoCopyWith<$Res> {
  factory _$ReceiptDtoCopyWith(_ReceiptDto value, $Res Function(_ReceiptDto) _then) = __$ReceiptDtoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'fiscal_id') String fiscalId,@JsonKey(name: 'merchant_name') String? merchantName,@JsonKey(name: 'chain_code') String? chainCode,@JsonKey(name: 'issued_at') DateTime issuedAt,@JsonKey(name: 'total_minor') int totalMinor,@JsonKey(name: 'uploaded_at') DateTime uploadedAt, String status, bool duplicate,@JsonKey(name: 'points_awarded') int pointsAwarded, List<ReceiptItemDto> items
});




}
/// @nodoc
class __$ReceiptDtoCopyWithImpl<$Res>
    implements _$ReceiptDtoCopyWith<$Res> {
  __$ReceiptDtoCopyWithImpl(this._self, this._then);

  final _ReceiptDto _self;
  final $Res Function(_ReceiptDto) _then;

/// Create a copy of ReceiptDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fiscalId = null,Object? merchantName = freezed,Object? chainCode = freezed,Object? issuedAt = null,Object? totalMinor = null,Object? uploadedAt = null,Object? status = null,Object? duplicate = null,Object? pointsAwarded = null,Object? items = null,}) {
  return _then(_ReceiptDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,fiscalId: null == fiscalId ? _self.fiscalId : fiscalId // ignore: cast_nullable_to_non_nullable
as String,merchantName: freezed == merchantName ? _self.merchantName : merchantName // ignore: cast_nullable_to_non_nullable
as String?,chainCode: freezed == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String?,issuedAt: null == issuedAt ? _self.issuedAt : issuedAt // ignore: cast_nullable_to_non_nullable
as DateTime,totalMinor: null == totalMinor ? _self.totalMinor : totalMinor // ignore: cast_nullable_to_non_nullable
as int,uploadedAt: null == uploadedAt ? _self.uploadedAt : uploadedAt // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,duplicate: null == duplicate ? _self.duplicate : duplicate // ignore: cast_nullable_to_non_nullable
as bool,pointsAwarded: null == pointsAwarded ? _self.pointsAwarded : pointsAwarded // ignore: cast_nullable_to_non_nullable
as int,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptItemDto>,
  ));
}


}


/// @nodoc
mixin _$ReceiptsResponseDto {

 List<ReceiptDto> get items;
/// Create a copy of ReceiptsResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReceiptsResponseDtoCopyWith<ReceiptsResponseDto> get copyWith => _$ReceiptsResponseDtoCopyWithImpl<ReceiptsResponseDto>(this as ReceiptsResponseDto, _$identity);

  /// Serializes this ReceiptsResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReceiptsResponseDto&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'ReceiptsResponseDto(items: $items)';
}


}

/// @nodoc
abstract mixin class $ReceiptsResponseDtoCopyWith<$Res>  {
  factory $ReceiptsResponseDtoCopyWith(ReceiptsResponseDto value, $Res Function(ReceiptsResponseDto) _then) = _$ReceiptsResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<ReceiptDto> items
});




}
/// @nodoc
class _$ReceiptsResponseDtoCopyWithImpl<$Res>
    implements $ReceiptsResponseDtoCopyWith<$Res> {
  _$ReceiptsResponseDtoCopyWithImpl(this._self, this._then);

  final ReceiptsResponseDto _self;
  final $Res Function(ReceiptsResponseDto) _then;

/// Create a copy of ReceiptsResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ReceiptsResponseDto].
extension ReceiptsResponseDtoPatterns on ReceiptsResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReceiptsResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReceiptsResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReceiptsResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _ReceiptsResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReceiptsResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _ReceiptsResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ReceiptDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReceiptsResponseDto() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ReceiptDto> items)  $default,) {final _that = this;
switch (_that) {
case _ReceiptsResponseDto():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ReceiptDto> items)?  $default,) {final _that = this;
switch (_that) {
case _ReceiptsResponseDto() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ReceiptsResponseDto implements ReceiptsResponseDto {
  const _ReceiptsResponseDto({required final  List<ReceiptDto> items}): _items = items;
  factory _ReceiptsResponseDto.fromJson(Map<String, dynamic> json) => _$ReceiptsResponseDtoFromJson(json);

 final  List<ReceiptDto> _items;
@override List<ReceiptDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of ReceiptsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReceiptsResponseDtoCopyWith<_ReceiptsResponseDto> get copyWith => __$ReceiptsResponseDtoCopyWithImpl<_ReceiptsResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReceiptsResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReceiptsResponseDto&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'ReceiptsResponseDto(items: $items)';
}


}

/// @nodoc
abstract mixin class _$ReceiptsResponseDtoCopyWith<$Res> implements $ReceiptsResponseDtoCopyWith<$Res> {
  factory _$ReceiptsResponseDtoCopyWith(_ReceiptsResponseDto value, $Res Function(_ReceiptsResponseDto) _then) = __$ReceiptsResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<ReceiptDto> items
});




}
/// @nodoc
class __$ReceiptsResponseDtoCopyWithImpl<$Res>
    implements _$ReceiptsResponseDtoCopyWith<$Res> {
  __$ReceiptsResponseDtoCopyWithImpl(this._self, this._then);

  final _ReceiptsResponseDto _self;
  final $Res Function(_ReceiptsResponseDto) _then;

/// Create a copy of ReceiptsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_ReceiptsResponseDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<ReceiptDto>,
  ));
}


}


/// @nodoc
mixin _$PointsDto {

 int get points;@JsonKey(name: 'receipts_uploaded') int get receiptsUploaded;
/// Create a copy of PointsDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PointsDtoCopyWith<PointsDto> get copyWith => _$PointsDtoCopyWithImpl<PointsDto>(this as PointsDto, _$identity);

  /// Serializes this PointsDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PointsDto&&(identical(other.points, points) || other.points == points)&&(identical(other.receiptsUploaded, receiptsUploaded) || other.receiptsUploaded == receiptsUploaded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,receiptsUploaded);

@override
String toString() {
  return 'PointsDto(points: $points, receiptsUploaded: $receiptsUploaded)';
}


}

/// @nodoc
abstract mixin class $PointsDtoCopyWith<$Res>  {
  factory $PointsDtoCopyWith(PointsDto value, $Res Function(PointsDto) _then) = _$PointsDtoCopyWithImpl;
@useResult
$Res call({
 int points,@JsonKey(name: 'receipts_uploaded') int receiptsUploaded
});




}
/// @nodoc
class _$PointsDtoCopyWithImpl<$Res>
    implements $PointsDtoCopyWith<$Res> {
  _$PointsDtoCopyWithImpl(this._self, this._then);

  final PointsDto _self;
  final $Res Function(PointsDto) _then;

/// Create a copy of PointsDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? points = null,Object? receiptsUploaded = null,}) {
  return _then(_self.copyWith(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,receiptsUploaded: null == receiptsUploaded ? _self.receiptsUploaded : receiptsUploaded // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PointsDto].
extension PointsDtoPatterns on PointsDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PointsDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PointsDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PointsDto value)  $default,){
final _that = this;
switch (_that) {
case _PointsDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PointsDto value)?  $default,){
final _that = this;
switch (_that) {
case _PointsDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int points, @JsonKey(name: 'receipts_uploaded')  int receiptsUploaded)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PointsDto() when $default != null:
return $default(_that.points,_that.receiptsUploaded);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int points, @JsonKey(name: 'receipts_uploaded')  int receiptsUploaded)  $default,) {final _that = this;
switch (_that) {
case _PointsDto():
return $default(_that.points,_that.receiptsUploaded);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int points, @JsonKey(name: 'receipts_uploaded')  int receiptsUploaded)?  $default,) {final _that = this;
switch (_that) {
case _PointsDto() when $default != null:
return $default(_that.points,_that.receiptsUploaded);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PointsDto implements PointsDto {
  const _PointsDto({required this.points, @JsonKey(name: 'receipts_uploaded') required this.receiptsUploaded});
  factory _PointsDto.fromJson(Map<String, dynamic> json) => _$PointsDtoFromJson(json);

@override final  int points;
@override@JsonKey(name: 'receipts_uploaded') final  int receiptsUploaded;

/// Create a copy of PointsDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PointsDtoCopyWith<_PointsDto> get copyWith => __$PointsDtoCopyWithImpl<_PointsDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PointsDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PointsDto&&(identical(other.points, points) || other.points == points)&&(identical(other.receiptsUploaded, receiptsUploaded) || other.receiptsUploaded == receiptsUploaded));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,points,receiptsUploaded);

@override
String toString() {
  return 'PointsDto(points: $points, receiptsUploaded: $receiptsUploaded)';
}


}

/// @nodoc
abstract mixin class _$PointsDtoCopyWith<$Res> implements $PointsDtoCopyWith<$Res> {
  factory _$PointsDtoCopyWith(_PointsDto value, $Res Function(_PointsDto) _then) = __$PointsDtoCopyWithImpl;
@override @useResult
$Res call({
 int points,@JsonKey(name: 'receipts_uploaded') int receiptsUploaded
});




}
/// @nodoc
class __$PointsDtoCopyWithImpl<$Res>
    implements _$PointsDtoCopyWith<$Res> {
  __$PointsDtoCopyWithImpl(this._self, this._then);

  final _PointsDto _self;
  final $Res Function(_PointsDto) _then;

/// Create a copy of PointsDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? points = null,Object? receiptsUploaded = null,}) {
  return _then(_PointsDto(
points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int,receiptsUploaded: null == receiptsUploaded ? _self.receiptsUploaded : receiptsUploaded // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
