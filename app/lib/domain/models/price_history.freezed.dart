// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PricePoint {

 DateTime get observedAt; int get priceMinor; int? get oldPriceMinor; bool get isPromo; String get chainCode;
/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PricePointCopyWith<PricePoint> get copyWith => _$PricePointCopyWithImpl<PricePoint>(this as PricePoint, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PricePoint&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.isPromo, isPromo) || other.isPromo == isPromo)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode));
}


@override
int get hashCode => Object.hash(runtimeType,observedAt,priceMinor,oldPriceMinor,isPromo,chainCode);

@override
String toString() {
  return 'PricePoint(observedAt: $observedAt, priceMinor: $priceMinor, oldPriceMinor: $oldPriceMinor, isPromo: $isPromo, chainCode: $chainCode)';
}


}

/// @nodoc
abstract mixin class $PricePointCopyWith<$Res>  {
  factory $PricePointCopyWith(PricePoint value, $Res Function(PricePoint) _then) = _$PricePointCopyWithImpl;
@useResult
$Res call({
 DateTime observedAt, int priceMinor, int? oldPriceMinor, bool isPromo, String chainCode
});




}
/// @nodoc
class _$PricePointCopyWithImpl<$Res>
    implements $PricePointCopyWith<$Res> {
  _$PricePointCopyWithImpl(this._self, this._then);

  final PricePoint _self;
  final $Res Function(PricePoint) _then;

/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? observedAt = null,Object? priceMinor = null,Object? oldPriceMinor = freezed,Object? isPromo = null,Object? chainCode = null,}) {
  return _then(_self.copyWith(
observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,oldPriceMinor: freezed == oldPriceMinor ? _self.oldPriceMinor : oldPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,isPromo: null == isPromo ? _self.isPromo : isPromo // ignore: cast_nullable_to_non_nullable
as bool,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [PricePoint].
extension PricePointPatterns on PricePoint {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PricePoint value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PricePoint() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PricePoint value)  $default,){
final _that = this;
switch (_that) {
case _PricePoint():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PricePoint value)?  $default,){
final _that = this;
switch (_that) {
case _PricePoint() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime observedAt,  int priceMinor,  int? oldPriceMinor,  bool isPromo,  String chainCode)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PricePoint() when $default != null:
return $default(_that.observedAt,_that.priceMinor,_that.oldPriceMinor,_that.isPromo,_that.chainCode);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime observedAt,  int priceMinor,  int? oldPriceMinor,  bool isPromo,  String chainCode)  $default,) {final _that = this;
switch (_that) {
case _PricePoint():
return $default(_that.observedAt,_that.priceMinor,_that.oldPriceMinor,_that.isPromo,_that.chainCode);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime observedAt,  int priceMinor,  int? oldPriceMinor,  bool isPromo,  String chainCode)?  $default,) {final _that = this;
switch (_that) {
case _PricePoint() when $default != null:
return $default(_that.observedAt,_that.priceMinor,_that.oldPriceMinor,_that.isPromo,_that.chainCode);case _:
  return null;

}
}

}

/// @nodoc


class _PricePoint implements PricePoint {
  const _PricePoint({required this.observedAt, required this.priceMinor, this.oldPriceMinor, required this.isPromo, required this.chainCode});
  

@override final  DateTime observedAt;
@override final  int priceMinor;
@override final  int? oldPriceMinor;
@override final  bool isPromo;
@override final  String chainCode;

/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PricePointCopyWith<_PricePoint> get copyWith => __$PricePointCopyWithImpl<_PricePoint>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PricePoint&&(identical(other.observedAt, observedAt) || other.observedAt == observedAt)&&(identical(other.priceMinor, priceMinor) || other.priceMinor == priceMinor)&&(identical(other.oldPriceMinor, oldPriceMinor) || other.oldPriceMinor == oldPriceMinor)&&(identical(other.isPromo, isPromo) || other.isPromo == isPromo)&&(identical(other.chainCode, chainCode) || other.chainCode == chainCode));
}


@override
int get hashCode => Object.hash(runtimeType,observedAt,priceMinor,oldPriceMinor,isPromo,chainCode);

@override
String toString() {
  return 'PricePoint(observedAt: $observedAt, priceMinor: $priceMinor, oldPriceMinor: $oldPriceMinor, isPromo: $isPromo, chainCode: $chainCode)';
}


}

/// @nodoc
abstract mixin class _$PricePointCopyWith<$Res> implements $PricePointCopyWith<$Res> {
  factory _$PricePointCopyWith(_PricePoint value, $Res Function(_PricePoint) _then) = __$PricePointCopyWithImpl;
@override @useResult
$Res call({
 DateTime observedAt, int priceMinor, int? oldPriceMinor, bool isPromo, String chainCode
});




}
/// @nodoc
class __$PricePointCopyWithImpl<$Res>
    implements _$PricePointCopyWith<$Res> {
  __$PricePointCopyWithImpl(this._self, this._then);

  final _PricePoint _self;
  final $Res Function(_PricePoint) _then;

/// Create a copy of PricePoint
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? observedAt = null,Object? priceMinor = null,Object? oldPriceMinor = freezed,Object? isPromo = null,Object? chainCode = null,}) {
  return _then(_PricePoint(
observedAt: null == observedAt ? _self.observedAt : observedAt // ignore: cast_nullable_to_non_nullable
as DateTime,priceMinor: null == priceMinor ? _self.priceMinor : priceMinor // ignore: cast_nullable_to_non_nullable
as int,oldPriceMinor: freezed == oldPriceMinor ? _self.oldPriceMinor : oldPriceMinor // ignore: cast_nullable_to_non_nullable
as int?,isPromo: null == isPromo ? _self.isPromo : isPromo // ignore: cast_nullable_to_non_nullable
as bool,chainCode: null == chainCode ? _self.chainCode : chainCode // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc
mixin _$PriceHistory {

 int get productId; int get days; List<PricePoint> get points;
/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PriceHistoryCopyWith<PriceHistory> get copyWith => _$PriceHistoryCopyWithImpl<PriceHistory>(this as PriceHistory, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PriceHistory&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.days, days) || other.days == days)&&const DeepCollectionEquality().equals(other.points, points));
}


@override
int get hashCode => Object.hash(runtimeType,productId,days,const DeepCollectionEquality().hash(points));

@override
String toString() {
  return 'PriceHistory(productId: $productId, days: $days, points: $points)';
}


}

/// @nodoc
abstract mixin class $PriceHistoryCopyWith<$Res>  {
  factory $PriceHistoryCopyWith(PriceHistory value, $Res Function(PriceHistory) _then) = _$PriceHistoryCopyWithImpl;
@useResult
$Res call({
 int productId, int days, List<PricePoint> points
});




}
/// @nodoc
class _$PriceHistoryCopyWithImpl<$Res>
    implements $PriceHistoryCopyWith<$Res> {
  _$PriceHistoryCopyWithImpl(this._self, this._then);

  final PriceHistory _self;
  final $Res Function(PriceHistory) _then;

/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? days = null,Object? points = null,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,
  ));
}

}


/// Adds pattern-matching-related methods to [PriceHistory].
extension PriceHistoryPatterns on PriceHistory {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PriceHistory value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PriceHistory value)  $default,){
final _that = this;
switch (_that) {
case _PriceHistory():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PriceHistory value)?  $default,){
final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int productId,  int days,  List<PricePoint> points)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
return $default(_that.productId,_that.days,_that.points);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int productId,  int days,  List<PricePoint> points)  $default,) {final _that = this;
switch (_that) {
case _PriceHistory():
return $default(_that.productId,_that.days,_that.points);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int productId,  int days,  List<PricePoint> points)?  $default,) {final _that = this;
switch (_that) {
case _PriceHistory() when $default != null:
return $default(_that.productId,_that.days,_that.points);case _:
  return null;

}
}

}

/// @nodoc


class _PriceHistory extends PriceHistory {
  const _PriceHistory({required this.productId, required this.days, required final  List<PricePoint> points}): _points = points,super._();
  

@override final  int productId;
@override final  int days;
 final  List<PricePoint> _points;
@override List<PricePoint> get points {
  if (_points is EqualUnmodifiableListView) return _points;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_points);
}


/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PriceHistoryCopyWith<_PriceHistory> get copyWith => __$PriceHistoryCopyWithImpl<_PriceHistory>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PriceHistory&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.days, days) || other.days == days)&&const DeepCollectionEquality().equals(other._points, _points));
}


@override
int get hashCode => Object.hash(runtimeType,productId,days,const DeepCollectionEquality().hash(_points));

@override
String toString() {
  return 'PriceHistory(productId: $productId, days: $days, points: $points)';
}


}

/// @nodoc
abstract mixin class _$PriceHistoryCopyWith<$Res> implements $PriceHistoryCopyWith<$Res> {
  factory _$PriceHistoryCopyWith(_PriceHistory value, $Res Function(_PriceHistory) _then) = __$PriceHistoryCopyWithImpl;
@override @useResult
$Res call({
 int productId, int days, List<PricePoint> points
});




}
/// @nodoc
class __$PriceHistoryCopyWithImpl<$Res>
    implements _$PriceHistoryCopyWith<$Res> {
  __$PriceHistoryCopyWithImpl(this._self, this._then);

  final _PriceHistory _self;
  final $Res Function(_PriceHistory) _then;

/// Create a copy of PriceHistory
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? days = null,Object? points = null,}) {
  return _then(_PriceHistory(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as int,days: null == days ? _self.days : days // ignore: cast_nullable_to_non_nullable
as int,points: null == points ? _self._points : points // ignore: cast_nullable_to_non_nullable
as List<PricePoint>,
  ));
}


}

// dart format on
