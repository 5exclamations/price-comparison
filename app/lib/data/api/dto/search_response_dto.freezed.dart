// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_response_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SearchResponseDto {

@JsonKey(name: 'next_cursor') String? get nextCursor;@JsonKey(name: 'has_more') bool get hasMore; String get query;@JsonKey(name: 'normalized_query') String get normalizedQuery;@JsonKey(name: 'matched_by') String get matchedBy; List<SearchItemDto> get items;
/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchResponseDtoCopyWith<SearchResponseDto> get copyWith => _$SearchResponseDtoCopyWithImpl<SearchResponseDto>(this as SearchResponseDto, _$identity);

  /// Serializes this SearchResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchResponseDto&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.query, query) || other.query == query)&&(identical(other.normalizedQuery, normalizedQuery) || other.normalizedQuery == normalizedQuery)&&(identical(other.matchedBy, matchedBy) || other.matchedBy == matchedBy)&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nextCursor,hasMore,query,normalizedQuery,matchedBy,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'SearchResponseDto(nextCursor: $nextCursor, hasMore: $hasMore, query: $query, normalizedQuery: $normalizedQuery, matchedBy: $matchedBy, items: $items)';
}


}

/// @nodoc
abstract mixin class $SearchResponseDtoCopyWith<$Res>  {
  factory $SearchResponseDtoCopyWith(SearchResponseDto value, $Res Function(SearchResponseDto) _then) = _$SearchResponseDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'next_cursor') String? nextCursor,@JsonKey(name: 'has_more') bool hasMore, String query,@JsonKey(name: 'normalized_query') String normalizedQuery,@JsonKey(name: 'matched_by') String matchedBy, List<SearchItemDto> items
});




}
/// @nodoc
class _$SearchResponseDtoCopyWithImpl<$Res>
    implements $SearchResponseDtoCopyWith<$Res> {
  _$SearchResponseDtoCopyWithImpl(this._self, this._then);

  final SearchResponseDto _self;
  final $Res Function(SearchResponseDto) _then;

/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? nextCursor = freezed,Object? hasMore = null,Object? query = null,Object? normalizedQuery = null,Object? matchedBy = null,Object? items = null,}) {
  return _then(_self.copyWith(
nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,normalizedQuery: null == normalizedQuery ? _self.normalizedQuery : normalizedQuery // ignore: cast_nullable_to_non_nullable
as String,matchedBy: null == matchedBy ? _self.matchedBy : matchedBy // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<SearchItemDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [SearchResponseDto].
extension SearchResponseDtoPatterns on SearchResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _SearchResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _SearchResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore,  String query, @JsonKey(name: 'normalized_query')  String normalizedQuery, @JsonKey(name: 'matched_by')  String matchedBy,  List<SearchItemDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchResponseDto() when $default != null:
return $default(_that.nextCursor,_that.hasMore,_that.query,_that.normalizedQuery,_that.matchedBy,_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore,  String query, @JsonKey(name: 'normalized_query')  String normalizedQuery, @JsonKey(name: 'matched_by')  String matchedBy,  List<SearchItemDto> items)  $default,) {final _that = this;
switch (_that) {
case _SearchResponseDto():
return $default(_that.nextCursor,_that.hasMore,_that.query,_that.normalizedQuery,_that.matchedBy,_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'next_cursor')  String? nextCursor, @JsonKey(name: 'has_more')  bool hasMore,  String query, @JsonKey(name: 'normalized_query')  String normalizedQuery, @JsonKey(name: 'matched_by')  String matchedBy,  List<SearchItemDto> items)?  $default,) {final _that = this;
switch (_that) {
case _SearchResponseDto() when $default != null:
return $default(_that.nextCursor,_that.hasMore,_that.query,_that.normalizedQuery,_that.matchedBy,_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchResponseDto implements SearchResponseDto {
  const _SearchResponseDto({@JsonKey(name: 'next_cursor') this.nextCursor, @JsonKey(name: 'has_more') required this.hasMore, required this.query, @JsonKey(name: 'normalized_query') required this.normalizedQuery, @JsonKey(name: 'matched_by') required this.matchedBy, required final  List<SearchItemDto> items}): _items = items;
  factory _SearchResponseDto.fromJson(Map<String, dynamic> json) => _$SearchResponseDtoFromJson(json);

@override@JsonKey(name: 'next_cursor') final  String? nextCursor;
@override@JsonKey(name: 'has_more') final  bool hasMore;
@override final  String query;
@override@JsonKey(name: 'normalized_query') final  String normalizedQuery;
@override@JsonKey(name: 'matched_by') final  String matchedBy;
 final  List<SearchItemDto> _items;
@override List<SearchItemDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchResponseDtoCopyWith<_SearchResponseDto> get copyWith => __$SearchResponseDtoCopyWithImpl<_SearchResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchResponseDto&&(identical(other.nextCursor, nextCursor) || other.nextCursor == nextCursor)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.query, query) || other.query == query)&&(identical(other.normalizedQuery, normalizedQuery) || other.normalizedQuery == normalizedQuery)&&(identical(other.matchedBy, matchedBy) || other.matchedBy == matchedBy)&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,nextCursor,hasMore,query,normalizedQuery,matchedBy,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'SearchResponseDto(nextCursor: $nextCursor, hasMore: $hasMore, query: $query, normalizedQuery: $normalizedQuery, matchedBy: $matchedBy, items: $items)';
}


}

/// @nodoc
abstract mixin class _$SearchResponseDtoCopyWith<$Res> implements $SearchResponseDtoCopyWith<$Res> {
  factory _$SearchResponseDtoCopyWith(_SearchResponseDto value, $Res Function(_SearchResponseDto) _then) = __$SearchResponseDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'next_cursor') String? nextCursor,@JsonKey(name: 'has_more') bool hasMore, String query,@JsonKey(name: 'normalized_query') String normalizedQuery,@JsonKey(name: 'matched_by') String matchedBy, List<SearchItemDto> items
});




}
/// @nodoc
class __$SearchResponseDtoCopyWithImpl<$Res>
    implements _$SearchResponseDtoCopyWith<$Res> {
  __$SearchResponseDtoCopyWithImpl(this._self, this._then);

  final _SearchResponseDto _self;
  final $Res Function(_SearchResponseDto) _then;

/// Create a copy of SearchResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? nextCursor = freezed,Object? hasMore = null,Object? query = null,Object? normalizedQuery = null,Object? matchedBy = null,Object? items = null,}) {
  return _then(_SearchResponseDto(
nextCursor: freezed == nextCursor ? _self.nextCursor : nextCursor // ignore: cast_nullable_to_non_nullable
as String?,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,normalizedQuery: null == normalizedQuery ? _self.normalizedQuery : normalizedQuery // ignore: cast_nullable_to_non_nullable
as String,matchedBy: null == matchedBy ? _self.matchedBy : matchedBy // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<SearchItemDto>,
  ));
}


}


/// @nodoc
mixin _$SearchItemDto {

@JsonKey(name: 'product_id') int get productId; String get name; String? get brand; String? get ean;@JsonKey(name: 'unit_value') double? get unitValue;@JsonKey(name: 'unit_type') String? get unitType;@JsonKey(name: 'best_price_minor') int? get bestPriceMinor;@JsonKey(name: 'best_price_chain') String? get bestPriceChain;@JsonKey(name: 'chains_count') int get chainsCount;@JsonKey(name: 'has_promo') bool get hasPromo;@JsonKey(name: 'observed_at') DateTime? get observedAt;@JsonKey(name: 'needs_store_selection') bool get needsStoreSelection;
/// Create a copy of SearchItemDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchItemDtoCopyWith<SearchItemDto> get copyWith => _$SearchItemDtoCopyWithImpl<SearchItemDto>(this as SearchItemDto, _$identity);

  /// Serializes this SearchItemDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchItemDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.bestPriceMinor, bestPriceMinor) || other.bestPriceMinor == bestPriceMinor)&&(identical(other.bestPriceChain, bestPriceChain) || other.bestPriceChain == bestPriceChain)&&(identical(other.chainsCount, chainsCount) || other.chainsCount == chainsCount)&&(identical(other.hasPromo, hasPromo) || other.hasPromo == hasPromo)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.needsStoreSelection, needsStoreSelection) || other.needsStoreSelection == needsStoreSelection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,name,brand,ean,unitValue,unitType,bestPriceMinor,bestPriceChain,chainsCount,hasPromo,observedAt,needsStoreSelection);

@override
String toString() {
  return 'SearchItemDto(productId: $productId, name: $name, brand: $brand, ean: $ean, unitValue: $unitValue, unitType: $unitType, bestPriceMinor: $bestPriceMinor, bestPriceChain: $bestPriceChain, chainsCount: $chainsCount, hasPromo: $hasPromo, observedAt: $observedAt, needsStoreSelection: $needsStoreSelection)';
}


}

/// @nodoc
abstract mixin class $SearchItemDtoCopyWith<$Res>  {
  factory $SearchItemDtoCopyWith(SearchItemDto value, $Res Function(SearchItemDto) _then) = _$SearchItemDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') int productId, String name, String? brand, String? ean,@JsonKey(name: 'unit_value') double? unitValue,@JsonKey(name: 'unit_type') String? unitType,@JsonKey(name: 'best_price_minor') int? bestPriceMinor,@JsonKey(name: 'best_price_chain') String? bestPriceChain,@JsonKey(name: 'chains_count') int chainsCount,@JsonKey(name: 'has_promo') bool hasPromo,@JsonKey(name: 'observed_at') DateTime? observedAt,@JsonKey(name: 'needs_store_selection') bool needsStoreSelection
});




}
/// @nodoc
class _$SearchItemDtoCopyWithImpl<$Res>
    implements $SearchItemDtoCopyWith<$Res> {
  _$SearchItemDtoCopyWithImpl(this._self, this._then);

  final SearchItemDto _self;
  final $Res Function(SearchItemDto) _then;

/// Create a copy of SearchItemDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? name = null,Object? brand = freezed,Object? ean = freezed,Object? unitValue = freezed,Object? unitType = freezed,Object? bestPriceMinor = freezed,Object? bestPriceChain = freezed,Object? chainsCount = null,Object? hasPromo = null,Object? observedAt = freezed,Object? needsStoreSelection = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
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


/// Adds pattern-matching-related methods to [SearchItemDto].
extension SearchItemDtoPatterns on SearchItemDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SearchItemDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SearchItemDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SearchItemDto value)  $default,){
final _that = this;
switch (_that) {
case _SearchItemDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SearchItemDto value)?  $default,){
final _that = this;
switch (_that) {
case _SearchItemDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  int productId,  String name,  String? brand,  String? ean, @JsonKey(name: 'unit_value')  double? unitValue, @JsonKey(name: 'unit_type')  String? unitType, @JsonKey(name: 'best_price_minor')  int? bestPriceMinor, @JsonKey(name: 'best_price_chain')  String? bestPriceChain, @JsonKey(name: 'chains_count')  int chainsCount, @JsonKey(name: 'has_promo')  bool hasPromo, @JsonKey(name: 'observed_at')  DateTime? observedAt, @JsonKey(name: 'needs_store_selection')  bool needsStoreSelection)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SearchItemDto() when $default != null:
return $default(_that.productId,_that.name,_that.brand,_that.ean,_that.unitValue,_that.unitType,_that.bestPriceMinor,_that.bestPriceChain,_that.chainsCount,_that.hasPromo,_that.observedAt,_that.needsStoreSelection);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  int productId,  String name,  String? brand,  String? ean, @JsonKey(name: 'unit_value')  double? unitValue, @JsonKey(name: 'unit_type')  String? unitType, @JsonKey(name: 'best_price_minor')  int? bestPriceMinor, @JsonKey(name: 'best_price_chain')  String? bestPriceChain, @JsonKey(name: 'chains_count')  int chainsCount, @JsonKey(name: 'has_promo')  bool hasPromo, @JsonKey(name: 'observed_at')  DateTime? observedAt, @JsonKey(name: 'needs_store_selection')  bool needsStoreSelection)  $default,) {final _that = this;
switch (_that) {
case _SearchItemDto():
return $default(_that.productId,_that.name,_that.brand,_that.ean,_that.unitValue,_that.unitType,_that.bestPriceMinor,_that.bestPriceChain,_that.chainsCount,_that.hasPromo,_that.observedAt,_that.needsStoreSelection);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  int productId,  String name,  String? brand,  String? ean, @JsonKey(name: 'unit_value')  double? unitValue, @JsonKey(name: 'unit_type')  String? unitType, @JsonKey(name: 'best_price_minor')  int? bestPriceMinor, @JsonKey(name: 'best_price_chain')  String? bestPriceChain, @JsonKey(name: 'chains_count')  int chainsCount, @JsonKey(name: 'has_promo')  bool hasPromo, @JsonKey(name: 'observed_at')  DateTime? observedAt, @JsonKey(name: 'needs_store_selection')  bool needsStoreSelection)?  $default,) {final _that = this;
switch (_that) {
case _SearchItemDto() when $default != null:
return $default(_that.productId,_that.name,_that.brand,_that.ean,_that.unitValue,_that.unitType,_that.bestPriceMinor,_that.bestPriceChain,_that.chainsCount,_that.hasPromo,_that.observedAt,_that.needsStoreSelection);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SearchItemDto implements SearchItemDto {
  const _SearchItemDto({@JsonKey(name: 'product_id') required this.productId, required this.name, this.brand, this.ean, @JsonKey(name: 'unit_value') this.unitValue, @JsonKey(name: 'unit_type') this.unitType, @JsonKey(name: 'best_price_minor') this.bestPriceMinor, @JsonKey(name: 'best_price_chain') this.bestPriceChain, @JsonKey(name: 'chains_count') required this.chainsCount, @JsonKey(name: 'has_promo') required this.hasPromo, @JsonKey(name: 'observed_at') this.observedAt, @JsonKey(name: 'needs_store_selection') this.needsStoreSelection = false});
  factory _SearchItemDto.fromJson(Map<String, dynamic> json) => _$SearchItemDtoFromJson(json);

@override@JsonKey(name: 'product_id') final  int productId;
@override final  String name;
@override final  String? brand;
@override final  String? ean;
@override@JsonKey(name: 'unit_value') final  double? unitValue;
@override@JsonKey(name: 'unit_type') final  String? unitType;
@override@JsonKey(name: 'best_price_minor') final  int? bestPriceMinor;
@override@JsonKey(name: 'best_price_chain') final  String? bestPriceChain;
@override@JsonKey(name: 'chains_count') final  int chainsCount;
@override@JsonKey(name: 'has_promo') final  bool hasPromo;
@override@JsonKey(name: 'observed_at') final  DateTime? observedAt;
@override@JsonKey(name: 'needs_store_selection') final  bool needsStoreSelection;

/// Create a copy of SearchItemDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SearchItemDtoCopyWith<_SearchItemDto> get copyWith => __$SearchItemDtoCopyWithImpl<_SearchItemDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SearchItemDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SearchItemDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.brand, brand) || other.brand == brand)&&(identical(other.ean, ean) || other.ean == ean)&&(identical(other.unitValue, unitValue) || other.unitValue == unitValue)&&(identical(other.unitType, unitType) || other.unitType == unitType)&&(identical(other.bestPriceMinor, bestPriceMinor) || other.bestPriceMinor == bestPriceMinor)&&(identical(other.bestPriceChain, bestPriceChain) || other.bestPriceChain == bestPriceChain)&&(identical(other.chainsCount, chainsCount) || other.chainsCount == chainsCount)&&(identical(other.hasPromo, hasPromo) || other.hasPromo == hasPromo)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.needsStoreSelection, needsStoreSelection) || other.needsStoreSelection == needsStoreSelection));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,name,brand,ean,unitValue,unitType,bestPriceMinor,bestPriceChain,chainsCount,hasPromo,observedAt,needsStoreSelection);

@override
String toString() {
  return 'SearchItemDto(productId: $productId, name: $name, brand: $brand, ean: $ean, unitValue: $unitValue, unitType: $unitType, bestPriceMinor: $bestPriceMinor, bestPriceChain: $bestPriceChain, chainsCount: $chainsCount, hasPromo: $hasPromo, observedAt: $observedAt, needsStoreSelection: $needsStoreSelection)';
}


}

/// @nodoc
abstract mixin class _$SearchItemDtoCopyWith<$Res> implements $SearchItemDtoCopyWith<$Res> {
  factory _$SearchItemDtoCopyWith(_SearchItemDto value, $Res Function(_SearchItemDto) _then) = __$SearchItemDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') int productId, String name, String? brand, String? ean,@JsonKey(name: 'unit_value') double? unitValue,@JsonKey(name: 'unit_type') String? unitType,@JsonKey(name: 'best_price_minor') int? bestPriceMinor,@JsonKey(name: 'best_price_chain') String? bestPriceChain,@JsonKey(name: 'chains_count') int chainsCount,@JsonKey(name: 'has_promo') bool hasPromo,@JsonKey(name: 'observed_at') DateTime? observedAt,@JsonKey(name: 'needs_store_selection') bool needsStoreSelection
});




}
/// @nodoc
class __$SearchItemDtoCopyWithImpl<$Res>
    implements _$SearchItemDtoCopyWith<$Res> {
  __$SearchItemDtoCopyWithImpl(this._self, this._then);

  final _SearchItemDto _self;
  final $Res Function(_SearchItemDto) _then;

/// Create a copy of SearchItemDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? name = null,Object? brand = freezed,Object? ean = freezed,Object? unitValue = freezed,Object? unitType = freezed,Object? bestPriceMinor = freezed,Object? bestPriceChain = freezed,Object? chainsCount = null,Object? hasPromo = null,Object? observedAt = freezed,Object? needsStoreSelection = null,}) {
  return _then(_SearchItemDto(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,brand: freezed == brand ? _self.brand : brand // ignore: cast_nullable_to_non_nullable
as String?,ean: freezed == ean ? _self.ean : ean // ignore: cast_nullable_to_non_nullable
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
