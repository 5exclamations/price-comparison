// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'deal_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DealsResponseDto {

@JsonKey(name: 'next_cursor') String? get nextCursor;@JsonKey(name: 'has_more') bool get hasMore; List<DealDto> get items;
/// Create a copy of DealsResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DealsResponseDtoCopyWith<DealsResponseDto> get copyWith => _$DealsResponseDtoCopyWithImpl<DealsResponseDto>(this as DealsResponseDto, _$identity);

  /// Serializes this DealsResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DealsResponseDto&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nextCursor,hasMore,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'DealsResponseDto(nextCursor: $nextCursor, hasMore: $hasMore, items: $items)';
}


}

/// @nodoc
abstract mixin class $DealsResponseDtoCopyWith<$Res>  {
  factory $DealsResponseDtoCopyWith(DealsResponseDto value, $Res Function(DealsResponseDto) _then) = _$DealsResponseDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'next_cursor') String? nextCursor,@JsonKey(name: 'has_more') bool hasMore, List<DealDto> items
});




}
/// @nodoc
class _$DealsResponseDtoCopyWithImpl<$Res>
    implements $DealsResponseDtoCopyWith<$Res> {
  _$DealsResponseDtoCopyWithImpl(this._self, this._then);

  final DealsResponseDto _self;
  final $Res Function(DealsResponseDto) _then;

/// Create a copy of DealsResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nextCursor = freezed,Object? hasMore = null,Object? items = null,}) {
  return _then(_self.copyWith(
nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<DealDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [DealsResponseDto].
extension DealsResponseDtoPatterns on DealsResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DealsResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DealsResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DealsResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _DealsResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DealsResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _DealsResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore,  List<DealDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DealsResponseDto() when $default != null:
return $default(_that.nextCursor,_that.hasMore,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore,  List<DealDto> items)  $default,) {final _that = this;
switch (_that) {
case _DealsResponseDto():
return $default(_that.nextCursor,_that.hasMore,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore,  List<DealDto> items)?  $default,) {final _that = this;
switch (_that) {
case _DealsResponseDto() when $default != null:
return $default(_that.nextCursor,_that.hasMore,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DealsResponseDto implements DealsResponseDto {
  const _DealsResponseDto({@JsonKey(name: 'next_cursor') this.nextCursor, @JsonKey(name: 'has_more') required this.hasMore, required final  List<DealDto> items}): _items = items;
  factory _DealsResponseDto.fromJson(Map<String, dynamic> json) => _$DealsResponseDtoFromJson(json);

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;
@override@JsonKey(name: 'has_more') final  bool hasMore;
 final  List<DealDto> _items;
@override List<DealDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of DealsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DealsResponseDtoCopyWith<_DealsResponseDto> get copyWith => __$DealsResponseDtoCopyWithImpl<_DealsResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DealsResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DealsResponseDto&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nextCursor,hasMore,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'DealsResponseDto(nextCursor: $nextCursor, hasMore: $hasMore, items: $items)';
}


}

/// @nodoc
abstract mixin class _$DealsResponseDtoCopyWith<$Res> implements $DealsResponseDtoCopyWith<$Res> {
  factory _$DealsResponseDtoCopyWith(_DealsResponseDto value, $Res Function(_DealsResponseDto) _then) = __$DealsResponseDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'next_cursor') String? nextCursor,@JsonKey(name: 'has_more') bool hasMore, List<DealDto> items
});




}
/// @nodoc
class __$DealsResponseDtoCopyWithImpl<$Res>
    implements _$DealsResponseDtoCopyWith<$Res> {
  __$DealsResponseDtoCopyWithImpl(this._self, this._then);

  final _DealsResponseDto _self;
  final $Res Function(_DealsResponseDto) _then;

/// Create a copy of DealsResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nextCursor = freezed,Object? hasMore = null,Object? items = null,}) {
  return _then(_DealsResponseDto(
nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<DealDto>,
  ));
}


}


/// @nodoc
mixin _$DealDto {

@JsonKey(name: 'deal_id') int get dealId;@JsonKey(name: 'product_id') int get productId; String get name; String? get brand; String? get ean;@JsonKey(name: 'chain_code') String get chainCode;@JsonKey(name: 'store_id') int? get storeId;@JsonKey(name: 'store_name') String? get storeName;@JsonKey(name: 'price_cluster') String? get priceCluster;@JsonKey(name: 'price_minor') int get priceMinor;@JsonKey(name: 'old_price_minor') int get oldPriceMinor;@JsonKey(name: 'market_price_minor') int get marketPriceMinor;@JsonKey(name: 'reference_chains') int get referenceChains;@JsonKey(name: 'claimed_discount') double get claimedDiscount;@JsonKey(name: 'real_discount') double get realDiscount; double get inflation; bool get inflated;@JsonKey(name: 'observed_at') DateTime get observedAt;
/// Create a copy of DealDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DealDtoCopyWith<DealDto> get copyWith => _$DealDtoCopyWithImpl<DealDto>(this as DealDto, _$identity);

  /// Serializes this DealDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DealDto&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.priceCluster, priceCluster) || other.priceCluster == priceCluster)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.marketPriceMinor, marketPriceMinor) || other.marketPriceMinor == marketPriceMinor)&&(identical(other.referenceChains, referenceChains) || other.referenceChains == referenceChains)&&(identical(other.claimedDiscount, claimedDiscount) || other.claimedDiscount == claimedDiscount)&&(identical(other.realDiscount, realDiscount) || other.realDiscount == realDiscount)&&(identical(other.inflation, inflation) || other.inflation == inflation)&&(identical(other.inflated, inflated) || other.inflated == inflated)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dealId,productId,name,brand,ean,chainCode,storeId,storeName,priceCluster,priceMinor,oldPriceMinor,marketPriceMinor,referenceChains,claimedDiscount,realDiscount,inflation,inflated,observedAt);

@override
String toString() {
  return 'DealDto(dealId: $dealId, productId: $productId, name: $name, brand: $brand, ean: $ean, chainCode: $chainCode, storeId: $storeId, storeName: $storeName, priceCluster: $priceCluster, priceMinor: $priceMinor, oldPriceMinor: $oldPriceMinor, marketPriceMinor: $marketPriceMinor, referenceChains: $referenceChains, claimedDiscount: $claimedDiscount, realDiscount: $realDiscount, inflation: $inflation, inflated: $inflated, observedAt: $observedAt)';
}


}

/// @nodoc
abstract mixin class $DealDtoCopyWith<$Res>  {
  factory $DealDtoCopyWith(DealDto value, $Res Function(DealDto) _then) = _$DealDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'deal_id') int dealId,@JsonKey(name: 'product_id') int productId, String name, String? brand, String? ean,@JsonKey(name: 'chain_code') String chainCode,@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'store_name') String? storeName,@JsonKey(name: 'price_cluster') String? priceCluster,@JsonKey(name: 'price_minor') int priceMinor,@JsonKey(name: 'old_price_minor') int oldPriceMinor,@JsonKey(name: 'market_price_minor') int marketPriceMinor,@JsonKey(name: 'reference_chains') int referenceChains,@JsonKey(name: 'claimed_discount') double claimedDiscount,@JsonKey(name: 'real_discount') double realDiscount, double inflation, bool inflated,@JsonKey(name: 'observed_at') DateTime observedAt
});




}
/// @nodoc
class _$DealDtoCopyWithImpl<$Res>
    implements $DealDtoCopyWith<$Res> {
  _$DealDtoCopyWithImpl(this._self, this._then);

  final DealDto _self;
  final $Res Function(DealDto) _then;

/// Create a copy of DealDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? dealId = null,Object? productId = null,Object? name = null,Object? brand = freezed,Object? ean = freezed,Object? chainCode = null,Object? storeId = freezed,Object? storeName = freezed,Object? priceCluster = freezed,Object? priceMinor = null,Object? oldPriceMinor = null,Object? marketPriceMinor = null,Object? referenceChains = null,Object? claimedDiscount = null,Object? realDiscount = null,Object? inflation = null,Object? inflated = null,Object? observedAt = null,}) {
  return _then(_self.copyWith(
dealId: null == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [DealDto].
extension DealDtoPatterns on DealDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DealDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DealDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DealDto value)  $default,){
final _that = this;
switch (_that) {
case _DealDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DealDto value)?  $default,){
final _that = this;
switch (_that) {
case _DealDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'deal_id')  int dealId, @JsonKey(name: 'product_id')  int productId,  String name,  String? brand,  String? ean, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'price_cluster')  String? priceCluster, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'old_price_minor')  int oldPriceMinor, @JsonKey(name: 'market_price_minor')  int marketPriceMinor, @JsonKey(name: 'reference_chains')  int referenceChains, @JsonKey(name: 'claimed_discount')  double claimedDiscount, @JsonKey(name: 'real_discount')  double realDiscount,  double inflation,  bool inflated, @JsonKey(name: 'observed_at')  DateTime observedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DealDto() when $default != null:
return $default(_that.dealId,_that.productId,_that.name,_that.brand,_that.ean,_that.chainCode,_that.storeId,_that.storeName,_that.priceCluster,_that.priceMinor,_that.oldPriceMinor,_that.marketPriceMinor,_that.referenceChains,_that.claimedDiscount,_that.realDiscount,_that.inflation,_that.inflated,_that.observedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'deal_id')  int dealId, @JsonKey(name: 'product_id')  int productId,  String name,  String? brand,  String? ean, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'price_cluster')  String? priceCluster, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'old_price_minor')  int oldPriceMinor, @JsonKey(name: 'market_price_minor')  int marketPriceMinor, @JsonKey(name: 'reference_chains')  int referenceChains, @JsonKey(name: 'claimed_discount')  double claimedDiscount, @JsonKey(name: 'real_discount')  double realDiscount,  double inflation,  bool inflated, @JsonKey(name: 'observed_at')  DateTime observedAt)  $default,) {final _that = this;
switch (_that) {
case _DealDto():
return $default(_that.dealId,_that.productId,_that.name,_that.brand,_that.ean,_that.chainCode,_that.storeId,_that.storeName,_that.priceCluster,_that.priceMinor,_that.oldPriceMinor,_that.marketPriceMinor,_that.referenceChains,_that.claimedDiscount,_that.realDiscount,_that.inflation,_that.inflated,_that.observedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'deal_id')  int dealId, @JsonKey(name: 'product_id')  int productId,  String name,  String? brand,  String? ean, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'price_cluster')  String? priceCluster, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'old_price_minor')  int oldPriceMinor, @JsonKey(name: 'market_price_minor')  int marketPriceMinor, @JsonKey(name: 'reference_chains')  int referenceChains, @JsonKey(name: 'claimed_discount')  double claimedDiscount, @JsonKey(name: 'real_discount')  double realDiscount,  double inflation,  bool inflated, @JsonKey(name: 'observed_at')  DateTime observedAt)?  $default,) {final _that = this;
switch (_that) {
case _DealDto() when $default != null:
return $default(_that.dealId,_that.productId,_that.name,_that.brand,_that.ean,_that.chainCode,_that.storeId,_that.storeName,_that.priceCluster,_that.priceMinor,_that.oldPriceMinor,_that.marketPriceMinor,_that.referenceChains,_that.claimedDiscount,_that.realDiscount,_that.inflation,_that.inflated,_that.observedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DealDto implements DealDto {
  const _DealDto({@JsonKey(name: 'deal_id') required this.dealId, @JsonKey(name: 'product_id') required this.productId, required this.name, this.brand, this.ean, @JsonKey(name: 'chain_code') required this.chainCode, @JsonKey(name: 'store_id') this.storeId, @JsonKey(name: 'store_name') this.storeName, @JsonKey(name: 'price_cluster') this.priceCluster, @JsonKey(name: 'price_minor') required this.priceMinor, @JsonKey(name: 'old_price_minor') required this.oldPriceMinor, @JsonKey(name: 'market_price_minor') required this.marketPriceMinor, @JsonKey(name: 'reference_chains') required this.referenceChains, @JsonKey(name: 'claimed_discount') required this.claimedDiscount, @JsonKey(name: 'real_discount') required this.realDiscount, required this.inflation, required this.inflated, @JsonKey(name: 'observed_at') required this.observedAt});
  factory _DealDto.fromJson(Map<String, dynamic> json) => _$DealDtoFromJson(json);

@override@JsonKey(name: 'deal_id') final  int dealId;
@override@JsonKey(name: 'product_id') final  int productId;
@override final  String name;
@override final  String? brand;
@override final  String? ean;
@override@JsonKey(name: 'chain_code') final  String chainCode;
@override@JsonKey(name: 'store_id') final  int? storeId;
@override@JsonKey(name: 'store_name') final  String? storeName;
@override@JsonKey(name: 'price_cluster') final  String? priceCluster;
@override@JsonKey(name: 'price_minor') final  int priceMinor;
@override@JsonKey(name: 'old_price_minor') final  int oldPriceMinor;
@override@JsonKey(name: 'market_price_minor') final  int marketPriceMinor;
@override@JsonKey(name: 'reference_chains') final  int referenceChains;
@override@JsonKey(name: 'claimed_discount') final  double claimedDiscount;
@override@JsonKey(name: 'real_discount') final  double realDiscount;
@override final  double inflation;
@override final  bool inflated;
@override@JsonKey(name: 'observed_at') final  DateTime observedAt;

/// Create a copy of DealDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DealDtoCopyWith<_DealDto> get copyWith => __$DealDtoCopyWithImpl<_DealDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DealDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DealDto&&(identical(other.dealId, dealId) || other.dealId == dealId)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.priceCluster, priceCluster) || other.priceCluster == priceCluster)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.marketPriceMinor, marketPriceMinor) || other.marketPriceMinor == marketPriceMinor)&&(identical(other.referenceChains, referenceChains) || other.referenceChains == referenceChains)&&(identical(other.claimedDiscount, claimedDiscount) || other.claimedDiscount == claimedDiscount)&&(identical(other.realDiscount, realDiscount) || other.realDiscount == realDiscount)&&(identical(other.inflation, inflation) || other.inflation == inflation)&&(identical(other.inflated, inflated) || other.inflated == inflated)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,dealId,productId,name,brand,ean,chainCode,storeId,storeName,priceCluster,priceMinor,oldPriceMinor,marketPriceMinor,referenceChains,claimedDiscount,realDiscount,inflation,inflated,observedAt);

@override
String toString() {
  return 'DealDto(dealId: $dealId, productId: $productId, name: $name, brand: $brand, ean: $ean, chainCode: $chainCode, storeId: $storeId, storeName: $storeName, priceCluster: $priceCluster, priceMinor: $priceMinor, oldPriceMinor: $oldPriceMinor, marketPriceMinor: $marketPriceMinor, referenceChains: $referenceChains, claimedDiscount: $claimedDiscount, realDiscount: $realDiscount, inflation: $inflation, inflated: $inflated, observedAt: $observedAt)';
}


}

/// @nodoc
abstract mixin class _$DealDtoCopyWith<$Res> implements $DealDtoCopyWith<$Res> {
  factory _$DealDtoCopyWith(_DealDto value, $Res Function(_DealDto) _then) = __$DealDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'deal_id') int dealId,@JsonKey(name: 'product_id') int productId, String name, String? brand, String? ean,@JsonKey(name: 'chain_code') String chainCode,@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'store_name') String? storeName,@JsonKey(name: 'price_cluster') String? priceCluster,@JsonKey(name: 'price_minor') int priceMinor,@JsonKey(name: 'old_price_minor') int oldPriceMinor,@JsonKey(name: 'market_price_minor') int marketPriceMinor,@JsonKey(name: 'reference_chains') int referenceChains,@JsonKey(name: 'claimed_discount') double claimedDiscount,@JsonKey(name: 'real_discount') double realDiscount, double inflation, bool inflated,@JsonKey(name: 'observed_at') DateTime observedAt
});




}
/// @nodoc
class __$DealDtoCopyWithImpl<$Res>
    implements _$DealDtoCopyWith<$Res> {
  __$DealDtoCopyWithImpl(this._self, this._then);

  final _DealDto _self;
  final $Res Function(_DealDto) _then;

/// Create a copy of DealDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? dealId = null,Object? productId = null,Object? name = null,Object? brand = freezed,Object? ean = freezed,Object? chainCode = null,Object? storeId = freezed,Object? storeName = freezed,Object? priceCluster = freezed,Object? priceMinor = null,Object? oldPriceMinor = null,Object? marketPriceMinor = null,Object? referenceChains = null,Object? claimedDiscount = null,Object? realDiscount = null,Object? inflation = null,Object? inflated = null,Object? observedAt = null,}) {
  return _then(_DealDto(
dealId: null == dealId ? _self.dealId : dealId // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
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
