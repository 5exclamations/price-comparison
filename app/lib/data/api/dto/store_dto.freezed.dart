// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StoresResponseDto {

 List<StoreDto> get items;/// У скольких записей есть координаты. Ноль означает, что сортировать по
/// расстоянию нечем, и экран не должен обещать пользователю сортировку.
@JsonKey(name: 'coordinates_known') int get coordinatesKnown;
/// Create a copy of StoresResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoresResponseDtoCopyWith<StoresResponseDto> get copyWith => _$StoresResponseDtoCopyWithImpl<StoresResponseDto>(this as StoresResponseDto, _$identity);

  /// Serializes this StoresResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoresResponseDto&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.coordinatesKnown, coordinatesKnown) || other.coordinatesKnown == coordinatesKnown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(items),coordinatesKnown);

@override
String toString() {
  return 'StoresResponseDto(items: $items, coordinatesKnown: $coordinatesKnown)';
}


}

/// @nodoc
abstract mixin class $StoresResponseDtoCopyWith<$Res>  {
  factory $StoresResponseDtoCopyWith(StoresResponseDto value, $Res Function(StoresResponseDto) _then) = _$StoresResponseDtoCopyWithImpl;
@useResult
$Res call({
 List<StoreDto> items,@JsonKey(name: 'coordinates_known') int coordinatesKnown
});




}
/// @nodoc
class _$StoresResponseDtoCopyWithImpl<$Res>
    implements $StoresResponseDtoCopyWith<$Res> {
  _$StoresResponseDtoCopyWithImpl(this._self, this._then);

  final StoresResponseDto _self;
  final $Res Function(StoresResponseDto) _then;

/// Create a copy of StoresResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? items = null,Object? coordinatesKnown = null,}) {
  return _then(_self.copyWith(
items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<StoreDto>,coordinatesKnown: null == coordinatesKnown ? _self.coordinatesKnown : coordinatesKnown // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [StoresResponseDto].
extension StoresResponseDtoPatterns on StoresResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoresResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoresResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoresResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _StoresResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoresResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoresResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<StoreDto> items, @JsonKey(name: 'coordinates_known')  int coordinatesKnown)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoresResponseDto() when $default != null:
return $default(_that.items,_that.coordinatesKnown);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<StoreDto> items, @JsonKey(name: 'coordinates_known')  int coordinatesKnown)  $default,) {final _that = this;
switch (_that) {
case _StoresResponseDto():
return $default(_that.items,_that.coordinatesKnown);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<StoreDto> items, @JsonKey(name: 'coordinates_known')  int coordinatesKnown)?  $default,) {final _that = this;
switch (_that) {
case _StoresResponseDto() when $default != null:
return $default(_that.items,_that.coordinatesKnown);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoresResponseDto implements StoresResponseDto {
  const _StoresResponseDto({required final  List<StoreDto> items, @JsonKey(name: 'coordinates_known') required this.coordinatesKnown}): _items = items;
  factory _StoresResponseDto.fromJson(Map<String, dynamic> json) => _$StoresResponseDtoFromJson(json);

 final  List<StoreDto> _items;
@override List<StoreDto> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

/// У скольких записей есть координаты. Ноль означает, что сортировать по
/// расстоянию нечем, и экран не должен обещать пользователю сортировку.
@override@JsonKey(name: 'coordinates_known') final  int coordinatesKnown;

/// Create a copy of StoresResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoresResponseDtoCopyWith<_StoresResponseDto> get copyWith => __$StoresResponseDtoCopyWithImpl<_StoresResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoresResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoresResponseDto&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.coordinatesKnown, coordinatesKnown) || other.coordinatesKnown == coordinatesKnown));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_items),coordinatesKnown);

@override
String toString() {
  return 'StoresResponseDto(items: $items, coordinatesKnown: $coordinatesKnown)';
}


}

/// @nodoc
abstract mixin class _$StoresResponseDtoCopyWith<$Res> implements $StoresResponseDtoCopyWith<$Res> {
  factory _$StoresResponseDtoCopyWith(_StoresResponseDto value, $Res Function(_StoresResponseDto) _then) = __$StoresResponseDtoCopyWithImpl;
@override @useResult
$Res call({
 List<StoreDto> items,@JsonKey(name: 'coordinates_known') int coordinatesKnown
});




}
/// @nodoc
class __$StoresResponseDtoCopyWithImpl<$Res>
    implements _$StoresResponseDtoCopyWith<$Res> {
  __$StoresResponseDtoCopyWithImpl(this._self, this._then);

  final _StoresResponseDto _self;
  final $Res Function(_StoresResponseDto) _then;

/// Create a copy of StoresResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? items = null,Object? coordinatesKnown = null,}) {
  return _then(_StoresResponseDto(
items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<StoreDto>,coordinatesKnown: null == coordinatesKnown ? _self.coordinatesKnown : coordinatesKnown // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$StoreDto {

@JsonKey(name: 'store_id') int? get storeId;@JsonKey(name: 'chain_id') int get chainId;@JsonKey(name: 'chain_code') String get chainCode;@JsonKey(name: 'chain_name') String get chainName;@JsonKey(name: 'price_model') String get priceModel; String get name; String? get format;@JsonKey(name: 'price_cluster') String? get priceCluster; String? get address; double? get lat; double? get lon;@JsonKey(name: 'distance_m') int? get distanceM; bool get synthetic;
/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreDtoCopyWith<StoreDto> get copyWith => _$StoreDtoCopyWithImpl<StoreDto>(this as StoreDto, _$identity);

  /// Serializes this StoreDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreDto&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.chainId, chainId) || other.chainId == chainId)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.chainName, chainName) || other.chainName == chainName)&&(identical(other.priceModel, priceModel) || other.priceModel == priceModel)&&(identical(other.name, name) || other.name == name)&&(identical(other.format, format) || other.format == format)&&(identical(other.priceCluster, priceCluster) || other.priceCluster == priceCluster)&&(identical(other.address, address) || other.address == address)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.synthetic, synthetic) || other.synthetic == synthetic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeId,chainId,chainCode,chainName,priceModel,name,format,priceCluster,address,lat,lon,distanceM,synthetic);

@override
String toString() {
  return 'StoreDto(storeId: $storeId, chainId: $chainId, chainCode: $chainCode, chainName: $chainName, priceModel: $priceModel, name: $name, format: $format, priceCluster: $priceCluster, address: $address, lat: $lat, lon: $lon, distanceM: $distanceM, synthetic: $synthetic)';
}


}

/// @nodoc
abstract mixin class $StoreDtoCopyWith<$Res>  {
  factory $StoreDtoCopyWith(StoreDto value, $Res Function(StoreDto) _then) = _$StoreDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'chain_id') int chainId,@JsonKey(name: 'chain_code') String chainCode,@JsonKey(name: 'chain_name') String chainName,@JsonKey(name: 'price_model') String priceModel, String name, String? format,@JsonKey(name: 'price_cluster') String? priceCluster, String? address, double? lat, double? lon,@JsonKey(name: 'distance_m') int? distanceM, bool synthetic
});




}
/// @nodoc
class _$StoreDtoCopyWithImpl<$Res>
    implements $StoreDtoCopyWith<$Res> {
  _$StoreDtoCopyWithImpl(this._self, this._then);

  final StoreDto _self;
  final $Res Function(StoreDto) _then;

/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeId = freezed,Object? chainId = null,Object? chainCode = null,Object? chainName = null,Object? priceModel = null,Object? name = null,Object? format = freezed,Object? priceCluster = freezed,Object? address = freezed,Object? lat = freezed,Object? lon = freezed,Object? distanceM = freezed,Object? synthetic = null,}) {
  return _then(_self.copyWith(
storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,chainId: null == chainId ? _self.chainId : chainId // ignore: cast_nullable_to_non_nullable
as int,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,chainName: null == chainName ? _self.chainName : chainName // ignore: cast_nullable_to_non_nullable
as String,priceModel: null == priceModel ? _self.priceModel : priceModel // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String?,priceCluster: freezed == priceCluster ? _self.priceCluster : priceCluster // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int?,synthetic: null == synthetic ? _self.synthetic : synthetic // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreDto].
extension StoreDtoPatterns on StoreDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreDto value)  $default,){
final _that = this;
switch (_that) {
case _StoreDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'chain_id')  int chainId, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'chain_name')  String chainName, @JsonKey(name: 'price_model')  String priceModel,  String name,  String? format, @JsonKey(name: 'price_cluster')  String? priceCluster,  String? address,  double? lat,  double? lon, @JsonKey(name: 'distance_m')  int? distanceM,  bool synthetic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
return $default(_that.storeId,_that.chainId,_that.chainCode,_that.chainName,_that.priceModel,_that.name,_that.format,_that.priceCluster,_that.address,_that.lat,_that.lon,_that.distanceM,_that.synthetic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'chain_id')  int chainId, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'chain_name')  String chainName, @JsonKey(name: 'price_model')  String priceModel,  String name,  String? format, @JsonKey(name: 'price_cluster')  String? priceCluster,  String? address,  double? lat,  double? lon, @JsonKey(name: 'distance_m')  int? distanceM,  bool synthetic)  $default,) {final _that = this;
switch (_that) {
case _StoreDto():
return $default(_that.storeId,_that.chainId,_that.chainCode,_that.chainName,_that.priceModel,_that.name,_that.format,_that.priceCluster,_that.address,_that.lat,_that.lon,_that.distanceM,_that.synthetic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'chain_id')  int chainId, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'chain_name')  String chainName, @JsonKey(name: 'price_model')  String priceModel,  String name,  String? format, @JsonKey(name: 'price_cluster')  String? priceCluster,  String? address,  double? lat,  double? lon, @JsonKey(name: 'distance_m')  int? distanceM,  bool synthetic)?  $default,) {final _that = this;
switch (_that) {
case _StoreDto() when $default != null:
return $default(_that.storeId,_that.chainId,_that.chainCode,_that.chainName,_that.priceModel,_that.name,_that.format,_that.priceCluster,_that.address,_that.lat,_that.lon,_that.distanceM,_that.synthetic);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreDto implements StoreDto {
  const _StoreDto({@JsonKey(name: 'store_id') this.storeId, @JsonKey(name: 'chain_id') required this.chainId, @JsonKey(name: 'chain_code') required this.chainCode, @JsonKey(name: 'chain_name') required this.chainName, @JsonKey(name: 'price_model') required this.priceModel, required this.name, this.format, @JsonKey(name: 'price_cluster') this.priceCluster, this.address, this.lat, this.lon, @JsonKey(name: 'distance_m') this.distanceM, required this.synthetic});
  factory _StoreDto.fromJson(Map<String, dynamic> json) => _$StoreDtoFromJson(json);

@override@JsonKey(name: 'store_id') final  int? storeId;
@override@JsonKey(name: 'chain_id') final  int chainId;
@override@JsonKey(name: 'chain_code') final  String chainCode;
@override@JsonKey(name: 'chain_name') final  String chainName;
@override@JsonKey(name: 'price_model') final  String priceModel;
@override final  String name;
@override final  String? format;
@override@JsonKey(name: 'price_cluster') final  String? priceCluster;
@override final  String? address;
@override final  double? lat;
@override final  double? lon;
@override@JsonKey(name: 'distance_m') final  int? distanceM;
@override final  bool synthetic;

/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreDtoCopyWith<_StoreDto> get copyWith => __$StoreDtoCopyWithImpl<_StoreDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreDto&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.chainId, chainId) || other.chainId == chainId)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.chainName, chainName) || other.chainName == chainName)&&(identical(other.priceModel, priceModel) || other.priceModel == priceModel)&&(identical(other.name, name) || other.name == name)&&(identical(other.format, format) || other.format == format)&&(identical(other.priceCluster, priceCluster) || other.priceCluster == priceCluster)&&(identical(other.address, address) || other.address == address)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.synthetic, synthetic) || other.synthetic == synthetic));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeId,chainId,chainCode,chainName,priceModel,name,format,priceCluster,address,lat,lon,distanceM,synthetic);

@override
String toString() {
  return 'StoreDto(storeId: $storeId, chainId: $chainId, chainCode: $chainCode, chainName: $chainName, priceModel: $priceModel, name: $name, format: $format, priceCluster: $priceCluster, address: $address, lat: $lat, lon: $lon, distanceM: $distanceM, synthetic: $synthetic)';
}


}

/// @nodoc
abstract mixin class _$StoreDtoCopyWith<$Res> implements $StoreDtoCopyWith<$Res> {
  factory _$StoreDtoCopyWith(_StoreDto value, $Res Function(_StoreDto) _then) = __$StoreDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'chain_id') int chainId,@JsonKey(name: 'chain_code') String chainCode,@JsonKey(name: 'chain_name') String chainName,@JsonKey(name: 'price_model') String priceModel, String name, String? format,@JsonKey(name: 'price_cluster') String? priceCluster, String? address, double? lat, double? lon,@JsonKey(name: 'distance_m') int? distanceM, bool synthetic
});




}
/// @nodoc
class __$StoreDtoCopyWithImpl<$Res>
    implements _$StoreDtoCopyWith<$Res> {
  __$StoreDtoCopyWithImpl(this._self, this._then);

  final _StoreDto _self;
  final $Res Function(_StoreDto) _then;

/// Create a copy of StoreDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeId = freezed,Object? chainId = null,Object? chainCode = null,Object? chainName = null,Object? priceModel = null,Object? name = null,Object? format = freezed,Object? priceCluster = freezed,Object? address = freezed,Object? lat = freezed,Object? lon = freezed,Object? distanceM = freezed,Object? synthetic = null,}) {
  return _then(_StoreDto(
storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,chainId: null == chainId ? _self.chainId : chainId // ignore: cast_nullable_to_non_nullable
as int,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,chainName: null == chainName ? _self.chainName : chainName // ignore: cast_nullable_to_non_nullable
as String,priceModel: null == priceModel ? _self.priceModel : priceModel // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String?,priceCluster: freezed == priceCluster ? _self.priceCluster : priceCluster // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int?,synthetic: null == synthetic ? _self.synthetic : synthetic // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
