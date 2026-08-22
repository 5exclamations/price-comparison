// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'packaging.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Packaging {

 double? get value; String? get type;
/// Create a copy of Packaging
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PackagingCopyWith<Packaging> get copyWith => _$PackagingCopyWithImpl<Packaging>(this as Packaging, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Packaging&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,value,type);

@override
String toString() {
  return 'Packaging(value: $value, type: $type)';
}


}

/// @nodoc
abstract mixin class $PackagingCopyWith<$Res>  {
  factory $PackagingCopyWith(Packaging value, $Res Function(Packaging) _then) = _$PackagingCopyWithImpl;
@useResult
$Res call({
 double? value, String? type
});




}
/// @nodoc
class _$PackagingCopyWithImpl<$Res>
    implements $PackagingCopyWith<$Res> {
  _$PackagingCopyWithImpl(this._self, this._then);

  final Packaging _self;
  final $Res Function(Packaging) _then;

/// Create a copy of Packaging
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = freezed,Object? type = freezed,}) {
  return _then(_self.copyWith(
value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Packaging].
extension PackagingPatterns on Packaging {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Packaging value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Packaging() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Packaging value)  $default,){
final _that = this;
switch (_that) {
case _Packaging():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Packaging value)?  $default,){
final _that = this;
switch (_that) {
case _Packaging() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double? value,  String? type)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Packaging() when $default != null:
return $default(_that.value,_that.type);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double? value,  String? type)  $default,) {final _that = this;
switch (_that) {
case _Packaging():
return $default(_that.value,_that.type);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double? value,  String? type)?  $default,) {final _that = this;
switch (_that) {
case _Packaging() when $default != null:
return $default(_that.value,_that.type);case _:
  return null;

}
}

}

/// @nodoc


class _Packaging extends Packaging {
  const _Packaging({this.value, this.type}): super._();
  

@override final  double? value;
@override final  String? type;

/// Create a copy of Packaging
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PackagingCopyWith<_Packaging> get copyWith => __$PackagingCopyWithImpl<_Packaging>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Packaging&&(identical(other.value, value) || other.value == value)&&(identical(other.type, type) || other.type == type));
}


@override
int get hashCode => Object.hash(runtimeType,value,type);

@override
String toString() {
  return 'Packaging(value: $value, type: $type)';
}


}

/// @nodoc
abstract mixin class _$PackagingCopyWith<$Res> implements $PackagingCopyWith<$Res> {
  factory _$PackagingCopyWith(_Packaging value, $Res Function(_Packaging) _then) = __$PackagingCopyWithImpl;
@override @useResult
$Res call({
 double? value, String? type
});




}
/// @nodoc
class __$PackagingCopyWithImpl<$Res>
    implements _$PackagingCopyWith<$Res> {
  __$PackagingCopyWithImpl(this._self, this._then);

  final _Packaging _self;
  final $Res Function(_Packaging) _then;

/// Create a copy of Packaging
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = freezed,Object? type = freezed,}) {
  return _then(_Packaging(
value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as double?,type: freezed == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
