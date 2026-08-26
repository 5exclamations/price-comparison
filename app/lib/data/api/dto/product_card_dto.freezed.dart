// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_card_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProductCardDto {

@JsonKey(name: 'product_id') int get productId; String get name; String? get brand; String? get ean;@JsonKey(name: 'image_url') String? get imageUrl;@JsonKey(name: 'unit_value') double? get unitValue;@JsonKey(name: 'unit_type') String? get unitType; List<ChainPriceDto> get prices;@JsonKey(name: 'chains_count') int get chainsCount;@JsonKey(name: 'best_price_minor') int? get bestPriceMinor;@JsonKey(name: 'best_price_chain') String? get bestPriceChain;@JsonKey(name: 'needs_store_selection') List<String> get needsStoreSelection;
/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCardDtoCopyWith<ProductCardDto> get copyWith => _$ProductCardDtoCopyWithImpl<ProductCardDto>(this as ProductCardDto, _$identity);

  /// Serializes this ProductCardDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductCardDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&const DeepCollectionEquality().equals(other.prices, prices)&&(identical(other.chainsCount, chainsCount) || other.chainsCount == chainsCount)&&(identical(other.bestPriceMinor, bestPriceMinor) || other.bestPriceMinor == bestPriceMinor)&&(identical(other.bestPriceChain, bestPriceChain) || other.bestPriceChain == bestPriceChain)&&const DeepCollectionEquality().equals(other.needsStoreSelection, needsStoreSelection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,name,brand,ean,imageUrl,unitValue,unitType,const DeepCollectionEquality().hash(prices),chainsCount,bestPriceMinor,bestPriceChain,const DeepCollectionEquality().hash(needsStoreSelection));

@override
String toString() {
  return 'ProductCardDto(productId: $productId, name: $name, brand: $brand, ean: $ean, imageUrl: $imageUrl, unitValue: $unitValue, unitType: $unitType, prices: $prices, chainsCount: $chainsCount, bestPriceMinor: $bestPriceMinor, bestPriceChain: $bestPriceChain, needsStoreSelection: $needsStoreSelection)';
}


}

/// @nodoc
abstract mixin class $ProductCardDtoCopyWith<$Res>  {
  factory $ProductCardDtoCopyWith(ProductCardDto value, $Res Function(ProductCardDto) _then) = _$ProductCardDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') int productId, String name, String? brand, String? ean,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'unit_value') double? unitValue,@JsonKey(name: 'unit_type') String? unitType, List<ChainPriceDto> prices,@JsonKey(name: 'chains_count') int chainsCount,@JsonKey(name: 'best_price_minor') int? bestPriceMinor,@JsonKey(name: 'best_price_chain') String? bestPriceChain,@JsonKey(name: 'needs_store_selection') List<String> needsStoreSelection
});




}
/// @nodoc
class _$ProductCardDtoCopyWithImpl<$Res>
    implements $ProductCardDtoCopyWith<$Res> {
  _$ProductCardDtoCopyWithImpl(this._self, this._then);

  final ProductCardDto _self;
  final $Res Function(ProductCardDto) _then;

/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? name = null,Object? brand = freezed,Object? ean = freezed,Object? imageUrl = freezed,Object? unitValue = freezed,Object? unitType = freezed,Object? prices = null,Object? chainsCount = null,Object? bestPriceMinor = freezed,Object? bestPriceChain = freezed,Object? needsStoreSelection = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,unitValue: freezed == unitValue ? _self.unitValue : unitValue // ignore: cast_nullable_to_non_nullable
as double?,unitType: freezed == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String?,prices: null == prices ? _self.prices : prices // ignore: cast_nullable_to_non_nullable
as List<ChainPriceDto>,chainsCount: null == chainsCount ? _self.chainsCount : chainsCount // ignore: cast_nullable_to_non_nullable
as int,bestPriceMinor: freezed == bestPriceMinor ? _self.bestPriceMinor : bestPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,bestPriceChain: freezed == bestPriceChain ? _self.bestPriceChain : bestPriceChain // ignore: cast_nullable_to_non_nullable
as String?,needsStoreSelection: null == needsStoreSelection ? _self.needsStoreSelection : needsStoreSelection // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductCardDto].
extension ProductCardDtoPatterns on ProductCardDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductCardDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductCardDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductCardDto value)  $default,){
final _that = this;
switch (_that) {
case _ProductCardDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductCardDto value)?  $default,){
final _that = this;
switch (_that) {
case _ProductCardDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  int productId,  String name,  String? brand,  String? ean, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'unit_value')  double? unitValue, @JsonKey(name: 'unit_type')  String? unitType,  List<ChainPriceDto> prices, @JsonKey(name: 'chains_count')  int chainsCount, @JsonKey(name: 'best_price_minor')  int? bestPriceMinor, @JsonKey(name: 'best_price_chain')  String? bestPriceChain, @JsonKey(name: 'needs_store_selection')  List<String> needsStoreSelection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductCardDto() when $default != null:
return $default(_that.productId,_that.name,_that.brand,_that.ean,_that.imageUrl,_that.unitValue,_that.unitType,_that.prices,_that.chainsCount,_that.bestPriceMinor,_that.bestPriceChain,_that.needsStoreSelection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  int productId,  String name,  String? brand,  String? ean, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'unit_value')  double? unitValue, @JsonKey(name: 'unit_type')  String? unitType,  List<ChainPriceDto> prices, @JsonKey(name: 'chains_count')  int chainsCount, @JsonKey(name: 'best_price_minor')  int? bestPriceMinor, @JsonKey(name: 'best_price_chain')  String? bestPriceChain, @JsonKey(name: 'needs_store_selection')  List<String> needsStoreSelection)  $default,) {final _that = this;
switch (_that) {
case _ProductCardDto():
return $default(_that.productId,_that.name,_that.brand,_that.ean,_that.imageUrl,_that.unitValue,_that.unitType,_that.prices,_that.chainsCount,_that.bestPriceMinor,_that.bestPriceChain,_that.needsStoreSelection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  int productId,  String name,  String? brand,  String? ean, @JsonKey(name: 'image_url')  String? imageUrl, @JsonKey(name: 'unit_value')  double? unitValue, @JsonKey(name: 'unit_type')  String? unitType,  List<ChainPriceDto> prices, @JsonKey(name: 'chains_count')  int chainsCount, @JsonKey(name: 'best_price_minor')  int? bestPriceMinor, @JsonKey(name: 'best_price_chain')  String? bestPriceChain, @JsonKey(name: 'needs_store_selection')  List<String> needsStoreSelection)?  $default,) {final _that = this;
switch (_that) {
case _ProductCardDto() when $default != null:
return $default(_that.productId,_that.name,_that.brand,_that.ean,_that.imageUrl,_that.unitValue,_that.unitType,_that.prices,_that.chainsCount,_that.bestPriceMinor,_that.bestPriceChain,_that.needsStoreSelection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProductCardDto implements ProductCardDto {
  const _ProductCardDto({@JsonKey(name: 'product_id') required this.productId, required this.name, this.brand, this.ean, @JsonKey(name: 'image_url') this.imageUrl, @JsonKey(name: 'unit_value') this.unitValue, @JsonKey(name: 'unit_type') this.unitType, required final  List<ChainPriceDto> prices, @JsonKey(name: 'chains_count') required this.chainsCount, @JsonKey(name: 'best_price_minor') this.bestPriceMinor, @JsonKey(name: 'best_price_chain') this.bestPriceChain, @JsonKey(name: 'needs_store_selection') final  List<String> needsStoreSelection = const <String>[]}): _prices = prices,_needsStoreSelection = needsStoreSelection;
  factory _ProductCardDto.fromJson(Map<String, dynamic> json) => _$ProductCardDtoFromJson(json);

@override@JsonKey(name: 'product_id') final  int productId;
@override final  String name;
@override final  String? brand;
@override final  String? ean;
@override@JsonKey(name: 'image_url') final  String? imageUrl;
@override@JsonKey(name: 'unit_value') final  double? unitValue;
@override@JsonKey(name: 'unit_type') final  String? unitType;
 final  List<ChainPriceDto> _prices;
@override List<ChainPriceDto> get prices {
  if (_prices is EqualUnmodifiableListView) return _prices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prices);
}

@override@JsonKey(name: 'chains_count') final  int chainsCount;
@override@JsonKey(name: 'best_price_minor') final  int? bestPriceMinor;
@override@JsonKey(name: 'best_price_chain') final  String? bestPriceChain;
 final  List<String> _needsStoreSelection;
@override@JsonKey(name: 'needs_store_selection') List<String> get needsStoreSelection {
  if (_needsStoreSelection is EqualUnmodifiableListView) return _needsStoreSelection;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_needsStoreSelection);
}


/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCardDtoCopyWith<_ProductCardDto> get copyWith => __$ProductCardDtoCopyWithImpl<_ProductCardDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProductCardDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductCardDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&const DeepCollectionEquality().equals(other._prices, _prices)&&(identical(other.chainsCount, chainsCount) || other.chainsCount == chainsCount)&&(identical(other.bestPriceMinor, bestPriceMinor) || other.bestPriceMinor == bestPriceMinor)&&(identical(other.bestPriceChain, bestPriceChain) || other.bestPriceChain == bestPriceChain)&&const DeepCollectionEquality().equals(other._needsStoreSelection, _needsStoreSelection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,name,brand,ean,imageUrl,unitValue,unitType,const DeepCollectionEquality().hash(_prices),chainsCount,bestPriceMinor,bestPriceChain,const DeepCollectionEquality().hash(_needsStoreSelection));

@override
String toString() {
  return 'ProductCardDto(productId: $productId, name: $name, brand: $brand, ean: $ean, imageUrl: $imageUrl, unitValue: $unitValue, unitType: $unitType, prices: $prices, chainsCount: $chainsCount, bestPriceMinor: $bestPriceMinor, bestPriceChain: $bestPriceChain, needsStoreSelection: $needsStoreSelection)';
}


}

/// @nodoc
abstract mixin class _$ProductCardDtoCopyWith<$Res> implements $ProductCardDtoCopyWith<$Res> {
  factory _$ProductCardDtoCopyWith(_ProductCardDto value, $Res Function(_ProductCardDto) _then) = __$ProductCardDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') int productId, String name, String? brand, String? ean,@JsonKey(name: 'image_url') String? imageUrl,@JsonKey(name: 'unit_value') double? unitValue,@JsonKey(name: 'unit_type') String? unitType, List<ChainPriceDto> prices,@JsonKey(name: 'chains_count') int chainsCount,@JsonKey(name: 'best_price_minor') int? bestPriceMinor,@JsonKey(name: 'best_price_chain') String? bestPriceChain,@JsonKey(name: 'needs_store_selection') List<String> needsStoreSelection
});




}
/// @nodoc
class __$ProductCardDtoCopyWithImpl<$Res>
    implements _$ProductCardDtoCopyWith<$Res> {
  __$ProductCardDtoCopyWithImpl(this._self, this._then);

  final _ProductCardDto _self;
  final $Res Function(_ProductCardDto) _then;

/// Create a copy of ProductCardDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? name = null,Object? brand = freezed,Object? ean = freezed,Object? imageUrl = freezed,Object? unitValue = freezed,Object? unitType = freezed,Object? prices = null,Object? chainsCount = null,Object? bestPriceMinor = freezed,Object? bestPriceChain = freezed,Object? needsStoreSelection = null,}) {
  return _then(_ProductCardDto(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,unitValue: freezed == unitValue ? _self.unitValue : unitValue // ignore: cast_nullable_to_non_nullable
as double?,unitType: freezed == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String?,prices: null == prices ? _self._prices : prices // ignore: cast_nullable_to_non_nullable
as List<ChainPriceDto>,chainsCount: null == chainsCount ? _self.chainsCount : chainsCount // ignore: cast_nullable_to_non_nullable
as int,bestPriceMinor: freezed == bestPriceMinor ? _self.bestPriceMinor : bestPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,bestPriceChain: freezed == bestPriceChain ? _self.bestPriceChain : bestPriceChain // ignore: cast_nullable_to_non_nullable
as String?,needsStoreSelection: null == needsStoreSelection ? _self._needsStoreSelection : needsStoreSelection // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$ChainPriceDto {

@JsonKey(name: 'chain_id') int get chainId;@JsonKey(name: 'chain_code') String get chainCode;@JsonKey(name: 'chain_name') String get chainName;@JsonKey(name: 'price_model') String get priceModel;@JsonKey(name: 'store_id') int? get storeId;@JsonKey(name: 'store_name') String? get storeName;@JsonKey(name: 'price_cluster') String? get priceCluster;@JsonKey(name: 'price_minor') int get priceMinor;@JsonKey(name: 'old_price_minor') int? get oldPriceMinor;@JsonKey(name: 'is_promo') bool get isPromo; bool get available;@JsonKey(name: 'observed_at') DateTime get observedAt; String get source;@JsonKey(name: 'requires_store_selection') bool get requiresStoreSelection;
/// Create a copy of ChainPriceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChainPriceDtoCopyWith<ChainPriceDto> get copyWith => _$ChainPriceDtoCopyWithImpl<ChainPriceDto>(this as ChainPriceDto, _$identity);

  /// Serializes this ChainPriceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChainPriceDto&&(identical(other.chainId, chainId) || other.chainId == chainId)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.chainName, chainName) || other.chainName == chainName)&&(identical(other.priceModel, priceModel) || other.priceModel == priceModel)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.priceCluster, priceCluster) || other.priceCluster == priceCluster)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.isPromo, isPromo) || other.isPromo == isPromo)&&(identical(other.available, available) || other.available == available)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.source, source) || other.source == source)&&(identical(other.requiresStoreSelection, requiresStoreSelection) || other.requiresStoreSelection == requiresStoreSelection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chainId,chainCode,chainName,priceModel,storeId,storeName,priceCluster,priceMinor,oldPriceMinor,isPromo,available,observedAt,source,requiresStoreSelection);

@override
String toString() {
  return 'ChainPriceDto(chainId: $chainId, chainCode: $chainCode, chainName: $chainName, priceModel: $priceModel, storeId: $storeId, storeName: $storeName, priceCluster: $priceCluster, priceMinor: $priceMinor, oldPriceMinor: $oldPriceMinor, isPromo: $isPromo, available: $available, observedAt: $observedAt, source: $source, requiresStoreSelection: $requiresStoreSelection)';
}


}

/// @nodoc
abstract mixin class $ChainPriceDtoCopyWith<$Res>  {
  factory $ChainPriceDtoCopyWith(ChainPriceDto value, $Res Function(ChainPriceDto) _then) = _$ChainPriceDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'chain_id') int chainId,@JsonKey(name: 'chain_code') String chainCode,@JsonKey(name: 'chain_name') String chainName,@JsonKey(name: 'price_model') String priceModel,@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'store_name') String? storeName,@JsonKey(name: 'price_cluster') String? priceCluster,@JsonKey(name: 'price_minor') int priceMinor,@JsonKey(name: 'old_price_minor') int? oldPriceMinor,@JsonKey(name: 'is_promo') bool isPromo, bool available,@JsonKey(name: 'observed_at') DateTime observedAt, String source,@JsonKey(name: 'requires_store_selection') bool requiresStoreSelection
});




}
/// @nodoc
class _$ChainPriceDtoCopyWithImpl<$Res>
    implements $ChainPriceDtoCopyWith<$Res> {
  _$ChainPriceDtoCopyWithImpl(this._self, this._then);

  final ChainPriceDto _self;
  final $Res Function(ChainPriceDto) _then;

/// Create a copy of ChainPriceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chainId = null,Object? chainCode = null,Object? chainName = null,Object? priceModel = null,Object? storeId = freezed,Object? storeName = freezed,Object? priceCluster = freezed,Object? priceMinor = null,Object? oldPriceMinor = freezed,Object? isPromo = null,Object? available = null,Object? observedAt = null,Object? source = null,Object? requiresStoreSelection = null,}) {
  return _then(_self.copyWith(
chainId: null == chainId ? _self.chainId : chainId // ignore: cast_nullable_to_non_nullable
as int,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,chainName: null == chainName ? _self.chainName : chainName // ignore: cast_nullable_to_non_nullable
as String,priceModel: null == priceModel ? _self.priceModel : priceModel // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,priceCluster: freezed == priceCluster ? _self.priceCluster : priceCluster // ignore: cast_nullable_to_non_nullable
as String?,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,oldPriceMinor: freezed == oldPriceMinor ? _self.oldPriceMinor : oldPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,isPromo: null == isPromo ? _self.isPromo : isPromo // ignore: cast_nullable_to_non_nullable
as bool,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,requiresStoreSelection: null == requiresStoreSelection ? _self.requiresStoreSelection : requiresStoreSelection // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ChainPriceDto].
extension ChainPriceDtoPatterns on ChainPriceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChainPriceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChainPriceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChainPriceDto value)  $default,){
final _that = this;
switch (_that) {
case _ChainPriceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChainPriceDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChainPriceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'chain_id')  int chainId, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'chain_name')  String chainName, @JsonKey(name: 'price_model')  String priceModel, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'price_cluster')  String? priceCluster, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'old_price_minor')  int? oldPriceMinor, @JsonKey(name: 'is_promo')  bool isPromo,  bool available, @JsonKey(name: 'observed_at')  DateTime observedAt,  String source, @JsonKey(name: 'requires_store_selection')  bool requiresStoreSelection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChainPriceDto() when $default != null:
return $default(_that.chainId,_that.chainCode,_that.chainName,_that.priceModel,_that.storeId,_that.storeName,_that.priceCluster,_that.priceMinor,_that.oldPriceMinor,_that.isPromo,_that.available,_that.observedAt,_that.source,_that.requiresStoreSelection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'chain_id')  int chainId, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'chain_name')  String chainName, @JsonKey(name: 'price_model')  String priceModel, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'price_cluster')  String? priceCluster, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'old_price_minor')  int? oldPriceMinor, @JsonKey(name: 'is_promo')  bool isPromo,  bool available, @JsonKey(name: 'observed_at')  DateTime observedAt,  String source, @JsonKey(name: 'requires_store_selection')  bool requiresStoreSelection)  $default,) {final _that = this;
switch (_that) {
case _ChainPriceDto():
return $default(_that.chainId,_that.chainCode,_that.chainName,_that.priceModel,_that.storeId,_that.storeName,_that.priceCluster,_that.priceMinor,_that.oldPriceMinor,_that.isPromo,_that.available,_that.observedAt,_that.source,_that.requiresStoreSelection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'chain_id')  int chainId, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'chain_name')  String chainName, @JsonKey(name: 'price_model')  String priceModel, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'price_cluster')  String? priceCluster, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'old_price_minor')  int? oldPriceMinor, @JsonKey(name: 'is_promo')  bool isPromo,  bool available, @JsonKey(name: 'observed_at')  DateTime observedAt,  String source, @JsonKey(name: 'requires_store_selection')  bool requiresStoreSelection)?  $default,) {final _that = this;
switch (_that) {
case _ChainPriceDto() when $default != null:
return $default(_that.chainId,_that.chainCode,_that.chainName,_that.priceModel,_that.storeId,_that.storeName,_that.priceCluster,_that.priceMinor,_that.oldPriceMinor,_that.isPromo,_that.available,_that.observedAt,_that.source,_that.requiresStoreSelection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChainPriceDto implements ChainPriceDto {
  const _ChainPriceDto({@JsonKey(name: 'chain_id') required this.chainId, @JsonKey(name: 'chain_code') required this.chainCode, @JsonKey(name: 'chain_name') required this.chainName, @JsonKey(name: 'price_model') required this.priceModel, @JsonKey(name: 'store_id') this.storeId, @JsonKey(name: 'store_name') this.storeName, @JsonKey(name: 'price_cluster') this.priceCluster, @JsonKey(name: 'price_minor') required this.priceMinor, @JsonKey(name: 'old_price_minor') this.oldPriceMinor, @JsonKey(name: 'is_promo') required this.isPromo, required this.available, @JsonKey(name: 'observed_at') required this.observedAt, required this.source, @JsonKey(name: 'requires_store_selection') this.requiresStoreSelection = false});
  factory _ChainPriceDto.fromJson(Map<String, dynamic> json) => _$ChainPriceDtoFromJson(json);

@override@JsonKey(name: 'chain_id') final  int chainId;
@override@JsonKey(name: 'chain_code') final  String chainCode;
@override@JsonKey(name: 'chain_name') final  String chainName;
@override@JsonKey(name: 'price_model') final  String priceModel;
@override@JsonKey(name: 'store_id') final  int? storeId;
@override@JsonKey(name: 'store_name') final  String? storeName;
@override@JsonKey(name: 'price_cluster') final  String? priceCluster;
@override@JsonKey(name: 'price_minor') final  int priceMinor;
@override@JsonKey(name: 'old_price_minor') final  int? oldPriceMinor;
@override@JsonKey(name: 'is_promo') final  bool isPromo;
@override final  bool available;
@override@JsonKey(name: 'observed_at') final  DateTime observedAt;
@override final  String source;
@override@JsonKey(name: 'requires_store_selection') final  bool requiresStoreSelection;

/// Create a copy of ChainPriceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChainPriceDtoCopyWith<_ChainPriceDto> get copyWith => __$ChainPriceDtoCopyWithImpl<_ChainPriceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChainPriceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChainPriceDto&&(identical(other.chainId, chainId) || other.chainId == chainId)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.chainName, chainName) || other.chainName == chainName)&&(identical(other.priceModel, priceModel) || other.priceModel == priceModel)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.priceCluster, priceCluster) || other.priceCluster == priceCluster)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.isPromo, isPromo) || other.isPromo == isPromo)&&(identical(other.available, available) || other.available == available)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.source, source) || other.source == source)&&(identical(other.requiresStoreSelection, requiresStoreSelection) || other.requiresStoreSelection == requiresStoreSelection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chainId,chainCode,chainName,priceModel,storeId,storeName,priceCluster,priceMinor,oldPriceMinor,isPromo,available,observedAt,source,requiresStoreSelection);

@override
String toString() {
  return 'ChainPriceDto(chainId: $chainId, chainCode: $chainCode, chainName: $chainName, priceModel: $priceModel, storeId: $storeId, storeName: $storeName, priceCluster: $priceCluster, priceMinor: $priceMinor, oldPriceMinor: $oldPriceMinor, isPromo: $isPromo, available: $available, observedAt: $observedAt, source: $source, requiresStoreSelection: $requiresStoreSelection)';
}


}

/// @nodoc
abstract mixin class _$ChainPriceDtoCopyWith<$Res> implements $ChainPriceDtoCopyWith<$Res> {
  factory _$ChainPriceDtoCopyWith(_ChainPriceDto value, $Res Function(_ChainPriceDto) _then) = __$ChainPriceDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'chain_id') int chainId,@JsonKey(name: 'chain_code') String chainCode,@JsonKey(name: 'chain_name') String chainName,@JsonKey(name: 'price_model') String priceModel,@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'store_name') String? storeName,@JsonKey(name: 'price_cluster') String? priceCluster,@JsonKey(name: 'price_minor') int priceMinor,@JsonKey(name: 'old_price_minor') int? oldPriceMinor,@JsonKey(name: 'is_promo') bool isPromo, bool available,@JsonKey(name: 'observed_at') DateTime observedAt, String source,@JsonKey(name: 'requires_store_selection') bool requiresStoreSelection
});




}
/// @nodoc
class __$ChainPriceDtoCopyWithImpl<$Res>
    implements _$ChainPriceDtoCopyWith<$Res> {
  __$ChainPriceDtoCopyWithImpl(this._self, this._then);

  final _ChainPriceDto _self;
  final $Res Function(_ChainPriceDto) _then;

/// Create a copy of ChainPriceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chainId = null,Object? chainCode = null,Object? chainName = null,Object? priceModel = null,Object? storeId = freezed,Object? storeName = freezed,Object? priceCluster = freezed,Object? priceMinor = null,Object? oldPriceMinor = freezed,Object? isPromo = null,Object? available = null,Object? observedAt = null,Object? source = null,Object? requiresStoreSelection = null,}) {
  return _then(_ChainPriceDto(
chainId: null == chainId ? _self.chainId : chainId // ignore: cast_nullable_to_non_nullable
as int,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,chainName: null == chainName ? _self.chainName : chainName // ignore: cast_nullable_to_non_nullable
as String,priceModel: null == priceModel ? _self.priceModel : priceModel // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,priceCluster: freezed == priceCluster ? _self.priceCluster : priceCluster // ignore: cast_nullable_to_non_nullable
as String?,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,oldPriceMinor: freezed == oldPriceMinor ? _self.oldPriceMinor : oldPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,isPromo: null == isPromo ? _self.isPromo : isPromo // ignore: cast_nullable_to_non_nullable
as bool,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,source: null == source ? _self.source : source // ignore: cast_nullable_to_non_nullable
as String,requiresStoreSelection: null == requiresStoreSelection ? _self.requiresStoreSelection : requiresStoreSelection // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
