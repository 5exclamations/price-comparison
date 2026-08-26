// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deal.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Deal {

/// Устойчивый идентификатор акции. Один товар даёт несколько акций —
/// по одной на сеть и ценовую зону, — поэтому productId для этого не годится.
 int get dealId; int get productId; String get name; String? get brand; String? get ean;/// Картинка товара. null примерно у 2% карточек — у сети её нет.
/// Показывать через ProductThumb: он рисует плашку, когда ссылки нет
/// или она не загрузилась.
 String? get imageUrl; String get chainCode; int? get storeId; String? get storeName; String? get priceCluster; int get priceMinor; int get oldPriceMinor;/// Медиана неакционных цен на тот же штрихкод в других сетях.
 int get marketPriceMinor; int get referenceChains; double get claimedDiscount; double get realDiscount; double get inflation;/// Заявленная скидка глубже настоящей больше чем на 15 п.п.
 bool get inflated; DateTime get observedAt;
/// Create a copy of Deal
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DealCopyWith<Deal> get copyWith => _$DealCopyWithImpl<Deal>(this as Deal, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Deal&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.priceCluster, priceCluster) || other.priceCluster == priceCluster)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.marketPriceMinor, marketPriceMinor) || other.marketPriceMinor == marketPriceMinor)&&(identical(other.referenceChains, referenceChains) || other.referenceChains == referenceChains)&&(identical(other.claimedDiscount, claimedDiscount) || other.claimedDiscount == claimedDiscount)&&(identical(other.realDiscount, realDiscount) || other.realDiscount == realDiscount)&&(identical(other.inflation, inflation) || other.inflation == inflation)&&(identical(other.inflated, inflated) || other.inflated == inflated)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,dealId,productId,name,brand,ean,imageUrl,chainCode,storeId,storeName,priceCluster,priceMinor,oldPriceMinor,marketPriceMinor,referenceChains,claimedDiscount,realDiscount,inflation,inflated,observedAt]);

@override
String toString() {
  return 'Deal(dealId: $dealId, productId: $productId, name: $name, brand: $brand, ean: $ean, imageUrl: $imageUrl, chainCode: $chainCode, storeId: $storeId, storeName: $storeName, priceCluster: $priceCluster, priceMinor: $priceMinor, oldPriceMinor: $oldPriceMinor, marketPriceMinor: $marketPriceMinor, referenceChains: $referenceChains, claimedDiscount: $claimedDiscount, realDiscount: $realDiscount, inflation: $inflation, inflated: $inflated, observedAt: $observedAt)';
}


}

/// @nodoc
abstract mixin class $DealCopyWith<$Res>  {
  factory $DealCopyWith(Deal value, $Res Function(Deal) _then) = _$DealCopyWithImpl;
@useResult
$Res call({
 int dealId, int productId, String name, String? brand, String? ean, String? imageUrl, String chainCode, int? storeId, String? storeName, String? priceCluster, int priceMinor, int oldPriceMinor, int marketPriceMinor, int referenceChains, double claimedDiscount, double realDiscount, double inflation, bool inflated, DateTime observedAt
});




}
/// @nodoc
class _$DealCopyWithImpl<$Res>
    implements $DealCopyWith<$Res> {
  _$DealCopyWithImpl(this._self, this._then);

  final Deal _self;
  final $Res Function(Deal) _then;

/// Create a copy of Deal
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dealId = null,Object? productId = null,Object? name = null,Object? brand = freezed,Object? ean = freezed,Object? imageUrl = freezed,Object? chainCode = null,Object? storeId = freezed,Object? storeName = freezed,Object? priceCluster = freezed,Object? priceMinor = null,Object? oldPriceMinor = null,Object? marketPriceMinor = null,Object? referenceChains = null,Object? claimedDiscount = null,Object? realDiscount = null,Object? inflation = null,Object? inflated = null,Object? observedAt = null,}) {
  return _then(_self.copyWith(
dealId: null == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,priceCluster: freezed == priceCluster ? _self.priceCluster : priceCluster // ignore: cast_nullable_to_non_nullable
as String?,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,oldPriceMinor: null == oldPriceMinor ? _self.oldPriceMinor : oldPriceMinor // ignore: cast_nullable_to_non_nullable
as int,marketPriceMinor: null == marketPriceMinor ? _self.marketPriceMinor : marketPriceMinor // ignore: cast_nullable_to_non_nullable
as int,referenceChains: null == referenceChains ? _self.referenceChains : referenceChains // ignore: cast_nullable_to_non_nullable
as int,claimedDiscount: null == claimedDiscount ? _self.claimedDiscount : claimedDiscount // ignore: cast_nullable_to_non_nullable
as double,realDiscount: null == realDiscount ? _self.realDiscount : realDiscount // ignore: cast_nullable_to_non_nullable
as double,inflation: null == inflation ? _self.inflation : inflation // ignore: cast_nullable_to_non_nullable
as double,inflated: null == inflated ? _self.inflated : inflated // ignore: cast_nullable_to_non_nullable
as bool,observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Deal].
extension DealPatterns on Deal {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Deal value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Deal() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Deal value)  $default,){
final _that = this;
switch (_that) {
case _Deal():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Deal value)?  $default,){
final _that = this;
switch (_that) {
case _Deal() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int dealId,  int productId,  String name,  String? brand,  String? ean,  String? imageUrl,  String chainCode,  int? storeId,  String? storeName,  String? priceCluster,  int priceMinor,  int oldPriceMinor,  int marketPriceMinor,  int referenceChains,  double claimedDiscount,  double realDiscount,  double inflation,  bool inflated,  DateTime observedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Deal() when $default != null:
return $default(_that.dealId,_that.productId,_that.name,_that.brand,_that.ean,_that.imageUrl,_that.chainCode,_that.storeId,_that.storeName,_that.priceCluster,_that.priceMinor,_that.oldPriceMinor,_that.marketPriceMinor,_that.referenceChains,_that.claimedDiscount,_that.realDiscount,_that.inflation,_that.inflated,_that.observedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int dealId,  int productId,  String name,  String? brand,  String? ean,  String? imageUrl,  String chainCode,  int? storeId,  String? storeName,  String? priceCluster,  int priceMinor,  int oldPriceMinor,  int marketPriceMinor,  int referenceChains,  double claimedDiscount,  double realDiscount,  double inflation,  bool inflated,  DateTime observedAt)  $default,) {final _that = this;
switch (_that) {
case _Deal():
return $default(_that.dealId,_that.productId,_that.name,_that.brand,_that.ean,_that.imageUrl,_that.chainCode,_that.storeId,_that.storeName,_that.priceCluster,_that.priceMinor,_that.oldPriceMinor,_that.marketPriceMinor,_that.referenceChains,_that.claimedDiscount,_that.realDiscount,_that.inflation,_that.inflated,_that.observedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int dealId,  int productId,  String name,  String? brand,  String? ean,  String? imageUrl,  String chainCode,  int? storeId,  String? storeName,  String? priceCluster,  int priceMinor,  int oldPriceMinor,  int marketPriceMinor,  int referenceChains,  double claimedDiscount,  double realDiscount,  double inflation,  bool inflated,  DateTime observedAt)?  $default,) {final _that = this;
switch (_that) {
case _Deal() when $default != null:
return $default(_that.dealId,_that.productId,_that.name,_that.brand,_that.ean,_that.imageUrl,_that.chainCode,_that.storeId,_that.storeName,_that.priceCluster,_that.priceMinor,_that.oldPriceMinor,_that.marketPriceMinor,_that.referenceChains,_that.claimedDiscount,_that.realDiscount,_that.inflation,_that.inflated,_that.observedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Deal implements Deal {
  const _Deal({required this.dealId, required this.productId, required this.name, this.brand, this.ean, this.imageUrl, required this.chainCode, this.storeId, this.storeName, this.priceCluster, required this.priceMinor, required this.oldPriceMinor, required this.marketPriceMinor, required this.referenceChains, required this.claimedDiscount, required this.realDiscount, required this.inflation, required this.inflated, required this.observedAt});
  

/// Устойчивый идентификатор акции. Один товар даёт несколько акций —
/// по одной на сеть и ценовую зону, — поэтому productId для этого не годится.
@override final  int dealId;
@override final  int productId;
@override final  String name;
@override final  String? brand;
@override final  String? ean;
/// Картинка товара. null примерно у 2% карточек — у сети её нет.
/// Показывать через ProductThumb: он рисует плашку, когда ссылки нет
/// или она не загрузилась.
@override final  String? imageUrl;
@override final  String chainCode;
@override final  int? storeId;
@override final  String? storeName;
@override final  String? priceCluster;
@override final  int priceMinor;
@override final  int oldPriceMinor;
/// Медиана неакционных цен на тот же штрихкод в других сетях.
@override final  int marketPriceMinor;
@override final  int referenceChains;
@override final  double claimedDiscount;
@override final  double realDiscount;
@override final  double inflation;
/// Заявленная скидка глубже настоящей больше чем на 15 п.п.
@override final  bool inflated;
@override final  DateTime observedAt;

/// Create a copy of Deal
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DealCopyWith<_Deal> get copyWith => __$DealCopyWithImpl<_Deal>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Deal&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.priceCluster, priceCluster) || other.priceCluster == priceCluster)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.marketPriceMinor, marketPriceMinor) || other.marketPriceMinor == marketPriceMinor)&&(identical(other.referenceChains, referenceChains) || other.referenceChains == referenceChains)&&(identical(other.claimedDiscount, claimedDiscount) || other.claimedDiscount == claimedDiscount)&&(identical(other.realDiscount, realDiscount) || other.realDiscount == realDiscount)&&(identical(other.inflation, inflation) || other.inflation == inflation)&&(identical(other.inflated, inflated) || other.inflated == inflated)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt));
}


@override
int get hashCode => Object.hashAll([runtimeType,dealId,productId,name,brand,ean,imageUrl,chainCode,storeId,storeName,priceCluster,priceMinor,oldPriceMinor,marketPriceMinor,referenceChains,claimedDiscount,realDiscount,inflation,inflated,observedAt]);

@override
String toString() {
  return 'Deal(dealId: $dealId, productId: $productId, name: $name, brand: $brand, ean: $ean, imageUrl: $imageUrl, chainCode: $chainCode, storeId: $storeId, storeName: $storeName, priceCluster: $priceCluster, priceMinor: $priceMinor, oldPriceMinor: $oldPriceMinor, marketPriceMinor: $marketPriceMinor, referenceChains: $referenceChains, claimedDiscount: $claimedDiscount, realDiscount: $realDiscount, inflation: $inflation, inflated: $inflated, observedAt: $observedAt)';
}


}

/// @nodoc
abstract mixin class _$DealCopyWith<$Res> implements $DealCopyWith<$Res> {
  factory _$DealCopyWith(_Deal value, $Res Function(_Deal) _then) = __$DealCopyWithImpl;
@override @useResult
$Res call({
 int dealId, int productId, String name, String? brand, String? ean, String? imageUrl, String chainCode, int? storeId, String? storeName, String? priceCluster, int priceMinor, int oldPriceMinor, int marketPriceMinor, int referenceChains, double claimedDiscount, double realDiscount, double inflation, bool inflated, DateTime observedAt
});




}
/// @nodoc
class __$DealCopyWithImpl<$Res>
    implements _$DealCopyWith<$Res> {
  __$DealCopyWithImpl(this._self, this._then);

  final _Deal _self;
  final $Res Function(_Deal) _then;

/// Create a copy of Deal
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dealId = null,Object? productId = null,Object? name = null,Object? brand = freezed,Object? ean = freezed,Object? imageUrl = freezed,Object? chainCode = null,Object? storeId = freezed,Object? storeName = freezed,Object? priceCluster = freezed,Object? priceMinor = null,Object? oldPriceMinor = null,Object? marketPriceMinor = null,Object? referenceChains = null,Object? claimedDiscount = null,Object? realDiscount = null,Object? inflation = null,Object? inflated = null,Object? observedAt = null,}) {
  return _then(_Deal(
dealId: null == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
as String?,imageUrl: freezed == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String?,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,priceCluster: freezed == priceCluster ? _self.priceCluster : priceCluster // ignore: cast_nullable_to_non_nullable
as String?,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,oldPriceMinor: null == oldPriceMinor ? _self.oldPriceMinor : oldPriceMinor // ignore: cast_nullable_to_non_nullable
as int,marketPriceMinor: null == marketPriceMinor ? _self.marketPriceMinor : marketPriceMinor // ignore: cast_nullable_to_non_nullable
as int,referenceChains: null == referenceChains ? _self.referenceChains : referenceChains // ignore: cast_nullable_to_non_nullable
as int,claimedDiscount: null == claimedDiscount ? _self.claimedDiscount : claimedDiscount // ignore: cast_nullable_to_non_nullable
as double,realDiscount: null == realDiscount ? _self.realDiscount : realDiscount // ignore: cast_nullable_to_non_nullable
as double,inflation: null == inflation ? _self.inflation : inflation // ignore: cast_nullable_to_non_nullable
as double,inflated: null == inflated ? _self.inflated : inflated // ignore: cast_nullable_to_non_nullable
as bool,observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
