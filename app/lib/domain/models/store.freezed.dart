// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'store.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Store {

 int? get storeId; int get chainId; String get chainCode; String get chainName; String get priceModel; String get name; String? get format; String? get address; double? get lat; double? get lon;/// Расстояние в метрах. null, если у магазина нет координат либо точка
/// пользователя неизвестна.
 int? get distanceM;/// Одна запись на всю сеть вместо списка филиалов.
 bool get synthetic;
/// Create a copy of Store
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreCopyWith<Store> get copyWith => _$StoreCopyWithImpl<Store>(this as Store, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Store&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.chainId, chainId) || other.chainId == chainId)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.chainName, chainName) || other.chainName == chainName)&&(identical(other.priceModel, priceModel) || other.priceModel == priceModel)&&(identical(other.name, name) || other.name == name)&&(identical(other.format, format) || other.format == format)&&(identical(other.address, address) || other.address == address)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.synthetic, synthetic) || other.synthetic == synthetic));
}


@override
int get hashCode => Object.hash(runtimeType,storeId,chainId,chainCode,chainName,priceModel,name,format,address,lat,lon,distanceM,synthetic);

@override
String toString() {
  return 'Store(storeId: $storeId, chainId: $chainId, chainCode: $chainCode, chainName: $chainName, priceModel: $priceModel, name: $name, format: $format, address: $address, lat: $lat, lon: $lon, distanceM: $distanceM, synthetic: $synthetic)';
}


}

/// @nodoc
abstract mixin class $StoreCopyWith<$Res>  {
  factory $StoreCopyWith(Store value, $Res Function(Store) _then) = _$StoreCopyWithImpl;
@useResult
$Res call({
 int? storeId, int chainId, String chainCode, String chainName, String priceModel, String name, String? format, String? address, double? lat, double? lon, int? distanceM, bool synthetic
});




}
/// @nodoc
class _$StoreCopyWithImpl<$Res>
    implements $StoreCopyWith<$Res> {
  _$StoreCopyWithImpl(this._self, this._then);

  final Store _self;
  final $Res Function(Store) _then;

/// Create a copy of Store
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeId = freezed,Object? chainId = null,Object? chainCode = null,Object? chainName = null,Object? priceModel = null,Object? name = null,Object? format = freezed,Object? address = freezed,Object? lat = freezed,Object? lon = freezed,Object? distanceM = freezed,Object? synthetic = null,}) {
  return _then(_self.copyWith(
storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,chainId: null == chainId ? _self.chainId : chainId // ignore: cast_nullable_to_non_nullable
as int,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,chainName: null == chainName ? _self.chainName : chainName // ignore: cast_nullable_to_non_nullable
as String,priceModel: null == priceModel ? _self.priceModel : priceModel // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
as String?,address: freezed == address ? _self.address : address // ignore: cast_nullable_to_non_nullable
as String?,lat: freezed == lat ? _self.lat : lat // ignore: cast_nullable_to_non_nullable
as double?,lon: freezed == lon ? _self.lon : lon // ignore: cast_nullable_to_non_nullable
as double?,distanceM: freezed == distanceM ? _self.distanceM : distanceM // ignore: cast_nullable_to_non_nullable
as int?,synthetic: null == synthetic ? _self.synthetic : synthetic // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [Store].
extension StorePatterns on Store {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Store value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Store() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Store value)  $default,){
final _that = this;
switch (_that) {
case _Store():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Store value)?  $default,){
final _that = this;
switch (_that) {
case _Store() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? storeId,  int chainId,  String chainCode,  String chainName,  String priceModel,  String name,  String? format,  String? address,  double? lat,  double? lon,  int? distanceM,  bool synthetic)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Store() when $default != null:
return $default(_that.storeId,_that.chainId,_that.chainCode,_that.chainName,_that.priceModel,_that.name,_that.format,_that.address,_that.lat,_that.lon,_that.distanceM,_that.synthetic);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? storeId,  int chainId,  String chainCode,  String chainName,  String priceModel,  String name,  String? format,  String? address,  double? lat,  double? lon,  int? distanceM,  bool synthetic)  $default,) {final _that = this;
switch (_that) {
case _Store():
return $default(_that.storeId,_that.chainId,_that.chainCode,_that.chainName,_that.priceModel,_that.name,_that.format,_that.address,_that.lat,_that.lon,_that.distanceM,_that.synthetic);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? storeId,  int chainId,  String chainCode,  String chainName,  String priceModel,  String name,  String? format,  String? address,  double? lat,  double? lon,  int? distanceM,  bool synthetic)?  $default,) {final _that = this;
switch (_that) {
case _Store() when $default != null:
return $default(_that.storeId,_that.chainId,_that.chainCode,_that.chainName,_that.priceModel,_that.name,_that.format,_that.address,_that.lat,_that.lon,_that.distanceM,_that.synthetic);case _:
  return null;

}
}

}

/// @nodoc


class _Store extends Store {
  const _Store({this.storeId, required this.chainId, required this.chainCode, required this.chainName, required this.priceModel, required this.name, this.format, this.address, this.lat, this.lon, this.distanceM, required this.synthetic}): super._();
  

@override final  int? storeId;
@override final  int chainId;
@override final  String chainCode;
@override final  String chainName;
@override final  String priceModel;
@override final  String name;
@override final  String? format;
@override final  String? address;
@override final  double? lat;
@override final  double? lon;
/// Расстояние в метрах. null, если у магазина нет координат либо точка
/// пользователя неизвестна.
@override final  int? distanceM;
/// Одна запись на всю сеть вместо списка филиалов.
@override final  bool synthetic;

/// Create a copy of Store
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreCopyWith<_Store> get copyWith => __$StoreCopyWithImpl<_Store>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Store&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.chainId, chainId) || other.chainId == chainId)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.chainName, chainName) || other.chainName == chainName)&&(identical(other.priceModel, priceModel) || other.priceModel == priceModel)&&(identical(other.name, name) || other.name == name)&&(identical(other.format, format) || other.format == format)&&(identical(other.address, address) || other.address == address)&&(identical(other.lat, lat) || other.lat == lat)&&(identical(other.lon, lon) || other.lon == lon)&&(identical(other.distanceM, distanceM) || other.distanceM == distanceM)&&(identical(other.synthetic, synthetic) || other.synthetic == synthetic));
}


@override
int get hashCode => Object.hash(runtimeType,storeId,chainId,chainCode,chainName,priceModel,name,format,address,lat,lon,distanceM,synthetic);

@override
String toString() {
  return 'Store(storeId: $storeId, chainId: $chainId, chainCode: $chainCode, chainName: $chainName, priceModel: $priceModel, name: $name, format: $format, address: $address, lat: $lat, lon: $lon, distanceM: $distanceM, synthetic: $synthetic)';
}


}

/// @nodoc
abstract mixin class _$StoreCopyWith<$Res> implements $StoreCopyWith<$Res> {
  factory _$StoreCopyWith(_Store value, $Res Function(_Store) _then) = __$StoreCopyWithImpl;
@override @useResult
$Res call({
 int? storeId, int chainId, String chainCode, String chainName, String priceModel, String name, String? format, String? address, double? lat, double? lon, int? distanceM, bool synthetic
});




}
/// @nodoc
class __$StoreCopyWithImpl<$Res>
    implements _$StoreCopyWith<$Res> {
  __$StoreCopyWithImpl(this._self, this._then);

  final _Store _self;
  final $Res Function(_Store) _then;

/// Create a copy of Store
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeId = freezed,Object? chainId = null,Object? chainCode = null,Object? chainName = null,Object? priceModel = null,Object? name = null,Object? format = freezed,Object? address = freezed,Object? lat = freezed,Object? lon = freezed,Object? distanceM = freezed,Object? synthetic = null,}) {
  return _then(_Store(
storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,chainId: null == chainId ? _self.chainId : chainId // ignore: cast_nullable_to_non_nullable
as int,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,chainName: null == chainName ? _self.chainName : chainName // ignore: cast_nullable_to_non_nullable
as String,priceModel: null == priceModel ? _self.priceModel : priceModel // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,format: freezed == format ? _self.format : format // ignore: cast_nullable_to_non_nullable
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
