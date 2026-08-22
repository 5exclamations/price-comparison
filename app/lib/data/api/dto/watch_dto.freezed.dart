// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watch_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WatchInDto {

@JsonKey(name: 'product_id') int get productId;@JsonKey(name: 'store_id') int? get storeId;/// Целевая цена в ГЯПИКАХ. null = хватит падения на 5%.
@JsonKey(name: 'target_price_minor') int? get targetPriceMinor;
/// Create a copy of WatchInDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchInDtoCopyWith<WatchInDto> get copyWith => _$WatchInDtoCopyWithImpl<WatchInDto>(this as WatchInDto, _$identity);

  /// Serializes this WatchInDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchInDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.targetPriceMinor, targetPriceMinor) || other.targetPriceMinor == targetPriceMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,storeId,targetPriceMinor);

@override
String toString() {
  return 'WatchInDto(productId: $productId, storeId: $storeId, targetPriceMinor: $targetPriceMinor)';
}


}

/// @nodoc
abstract mixin class $WatchInDtoCopyWith<$Res>  {
  factory $WatchInDtoCopyWith(WatchInDto value, $Res Function(WatchInDto) _then) = _$WatchInDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') int productId,@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'target_price_minor') int? targetPriceMinor
});




}
/// @nodoc
class _$WatchInDtoCopyWithImpl<$Res>
    implements $WatchInDtoCopyWith<$Res> {
  _$WatchInDtoCopyWithImpl(this._self, this._then);

  final WatchInDto _self;
  final $Res Function(WatchInDto) _then;

/// Create a copy of WatchInDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? storeId = freezed,Object? targetPriceMinor = freezed,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,targetPriceMinor: freezed == targetPriceMinor ? _self.targetPriceMinor : targetPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchInDto].
extension WatchInDtoPatterns on WatchInDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchInDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchInDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchInDto value)  $default,){
final _that = this;
switch (_that) {
case _WatchInDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchInDto value)?  $default,){
final _that = this;
switch (_that) {
case _WatchInDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'target_price_minor')  int? targetPriceMinor)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchInDto() when $default != null:
return $default(_that.productId,_that.storeId,_that.targetPriceMinor);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'target_price_minor')  int? targetPriceMinor)  $default,) {final _that = this;
switch (_that) {
case _WatchInDto():
return $default(_that.productId,_that.storeId,_that.targetPriceMinor);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'target_price_minor')  int? targetPriceMinor)?  $default,) {final _that = this;
switch (_that) {
case _WatchInDto() when $default != null:
return $default(_that.productId,_that.storeId,_that.targetPriceMinor);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WatchInDto implements WatchInDto {
  const _WatchInDto({@JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'store_id') this.storeId, @JsonKey(name: 'target_price_minor') this.targetPriceMinor});
  factory _WatchInDto.fromJson(Map<String, dynamic> json) => _$WatchInDtoFromJson(json);

@override@JsonKey(name: 'product_id') final  int productId;
@override@JsonKey(name: 'store_id') final  int? storeId;
/// Целевая цена в ГЯПИКАХ. null = хватит падения на 5%.
@override@JsonKey(name: 'target_price_minor') final  int? targetPriceMinor;

/// Create a copy of WatchInDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchInDtoCopyWith<_WatchInDto> get copyWith => __$WatchInDtoCopyWithImpl<_WatchInDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchInDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchInDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.targetPriceMinor, targetPriceMinor) || other.targetPriceMinor == targetPriceMinor));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,storeId,targetPriceMinor);

@override
String toString() {
  return 'WatchInDto(productId: $productId, storeId: $storeId, targetPriceMinor: $targetPriceMinor)';
}


}

/// @nodoc
abstract mixin class _$WatchInDtoCopyWith<$Res> implements $WatchInDtoCopyWith<$Res> {
  factory _$WatchInDtoCopyWith(_WatchInDto value, $Res Function(_WatchInDto) _then) = __$WatchInDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') int productId,@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'target_price_minor') int? targetPriceMinor
});




}
/// @nodoc
class __$WatchInDtoCopyWithImpl<$Res>
    implements _$WatchInDtoCopyWith<$Res> {
  __$WatchInDtoCopyWithImpl(this._self, this._then);

  final _WatchInDto _self;
  final $Res Function(_WatchInDto) _then;

/// Create a copy of WatchInDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? storeId = freezed,Object? targetPriceMinor = freezed,}) {
  return _then(_WatchInDto(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,targetPriceMinor: freezed == targetPriceMinor ? _self.targetPriceMinor : targetPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$WatchOutDto {

 int get id;@JsonKey(name: 'product_id') int get productId;@JsonKey(name: 'product_name') String get productName;@JsonKey(name: 'store_id') int? get storeId;@JsonKey(name: 'store_name') String? get storeName;@JsonKey(name: 'target_price_minor') int? get targetPriceMinor; bool get active;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'current_best_price_minor') int? get currentBestPriceMinor;@JsonKey(name: 'current_best_chain') String? get currentBestChain;@JsonKey(name: 'observed_at') DateTime? get observedAt;
/// Create a copy of WatchOutDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchOutDtoCopyWith<WatchOutDto> get copyWith => _$WatchOutDtoCopyWithImpl<WatchOutDto>(this as WatchOutDto, _$identity);

  /// Serializes this WatchOutDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchOutDto&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.targetPriceMinor, targetPriceMinor) || other.targetPriceMinor == targetPriceMinor)&&(identical(other.active, active) || other.active == active)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.currentBestPriceMinor, currentBestPriceMinor) || other.currentBestPriceMinor == currentBestPriceMinor)&&(identical(other.currentBestChain, currentBestChain) || other.currentBestChain == currentBestChain)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,storeId,storeName,targetPriceMinor,active,createdAt,currentBestPriceMinor,currentBestChain,observedAt);

@override
String toString() {
  return 'WatchOutDto(id: $id, productId: $productId, productName: $productName, storeId: $storeId, storeName: $storeName, targetPriceMinor: $targetPriceMinor, active: $active, createdAt: $createdAt, currentBestPriceMinor: $currentBestPriceMinor, currentBestChain: $currentBestChain, observedAt: $observedAt)';
}


}

/// @nodoc
abstract mixin class $WatchOutDtoCopyWith<$Res>  {
  factory $WatchOutDtoCopyWith(WatchOutDto value, $Res Function(WatchOutDto) _then) = _$WatchOutDtoCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'product_id') int productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'store_name') String? storeName,@JsonKey(name: 'target_price_minor') int? targetPriceMinor, bool active,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'current_best_price_minor') int? currentBestPriceMinor,@JsonKey(name: 'current_best_chain') String? currentBestChain,@JsonKey(name: 'observed_at') DateTime? observedAt
});




}
/// @nodoc
class _$WatchOutDtoCopyWithImpl<$Res>
    implements $WatchOutDtoCopyWith<$Res> {
  _$WatchOutDtoCopyWithImpl(this._self, this._then);

  final WatchOutDto _self;
  final $Res Function(WatchOutDto) _then;

/// Create a copy of WatchOutDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? storeId = freezed,Object? storeName = freezed,Object? targetPriceMinor = freezed,Object? active = null,Object? createdAt = null,Object? currentBestPriceMinor = freezed,Object? currentBestChain = freezed,Object? observedAt = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,targetPriceMinor: freezed == targetPriceMinor ? _self.targetPriceMinor : targetPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,currentBestPriceMinor: freezed == currentBestPriceMinor ? _self.currentBestPriceMinor : currentBestPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,currentBestChain: freezed == currentBestChain ? _self.currentBestChain : currentBestChain // ignore: cast_nullable_to_non_nullable
as String?,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchOutDto].
extension WatchOutDtoPatterns on WatchOutDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchOutDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchOutDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchOutDto value)  $default,){
final _that = this;
switch (_that) {
case _WatchOutDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchOutDto value)?  $default,){
final _that = this;
switch (_that) {
case _WatchOutDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'target_price_minor')  int? targetPriceMinor,  bool active, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'current_best_price_minor')  int? currentBestPriceMinor, @JsonKey(name: 'current_best_chain')  String? currentBestChain, @JsonKey(name: 'observed_at')  DateTime? observedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchOutDto() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.storeId,_that.storeName,_that.targetPriceMinor,_that.active,_that.createdAt,_that.currentBestPriceMinor,_that.currentBestChain,_that.observedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'target_price_minor')  int? targetPriceMinor,  bool active, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'current_best_price_minor')  int? currentBestPriceMinor, @JsonKey(name: 'current_best_chain')  String? currentBestChain, @JsonKey(name: 'observed_at')  DateTime? observedAt)  $default,) {final _that = this;
switch (_that) {
case _WatchOutDto():
return $default(_that.id,_that.productId,_that.productName,_that.storeId,_that.storeName,_that.targetPriceMinor,_that.active,_that.createdAt,_that.currentBestPriceMinor,_that.currentBestChain,_that.observedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'product_id')  int productId, @JsonKey(name: 'product_name')  String productName, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'target_price_minor')  int? targetPriceMinor,  bool active, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'current_best_price_minor')  int? currentBestPriceMinor, @JsonKey(name: 'current_best_chain')  String? currentBestChain, @JsonKey(name: 'observed_at')  DateTime? observedAt)?  $default,) {final _that = this;
switch (_that) {
case _WatchOutDto() when $default != null:
return $default(_that.id,_that.productId,_that.productName,_that.storeId,_that.storeName,_that.targetPriceMinor,_that.active,_that.createdAt,_that.currentBestPriceMinor,_that.currentBestChain,_that.observedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WatchOutDto implements WatchOutDto {
  const _WatchOutDto({required this.id, @JsonKey(name: 'product_id') required this.productId, @JsonKey(name: 'product_name') required this.productName, @JsonKey(name: 'store_id') this.storeId, @JsonKey(name: 'store_name') this.storeName, @JsonKey(name: 'target_price_minor') this.targetPriceMinor, required this.active, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'current_best_price_minor') this.currentBestPriceMinor, @JsonKey(name: 'current_best_chain') this.currentBestChain, @JsonKey(name: 'observed_at') this.observedAt});
  factory _WatchOutDto.fromJson(Map<String, dynamic> json) => _$WatchOutDtoFromJson(json);

@override final  int id;
@override@JsonKey(name: 'product_id') final  int productId;
@override@JsonKey(name: 'product_name') final  String productName;
@override@JsonKey(name: 'store_id') final  int? storeId;
@override@JsonKey(name: 'store_name') final  String? storeName;
@override@JsonKey(name: 'target_price_minor') final  int? targetPriceMinor;
@override final  bool active;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'current_best_price_minor') final  int? currentBestPriceMinor;
@override@JsonKey(name: 'current_best_chain') final  String? currentBestChain;
@override@JsonKey(name: 'observed_at') final  DateTime? observedAt;

/// Create a copy of WatchOutDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchOutDtoCopyWith<_WatchOutDto> get copyWith => __$WatchOutDtoCopyWithImpl<_WatchOutDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchOutDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchOutDto&&(identical(other.id, id) || other.id == id)&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.productName, productName) || other.productName == productName)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.targetPriceMinor, targetPriceMinor) || other.targetPriceMinor == targetPriceMinor)&&(identical(other.active, active) || other.active == active)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.currentBestPriceMinor, currentBestPriceMinor) || other.currentBestPriceMinor == currentBestPriceMinor)&&(identical(other.currentBestChain, currentBestChain) || other.currentBestChain == currentBestChain)&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,productId,productName,storeId,storeName,targetPriceMinor,active,createdAt,currentBestPriceMinor,currentBestChain,observedAt);

@override
String toString() {
  return 'WatchOutDto(id: $id, productId: $productId, productName: $productName, storeId: $storeId, storeName: $storeName, targetPriceMinor: $targetPriceMinor, active: $active, createdAt: $createdAt, currentBestPriceMinor: $currentBestPriceMinor, currentBestChain: $currentBestChain, observedAt: $observedAt)';
}


}

/// @nodoc
abstract mixin class _$WatchOutDtoCopyWith<$Res> implements $WatchOutDtoCopyWith<$Res> {
  factory _$WatchOutDtoCopyWith(_WatchOutDto value, $Res Function(_WatchOutDto) _then) = __$WatchOutDtoCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'product_id') int productId,@JsonKey(name: 'product_name') String productName,@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'store_name') String? storeName,@JsonKey(name: 'target_price_minor') int? targetPriceMinor, bool active,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'current_best_price_minor') int? currentBestPriceMinor,@JsonKey(name: 'current_best_chain') String? currentBestChain,@JsonKey(name: 'observed_at') DateTime? observedAt
});




}
/// @nodoc
class __$WatchOutDtoCopyWithImpl<$Res>
    implements _$WatchOutDtoCopyWith<$Res> {
  __$WatchOutDtoCopyWithImpl(this._self, this._then);

  final _WatchOutDto _self;
  final $Res Function(_WatchOutDto) _then;

/// Create a copy of WatchOutDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? productId = null,Object? productName = null,Object? storeId = freezed,Object? storeName = freezed,Object? targetPriceMinor = freezed,Object? active = null,Object? createdAt = null,Object? currentBestPriceMinor = freezed,Object? currentBestChain = freezed,Object? observedAt = freezed,}) {
  return _then(_WatchOutDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,productName: null == productName ? _self.productName : productName // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,targetPriceMinor: freezed == targetPriceMinor ? _self.targetPriceMinor : targetPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,active: null == active ? _self.active : active // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,currentBestPriceMinor: freezed == currentBestPriceMinor ? _self.currentBestPriceMinor : currentBestPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,currentBestChain: freezed == currentBestChain ? _self.currentBestChain : currentBestChain // ignore: cast_nullable_to_non_nullable
as String?,observedAt: freezed == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}


/// @nodoc
mixin _$WatchesResponseDto {

 List<WatchOutDto> get items;
/// Create a copy of WatchesResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WatchesResponseDtoCopyWith<WatchesResponseDto> get copyWith => _$WatchesResponseDtoCopyWithImpl<WatchesResponseDto>(this as WatchesResponseDto, _$identity);

  /// Serializes this WatchesResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WatchesResponseDto&&const DeepCollectionEquality().equals(other.items, items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items));

@override
String toString() {
  return 'WatchesResponseDto(items: $items)';
}


}

/// @nodoc
abstract mixin class $WatchesResponseDtoCopyWith<$Res>  {
  factory $WatchesResponseDtoCopyWith(WatchesResponseDto value, $Res Function(WatchesResponseDto) _then) = _$WatchesResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<WatchOutDto> items
});




}
/// @nodoc
class _$WatchesResponseDtoCopyWithImpl<$Res>
    implements $WatchesResponseDtoCopyWith<$Res> {
  _$WatchesResponseDtoCopyWithImpl(this._self, this._then);

  final WatchesResponseDto _self;
  final $Res Function(WatchesResponseDto) _then;

/// Create a copy of WatchesResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<WatchOutDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [WatchesResponseDto].
extension WatchesResponseDtoPatterns on WatchesResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WatchesResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WatchesResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WatchesResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _WatchesResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WatchesResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _WatchesResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<WatchOutDto> items)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WatchesResponseDto() when $default != null:
return $default(_that.items);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<WatchOutDto> items)  $default,) {final _that = this;
switch (_that) {
case _WatchesResponseDto():
return $default(_that.items);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<WatchOutDto> items)?  $default,) {final _that = this;
switch (_that) {
case _WatchesResponseDto() when $default != null:
return $default(_that.items);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WatchesResponseDto implements WatchesResponseDto {
  const _WatchesResponseDto({required final  List<WatchOutDto> items}): _items = items;
  factory _WatchesResponseDto.fromJson(Map<String, dynamic> json) => _$WatchesResponseDtoFromJson(json);

 final  List<WatchOutDto> _items;
@override List<WatchOutDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}


/// Create a copy of WatchesResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WatchesResponseDtoCopyWith<_WatchesResponseDto> get copyWith => __$WatchesResponseDtoCopyWithImpl<_WatchesResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WatchesResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WatchesResponseDto&&const DeepCollectionEquality().equals(other._items, _items));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items));

@override
String toString() {
  return 'WatchesResponseDto(items: $items)';
}


}

/// @nodoc
abstract mixin class _$WatchesResponseDtoCopyWith<$Res> implements $WatchesResponseDtoCopyWith<$Res> {
  factory _$WatchesResponseDtoCopyWith(_WatchesResponseDto value, $Res Function(_WatchesResponseDto) _then) = __$WatchesResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<WatchOutDto> items
});




}
/// @nodoc
class __$WatchesResponseDtoCopyWithImpl<$Res>
    implements _$WatchesResponseDtoCopyWith<$Res> {
  __$WatchesResponseDtoCopyWithImpl(this._self, this._then);

  final _WatchesResponseDto _self;
  final $Res Function(_WatchesResponseDto) _then;

/// Create a copy of WatchesResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,}) {
  return _then(_WatchesResponseDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<WatchOutDto>,
  ));
}


}

// dart format on
