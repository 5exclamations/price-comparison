// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'basket_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BasketItem {

 int get id; int? get productId; String get name; double? get unitValue; String? get unitType; bool get done; DateTime get addedAt;/// Цены по сетям. Пусто, если позиция ручная либо цены ещё не загружены.
 List<ChainPrice> get prices;/// Когда цены обновлялись последний раз. Показывается рядом с суммой:
/// корзина без времени наблюдения — такое же враньё, как цена без него.
 DateTime? get pricesUpdatedAt;
/// Create a copy of BasketItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BasketItemCopyWith<BasketItem> get copyWith => _$BasketItemCopyWithImpl<BasketItem>(this as BasketItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BasketItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.done, done) || other.done == done)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&const DeepCollectionEquality().equals(other.prices, prices)&&(identical(other.pricesUpdatedAt, pricesUpdatedAt) || other.pricesUpdatedAt == pricesUpdatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,productId,name,unitValue,unitType,done,addedAt,const DeepCollectionEquality().hash(prices),pricesUpdatedAt);

@override
String toString() {
  return 'BasketItem(id: $id, productId: $productId, name: $name, unitValue: $unitValue, unitType: $unitType, done: $done, addedAt: $addedAt, prices: $prices, pricesUpdatedAt: $pricesUpdatedAt)';
}


}

/// @nodoc
abstract mixin class $BasketItemCopyWith<$Res>  {
  factory $BasketItemCopyWith(BasketItem value, $Res Function(BasketItem) _then) = _$BasketItemCopyWithImpl;
@useResult
$Res call({
 int id, int? productId, String name, double? unitValue, String? unitType, bool done, DateTime addedAt, List<ChainPrice> prices, DateTime? pricesUpdatedAt
});




}
/// @nodoc
class _$BasketItemCopyWithImpl<$Res>
    implements $BasketItemCopyWith<$Res> {
  _$BasketItemCopyWithImpl(this._self, this._then);

  final BasketItem _self;
  final $Res Function(BasketItem) _then;

/// Create a copy of BasketItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = freezed,Object? name = null,Object? unitValue = freezed,Object? unitType = freezed,Object? done = null,Object? addedAt = null,Object? prices = null,Object? pricesUpdatedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unitValue: freezed == unitValue ? _self.unitValue : unitValue // ignore: cast_nullable_to_non_nullable
as double?,unitType: freezed == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,prices: null == prices ? _self.prices : prices // ignore: cast_nullable_to_non_nullable
as List<ChainPrice>,pricesUpdatedAt: freezed == pricesUpdatedAt ? _self.pricesUpdatedAt : pricesUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [BasketItem].
extension BasketItemPatterns on BasketItem {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BasketItem value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BasketItem() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BasketItem value)  $default,){
final _that = this;
switch (_that) {
case _BasketItem():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BasketItem value)?  $default,){
final _that = this;
switch (_that) {
case _BasketItem() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int? productId,  String name,  double? unitValue,  String? unitType,  bool done,  DateTime addedAt,  List<ChainPrice> prices,  DateTime? pricesUpdatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BasketItem() when $default != null:
return $default(_that.id,_that.productId,_that.name,_that.unitValue,_that.unitType,_that.done,_that.addedAt,_that.prices,_that.pricesUpdatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int? productId,  String name,  double? unitValue,  String? unitType,  bool done,  DateTime addedAt,  List<ChainPrice> prices,  DateTime? pricesUpdatedAt)  $default,) {final _that = this;
switch (_that) {
case _BasketItem():
return $default(_that.id,_that.productId,_that.name,_that.unitValue,_that.unitType,_that.done,_that.addedAt,_that.prices,_that.pricesUpdatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int? productId,  String name,  double? unitValue,  String? unitType,  bool done,  DateTime addedAt,  List<ChainPrice> prices,  DateTime? pricesUpdatedAt)?  $default,) {final _that = this;
switch (_that) {
case _BasketItem() when $default != null:
return $default(_that.id,_that.productId,_that.name,_that.unitValue,_that.unitType,_that.done,_that.addedAt,_that.prices,_that.pricesUpdatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _BasketItem extends BasketItem {
  const _BasketItem({required this.id, this.productId, required this.name, this.unitValue, this.unitType, this.done = false, required this.addedAt, final  List<ChainPrice> prices = const <ChainPrice>[], this.pricesUpdatedAt}): _prices = prices,super._();
  

@override final  int id;
@override final  int? productId;
@override final  String name;
@override final  double? unitValue;
@override final  String? unitType;
@override@JsonKey() final  bool done;
@override final  DateTime addedAt;
/// Цены по сетям. Пусто, если позиция ручная либо цены ещё не загружены.
 final  List<ChainPrice> _prices;
/// Цены по сетям. Пусто, если позиция ручная либо цены ещё не загружены.
@override@JsonKey() List<ChainPrice> get prices {
  if (_prices is EqualUnmodifiableListView) return _prices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prices);
}

/// Когда цены обновлялись последний раз. Показывается рядом с суммой:
/// корзина без времени наблюдения — такое же враньё, как цена без него.
@override final  DateTime? pricesUpdatedAt;

/// Create a copy of BasketItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BasketItemCopyWith<_BasketItem> get copyWith => __$BasketItemCopyWithImpl<_BasketItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BasketItem&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.done, done) || other.done == done)&&(identical(other.addedAt, addedAt) || other.addedAt == addedAt)&&const DeepCollectionEquality().equals(other._prices, _prices)&&(identical(other.pricesUpdatedAt, pricesUpdatedAt) || other.pricesUpdatedAt == pricesUpdatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,productId,name,unitValue,unitType,done,addedAt,const DeepCollectionEquality().hash(_prices),pricesUpdatedAt);

@override
String toString() {
  return 'BasketItem(id: $id, productId: $productId, name: $name, unitValue: $unitValue, unitType: $unitType, done: $done, addedAt: $addedAt, prices: $prices, pricesUpdatedAt: $pricesUpdatedAt)';
}


}

/// @nodoc
abstract mixin class _$BasketItemCopyWith<$Res> implements $BasketItemCopyWith<$Res> {
  factory _$BasketItemCopyWith(_BasketItem value, $Res Function(_BasketItem) _then) = __$BasketItemCopyWithImpl;
@override @useResult
$Res call({
 int id, int? productId, String name, double? unitValue, String? unitType, bool done, DateTime addedAt, List<ChainPrice> prices, DateTime? pricesUpdatedAt
});




}
/// @nodoc
class __$BasketItemCopyWithImpl<$Res>
    implements _$BasketItemCopyWith<$Res> {
  __$BasketItemCopyWithImpl(this._self, this._then);

  final _BasketItem _self;
  final $Res Function(_BasketItem) _then;

/// Create a copy of BasketItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = freezed,Object? name = null,Object? unitValue = freezed,Object? unitType = freezed,Object? done = null,Object? addedAt = null,Object? prices = null,Object? pricesUpdatedAt = freezed,}) {
  return _then(_BasketItem(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: freezed == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,unitValue: freezed == unitValue ? _self.unitValue : unitValue // ignore: cast_nullable_to_non_nullable
as double?,unitType: freezed == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String?,done: null == done ? _self.done : done // ignore: cast_nullable_to_non_nullable
as bool,addedAt: null == addedAt ? _self.addedAt : addedAt // ignore: cast_nullable_to_non_nullable
as DateTime,prices: null == prices ? _self._prices : prices // ignore: cast_nullable_to_non_nullable
as List<ChainPrice>,pricesUpdatedAt: freezed == pricesUpdatedAt ? _self.pricesUpdatedAt : pricesUpdatedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
