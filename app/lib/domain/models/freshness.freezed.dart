// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'freshness.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Fresh<T> {

 T get value;/// true = ответ пришёл из локального кеша, сеть недоступна.
 bool get fromCache;/// Когда данные были положены в кеш. Заполнено только при fromCache.
 DateTime? get cachedAt;
/// Create a copy of Fresh
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FreshCopyWith<T, Fresh<T>> get copyWith => _$FreshCopyWithImpl<T, Fresh<T>>(this as Fresh<T>, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Fresh<T>&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache)&&(identical(other.cachedAt, cachedAt) || other.cachedAt == cachedAt));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(value),fromCache,cachedAt);

@override
String toString() {
  return 'Fresh<$T>(value: $value, fromCache: $fromCache, cachedAt: $cachedAt)';
}


}

/// @nodoc
abstract mixin class $FreshCopyWith<T,$Res>  {
  factory $FreshCopyWith(Fresh<T> value, $Res Function(Fresh<T>) _then) = _$FreshCopyWithImpl;
@useResult
$Res call({
 T value, bool fromCache, DateTime? cachedAt
});




}
/// @nodoc
class _$FreshCopyWithImpl<T,$Res>
    implements $FreshCopyWith<T, $Res> {
  _$FreshCopyWithImpl(this._self, this._then);

  final Fresh<T> _self;
  final $Res Function(Fresh<T>) _then;

/// Create a copy of Fresh
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? value = freezed,Object? fromCache = null,Object? cachedAt = freezed,}) {
  return _then(_self.copyWith(
value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as T,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,cachedAt: freezed == cachedAt ? _self.cachedAt : cachedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Fresh].
extension FreshPatterns<T> on Fresh<T> {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Fresh<T> value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Fresh() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Fresh<T> value)  $default,){
final _that = this;
switch (_that) {
case _Fresh():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Fresh<T> value)?  $default,){
final _that = this;
switch (_that) {
case _Fresh() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( T value,  bool fromCache,  DateTime? cachedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Fresh() when $default != null:
return $default(_that.value,_that.fromCache,_that.cachedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( T value,  bool fromCache,  DateTime? cachedAt)  $default,) {final _that = this;
switch (_that) {
case _Fresh():
return $default(_that.value,_that.fromCache,_that.cachedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( T value,  bool fromCache,  DateTime? cachedAt)?  $default,) {final _that = this;
switch (_that) {
case _Fresh() when $default != null:
return $default(_that.value,_that.fromCache,_that.cachedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Fresh<T> extends Fresh<T> {
  const _Fresh({required this.value, this.fromCache = false, this.cachedAt}): super._();
  

@override final  T value;
/// true = ответ пришёл из локального кеша, сеть недоступна.
@override@JsonKey() final  bool fromCache;
/// Когда данные были положены в кеш. Заполнено только при fromCache.
@override final  DateTime? cachedAt;

/// Create a copy of Fresh
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FreshCopyWith<T, _Fresh<T>> get copyWith => __$FreshCopyWithImpl<T, _Fresh<T>>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Fresh<T>&&const DeepCollectionEquality().equals(other.value, value)&&(identical(other.fromCache, fromCache) || other.fromCache == fromCache)&&(identical(other.cachedAt, cachedAt) || other.cachedAt == cachedAt));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(value),fromCache,cachedAt);

@override
String toString() {
  return 'Fresh<$T>(value: $value, fromCache: $fromCache, cachedAt: $cachedAt)';
}


}

/// @nodoc
abstract mixin class _$FreshCopyWith<T,$Res> implements $FreshCopyWith<T, $Res> {
  factory _$FreshCopyWith(_Fresh<T> value, $Res Function(_Fresh<T>) _then) = __$FreshCopyWithImpl;
@override @useResult
$Res call({
 T value, bool fromCache, DateTime? cachedAt
});




}
/// @nodoc
class __$FreshCopyWithImpl<T,$Res>
    implements _$FreshCopyWith<T, $Res> {
  __$FreshCopyWithImpl(this._self, this._then);

  final _Fresh<T> _self;
  final $Res Function(_Fresh<T>) _then;

/// Create a copy of Fresh
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? value = freezed,Object? fromCache = null,Object? cachedAt = freezed,}) {
  return _then(_Fresh<T>(
value: freezed == value ? _self.value : value // ignore: cast_nullable_to_non_nullable
as T,fromCache: null == fromCache ? _self.fromCache : fromCache // ignore: cast_nullable_to_non_nullable
as bool,cachedAt: freezed == cachedAt ? _self.cachedAt : cachedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
