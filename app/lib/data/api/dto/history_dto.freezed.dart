// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'history_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$HistoryResponseDto {

@JsonKey(name: 'product_id') int get productId; int get days; DateTime get since; List<HistoryPointDto> get points; List<HistoryEventDto> get events;
/// Create a copy of HistoryResponseDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryResponseDtoCopyWith<HistoryResponseDto> get copyWith => _$HistoryResponseDtoCopyWithImpl<HistoryResponseDto>(this as HistoryResponseDto, _$identity);

  /// Serializes this HistoryResponseDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryResponseDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.days, days) || other.days == days)&&(identical(other.since, since) || other.since == since)&&const DeepCollectionEquality().equals(other.points, points)&&const DeepCollectionEquality().equals(other.events, events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,days,since,const DeepCollectionEquality().hash(points),const DeepCollectionEquality().hash(events));

@override
String toString() {
  return 'HistoryResponseDto(productId: $productId, days: $days, since: $since, points: $points, events: $events)';
}


}

/// @nodoc
abstract mixin class $HistoryResponseDtoCopyWith<$Res>  {
  factory $HistoryResponseDtoCopyWith(HistoryResponseDto value, $Res Function(HistoryResponseDto) _then) = _$HistoryResponseDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'product_id') int productId, int days, DateTime since, List<HistoryPointDto> points, List<HistoryEventDto> events
});




}
/// @nodoc
class _$HistoryResponseDtoCopyWithImpl<$Res>
    implements $HistoryResponseDtoCopyWith<$Res> {
  _$HistoryResponseDtoCopyWithImpl(this._self, this._then);

  final HistoryResponseDto _self;
  final $Res Function(HistoryResponseDto) _then;

/// Create a copy of HistoryResponseDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? days = null,Object? since = null,Object? points = null,Object? events = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,since: null == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as DateTime,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<HistoryPointDto>,events: null == events ? _self.events : events // ignore: cast_nullable_to_non_nullable
as List<HistoryEventDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryResponseDto].
extension HistoryResponseDtoPatterns on HistoryResponseDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryResponseDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryResponseDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryResponseDto value)  $default,){
final _that = this;
switch (_that) {
case _HistoryResponseDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryResponseDto value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryResponseDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  int productId,  int days,  DateTime since,  List<HistoryPointDto> points,  List<HistoryEventDto> events)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryResponseDto() when $default != null:
return $default(_that.productId,_that.days,_that.since,_that.points,_that.events);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'product_id')  int productId,  int days,  DateTime since,  List<HistoryPointDto> points,  List<HistoryEventDto> events)  $default,) {final _that = this;
switch (_that) {
case _HistoryResponseDto():
return $default(_that.productId,_that.days,_that.since,_that.points,_that.events);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'product_id')  int productId,  int days,  DateTime since,  List<HistoryPointDto> points,  List<HistoryEventDto> events)?  $default,) {final _that = this;
switch (_that) {
case _HistoryResponseDto() when $default != null:
return $default(_that.productId,_that.days,_that.since,_that.points,_that.events);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryResponseDto implements HistoryResponseDto {
  const _HistoryResponseDto({@JsonKey(name: 'product_id') required this.productId, required this.days, required this.since, required final  List<HistoryPointDto> points, required final  List<HistoryEventDto> events}): _points = points,_events = events;
  factory _HistoryResponseDto.fromJson(Map<String, dynamic> json) => _$HistoryResponseDtoFromJson(json);

@override@JsonKey(name: 'product_id') final  int productId;
@override final  int days;
@override final  DateTime since;
 final  List<HistoryPointDto> _points;
@override List<HistoryPointDto> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}

 final  List<HistoryEventDto> _events;
@override List<HistoryEventDto> get events {
  if (_events is EqualUnmodifiableListView) return _events;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_events);
}


/// Create a copy of HistoryResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryResponseDtoCopyWith<_HistoryResponseDto> get copyWith => __$HistoryResponseDtoCopyWithImpl<_HistoryResponseDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryResponseDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryResponseDto&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.days, days) || other.days == days)&&(identical(other.since, since) || other.since == since)&&const DeepCollectionEquality().equals(other._points, _points)&&const DeepCollectionEquality().equals(other._events, _events));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,productId,days,since,const DeepCollectionEquality().hash(_points),const DeepCollectionEquality().hash(_events));

@override
String toString() {
  return 'HistoryResponseDto(productId: $productId, days: $days, since: $since, points: $points, events: $events)';
}


}

/// @nodoc
abstract mixin class _$HistoryResponseDtoCopyWith<$Res> implements $HistoryResponseDtoCopyWith<$Res> {
  factory _$HistoryResponseDtoCopyWith(_HistoryResponseDto value, $Res Function(_HistoryResponseDto) _then) = __$HistoryResponseDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'product_id') int productId, int days, DateTime since, List<HistoryPointDto> points, List<HistoryEventDto> events
});




}
/// @nodoc
class __$HistoryResponseDtoCopyWithImpl<$Res>
    implements _$HistoryResponseDtoCopyWith<$Res> {
  __$HistoryResponseDtoCopyWithImpl(this._self, this._then);

  final _HistoryResponseDto _self;
  final $Res Function(_HistoryResponseDto) _then;

/// Create a copy of HistoryResponseDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? days = null,Object? since = null,Object? points = null,Object? events = null,}) {
  return _then(_HistoryResponseDto(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,since: null == since ? _self.since : since // ignore: cast_nullable_to_non_nullable
as DateTime,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<HistoryPointDto>,events: null == events ? _self._events : events // ignore: cast_nullable_to_non_nullable
as List<HistoryEventDto>,
  ));
}


}


/// @nodoc
mixin _$HistoryPointDto {

@JsonKey(name: 'observed_at') DateTime get observedAt;@JsonKey(name: 'price_minor') int get priceMinor;@JsonKey(name: 'old_price_minor') int? get oldPriceMinor;@JsonKey(name: 'is_promo') bool get isPromo; bool get available;@JsonKey(name: 'chain_code') String get chainCode;@JsonKey(name: 'store_id') int? get storeId;@JsonKey(name: 'price_cluster') String? get priceCluster;
/// Create a copy of HistoryPointDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryPointDtoCopyWith<HistoryPointDto> get copyWith => _$HistoryPointDtoCopyWithImpl<HistoryPointDto>(this as HistoryPointDto, _$identity);

  /// Serializes this HistoryPointDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryPointDto&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.isPromo, isPromo) || other.isPromo == isPromo)&&(identical(other.available, available) || other.available == available)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.priceCluster, priceCluster) || other.priceCluster == priceCluster));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,observedAt,priceMinor,oldPriceMinor,isPromo,available,chainCode,storeId,priceCluster);

@override
String toString() {
  return 'HistoryPointDto(observedAt: $observedAt, priceMinor: $priceMinor, oldPriceMinor: $oldPriceMinor, isPromo: $isPromo, available: $available, chainCode: $chainCode, storeId: $storeId, priceCluster: $priceCluster)';
}


}

/// @nodoc
abstract mixin class $HistoryPointDtoCopyWith<$Res>  {
  factory $HistoryPointDtoCopyWith(HistoryPointDto value, $Res Function(HistoryPointDto) _then) = _$HistoryPointDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'observed_at') DateTime observedAt,@JsonKey(name: 'price_minor') int priceMinor,@JsonKey(name: 'old_price_minor') int? oldPriceMinor,@JsonKey(name: 'is_promo') bool isPromo, bool available,@JsonKey(name: 'chain_code') String chainCode,@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'price_cluster') String? priceCluster
});




}
/// @nodoc
class _$HistoryPointDtoCopyWithImpl<$Res>
    implements $HistoryPointDtoCopyWith<$Res> {
  _$HistoryPointDtoCopyWithImpl(this._self, this._then);

  final HistoryPointDto _self;
  final $Res Function(HistoryPointDto) _then;

/// Create a copy of HistoryPointDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? observedAt = null,Object? priceMinor = null,Object? oldPriceMinor = freezed,Object? isPromo = null,Object? available = null,Object? chainCode = null,Object? storeId = freezed,Object? priceCluster = freezed,}) {
  return _then(_self.copyWith(
observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,oldPriceMinor: freezed == oldPriceMinor ? _self.oldPriceMinor : oldPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,isPromo: null == isPromo ? _self.isPromo : isPromo // ignore: cast_nullable_to_non_nullable
as bool,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,priceCluster: freezed == priceCluster ? _self.priceCluster : priceCluster // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryPointDto].
extension HistoryPointDtoPatterns on HistoryPointDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryPointDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryPointDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryPointDto value)  $default,){
final _that = this;
switch (_that) {
case _HistoryPointDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryPointDto value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryPointDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'observed_at')  DateTime observedAt, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'old_price_minor')  int? oldPriceMinor, @JsonKey(name: 'is_promo')  bool isPromo,  bool available, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'price_cluster')  String? priceCluster)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryPointDto() when $default != null:
return $default(_that.observedAt,_that.priceMinor,_that.oldPriceMinor,_that.isPromo,_that.available,_that.chainCode,_that.storeId,_that.priceCluster);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'observed_at')  DateTime observedAt, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'old_price_minor')  int? oldPriceMinor, @JsonKey(name: 'is_promo')  bool isPromo,  bool available, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'price_cluster')  String? priceCluster)  $default,) {final _that = this;
switch (_that) {
case _HistoryPointDto():
return $default(_that.observedAt,_that.priceMinor,_that.oldPriceMinor,_that.isPromo,_that.available,_that.chainCode,_that.storeId,_that.priceCluster);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'observed_at')  DateTime observedAt, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'old_price_minor')  int? oldPriceMinor, @JsonKey(name: 'is_promo')  bool isPromo,  bool available, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'store_id')  int? storeId, @JsonKey(name: 'price_cluster')  String? priceCluster)?  $default,) {final _that = this;
switch (_that) {
case _HistoryPointDto() when $default != null:
return $default(_that.observedAt,_that.priceMinor,_that.oldPriceMinor,_that.isPromo,_that.available,_that.chainCode,_that.storeId,_that.priceCluster);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryPointDto implements HistoryPointDto {
  const _HistoryPointDto({@JsonKey(name: 'observed_at') required this.observedAt, @JsonKey(name: 'price_minor') required this.priceMinor, @JsonKey(name: 'old_price_minor') this.oldPriceMinor, @JsonKey(name: 'is_promo') required this.isPromo, required this.available, @JsonKey(name: 'chain_code') required this.chainCode, @JsonKey(name: 'store_id') this.storeId, @JsonKey(name: 'price_cluster') this.priceCluster});
  factory _HistoryPointDto.fromJson(Map<String, dynamic> json) => _$HistoryPointDtoFromJson(json);

@override@JsonKey(name: 'observed_at') final  DateTime observedAt;
@override@JsonKey(name: 'price_minor') final  int priceMinor;
@override@JsonKey(name: 'old_price_minor') final  int? oldPriceMinor;
@override@JsonKey(name: 'is_promo') final  bool isPromo;
@override final  bool available;
@override@JsonKey(name: 'chain_code') final  String chainCode;
@override@JsonKey(name: 'store_id') final  int? storeId;
@override@JsonKey(name: 'price_cluster') final  String? priceCluster;

/// Create a copy of HistoryPointDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryPointDtoCopyWith<_HistoryPointDto> get copyWith => __$HistoryPointDtoCopyWithImpl<_HistoryPointDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryPointDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryPointDto&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.isPromo, isPromo) || other.isPromo == isPromo)&&(identical(other.available, available) || other.available == available)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.storeId, storeId) || other.storeId == storeId)&&(identical(other.priceCluster, priceCluster) || other.priceCluster == priceCluster));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,observedAt,priceMinor,oldPriceMinor,isPromo,available,chainCode,storeId,priceCluster);

@override
String toString() {
  return 'HistoryPointDto(observedAt: $observedAt, priceMinor: $priceMinor, oldPriceMinor: $oldPriceMinor, isPromo: $isPromo, available: $available, chainCode: $chainCode, storeId: $storeId, priceCluster: $priceCluster)';
}


}

/// @nodoc
abstract mixin class _$HistoryPointDtoCopyWith<$Res> implements $HistoryPointDtoCopyWith<$Res> {
  factory _$HistoryPointDtoCopyWith(_HistoryPointDto value, $Res Function(_HistoryPointDto) _then) = __$HistoryPointDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'observed_at') DateTime observedAt,@JsonKey(name: 'price_minor') int priceMinor,@JsonKey(name: 'old_price_minor') int? oldPriceMinor,@JsonKey(name: 'is_promo') bool isPromo, bool available,@JsonKey(name: 'chain_code') String chainCode,@JsonKey(name: 'store_id') int? storeId,@JsonKey(name: 'price_cluster') String? priceCluster
});




}
/// @nodoc
class __$HistoryPointDtoCopyWithImpl<$Res>
    implements _$HistoryPointDtoCopyWith<$Res> {
  __$HistoryPointDtoCopyWithImpl(this._self, this._then);

  final _HistoryPointDto _self;
  final $Res Function(_HistoryPointDto) _then;

/// Create a copy of HistoryPointDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? observedAt = null,Object? priceMinor = null,Object? oldPriceMinor = freezed,Object? isPromo = null,Object? available = null,Object? chainCode = null,Object? storeId = freezed,Object? priceCluster = freezed,}) {
  return _then(_HistoryPointDto(
observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,oldPriceMinor: freezed == oldPriceMinor ? _self.oldPriceMinor : oldPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,isPromo: null == isPromo ? _self.isPromo : isPromo // ignore: cast_nullable_to_non_nullable
as bool,available: null == available ? _self.available : available // ignore: cast_nullable_to_non_nullable
as bool,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,storeId: freezed == storeId ? _self.storeId : storeId // ignore: cast_nullable_to_non_nullable
as int?,priceCluster: freezed == priceCluster ? _self.priceCluster : priceCluster // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$HistoryEventDto {

@JsonKey(name: 'observed_at') DateTime get observedAt; String get kind;@JsonKey(name: 'chain_code') String get chainCode;@JsonKey(name: 'price_minor') int get priceMinor;@JsonKey(name: 'prev_price_minor') int get prevPriceMinor;@JsonKey(name: 'old_price_minor') int? get oldPriceMinor;@JsonKey(name: 'inflated_old_price') bool get inflatedOldPrice;
/// Create a copy of HistoryEventDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HistoryEventDtoCopyWith<HistoryEventDto> get copyWith => _$HistoryEventDtoCopyWithImpl<HistoryEventDto>(this as HistoryEventDto, _$identity);

  /// Serializes this HistoryEventDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HistoryEventDto&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.prevPriceMinor, prevPriceMinor) || other.prevPriceMinor == prevPriceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.inflatedOldPrice, inflatedOldPrice) || other.inflatedOldPrice == inflatedOldPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,observedAt,kind,chainCode,priceMinor,prevPriceMinor,oldPriceMinor,inflatedOldPrice);

@override
String toString() {
  return 'HistoryEventDto(observedAt: $observedAt, kind: $kind, chainCode: $chainCode, priceMinor: $priceMinor, prevPriceMinor: $prevPriceMinor, oldPriceMinor: $oldPriceMinor, inflatedOldPrice: $inflatedOldPrice)';
}


}

/// @nodoc
abstract mixin class $HistoryEventDtoCopyWith<$Res>  {
  factory $HistoryEventDtoCopyWith(HistoryEventDto value, $Res Function(HistoryEventDto) _then) = _$HistoryEventDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'observed_at') DateTime observedAt, String kind,@JsonKey(name: 'chain_code') String chainCode,@JsonKey(name: 'price_minor') int priceMinor,@JsonKey(name: 'prev_price_minor') int prevPriceMinor,@JsonKey(name: 'old_price_minor') int? oldPriceMinor,@JsonKey(name: 'inflated_old_price') bool inflatedOldPrice
});




}
/// @nodoc
class _$HistoryEventDtoCopyWithImpl<$Res>
    implements $HistoryEventDtoCopyWith<$Res> {
  _$HistoryEventDtoCopyWithImpl(this._self, this._then);

  final HistoryEventDto _self;
  final $Res Function(HistoryEventDto) _then;

/// Create a copy of HistoryEventDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? observedAt = null,Object? kind = null,Object? chainCode = null,Object? priceMinor = null,Object? prevPriceMinor = null,Object? oldPriceMinor = freezed,Object? inflatedOldPrice = null,}) {
  return _then(_self.copyWith(
observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,prevPriceMinor: null == prevPriceMinor ? _self.prevPriceMinor : prevPriceMinor // ignore: cast_nullable_to_non_nullable
as int,oldPriceMinor: freezed == oldPriceMinor ? _self.oldPriceMinor : oldPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,inflatedOldPrice: null == inflatedOldPrice ? _self.inflatedOldPrice : inflatedOldPrice // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [HistoryEventDto].
extension HistoryEventDtoPatterns on HistoryEventDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HistoryEventDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HistoryEventDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HistoryEventDto value)  $default,){
final _that = this;
switch (_that) {
case _HistoryEventDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HistoryEventDto value)?  $default,){
final _that = this;
switch (_that) {
case _HistoryEventDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'observed_at')  DateTime observedAt,  String kind, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'prev_price_minor')  int prevPriceMinor, @JsonKey(name: 'old_price_minor')  int? oldPriceMinor, @JsonKey(name: 'inflated_old_price')  bool inflatedOldPrice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HistoryEventDto() when $default != null:
return $default(_that.observedAt,_that.kind,_that.chainCode,_that.priceMinor,_that.prevPriceMinor,_that.oldPriceMinor,_that.inflatedOldPrice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'observed_at')  DateTime observedAt,  String kind, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'prev_price_minor')  int prevPriceMinor, @JsonKey(name: 'old_price_minor')  int? oldPriceMinor, @JsonKey(name: 'inflated_old_price')  bool inflatedOldPrice)  $default,) {final _that = this;
switch (_that) {
case _HistoryEventDto():
return $default(_that.observedAt,_that.kind,_that.chainCode,_that.priceMinor,_that.prevPriceMinor,_that.oldPriceMinor,_that.inflatedOldPrice);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'observed_at')  DateTime observedAt,  String kind, @JsonKey(name: 'chain_code')  String chainCode, @JsonKey(name: 'price_minor')  int priceMinor, @JsonKey(name: 'prev_price_minor')  int prevPriceMinor, @JsonKey(name: 'old_price_minor')  int? oldPriceMinor, @JsonKey(name: 'inflated_old_price')  bool inflatedOldPrice)?  $default,) {final _that = this;
switch (_that) {
case _HistoryEventDto() when $default != null:
return $default(_that.observedAt,_that.kind,_that.chainCode,_that.priceMinor,_that.prevPriceMinor,_that.oldPriceMinor,_that.inflatedOldPrice);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _HistoryEventDto implements HistoryEventDto {
  const _HistoryEventDto({@JsonKey(name: 'observed_at') required this.observedAt, required this.kind, @JsonKey(name: 'chain_code') required this.chainCode, @JsonKey(name: 'price_minor') required this.priceMinor, @JsonKey(name: 'prev_price_minor') required this.prevPriceMinor, @JsonKey(name: 'old_price_minor') this.oldPriceMinor, @JsonKey(name: 'inflated_old_price') this.inflatedOldPrice = false});
  factory _HistoryEventDto.fromJson(Map<String, dynamic> json) => _$HistoryEventDtoFromJson(json);

@override@JsonKey(name: 'observed_at') final  DateTime observedAt;
@override final  String kind;
@override@JsonKey(name: 'chain_code') final  String chainCode;
@override@JsonKey(name: 'price_minor') final  int priceMinor;
@override@JsonKey(name: 'prev_price_minor') final  int prevPriceMinor;
@override@JsonKey(name: 'old_price_minor') final  int? oldPriceMinor;
@override@JsonKey(name: 'inflated_old_price') final  bool inflatedOldPrice;

/// Create a copy of HistoryEventDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HistoryEventDtoCopyWith<_HistoryEventDto> get copyWith => __$HistoryEventDtoCopyWithImpl<_HistoryEventDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$HistoryEventDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _HistoryEventDto&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.prevPriceMinor, prevPriceMinor) || other.prevPriceMinor == prevPriceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.inflatedOldPrice, inflatedOldPrice) || other.inflatedOldPrice == inflatedOldPrice));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,observedAt,kind,chainCode,priceMinor,prevPriceMinor,oldPriceMinor,inflatedOldPrice);

@override
String toString() {
  return 'HistoryEventDto(observedAt: $observedAt, kind: $kind, chainCode: $chainCode, priceMinor: $priceMinor, prevPriceMinor: $prevPriceMinor, oldPriceMinor: $oldPriceMinor, inflatedOldPrice: $inflatedOldPrice)';
}


}

/// @nodoc
abstract mixin class _$HistoryEventDtoCopyWith<$Res> implements $HistoryEventDtoCopyWith<$Res> {
  factory _$HistoryEventDtoCopyWith(_HistoryEventDto value, $Res Function(_HistoryEventDto) _then) = __$HistoryEventDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'observed_at') DateTime observedAt, String kind,@JsonKey(name: 'chain_code') String chainCode,@JsonKey(name: 'price_minor') int priceMinor,@JsonKey(name: 'prev_price_minor') int prevPriceMinor,@JsonKey(name: 'old_price_minor') int? oldPriceMinor,@JsonKey(name: 'inflated_old_price') bool inflatedOldPrice
});




}
/// @nodoc
class __$HistoryEventDtoCopyWithImpl<$Res>
    implements _$HistoryEventDtoCopyWith<$Res> {
  __$HistoryEventDtoCopyWithImpl(this._self, this._then);

  final _HistoryEventDto _self;
  final $Res Function(_HistoryEventDto) _then;

/// Create a copy of HistoryEventDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? observedAt = null,Object? kind = null,Object? chainCode = null,Object? priceMinor = null,Object? prevPriceMinor = null,Object? oldPriceMinor = freezed,Object? inflatedOldPrice = null,}) {
  return _then(_HistoryEventDto(
observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,prevPriceMinor: null == prevPriceMinor ? _self.prevPriceMinor : prevPriceMinor // ignore: cast_nullable_to_non_nullable
as int,oldPriceMinor: freezed == oldPriceMinor ? _self.oldPriceMinor : oldPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,inflatedOldPrice: null == inflatedOldPrice ? _self.inflatedOldPrice : inflatedOldPrice // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
