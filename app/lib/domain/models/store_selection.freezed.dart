// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_selection.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoreSelection {

/// Коды выбранных сетей: bravo, araz, spar, neptun, rahat, bazarstore.
 Set<String> get chainCodes;/// Выбранный магазин сети, где цена зависит от точки.
 int? get pickedStoreId;/// Код сети, к которой относится [pickedStoreId]. Хранится рядом, чтобы
/// при снятии галочки с этой сети сбросить и магазин.
 String? get pickedStoreChainCode;/// Название магазина — чтобы показать выбор, не ходя в сеть.
 String? get pickedStoreName;
/// Create a copy of StoreSelection
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreSelectionCopyWith<StoreSelection> get copyWith => _$StoreSelectionCopyWithImpl<StoreSelection>(this as StoreSelection, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreSelection&&const DeepCollectionEquality().equals(other.chainCodes, chainCodes)&&(identical(other.pickedStoreId, pickedStoreId) || other.pickedStoreId == pickedStoreId)&&(identical(other.pickedStoreChainCode, pickedStoreChainCode) || other.pickedStoreChainCode == pickedStoreChainCode)&&(identical(other.pickedStoreName, pickedStoreName) || other.pickedStoreName == pickedStoreName));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(chainCodes),pickedStoreId,pickedStoreChainCode,pickedStoreName);

@override
String toString() {
  return 'StoreSelection(chainCodes: $chainCodes, pickedStoreId: $pickedStoreId, pickedStoreChainCode: $pickedStoreChainCode, pickedStoreName: $pickedStoreName)';
}


}

/// @nodoc
abstract mixin class $StoreSelectionCopyWith<$Res>  {
  factory $StoreSelectionCopyWith(StoreSelection value, $Res Function(StoreSelection) _then) = _$StoreSelectionCopyWithImpl;
@useResult
$Res call({
 Set<String> chainCodes, int? pickedStoreId, String? pickedStoreChainCode, String? pickedStoreName
});




}
/// @nodoc
class _$StoreSelectionCopyWithImpl<$Res>
    implements $StoreSelectionCopyWith<$Res> {
  _$StoreSelectionCopyWithImpl(this._self, this._then);

  final StoreSelection _self;
  final $Res Function(StoreSelection) _then;

/// Create a copy of StoreSelection
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chainCodes = null,Object? pickedStoreId = freezed,Object? pickedStoreChainCode = freezed,Object? pickedStoreName = freezed,}) {
  return _then(_self.copyWith(
chainCodes: null == chainCodes ? _self.chainCodes : chainCodes // ignore: cast_nullable_to_non_nullable
as Set<String>,pickedStoreId: freezed == pickedStoreId ? _self.pickedStoreId : pickedStoreId // ignore: cast_nullable_to_non_nullable
as int?,pickedStoreChainCode: freezed == pickedStoreChainCode ? _self.pickedStoreChainCode : pickedStoreChainCode // ignore: cast_nullable_to_non_nullable
as String?,pickedStoreName: freezed == pickedStoreName ? _self.pickedStoreName : pickedStoreName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreSelection].
extension StoreSelectionPatterns on StoreSelection {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreSelection value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreSelection() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreSelection value)  $default,){
final _that = this;
switch (_that) {
case _StoreSelection():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreSelection value)?  $default,){
final _that = this;
switch (_that) {
case _StoreSelection() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Set<String> chainCodes,  int? pickedStoreId,  String? pickedStoreChainCode,  String? pickedStoreName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreSelection() when $default != null:
return $default(_that.chainCodes,_that.pickedStoreId,_that.pickedStoreChainCode,_that.pickedStoreName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Set<String> chainCodes,  int? pickedStoreId,  String? pickedStoreChainCode,  String? pickedStoreName)  $default,) {final _that = this;
switch (_that) {
case _StoreSelection():
return $default(_that.chainCodes,_that.pickedStoreId,_that.pickedStoreChainCode,_that.pickedStoreName);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Set<String> chainCodes,  int? pickedStoreId,  String? pickedStoreChainCode,  String? pickedStoreName)?  $default,) {final _that = this;
switch (_that) {
case _StoreSelection() when $default != null:
return $default(_that.chainCodes,_that.pickedStoreId,_that.pickedStoreChainCode,_that.pickedStoreName);case _:
  return null;

}
}

}

/// @nodoc


class _StoreSelection extends StoreSelection {
  const _StoreSelection({final  Set<String> chainCodes = const <String>{}, this.pickedStoreId, this.pickedStoreChainCode, this.pickedStoreName}): _chainCodes = chainCodes,super._();
  

/// Коды выбранных сетей: bravo, araz, spar, neptun, rahat, bazarstore.
 final  Set<String> _chainCodes;
/// Коды выбранных сетей: bravo, araz, spar, neptun, rahat, bazarstore.
@override@JsonKey() Set<String> get chainCodes {
  if (_chainCodes is EqualUnmodifiableSetView) return _chainCodes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_chainCodes);
}

/// Выбранный магазин сети, где цена зависит от точки.
@override final  int? pickedStoreId;
/// Код сети, к которой относится [pickedStoreId]. Хранится рядом, чтобы
/// при снятии галочки с этой сети сбросить и магазин.
@override final  String? pickedStoreChainCode;
/// Название магазина — чтобы показать выбор, не ходя в сеть.
@override final  String? pickedStoreName;

/// Create a copy of StoreSelection
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreSelectionCopyWith<_StoreSelection> get copyWith => __$StoreSelectionCopyWithImpl<_StoreSelection>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreSelection&&const DeepCollectionEquality().equals(other._chainCodes, _chainCodes)&&(identical(other.pickedStoreId, pickedStoreId) || other.pickedStoreId == pickedStoreId)&&(identical(other.pickedStoreChainCode, pickedStoreChainCode) || other.pickedStoreChainCode == pickedStoreChainCode)&&(identical(other.pickedStoreName, pickedStoreName) || other.pickedStoreName == pickedStoreName));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_chainCodes),pickedStoreId,pickedStoreChainCode,pickedStoreName);

@override
String toString() {
  return 'StoreSelection(chainCodes: $chainCodes, pickedStoreId: $pickedStoreId, pickedStoreChainCode: $pickedStoreChainCode, pickedStoreName: $pickedStoreName)';
}


}

/// @nodoc
abstract mixin class _$StoreSelectionCopyWith<$Res> implements $StoreSelectionCopyWith<$Res> {
  factory _$StoreSelectionCopyWith(_StoreSelection value, $Res Function(_StoreSelection) _then) = __$StoreSelectionCopyWithImpl;
@override @useResult
$Res call({
 Set<String> chainCodes, int? pickedStoreId, String? pickedStoreChainCode, String? pickedStoreName
});




}
/// @nodoc
class __$StoreSelectionCopyWithImpl<$Res>
    implements _$StoreSelectionCopyWith<$Res> {
  __$StoreSelectionCopyWithImpl(this._self, this._then);

  final _StoreSelection _self;
  final $Res Function(_StoreSelection) _then;

/// Create a copy of StoreSelection
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chainCodes = null,Object? pickedStoreId = freezed,Object? pickedStoreChainCode = freezed,Object? pickedStoreName = freezed,}) {
  return _then(_StoreSelection(
chainCodes: null == chainCodes ? _self._chainCodes : chainCodes // ignore: cast_nullable_to_non_nullable
as Set<String>,pickedStoreId: freezed == pickedStoreId ? _self.pickedStoreId : pickedStoreId // ignore: cast_nullable_to_non_nullable
as int?,pickedStoreChainCode: freezed == pickedStoreChainCode ? _self.pickedStoreChainCode : pickedStoreChainCode // ignore: cast_nullable_to_non_nullable
as String?,pickedStoreName: freezed == pickedStoreName ? _self.pickedStoreName : pickedStoreName // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
