// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductSummary {

 int get productId; String get name; String? get brand; String? get ean;/// Картинка товара. null примерно у 2% карточек — у сети её нет.
/// Показывать через ProductThumb: он рисует плашку, когда ссылки нет
/// или она не загрузилась.
 String? get imageUrl;/// Фасовка: число и единица. Нужны вместе — «250» без «g» бессмысленно,
/// а у kg_bulk числа нет вовсе, там цена за килограмм.
 double? get unitValue; String? get unitType;/// Лучшая цена в ГЯПИКАХ. null, если её нельзя назвать однозначно.
 int? get bestPriceMinor; String? get bestPriceChain; int get chainsCount; bool get hasPromo;/// Время наблюдения лучшей цены. Показывать цену без него нельзя.
 DateTime? get observedAt;/// У сети с самой низкой ценой прайс зависит от магазина (Bravo),
/// а магазин не выбран.
 bool get needsStoreSelection;
/// Create a copy of ProductSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductSummaryCopyWith<ProductSummary> get copyWith => _$ProductSummaryCopyWithImpl<ProductSummary>(this as ProductSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductSummary&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.bestPriceMinor, bestPriceMinor) || other.bestPriceMinor == bestPriceMinor)&&(identical(other.bestPriceChain, bestPriceChain) || other.bestPriceChain == bestPriceChain)&&(identical(other.chainsCount, chainsCount) || other.chainsCount == chainsCount)&&(identical(other.hasPromo, hasPromo) || other.hasPromo == hasPromo)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.needsStoreSelection, needsStoreSelection) || other.needsStoreSelection == needsStoreSelection));
}


@override
int get hashCode => Object.hash(runtimeType,productId,name,brand,ean,imageUrl,unitValue,unitType,bestPriceMinor,bestPriceChain,chainsCount,hasPromo,observedAt,needsStoreSelection);

@override
String toString() {
  return 'ProductSummary(productId: $productId, name: $name, brand: $brand, ean: $ean, imageUrl: $imageUrl, unitValue: $unitValue, unitType: $unitType, bestPriceMinor: $bestPriceMinor, bestPriceChain: $bestPriceChain, chainsCount: $chainsCount, hasPromo: $hasPromo, observedAt: $observedAt, needsStoreSelection: $needsStoreSelection)';
}


}

/// @nodoc
abstract mixin class $ProductSummaryCopyWith<$Res>  {
  factory $ProductSummaryCopyWith(ProductSummary value, $Res Function(ProductSummary) _then) = _$ProductSummaryCopyWithImpl;
@useResult
$Res call({
 int productId, String name, String? brand, String? ean, String? imageUrl, double? unitValue, String? unitType, int? bestPriceMinor, String? bestPriceChain, int chainsCount, bool hasPromo, DateTime? observedAt, bool needsStoreSelection
});




}
/// @nodoc
class _$ProductSummaryCopyWithImpl<$Res>
    implements $ProductSummaryCopyWith<$Res> {
  _$ProductSummaryCopyWithImpl(this._self, this._then);

  final ProductSummary _self;
  final $Res Function(ProductSummary) _then;

/// Create a copy of ProductSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? name = null,Object? brand = freezed,Object? ean = freezed,Object? imageUrl = freezed,Object? unitValue = freezed,Object? unitType = freezed,Object? bestPriceMinor = freezed,Object? bestPriceChain = freezed,Object? chainsCount = null,Object? hasPromo = null,Object? observedAt = freezed,Object? needsStoreSelection = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,unitValue: freezed == unitValue ? _self.unitValue : unitValue // ignore: cast_nullable_to_non_nullable
as double?,unitType: freezed == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String?,bestPriceMinor: freezed == bestPriceMinor ? _self.bestPriceMinor : bestPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,bestPriceChain: freezed == bestPriceChain ? _self.bestPriceChain : bestPriceChain // ignore: cast_nullable_to_non_nullable
as String?,chainsCount: null == chainsCount ? _self.chainsCount : chainsCount // ignore: cast_nullable_to_non_nullable
as int,hasPromo: null == hasPromo ? _self.hasPromo : hasPromo // ignore: cast_nullable_to_non_nullable
as bool,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,needsStoreSelection: null == needsStoreSelection ? _self.needsStoreSelection : needsStoreSelection // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductSummary].
extension ProductSummaryPatterns on ProductSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductSummary value)  $default,){
final _that = this;
switch (_that) {
case _ProductSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ProductSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  String name,  String? brand,  String? ean,  String? imageUrl,  double? unitValue,  String? unitType,  int? bestPriceMinor,  String? bestPriceChain,  int chainsCount,  bool hasPromo,  DateTime? observedAt,  bool needsStoreSelection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductSummary() when $default != null:
return $default(_that.productId,_that.name,_that.brand,_that.ean,_that.imageUrl,_that.unitValue,_that.unitType,_that.bestPriceMinor,_that.bestPriceChain,_that.chainsCount,_that.hasPromo,_that.observedAt,_that.needsStoreSelection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  String name,  String? brand,  String? ean,  String? imageUrl,  double? unitValue,  String? unitType,  int? bestPriceMinor,  String? bestPriceChain,  int chainsCount,  bool hasPromo,  DateTime? observedAt,  bool needsStoreSelection)  $default,) {final _that = this;
switch (_that) {
case _ProductSummary():
return $default(_that.productId,_that.name,_that.brand,_that.ean,_that.imageUrl,_that.unitValue,_that.unitType,_that.bestPriceMinor,_that.bestPriceChain,_that.chainsCount,_that.hasPromo,_that.observedAt,_that.needsStoreSelection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  String name,  String? brand,  String? ean,  String? imageUrl,  double? unitValue,  String? unitType,  int? bestPriceMinor,  String? bestPriceChain,  int chainsCount,  bool hasPromo,  DateTime? observedAt,  bool needsStoreSelection)?  $default,) {final _that = this;
switch (_that) {
case _ProductSummary() when $default != null:
return $default(_that.productId,_that.name,_that.brand,_that.ean,_that.imageUrl,_that.unitValue,_that.unitType,_that.bestPriceMinor,_that.bestPriceChain,_that.chainsCount,_that.hasPromo,_that.observedAt,_that.needsStoreSelection);case _:
  return null;

}
}

}

/// @nodoc


class _ProductSummary implements ProductSummary {
  const _ProductSummary({required this.productId, required this.name, this.brand, this.ean, this.imageUrl, this.unitValue, this.unitType, this.bestPriceMinor, this.bestPriceChain, required this.chainsCount, required this.hasPromo, this.observedAt, this.needsStoreSelection = false});
  

@override final  int productId;
@override final  String name;
@override final  String? brand;
@override final  String? ean;
/// Картинка товара. null примерно у 2% карточек — у сети её нет.
/// Показывать через ProductThumb: он рисует плашку, когда ссылки нет
/// или она не загрузилась.
@override final  String? imageUrl;
/// Фасовка: число и единица. Нужны вместе — «250» без «g» бессмысленно,
/// а у kg_bulk числа нет вовсе, там цена за килограмм.
@override final  double? unitValue;
@override final  String? unitType;
/// Лучшая цена в ГЯПИКАХ. null, если её нельзя назвать однозначно.
@override final  int? bestPriceMinor;
@override final  String? bestPriceChain;
@override final  int chainsCount;
@override final  bool hasPromo;
/// Время наблюдения лучшей цены. Показывать цену без него нельзя.
@override final  DateTime? observedAt;
/// У сети с самой низкой ценой прайс зависит от магазина (Bravo),
/// а магазин не выбран.
@override@JsonKey() final  bool needsStoreSelection;

/// Create a copy of ProductSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductSummaryCopyWith<_ProductSummary> get copyWith => __$ProductSummaryCopyWithImpl<_ProductSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductSummary&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.bestPriceMinor, bestPriceMinor) || other.bestPriceMinor == bestPriceMinor)&&(identical(other.bestPriceChain, bestPriceChain) || other.bestPriceChain == bestPriceChain)&&(identical(other.chainsCount, chainsCount) || other.chainsCount == chainsCount)&&(identical(other.hasPromo, hasPromo) || other.hasPromo == hasPromo)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.needsStoreSelection, needsStoreSelection) || other.needsStoreSelection == needsStoreSelection));
}


@override
int get hashCode => Object.hash(runtimeType,productId,name,brand,ean,imageUrl,unitValue,unitType,bestPriceMinor,bestPriceChain,chainsCount,hasPromo,observedAt,needsStoreSelection);

@override
String toString() {
  return 'ProductSummary(productId: $productId, name: $name, brand: $brand, ean: $ean, imageUrl: $imageUrl, unitValue: $unitValue, unitType: $unitType, bestPriceMinor: $bestPriceMinor, bestPriceChain: $bestPriceChain, chainsCount: $chainsCount, hasPromo: $hasPromo, observedAt: $observedAt, needsStoreSelection: $needsStoreSelection)';
}


}

/// @nodoc
abstract mixin class _$ProductSummaryCopyWith<$Res> implements $ProductSummaryCopyWith<$Res> {
  factory _$ProductSummaryCopyWith(_ProductSummary value, $Res Function(_ProductSummary) _then) = __$ProductSummaryCopyWithImpl;
@override @useResult
$Res call({
 int productId, String name, String? brand, String? ean, String? imageUrl, double? unitValue, String? unitType, int? bestPriceMinor, String? bestPriceChain, int chainsCount, bool hasPromo, DateTime? observedAt, bool needsStoreSelection
});




}
/// @nodoc
class __$ProductSummaryCopyWithImpl<$Res>
    implements _$ProductSummaryCopyWith<$Res> {
  __$ProductSummaryCopyWithImpl(this._self, this._then);

  final _ProductSummary _self;
  final $Res Function(_ProductSummary) _then;

/// Create a copy of ProductSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? name = null,Object? brand = freezed,Object? ean = freezed,Object? imageUrl = freezed,Object? unitValue = freezed,Object? unitType = freezed,Object? bestPriceMinor = freezed,Object? bestPriceChain = freezed,Object? chainsCount = null,Object? hasPromo = null,Object? observedAt = freezed,Object? needsStoreSelection = null,}) {
  return _then(_ProductSummary(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,unitValue: freezed == unitValue ? _self.unitValue : unitValue // ignore: cast_nullable_to_non_nullable
as double?,unitType: freezed == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String?,bestPriceMinor: freezed == bestPriceMinor ? _self.bestPriceMinor : bestPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,bestPriceChain: freezed == bestPriceChain ? _self.bestPriceChain : bestPriceChain // ignore: cast_nullable_to_non_nullable
as String?,chainsCount: null == chainsCount ? _self.chainsCount : chainsCount // ignore: cast_nullable_to_non_nullable
as int,hasPromo: null == hasPromo ? _self.hasPromo : hasPromo // ignore: cast_nullable_to_non_nullable
as bool,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,needsStoreSelection: null == needsStoreSelection ? _self.needsStoreSelection : needsStoreSelection // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
