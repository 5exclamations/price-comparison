// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deal_filters.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DealFilters {

 String? get category;/// Порог по НАСТОЯЩЕЙ скидке в долях: 0.25 = минус 25% от рынка.
 double? get minDiscount;/// «Только мои сети». Пусто — все.
 Set<String> get chains;
/// Create a copy of DealFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DealFiltersCopyWith<DealFilters> get copyWith => _$DealFiltersCopyWithImpl<DealFilters>(this as DealFilters, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DealFilters&&(identical(other.category, category) || other.category == category)&&(identical(other.minDiscount, minDiscount) || other.minDiscount == minDiscount)&&const DeepCollectionEquality().equals(other.chains, chains));
}


@override
int get hashCode => Object.hash(runtimeType,category,minDiscount,const DeepCollectionEquality().hash(chains));

@override
String toString() {
  return 'DealFilters(category: $category, minDiscount: $minDiscount, chains: $chains)';
}


}

/// @nodoc
abstract mixin class $DealFiltersCopyWith<$Res>  {
  factory $DealFiltersCopyWith(DealFilters value, $Res Function(DealFilters) _then) = _$DealFiltersCopyWithImpl;
@useResult
$Res call({
 String? category, double? minDiscount, Set<String> chains
});




}
/// @nodoc
class _$DealFiltersCopyWithImpl<$Res>
    implements $DealFiltersCopyWith<$Res> {
  _$DealFiltersCopyWithImpl(this._self, this._then);

  final DealFilters _self;
  final $Res Function(DealFilters) _then;

/// Create a copy of DealFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = freezed,Object? minDiscount = freezed,Object? chains = null,}) {
  return _then(_self.copyWith(
category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,minDiscount: freezed == minDiscount ? _self.minDiscount : minDiscount // ignore: cast_nullable_to_non_nullable
as double?,chains: null == chains ? _self.chains : chains // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DealFilters].
extension DealFiltersPatterns on DealFilters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DealFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DealFilters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DealFilters value)  $default,){
final _that = this;
switch (_that) {
case _DealFilters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DealFilters value)?  $default,){
final _that = this;
switch (_that) {
case _DealFilters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? category,  double? minDiscount,  Set<String> chains)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DealFilters() when $default != null:
return $default(_that.category,_that.minDiscount,_that.chains);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? category,  double? minDiscount,  Set<String> chains)  $default,) {final _that = this;
switch (_that) {
case _DealFilters():
return $default(_that.category,_that.minDiscount,_that.chains);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? category,  double? minDiscount,  Set<String> chains)?  $default,) {final _that = this;
switch (_that) {
case _DealFilters() when $default != null:
return $default(_that.category,_that.minDiscount,_that.chains);case _:
  return null;

}
}

}

/// @nodoc


class _DealFilters extends DealFilters {
  const _DealFilters({this.category, this.minDiscount, final  Set<String> chains = const <String>{}}): _chains = chains,super._();
  

@override final  String? category;
/// Порог по НАСТОЯЩЕЙ скидке в долях: 0.25 = минус 25% от рынка.
@override final  double? minDiscount;
/// «Только мои сети». Пусто — все.
 final  Set<String> _chains;
/// «Только мои сети». Пусто — все.
@override@JsonKey() Set<String> get chains {
  if (_chains is EqualUnmodifiableSetView) return _chains;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_chains);
}


/// Create a copy of DealFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DealFiltersCopyWith<_DealFilters> get copyWith => __$DealFiltersCopyWithImpl<_DealFilters>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DealFilters&&(identical(other.category, category) || other.category == category)&&(identical(other.minDiscount, minDiscount) || other.minDiscount == minDiscount)&&const DeepCollectionEquality().equals(other._chains, _chains));
}


@override
int get hashCode => Object.hash(runtimeType,category,minDiscount,const DeepCollectionEquality().hash(_chains));

@override
String toString() {
  return 'DealFilters(category: $category, minDiscount: $minDiscount, chains: $chains)';
}


}

/// @nodoc
abstract mixin class _$DealFiltersCopyWith<$Res> implements $DealFiltersCopyWith<$Res> {
  factory _$DealFiltersCopyWith(_DealFilters value, $Res Function(_DealFilters) _then) = __$DealFiltersCopyWithImpl;
@override @useResult
$Res call({
 String? category, double? minDiscount, Set<String> chains
});




}
/// @nodoc
class __$DealFiltersCopyWithImpl<$Res>
    implements _$DealFiltersCopyWith<$Res> {
  __$DealFiltersCopyWithImpl(this._self, this._then);

  final _DealFilters _self;
  final $Res Function(_DealFilters) _then;

/// Create a copy of DealFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = freezed,Object? minDiscount = freezed,Object? chains = null,}) {
  return _then(_DealFilters(
category: freezed == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String?,minDiscount: freezed == minDiscount ? _self.minDiscount : minDiscount // ignore: cast_nullable_to_non_nullable
as double?,chains: null == chains ? _self._chains : chains // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

// dart format on
