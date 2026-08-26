// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_card.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChainPrice {

 int get chainId; String get chainCode; String get chainName; String get priceModel; int? get storeId; String? get storeName;/// Измеренная ценовая зона. У Bravo их четыре, и они не совпадают
/// с форматом магазина.
 String? get priceCluster; int get priceMinor; int? get oldPriceMinor; bool get isPromo; bool get available; DateTime get observedAt; String get source;/// Цена зависит от выбранного магазина, а магазин не выбран.
/// Показывать её как единственную цену сети нельзя.
 bool get requiresStoreSelection;
/// Create a copy of ChainPrice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChainPriceCopyWith<ChainPrice> get copyWith => _$ChainPriceCopyWithImpl<ChainPrice>(this as ChainPrice, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChainPrice&&(identical(other.chainId, chainId) || other.chainId == chainId)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.chainName, chainName) || other.chainName == chainName)&&(identical(other.priceModel, priceModel) || other.priceModel == priceModel)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.priceCluster, priceCluster) || other.priceCluster == priceCluster)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.isPromo, isPromo) || other.isPromo == isPromo)&&(identical(other.available, available) || other.available == available)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.source, source) || other.source == source)&&(identical(other.requiresStoreSelection, requiresStoreSelection) || other.requiresStoreSelection == requiresStoreSelection));
}


@override
int get hashCode => Object.hash(runtimeType,chainId,chainCode,chainName,priceModel,storeId,storeName,priceCluster,priceMinor,oldPriceMinor,isPromo,available,observedAt,source,requiresStoreSelection);

@override
String toString() {
  return 'ChainPrice(chainId: $chainId, chainCode: $chainCode, chainName: $chainName, priceModel: $priceModel, storeId: $storeId, storeName: $storeName, priceCluster: $priceCluster, priceMinor: $priceMinor, oldPriceMinor: $oldPriceMinor, isPromo: $isPromo, available: $available, observedAt: $observedAt, source: $source, requiresStoreSelection: $requiresStoreSelection)';
}


}

/// @nodoc
abstract mixin class $ChainPriceCopyWith<$Res>  {
  factory $ChainPriceCopyWith(ChainPrice value, $Res Function(ChainPrice) _then) = _$ChainPriceCopyWithImpl;
@useResult
$Res call({
 int chainId, String chainCode, String chainName, String priceModel, int? storeId, String? storeName, String? priceCluster, int priceMinor, int? oldPriceMinor, bool isPromo, bool available, DateTime observedAt, String source, bool requiresStoreSelection
});




}
/// @nodoc
class _$ChainPriceCopyWithImpl<$Res>
    implements $ChainPriceCopyWith<$Res> {
  _$ChainPriceCopyWithImpl(this._self, this._then);

  final ChainPrice _self;
  final $Res Function(ChainPrice) _then;

/// Create a copy of ChainPrice
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


/// Adds pattern-matching-related methods to [ChainPrice].
extension ChainPricePatterns on ChainPrice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChainPrice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChainPrice() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChainPrice value)  $default,){
final _that = this;
switch (_that) {
case _ChainPrice():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChainPrice value)?  $default,){
final _that = this;
switch (_that) {
case _ChainPrice() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int chainId,  String chainCode,  String chainName,  String priceModel,  int? storeId,  String? storeName,  String? priceCluster,  int priceMinor,  int? oldPriceMinor,  bool isPromo,  bool available,  DateTime observedAt,  String source,  bool requiresStoreSelection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChainPrice() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int chainId,  String chainCode,  String chainName,  String priceModel,  int? storeId,  String? storeName,  String? priceCluster,  int priceMinor,  int? oldPriceMinor,  bool isPromo,  bool available,  DateTime observedAt,  String source,  bool requiresStoreSelection)  $default,) {final _that = this;
switch (_that) {
case _ChainPrice():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int chainId,  String chainCode,  String chainName,  String priceModel,  int? storeId,  String? storeName,  String? priceCluster,  int priceMinor,  int? oldPriceMinor,  bool isPromo,  bool available,  DateTime observedAt,  String source,  bool requiresStoreSelection)?  $default,) {final _that = this;
switch (_that) {
case _ChainPrice() when $default != null:
return $default(_that.chainId,_that.chainCode,_that.chainName,_that.priceModel,_that.storeId,_that.storeName,_that.priceCluster,_that.priceMinor,_that.oldPriceMinor,_that.isPromo,_that.available,_that.observedAt,_that.source,_that.requiresStoreSelection);case _:
  return null;

}
}

}

/// @nodoc


class _ChainPrice implements ChainPrice {
  const _ChainPrice({required this.chainId, required this.chainCode, required this.chainName, required this.priceModel, this.storeId, this.storeName, this.priceCluster, required this.priceMinor, this.oldPriceMinor, required this.isPromo, required this.available, required this.observedAt, required this.source, this.requiresStoreSelection = false});
  

@override final  int chainId;
@override final  String chainCode;
@override final  String chainName;
@override final  String priceModel;
@override final  int? storeId;
@override final  String? storeName;
/// Измеренная ценовая зона. У Bravo их четыре, и они не совпадают
/// с форматом магазина.
@override final  String? priceCluster;
@override final  int priceMinor;
@override final  int? oldPriceMinor;
@override final  bool isPromo;
@override final  bool available;
@override final  DateTime observedAt;
@override final  String source;
/// Цена зависит от выбранного магазина, а магазин не выбран.
/// Показывать её как единственную цену сети нельзя.
@override@JsonKey() final  bool requiresStoreSelection;

/// Create a copy of ChainPrice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChainPriceCopyWith<_ChainPrice> get copyWith => __$ChainPriceCopyWithImpl<_ChainPrice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChainPrice&&(identical(other.chainId, chainId) || other.chainId == chainId)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.chainName, chainName) || other.chainName == chainName)&&(identical(other.priceModel, priceModel) || other.priceModel == priceModel)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.priceCluster, priceCluster) || other.priceCluster == priceCluster)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.isPromo, isPromo) || other.isPromo == isPromo)&&(identical(other.available, available) || other.available == available)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.source, source) || other.source == source)&&(identical(other.requiresStoreSelection, requiresStoreSelection) || other.requiresStoreSelection == requiresStoreSelection));
}


@override
int get hashCode => Object.hash(runtimeType,chainId,chainCode,chainName,priceModel,storeId,storeName,priceCluster,priceMinor,oldPriceMinor,isPromo,available,observedAt,source,requiresStoreSelection);

@override
String toString() {
  return 'ChainPrice(chainId: $chainId, chainCode: $chainCode, chainName: $chainName, priceModel: $priceModel, storeId: $storeId, storeName: $storeName, priceCluster: $priceCluster, priceMinor: $priceMinor, oldPriceMinor: $oldPriceMinor, isPromo: $isPromo, available: $available, observedAt: $observedAt, source: $source, requiresStoreSelection: $requiresStoreSelection)';
}


}

/// @nodoc
abstract mixin class _$ChainPriceCopyWith<$Res> implements $ChainPriceCopyWith<$Res> {
  factory _$ChainPriceCopyWith(_ChainPrice value, $Res Function(_ChainPrice) _then) = __$ChainPriceCopyWithImpl;
@override @useResult
$Res call({
 int chainId, String chainCode, String chainName, String priceModel, int? storeId, String? storeName, String? priceCluster, int priceMinor, int? oldPriceMinor, bool isPromo, bool available, DateTime observedAt, String source, bool requiresStoreSelection
});




}
/// @nodoc
class __$ChainPriceCopyWithImpl<$Res>
    implements _$ChainPriceCopyWith<$Res> {
  __$ChainPriceCopyWithImpl(this._self, this._then);

  final _ChainPrice _self;
  final $Res Function(_ChainPrice) _then;

/// Create a copy of ChainPrice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chainId = null,Object? chainCode = null,Object? chainName = null,Object? priceModel = null,Object? storeId = freezed,Object? storeName = freezed,Object? priceCluster = freezed,Object? priceMinor = null,Object? oldPriceMinor = freezed,Object? isPromo = null,Object? available = null,Object? observedAt = null,Object? source = null,Object? requiresStoreSelection = null,}) {
  return _then(_ChainPrice(
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

/// @nodoc
mixin _$ProductCard {

 int get productId; String get name; String? get brand; String? get ean;/// Картинка товара. null примерно у 2% карточек — у сети её нет.
/// Показывать через ProductThumb: он рисует плашку, когда ссылки нет
/// или она не загрузилась.
 String? get imageUrl; double? get unitValue; String? get unitType; List<ChainPrice> get prices; int get chainsCount; int? get bestPriceMinor; String? get bestPriceChain;/// Коды сетей, чью цену нельзя показать без выбора магазина.
 List<String> get needsStoreSelection;
/// Create a copy of ProductCard
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductCardCopyWith<ProductCard> get copyWith => _$ProductCardCopyWithImpl<ProductCard>(this as ProductCard, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductCard&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&const DeepCollectionEquality().equals(other.prices, prices)&&(identical(other.chainsCount, chainsCount) || other.chainsCount == chainsCount)&&(identical(other.bestPriceMinor, bestPriceMinor) || other.bestPriceMinor == bestPriceMinor)&&(identical(other.bestPriceChain, bestPriceChain) || other.bestPriceChain == bestPriceChain)&&const DeepCollectionEquality().equals(other.needsStoreSelection, needsStoreSelection));
}


@override
int get hashCode => Object.hash(runtimeType,productId,name,brand,ean,imageUrl,unitValue,unitType,const DeepCollectionEquality().hash(prices),chainsCount,bestPriceMinor,bestPriceChain,const DeepCollectionEquality().hash(needsStoreSelection));

@override
String toString() {
  return 'ProductCard(productId: $productId, name: $name, brand: $brand, ean: $ean, imageUrl: $imageUrl, unitValue: $unitValue, unitType: $unitType, prices: $prices, chainsCount: $chainsCount, bestPriceMinor: $bestPriceMinor, bestPriceChain: $bestPriceChain, needsStoreSelection: $needsStoreSelection)';
}


}

/// @nodoc
abstract mixin class $ProductCardCopyWith<$Res>  {
  factory $ProductCardCopyWith(ProductCard value, $Res Function(ProductCard) _then) = _$ProductCardCopyWithImpl;
@useResult
$Res call({
 int productId, String name, String? brand, String? ean, String? imageUrl, double? unitValue, String? unitType, List<ChainPrice> prices, int chainsCount, int? bestPriceMinor, String? bestPriceChain, List<String> needsStoreSelection
});




}
/// @nodoc
class _$ProductCardCopyWithImpl<$Res>
    implements $ProductCardCopyWith<$Res> {
  _$ProductCardCopyWithImpl(this._self, this._then);

  final ProductCard _self;
  final $Res Function(ProductCard) _then;

/// Create a copy of ProductCard
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
as List<ChainPrice>,chainsCount: null == chainsCount ? _self.chainsCount : chainsCount // ignore: cast_nullable_to_non_nullable
as int,bestPriceMinor: freezed == bestPriceMinor ? _self.bestPriceMinor : bestPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,bestPriceChain: freezed == bestPriceChain ? _self.bestPriceChain : bestPriceChain // ignore: cast_nullable_to_non_nullable
as String?,needsStoreSelection: null == needsStoreSelection ? _self.needsStoreSelection : needsStoreSelection // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [ProductCard].
extension ProductCardPatterns on ProductCard {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProductCard value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProductCard() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProductCard value)  $default,){
final _that = this;
switch (_that) {
case _ProductCard():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProductCard value)?  $default,){
final _that = this;
switch (_that) {
case _ProductCard() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  String name,  String? brand,  String? ean,  String? imageUrl,  double? unitValue,  String? unitType,  List<ChainPrice> prices,  int chainsCount,  int? bestPriceMinor,  String? bestPriceChain,  List<String> needsStoreSelection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProductCard() when $default != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  String name,  String? brand,  String? ean,  String? imageUrl,  double? unitValue,  String? unitType,  List<ChainPrice> prices,  int chainsCount,  int? bestPriceMinor,  String? bestPriceChain,  List<String> needsStoreSelection)  $default,) {final _that = this;
switch (_that) {
case _ProductCard():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  String name,  String? brand,  String? ean,  String? imageUrl,  double? unitValue,  String? unitType,  List<ChainPrice> prices,  int chainsCount,  int? bestPriceMinor,  String? bestPriceChain,  List<String> needsStoreSelection)?  $default,) {final _that = this;
switch (_that) {
case _ProductCard() when $default != null:
return $default(_that.productId,_that.name,_that.brand,_that.ean,_that.imageUrl,_that.unitValue,_that.unitType,_that.prices,_that.chainsCount,_that.bestPriceMinor,_that.bestPriceChain,_that.needsStoreSelection);case _:
  return null;

}
}

}

/// @nodoc


class _ProductCard implements ProductCard {
  const _ProductCard({required this.productId, required this.name, this.brand, this.ean, this.imageUrl, this.unitValue, this.unitType, required final  List<ChainPrice> prices, required this.chainsCount, this.bestPriceMinor, this.bestPriceChain, final  List<String> needsStoreSelection = const <String>[]}): _prices = prices,_needsStoreSelection = needsStoreSelection;
  

@override final  int productId;
@override final  String name;
@override final  String? brand;
@override final  String? ean;
/// Картинка товара. null примерно у 2% карточек — у сети её нет.
/// Показывать через ProductThumb: он рисует плашку, когда ссылки нет
/// или она не загрузилась.
@override final  String? imageUrl;
@override final  double? unitValue;
@override final  String? unitType;
 final  List<ChainPrice> _prices;
@override List<ChainPrice> get prices {
  if (_prices is EqualUnmodifiableListView) return _prices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prices);
}

@override final  int chainsCount;
@override final  int? bestPriceMinor;
@override final  String? bestPriceChain;
/// Коды сетей, чью цену нельзя показать без выбора магазина.
 final  List<String> _needsStoreSelection;
/// Коды сетей, чью цену нельзя показать без выбора магазина.
@override@JsonKey() List<String> get needsStoreSelection {
  if (_needsStoreSelection is EqualUnmodifiableListView) return _needsStoreSelection;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_needsStoreSelection);
}


/// Create a copy of ProductCard
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProductCardCopyWith<_ProductCard> get copyWith => __$ProductCardCopyWithImpl<_ProductCard>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProductCard&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&const DeepCollectionEquality().equals(other._prices, _prices)&&(identical(other.chainsCount, chainsCount) || other.chainsCount == chainsCount)&&(identical(other.bestPriceMinor, bestPriceMinor) || other.bestPriceMinor == bestPriceMinor)&&(identical(other.bestPriceChain, bestPriceChain) || other.bestPriceChain == bestPriceChain)&&const DeepCollectionEquality().equals(other._needsStoreSelection, _needsStoreSelection));
}


@override
int get hashCode => Object.hash(runtimeType,productId,name,brand,ean,imageUrl,unitValue,unitType,const DeepCollectionEquality().hash(_prices),chainsCount,bestPriceMinor,bestPriceChain,const DeepCollectionEquality().hash(_needsStoreSelection));

@override
String toString() {
  return 'ProductCard(productId: $productId, name: $name, brand: $brand, ean: $ean, imageUrl: $imageUrl, unitValue: $unitValue, unitType: $unitType, prices: $prices, chainsCount: $chainsCount, bestPriceMinor: $bestPriceMinor, bestPriceChain: $bestPriceChain, needsStoreSelection: $needsStoreSelection)';
}


}

/// @nodoc
abstract mixin class _$ProductCardCopyWith<$Res> implements $ProductCardCopyWith<$Res> {
  factory _$ProductCardCopyWith(_ProductCard value, $Res Function(_ProductCard) _then) = __$ProductCardCopyWithImpl;
@override @useResult
$Res call({
 int productId, String name, String? brand, String? ean, String? imageUrl, double? unitValue, String? unitType, List<ChainPrice> prices, int chainsCount, int? bestPriceMinor, String? bestPriceChain, List<String> needsStoreSelection
});




}
/// @nodoc
class __$ProductCardCopyWithImpl<$Res>
    implements _$ProductCardCopyWith<$Res> {
  __$ProductCardCopyWithImpl(this._self, this._then);

  final _ProductCard _self;
  final $Res Function(_ProductCard) _then;

/// Create a copy of ProductCard
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? name = null,Object? brand = freezed,Object? ean = freezed,Object? imageUrl = freezed,Object? unitValue = freezed,Object? unitType = freezed,Object? prices = null,Object? chainsCount = null,Object? bestPriceMinor = freezed,Object? bestPriceChain = freezed,Object? needsStoreSelection = null,}) {
  return _then(_ProductCard(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,unitValue: freezed == unitValue ? _self.unitValue : unitValue // ignore: cast_nullable_to_non_nullable
as double?,unitType: freezed == unitType ? _self.unitType : unitType // ignore: cast_nullable_to_non_nullable
as String?,prices: null == prices ? _self._prices : prices // ignore: cast_nullable_to_non_nullable
as List<ChainPrice>,chainsCount: null == chainsCount ? _self.chainsCount : chainsCount // ignore: cast_nullable_to_non_nullable
as int,bestPriceMinor: freezed == bestPriceMinor ? _self.bestPriceMinor : bestPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,bestPriceChain: freezed == bestPriceChain ? _self.bestPriceChain : bestPriceChain // ignore: cast_nullable_to_non_nullable
as String?,needsStoreSelection: null == needsStoreSelection ? _self._needsStoreSelection : needsStoreSelection // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
