// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'health_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HealthDto {

 String get status;@JsonKey(name: 'stale_after_hours') int get staleAfterHours;@JsonKey(name: 'generated_at') DateTime get generatedAt; List<ChainHealthDto> get chains;@JsonKey(name: 'data_quality') DataQualityDto get dataQuality;/// Точки, чьи данные старше staleAfterHours.
///
/// Сеть считается свежей по самой СТАРОЙ своей точке, но приложению этого
/// мало: человеку важна не сеть, а его магазин. У Bravo четыре ценовые
/// зоны, и выпавшая зона — это вчерашние цены конкретно для тех, кто её
/// выбрал.
@JsonKey(name: 'stale_store_ids') List<int> get staleStoreIds;
/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HealthDtoCopyWith<HealthDto> get copyWith => _$HealthDtoCopyWithImpl<HealthDto>(this as HealthDto, _$identity);

  /// Serializes this HealthDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HealthDto&&(identical(other.status, status) || other.status == status)&&(identical(other.staleAfterHours, staleAfterHours) || other.staleAfterHours == staleAfterHours)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&const DeepCollectionEquality().equals(other.chains, chains)&&(identical(other.dataQuality, dataQuality) || other.dataQuality == dataQuality)&&const DeepCollectionEquality().equals(other.staleStoreIds, staleStoreIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,staleAfterHours,generatedAt,const DeepCollectionEquality().hash(chains),dataQuality,const DeepCollectionEquality().hash(staleStoreIds));

@override
String toString() {
  return 'HealthDto(status: $status, staleAfterHours: $staleAfterHours, generatedAt: $generatedAt, chains: $chains, dataQuality: $dataQuality, staleStoreIds: $staleStoreIds)';
}


}

/// @nodoc
abstract mixin class $HealthDtoCopyWith<$Res>  {
  factory $HealthDtoCopyWith(HealthDto value, $Res Function(HealthDto) _then) = _$HealthDtoCopyWithImpl;
@useResult
$Res call({
 String status,@JsonKey(name: 'stale_after_hours') int staleAfterHours,@JsonKey(name: 'generated_at') DateTime generatedAt, List<ChainHealthDto> chains,@JsonKey(name: 'data_quality') DataQualityDto dataQuality,@JsonKey(name: 'stale_store_ids') List<int> staleStoreIds
});


$DataQualityDtoCopyWith<$Res> get dataQuality;

}
/// @nodoc
class _$HealthDtoCopyWithImpl<$Res>
    implements $HealthDtoCopyWith<$Res> {
  _$HealthDtoCopyWithImpl(this._self, this._then);

  final HealthDto _self;
  final $Res Function(HealthDto) _then;

/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? staleAfterHours = null,Object? generatedAt = null,Object? chains = null,Object? dataQuality = null,Object? staleStoreIds = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,staleAfterHours: null == staleAfterHours ? _self.staleAfterHours : staleAfterHours // ignore: cast_nullable_to_non_nullable
as int,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,chains: null == chains ? _self.chains : chains // ignore: cast_nullable_to_non_nullable
as List<ChainHealthDto>,dataQuality: null == dataQuality ? _self.dataQuality : dataQuality // ignore: cast_nullable_to_non_nullable
as DataQualityDto,staleStoreIds: null == staleStoreIds ? _self.staleStoreIds : staleStoreIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}
/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DataQualityDtoCopyWith<$Res> get dataQuality {
  
  return $DataQualityDtoCopyWith<$Res>(_self.dataQuality, (value) {
    return _then(_self.copyWith(dataQuality: value));
  });
}
}


/// Adds pattern-matching-related methods to [HealthDto].
extension HealthDtoPatterns on HealthDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HealthDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HealthDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HealthDto value)  $default,){
final _that = this;
switch (_that) {
case _HealthDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HealthDto value)?  $default,){
final _that = this;
switch (_that) {
case _HealthDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String status, @JsonKey(name: 'stale_after_hours')  int staleAfterHours, @JsonKey(name: 'generated_at')  DateTime generatedAt,  List<ChainHealthDto> chains, @JsonKey(name: 'data_quality')  DataQualityDto dataQuality, @JsonKey(name: 'stale_store_ids')  List<int> staleStoreIds)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HealthDto() when $default != null:
return $default(_that.status,_that.staleAfterHours,_that.generatedAt,_that.chains,_that.dataQuality,_that.staleStoreIds);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String status, @JsonKey(name: 'stale_after_hours')  int staleAfterHours, @JsonKey(name: 'generated_at')  DateTime generatedAt,  List<ChainHealthDto> chains, @JsonKey(name: 'data_quality')  DataQualityDto dataQuality, @JsonKey(name: 'stale_store_ids')  List<int> staleStoreIds)  $default,) {final _that = this;
switch (_that) {
case _HealthDto():
return $default(_that.status,_that.staleAfterHours,_that.generatedAt,_that.chains,_that.dataQuality,_that.staleStoreIds);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String status, @JsonKey(name: 'stale_after_hours')  int staleAfterHours, @JsonKey(name: 'generated_at')  DateTime generatedAt,  List<ChainHealthDto> chains, @JsonKey(name: 'data_quality')  DataQualityDto dataQuality, @JsonKey(name: 'stale_store_ids')  List<int> staleStoreIds)?  $default,) {final _that = this;
switch (_that) {
case _HealthDto() when $default != null:
return $default(_that.status,_that.staleAfterHours,_that.generatedAt,_that.chains,_that.dataQuality,_that.staleStoreIds);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HealthDto implements HealthDto {
  const _HealthDto({required this.status, @JsonKey(name: 'stale_after_hours') required this.staleAfterHours, @JsonKey(name: 'generated_at') required this.generatedAt, required final  List<ChainHealthDto> chains, @JsonKey(name: 'data_quality') required this.dataQuality, @JsonKey(name: 'stale_store_ids') final  List<int> staleStoreIds = const <int>[]}): _chains = chains,_staleStoreIds = staleStoreIds;
  factory _HealthDto.fromJson(Map<String, dynamic> json) => _$HealthDtoFromJson(json);

@override final  String status;
@override@JsonKey(name: 'stale_after_hours') final  int staleAfterHours;
@override@JsonKey(name: 'generated_at') final  DateTime generatedAt;
 final  List<ChainHealthDto> _chains;
@override List<ChainHealthDto> get chains {
  if (_chains is EqualUnmodifiableListView) return _chains;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_chains);
}

@override@JsonKey(name: 'data_quality') final  DataQualityDto dataQuality;
/// Точки, чьи данные старше staleAfterHours.
///
/// Сеть считается свежей по самой СТАРОЙ своей точке, но приложению этого
/// мало: человеку важна не сеть, а его магазин. У Bravo четыре ценовые
/// зоны, и выпавшая зона — это вчерашние цены конкретно для тех, кто её
/// выбрал.
 final  List<int> _staleStoreIds;
/// Точки, чьи данные старше staleAfterHours.
///
/// Сеть считается свежей по самой СТАРОЙ своей точке, но приложению этого
/// мало: человеку важна не сеть, а его магазин. У Bravo четыре ценовые
/// зоны, и выпавшая зона — это вчерашние цены конкретно для тех, кто её
/// выбрал.
@override@JsonKey(name: 'stale_store_ids') List<int> get staleStoreIds {
  if (_staleStoreIds is EqualUnmodifiableListView) return _staleStoreIds;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_staleStoreIds);
}


/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HealthDtoCopyWith<_HealthDto> get copyWith => __$HealthDtoCopyWithImpl<_HealthDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HealthDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HealthDto&&(identical(other.status, status) || other.status == status)&&(identical(other.staleAfterHours, staleAfterHours) || other.staleAfterHours == staleAfterHours)&&(identical(other.generatedAt, generatedAt) || other.generatedAt == generatedAt)&&const DeepCollectionEquality().equals(other._chains, _chains)&&(identical(other.dataQuality, dataQuality) || other.dataQuality == dataQuality)&&const DeepCollectionEquality().equals(other._staleStoreIds, _staleStoreIds));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,status,staleAfterHours,generatedAt,const DeepCollectionEquality().hash(_chains),dataQuality,const DeepCollectionEquality().hash(_staleStoreIds));

@override
String toString() {
  return 'HealthDto(status: $status, staleAfterHours: $staleAfterHours, generatedAt: $generatedAt, chains: $chains, dataQuality: $dataQuality, staleStoreIds: $staleStoreIds)';
}


}

/// @nodoc
abstract mixin class _$HealthDtoCopyWith<$Res> implements $HealthDtoCopyWith<$Res> {
  factory _$HealthDtoCopyWith(_HealthDto value, $Res Function(_HealthDto) _then) = __$HealthDtoCopyWithImpl;
@override @useResult
$Res call({
 String status,@JsonKey(name: 'stale_after_hours') int staleAfterHours,@JsonKey(name: 'generated_at') DateTime generatedAt, List<ChainHealthDto> chains,@JsonKey(name: 'data_quality') DataQualityDto dataQuality,@JsonKey(name: 'stale_store_ids') List<int> staleStoreIds
});


@override $DataQualityDtoCopyWith<$Res> get dataQuality;

}
/// @nodoc
class __$HealthDtoCopyWithImpl<$Res>
    implements _$HealthDtoCopyWith<$Res> {
  __$HealthDtoCopyWithImpl(this._self, this._then);

  final _HealthDto _self;
  final $Res Function(_HealthDto) _then;

/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? staleAfterHours = null,Object? generatedAt = null,Object? chains = null,Object? dataQuality = null,Object? staleStoreIds = null,}) {
  return _then(_HealthDto(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,staleAfterHours: null == staleAfterHours ? _self.staleAfterHours : staleAfterHours // ignore: cast_nullable_to_non_nullable
as int,generatedAt: null == generatedAt ? _self.generatedAt : generatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,chains: null == chains ? _self._chains : chains // ignore: cast_nullable_to_non_nullable
as List<ChainHealthDto>,dataQuality: null == dataQuality ? _self.dataQuality : dataQuality // ignore: cast_nullable_to_non_nullable
as DataQualityDto,staleStoreIds: null == staleStoreIds ? _self._staleStoreIds : staleStoreIds // ignore: cast_nullable_to_non_nullable
as List<int>,
  ));
}

/// Create a copy of HealthDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$DataQualityDtoCopyWith<$Res> get dataQuality {
  
  return $DataQualityDtoCopyWith<$Res>(_self.dataQuality, (value) {
    return _then(_self.copyWith(dataQuality: value));
  });
}
}


/// @nodoc
mixin _$ChainHealthDto {

@JsonKey(name: 'chain_code') String get chainCode;@JsonKey(name: 'chain_name') String get chainName;@JsonKey(name: 'age_hours') double? get ageHours; String get status; List<StoreHealthDto> get stores;
/// Create a copy of ChainHealthDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChainHealthDtoCopyWith<ChainHealthDto> get copyWith => _$ChainHealthDtoCopyWithImpl<ChainHealthDto>(this as ChainHealthDto, _$identity);

  /// Serializes this ChainHealthDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChainHealthDto&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.chainName, chainName) || other.chainName == chainName)&&(identical(other.ageHours, ageHours) || other.ageHours == ageHours)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.stores, stores));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chainCode,chainName,ageHours,status,const DeepCollectionEquality().hash(stores));

@override
String toString() {
  return 'ChainHealthDto(chainCode: $chainCode, chainName: $chainName, ageHours: $ageHours, status: $status, stores: $stores)';
}


}

/// @nodoc
abstract mixin class $ChainHealthDtoCopyWith<$Res>  {
  factory $ChainHealthDtoCopyWith(ChainHealthDto value, $Res Function(ChainHealthDto) _then) = _$ChainHealthDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'chain_code') String chainCode,@JsonKey(name: 'chain_name') String chainName,@JsonKey(name: 'age_hours') double? ageHours, String status, List<StoreHealthDto> stores
});




}
/// @nodoc
class _$ChainHealthDtoCopyWithImpl<$Res>
    implements $ChainHealthDtoCopyWith<$Res> {
  _$ChainHealthDtoCopyWithImpl(this._self, this._then);

  final ChainHealthDto _self;
  final $Res Function(ChainHealthDto) _then;

/// Create a copy of ChainHealthDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? chainCode = null,Object? chainName = null,Object? ageHours = freezed,Object? status = null,Object? stores = null,}) {
  return _then(_self.copyWith(
chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,chainName: null == chainName ? _self.chainName : chainName // ignore: cast_nullable_to_non_nullable
as String,ageHours: freezed == ageHours ? _self.ageHours : ageHours // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,stores: null == stores ? _self.stores : stores // ignore: cast_nullable_to_non_nullable
as List<StoreHealthDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ChainHealthDto].
extension ChainHealthDtoPatterns on ChainHealthDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChainHealthDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChainHealthDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChainHealthDto value)  $default,){
final _that = this;
switch (_that) {
case _ChainHealthDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChainHealthDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChainHealthDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'chain_name')  String chainName, @JsonKey(name: 'age_hours')  double? ageHours,  String status,  List<StoreHealthDto> stores)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChainHealthDto() when $default != null:
return $default(_that.chainCode,_that.chainName,_that.ageHours,_that.status,_that.stores);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'chain_name')  String chainName, @JsonKey(name: 'age_hours')  double? ageHours,  String status,  List<StoreHealthDto> stores)  $default,) {final _that = this;
switch (_that) {
case _ChainHealthDto():
return $default(_that.chainCode,_that.chainName,_that.ageHours,_that.status,_that.stores);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'chain_name')  String chainName, @JsonKey(name: 'age_hours')  double? ageHours,  String status,  List<StoreHealthDto> stores)?  $default,) {final _that = this;
switch (_that) {
case _ChainHealthDto() when $default != null:
return $default(_that.chainCode,_that.chainName,_that.ageHours,_that.status,_that.stores);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChainHealthDto implements ChainHealthDto {
  const _ChainHealthDto({@JsonKey(name: 'chain_code') required this.chainCode, @JsonKey(name: 'chain_name') required this.chainName, @JsonKey(name: 'age_hours') this.ageHours, required this.status, final  List<StoreHealthDto> stores = const <StoreHealthDto>[]}): _stores = stores;
  factory _ChainHealthDto.fromJson(Map<String, dynamic> json) => _$ChainHealthDtoFromJson(json);

@override@JsonKey(name: 'chain_code') final  String chainCode;
@override@JsonKey(name: 'chain_name') final  String chainName;
@override@JsonKey(name: 'age_hours') final  double? ageHours;
@override final  String status;
 final  List<StoreHealthDto> _stores;
@override@JsonKey() List<StoreHealthDto> get stores {
  if (_stores is EqualUnmodifiableListView) return _stores;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_stores);
}


/// Create a copy of ChainHealthDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChainHealthDtoCopyWith<_ChainHealthDto> get copyWith => __$ChainHealthDtoCopyWithImpl<_ChainHealthDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChainHealthDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChainHealthDto&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.chainName, chainName) || other.chainName == chainName)&&(identical(other.ageHours, ageHours) || other.ageHours == ageHours)&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._stores, _stores));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,chainCode,chainName,ageHours,status,const DeepCollectionEquality().hash(_stores));

@override
String toString() {
  return 'ChainHealthDto(chainCode: $chainCode, chainName: $chainName, ageHours: $ageHours, status: $status, stores: $stores)';
}


}

/// @nodoc
abstract mixin class _$ChainHealthDtoCopyWith<$Res> implements $ChainHealthDtoCopyWith<$Res> {
  factory _$ChainHealthDtoCopyWith(_ChainHealthDto value, $Res Function(_ChainHealthDto) _then) = __$ChainHealthDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'chain_code') String chainCode,@JsonKey(name: 'chain_name') String chainName,@JsonKey(name: 'age_hours') double? ageHours, String status, List<StoreHealthDto> stores
});




}
/// @nodoc
class __$ChainHealthDtoCopyWithImpl<$Res>
    implements _$ChainHealthDtoCopyWith<$Res> {
  __$ChainHealthDtoCopyWithImpl(this._self, this._then);

  final _ChainHealthDto _self;
  final $Res Function(_ChainHealthDto) _then;

/// Create a copy of ChainHealthDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? chainCode = null,Object? chainName = null,Object? ageHours = freezed,Object? status = null,Object? stores = null,}) {
  return _then(_ChainHealthDto(
chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,chainName: null == chainName ? _self.chainName : chainName // ignore: cast_nullable_to_non_nullable
as String,ageHours: freezed == ageHours ? _self.ageHours : ageHours // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,stores: null == stores ? _self._stores : stores // ignore: cast_nullable_to_non_nullable
as List<StoreHealthDto>,
  ));
}


}


/// @nodoc
mixin _$StoreHealthDto {

@JsonKey(name: 'store_id') int? get storeId;@JsonKey(name: 'store_name') String? get storeName;@JsonKey(name: 'age_hours') double? get ageHours; String get status;
/// Create a copy of StoreHealthDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoreHealthDtoCopyWith<StoreHealthDto> get copyWith => _$StoreHealthDtoCopyWithImpl<StoreHealthDto>(this as StoreHealthDto, _$identity);

  /// Serializes this StoreHealthDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoreHealthDto&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.ageHours, ageHours) || other.ageHours == ageHours)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeId,storeName,ageHours,status);

@override
String toString() {
  return 'StoreHealthDto(storeId: $storeId, storeName: $storeName, ageHours: $ageHours, status: $status)';
}


}

/// @nodoc
abstract mixin class $StoreHealthDtoCopyWith<$Res>  {
  factory $StoreHealthDtoCopyWith(StoreHealthDto value, $Res Function(StoreHealthDto) _then) = _$StoreHealthDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'store_name') String? storeName,@JsonKey(name: 'age_hours') double? ageHours, String status
});




}
/// @nodoc
class _$StoreHealthDtoCopyWithImpl<$Res>
    implements $StoreHealthDtoCopyWith<$Res> {
  _$StoreHealthDtoCopyWithImpl(this._self, this._then);

  final StoreHealthDto _self;
  final $Res Function(StoreHealthDto) _then;

/// Create a copy of StoreHealthDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? storeId = freezed,Object? storeName = freezed,Object? ageHours = freezed,Object? status = null,}) {
  return _then(_self.copyWith(
storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,ageHours: freezed == ageHours ? _self.ageHours : ageHours // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [StoreHealthDto].
extension StoreHealthDtoPatterns on StoreHealthDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StoreHealthDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StoreHealthDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StoreHealthDto value)  $default,){
final _that = this;
switch (_that) {
case _StoreHealthDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StoreHealthDto value)?  $default,){
final _that = this;
switch (_that) {
case _StoreHealthDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'age_hours')  double? ageHours,  String status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StoreHealthDto() when $default != null:
return $default(_that.storeId,_that.storeName,_that.ageHours,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'age_hours')  double? ageHours,  String status)  $default,) {final _that = this;
switch (_that) {
case _StoreHealthDto():
return $default(_that.storeId,_that.storeName,_that.ageHours,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'store_name')  String? storeName, @JsonKey(name: 'age_hours')  double? ageHours,  String status)?  $default,) {final _that = this;
switch (_that) {
case _StoreHealthDto() when $default != null:
return $default(_that.storeId,_that.storeName,_that.ageHours,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _StoreHealthDto implements StoreHealthDto {
  const _StoreHealthDto({@JsonKey(name: 'store_id') this.storeId, @JsonKey(name: 'store_name') this.storeName, @JsonKey(name: 'age_hours') this.ageHours, required this.status});
  factory _StoreHealthDto.fromJson(Map<String, dynamic> json) => _$StoreHealthDtoFromJson(json);

@override@JsonKey(name: 'store_id') final  int? storeId;
@override@JsonKey(name: 'store_name') final  String? storeName;
@override@JsonKey(name: 'age_hours') final  double? ageHours;
@override final  String status;

/// Create a copy of StoreHealthDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoreHealthDtoCopyWith<_StoreHealthDto> get copyWith => __$StoreHealthDtoCopyWithImpl<_StoreHealthDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StoreHealthDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoreHealthDto&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.storeName, storeName) || other.storeName == storeName)&&(identical(other.ageHours, ageHours) || other.ageHours == ageHours)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,storeId,storeName,ageHours,status);

@override
String toString() {
  return 'StoreHealthDto(storeId: $storeId, storeName: $storeName, ageHours: $ageHours, status: $status)';
}


}

/// @nodoc
abstract mixin class _$StoreHealthDtoCopyWith<$Res> implements $StoreHealthDtoCopyWith<$Res> {
  factory _$StoreHealthDtoCopyWith(_StoreHealthDto value, $Res Function(_StoreHealthDto) _then) = __$StoreHealthDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'store_name') String? storeName,@JsonKey(name: 'age_hours') double? ageHours, String status
});




}
/// @nodoc
class __$StoreHealthDtoCopyWithImpl<$Res>
    implements _$StoreHealthDtoCopyWith<$Res> {
  __$StoreHealthDtoCopyWithImpl(this._self, this._then);

  final _StoreHealthDto _self;
  final $Res Function(_StoreHealthDto) _then;

/// Create a copy of StoreHealthDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? storeId = freezed,Object? storeName = freezed,Object? ageHours = freezed,Object? status = null,}) {
  return _then(_StoreHealthDto(
storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,storeName: freezed == storeName ? _self.storeName : storeName // ignore: cast_nullable_to_non_nullable
as String?,ageHours: freezed == ageHours ? _self.ageHours : ageHours // ignore: cast_nullable_to_non_nullable
as double?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$DataQualityDto {

@JsonKey(name: 'checked_at') DateTime? get checkedAt;/// false — приложение обязано показать плашку вместо цен.
 bool get passed;@JsonKey(name: 'failed_checks') List<String> get failedChecks;
/// Create a copy of DataQualityDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataQualityDtoCopyWith<DataQualityDto> get copyWith => _$DataQualityDtoCopyWithImpl<DataQualityDto>(this as DataQualityDto, _$identity);

  /// Serializes this DataQualityDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataQualityDto&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.passed, passed) || other.passed == passed)&&const DeepCollectionEquality().equals(other.failedChecks, failedChecks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checkedAt,passed,const DeepCollectionEquality().hash(failedChecks));

@override
String toString() {
  return 'DataQualityDto(checkedAt: $checkedAt, passed: $passed, failedChecks: $failedChecks)';
}


}

/// @nodoc
abstract mixin class $DataQualityDtoCopyWith<$Res>  {
  factory $DataQualityDtoCopyWith(DataQualityDto value, $Res Function(DataQualityDto) _then) = _$DataQualityDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'checked_at') DateTime? checkedAt, bool passed,@JsonKey(name: 'failed_checks') List<String> failedChecks
});




}
/// @nodoc
class _$DataQualityDtoCopyWithImpl<$Res>
    implements $DataQualityDtoCopyWith<$Res> {
  _$DataQualityDtoCopyWithImpl(this._self, this._then);

  final DataQualityDto _self;
  final $Res Function(DataQualityDto) _then;

/// Create a copy of DataQualityDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? checkedAt = freezed,Object? passed = null,Object? failedChecks = null,}) {
  return _then(_self.copyWith(
checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool,failedChecks: null == failedChecks ? _self.failedChecks : failedChecks // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [DataQualityDto].
extension DataQualityDtoPatterns on DataQualityDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataQualityDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataQualityDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataQualityDto value)  $default,){
final _that = this;
switch (_that) {
case _DataQualityDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataQualityDto value)?  $default,){
final _that = this;
switch (_that) {
case _DataQualityDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'checked_at')  DateTime? checkedAt,  bool passed, @JsonKey(name: 'failed_checks')  List<String> failedChecks)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DataQualityDto() when $default != null:
return $default(_that.checkedAt,_that.passed,_that.failedChecks);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'checked_at')  DateTime? checkedAt,  bool passed, @JsonKey(name: 'failed_checks')  List<String> failedChecks)  $default,) {final _that = this;
switch (_that) {
case _DataQualityDto():
return $default(_that.checkedAt,_that.passed,_that.failedChecks);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'checked_at')  DateTime? checkedAt,  bool passed, @JsonKey(name: 'failed_checks')  List<String> failedChecks)?  $default,) {final _that = this;
switch (_that) {
case _DataQualityDto() when $default != null:
return $default(_that.checkedAt,_that.passed,_that.failedChecks);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DataQualityDto implements DataQualityDto {
  const _DataQualityDto({@JsonKey(name: 'checked_at') this.checkedAt, required this.passed, @JsonKey(name: 'failed_checks') final  List<String> failedChecks = const <String>[]}): _failedChecks = failedChecks;
  factory _DataQualityDto.fromJson(Map<String, dynamic> json) => _$DataQualityDtoFromJson(json);

@override@JsonKey(name: 'checked_at') final  DateTime? checkedAt;
/// false — приложение обязано показать плашку вместо цен.
@override final  bool passed;
 final  List<String> _failedChecks;
@override@JsonKey(name: 'failed_checks') List<String> get failedChecks {
  if (_failedChecks is EqualUnmodifiableListView) return _failedChecks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_failedChecks);
}


/// Create a copy of DataQualityDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataQualityDtoCopyWith<_DataQualityDto> get copyWith => __$DataQualityDtoCopyWithImpl<_DataQualityDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DataQualityDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataQualityDto&&(identical(other.checkedAt, checkedAt) || other.checkedAt == checkedAt)&&(identical(other.passed, passed) || other.passed == passed)&&const DeepCollectionEquality().equals(other._failedChecks, _failedChecks));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,checkedAt,passed,const DeepCollectionEquality().hash(_failedChecks));

@override
String toString() {
  return 'DataQualityDto(checkedAt: $checkedAt, passed: $passed, failedChecks: $failedChecks)';
}


}

/// @nodoc
abstract mixin class _$DataQualityDtoCopyWith<$Res> implements $DataQualityDtoCopyWith<$Res> {
  factory _$DataQualityDtoCopyWith(_DataQualityDto value, $Res Function(_DataQualityDto) _then) = __$DataQualityDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'checked_at') DateTime? checkedAt, bool passed,@JsonKey(name: 'failed_checks') List<String> failedChecks
});




}
/// @nodoc
class __$DataQualityDtoCopyWithImpl<$Res>
    implements _$DataQualityDtoCopyWith<$Res> {
  __$DataQualityDtoCopyWithImpl(this._self, this._then);

  final _DataQualityDto _self;
  final $Res Function(_DataQualityDto) _then;

/// Create a copy of DataQualityDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? checkedAt = freezed,Object? passed = null,Object? failedChecks = null,}) {
  return _then(_DataQualityDto(
checkedAt: freezed == checkedAt ? _self.checkedAt : checkedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,passed: null == passed ? _self.passed : passed // ignore: cast_nullable_to_non_nullable
as bool,failedChecks: null == failedChecks ? _self._failedChecks : failedChecks // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}

// dart format on
