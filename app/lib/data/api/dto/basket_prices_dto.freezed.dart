// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'basket_prices_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BasketPricesDto {

 List<BasketProductDto> get items;/// Запрошенные товары, которых нет: удалены либо склейка в карантине.
/// Клиенту важно отличать «нет цены» от «мы это потеряли».
 List<int> get missing;@JsonKey(name: 'stale_after_hours') int get staleAfterHours;
/// Create a copy of BasketPricesDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BasketPricesDtoCopyWith<BasketPricesDto> get copyWith => _$BasketPricesDtoCopyWithImpl<BasketPricesDto>(this as BasketPricesDto, _$identity);

  /// Serializes this BasketPricesDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BasketPricesDto&&const DeepCollectionEquality().equals(other.items, items)&&const DeepCollectionEquality().equals(other.missing, missing)&&(identical(other.staleAfterHours, staleAfterHours) || other.staleAfterHours == staleAfterHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),const DeepCollectionEquality().hash(missing),staleAfterHours);

@override
String toString() {
  return 'BasketPricesDto(items: $items, missing: $missing, staleAfterHours: $staleAfterHours)';
}


}

/// @nodoc
abstract mixin class $BasketPricesDtoCopyWith<$Res>  {
  factory $BasketPricesDtoCopyWith(BasketPricesDto value, $Res Function(BasketPricesDto) _then) = _$BasketPricesDtoCopyWithImpl;
@useResult
$Res call({
 List<BasketProductDto> items, List<int> missing,@JsonKey(name: 'stale_after_hours') int staleAfterHours
});




}
/// @nodoc
class _$BasketPricesDtoCopyWithImpl<$Res>
    implements $BasketPricesDtoCopyWith<$Res> {
  _$BasketPricesDtoCopyWithImpl(this._self, this._then);

  final BasketPricesDto _self;
  final $Res Function(BasketPricesDto) _then;

/// Create a copy of BasketPricesDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? missing = null,Object? staleAfterHours = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<BasketProductDto>,missing: null == missing ? _self.missing : missing // ignore: cast_nullable_to_non_nullable
as List<int>,staleAfterHours: null == staleAfterHours ? _self.staleAfterHours : staleAfterHours // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [BasketPricesDto].
extension BasketPricesDtoPatterns on BasketPricesDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BasketPricesDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BasketPricesDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BasketPricesDto value)  $default,){
final _that = this;
switch (_that) {
case _BasketPricesDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BasketPricesDto value)?  $default,){
final _that = this;
switch (_that) {
case _BasketPricesDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BasketProductDto> items,  List<int> missing, @JsonKey(name: 'stale_after_hours')  int staleAfterHours)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BasketPricesDto() when $default != null:
return $default(_that.items,_that.missing,_that.staleAfterHours);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BasketProductDto> items,  List<int> missing, @JsonKey(name: 'stale_after_hours')  int staleAfterHours)  $default,) {final _that = this;
switch (_that) {
case _BasketPricesDto():
return $default(_that.items,_that.missing,_that.staleAfterHours);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BasketProductDto> items,  List<int> missing, @JsonKey(name: 'stale_after_hours')  int staleAfterHours)?  $default,) {final _that = this;
switch (_that) {
case _BasketPricesDto() when $default != null:
return $default(_that.items,_that.missing,_that.staleAfterHours);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BasketPricesDto implements BasketPricesDto {
  const _BasketPricesDto({required final  List<BasketProductDto> items, required final  List<int> missing, @JsonKey(name: 'stale_after_hours') required this.staleAfterHours}): _items = items,_missing = missing;
  factory _BasketPricesDto.fromJson(Map<String, dynamic> json) => _$BasketPricesDtoFromJson(json);

 final  List<BasketProductDto> _items;
@override List<BasketProductDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// Запрошенные товары, которых нет: удалены либо склейка в карантине.
/// Клиенту важно отличать «нет цены» от «мы это потеряли».
 final  List<int> _missing;
/// Запрошенные товары, которых нет: удалены либо склейка в карантине.
/// Клиенту важно отличать «нет цены» от «мы это потеряли».
@override List<int> get missing {
  if (_missing is EqualUnmodifiableListView) return _missing;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_missing);
}

@override@JsonKey(name: 'stale_after_hours') final  int staleAfterHours;

/// Create a copy of BasketPricesDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BasketPricesDtoCopyWith<_BasketPricesDto> get copyWith => __$BasketPricesDtoCopyWithImpl<_BasketPricesDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BasketPricesDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BasketPricesDto&&const DeepCollectionEquality().equals(other._items, _items)&&const DeepCollectionEquality().equals(other._missing, _missing)&&(identical(other.staleAfterHours, staleAfterHours) || other.staleAfterHours == staleAfterHours));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),const DeepCollectionEquality().hash(_missing),staleAfterHours);

@override
String toString() {
  return 'BasketPricesDto(items: $items, missing: $missing, staleAfterHours: $staleAfterHours)';
}


}

/// @nodoc
abstract mixin class _$BasketPricesDtoCopyWith<$Res> implements $BasketPricesDtoCopyWith<$Res> {
  factory _$BasketPricesDtoCopyWith(_BasketPricesDto value, $Res Function(_BasketPricesDto) _then) = __$BasketPricesDtoCopyWithImpl;
@override @useResult
$Res call({
 List<BasketProductDto> items, List<int> missing,@JsonKey(name: 'stale_after_hours') int staleAfterHours
});




}
/// @nodoc
class __$BasketPricesDtoCopyWithImpl<$Res>
    implements _$BasketPricesDtoCopyWith<$Res> {
  __$BasketPricesDtoCopyWithImpl(this._self, this._then);

  final _BasketPricesDto _self;
  final $Res Function(_BasketPricesDto) _then;

/// Create a copy of BasketPricesDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? missing = null,Object? staleAfterHours = null,}) {
  return _then(_BasketPricesDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<BasketProductDto>,missing: null == missing ? _self._missing : missing // ignore: cast_nullable_to_non_nullable
as List<int>,staleAfterHours: null == staleAfterHours ? _self.staleAfterHours : staleAfterHours // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$BasketProductDto {

@JsonKey(name: 'product_id') int get productId; String get name; String? get brand; String? get ean;@JsonKey(name: 'unit_value') double? get unitValue;@JsonKey(name: 'unit_type') String? get unitType; List<ChainPriceDto> get prices;
/// Create a copy of BasketProductDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BasketProductDtoCopyWith<BasketProductDto> get copyWith => _$BasketProductDtoCopyWithImpl<BasketProductDto>(this as BasketProductDto, _$identity);

  /// Serializes this BasketProductDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BasketProductDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&const DeepCollectionEquality().equals(other.prices, prices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,name,brand,ean,unitValue,unitType,const DeepCollectionEquality().hash(prices));

@override
String toString() {
  return 'BasketProductDto(productId: $productId, name: $name, brand: $brand, ean: $ean, unitValue: $unitValue, unitType: $unitType, prices: $prices)';
}


}

/// @nodoc
abstract mixin class $BasketProductDtoCopyWith<$Res>  {
  factory $BasketProductDtoCopyWith(BasketProductDto value, $Res Function(BasketProductDto) _then) = _$BasketProductDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') int productId, String name, String? brand, String? ean,@JsonKey(name: 'unit_value') double? unitValue,@JsonKey(name: 'unit_type') String? unitType, List<ChainPriceDto> prices
});




}
/// @nodoc
class _$BasketProductDtoCopyWithImpl<$Res>
    implements $BasketProductDtoCopyWith<$Res> {
  _$BasketProductDtoCopyWithImpl(this._self, this._then);

  final BasketProductDto _self;
  final $Res Function(BasketProductDto) _then;

/// Create a copy of BasketProductDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? name = null,Object? brand = freezed,Object? ean = freezed,Object? unitValue = freezed,Object? unitType = freezed,Object? prices = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
as String?,unitValue: freezed == unitValue ? _self.unitValue : unitValue // ignore: cast_nullable_to_non_nullable
as double?,unitType: freezed == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String?,prices: null == prices ? _self.prices : prices // ignore: cast_nullable_to_non_nullable
as List<ChainPriceDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [BasketProductDto].
extension BasketProductDtoPatterns on BasketProductDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BasketProductDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BasketProductDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BasketProductDto value)  $default,){
final _that = this;
switch (_that) {
case _BasketProductDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BasketProductDto value)?  $default,){
final _that = this;
switch (_that) {
case _BasketProductDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  int productId,  String name,  String? brand,  String? ean, @JsonKey(name: 'unit_value')  double? unitValue, @JsonKey(name: 'unit_type')  String? unitType,  List<ChainPriceDto> prices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BasketProductDto() when $default != null:
return $default(_that.productId,_that.name,_that.brand,_that.ean,_that.unitValue,_that.unitType,_that.prices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  int productId,  String name,  String? brand,  String? ean, @JsonKey(name: 'unit_value')  double? unitValue, @JsonKey(name: 'unit_type')  String? unitType,  List<ChainPriceDto> prices)  $default,) {final _that = this;
switch (_that) {
case _BasketProductDto():
return $default(_that.productId,_that.name,_that.brand,_that.ean,_that.unitValue,_that.unitType,_that.prices);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  int productId,  String name,  String? brand,  String? ean, @JsonKey(name: 'unit_value')  double? unitValue, @JsonKey(name: 'unit_type')  String? unitType,  List<ChainPriceDto> prices)?  $default,) {final _that = this;
switch (_that) {
case _BasketProductDto() when $default != null:
return $default(_that.productId,_that.name,_that.brand,_that.ean,_that.unitValue,_that.unitType,_that.prices);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _BasketProductDto implements BasketProductDto {
  const _BasketProductDto({@JsonKey(name: 'product_id') required this.productId, required this.name, this.brand, this.ean, @JsonKey(name: 'unit_value') this.unitValue, @JsonKey(name: 'unit_type') this.unitType, required final  List<ChainPriceDto> prices}): _prices = prices;
  factory _BasketProductDto.fromJson(Map<String, dynamic> json) => _$BasketProductDtoFromJson(json);

@override@JsonKey(name: 'product_id') final  int productId;
@override final  String name;
@override final  String? brand;
@override final  String? ean;
@override@JsonKey(name: 'unit_value') final  double? unitValue;
@override@JsonKey(name: 'unit_type') final  String? unitType;
 final  List<ChainPriceDto> _prices;
@override List<ChainPriceDto> get prices {
  if (_prices is EqualUnmodifiableListView) return _prices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prices);
}


/// Create a copy of BasketProductDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BasketProductDtoCopyWith<_BasketProductDto> get copyWith => __$BasketProductDtoCopyWithImpl<_BasketProductDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$BasketProductDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BasketProductDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&const DeepCollectionEquality().equals(other._prices, _prices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,name,brand,ean,unitValue,unitType,const DeepCollectionEquality().hash(_prices));

@override
String toString() {
  return 'BasketProductDto(productId: $productId, name: $name, brand: $brand, ean: $ean, unitValue: $unitValue, unitType: $unitType, prices: $prices)';
}


}

/// @nodoc
abstract mixin class _$BasketProductDtoCopyWith<$Res> implements $BasketProductDtoCopyWith<$Res> {
  factory _$BasketProductDtoCopyWith(_BasketProductDto value, $Res Function(_BasketProductDto) _then) = __$BasketProductDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') int productId, String name, String? brand, String? ean,@JsonKey(name: 'unit_value') double? unitValue,@JsonKey(name: 'unit_type') String? unitType, List<ChainPriceDto> prices
});




}
/// @nodoc
class __$BasketProductDtoCopyWithImpl<$Res>
    implements _$BasketProductDtoCopyWith<$Res> {
  __$BasketProductDtoCopyWithImpl(this._self, this._then);

  final _BasketProductDto _self;
  final $Res Function(_BasketProductDto) _then;

/// Create a copy of BasketProductDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? name = null,Object? brand = freezed,Object? ean = freezed,Object? unitValue = freezed,Object? unitType = freezed,Object? prices = null,}) {
  return _then(_BasketProductDto(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
as String?,unitValue: freezed == unitValue ? _self.unitValue : unitValue // ignore: cast_nullable_to_non_nullable
as double?,unitType: freezed == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String?,prices: null == prices ? _self._prices : prices // ignore: cast_nullable_to_non_nullable
as List<ChainPriceDto>,
  ));
}


}

// dart format on
