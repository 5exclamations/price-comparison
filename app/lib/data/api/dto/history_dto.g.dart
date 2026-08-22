// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_HistoryResponseDto _$HistoryResponseDtoFromJson(Map<String, dynamic> json) =>
    _HistoryResponseDto(
      productId: (json['product_id'] as num).toInt(),
      days: (json['days'] as num).toInt(),
      since: DateTime.parse(json['since'] as String),
      points: (json['points'] as List<dynamic>)
          .map((e) => HistoryPointDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      events: (json['events'] as List<dynamic>)
          .map((e) => HistoryEventDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HistoryResponseDtoToJson(_HistoryResponseDto instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'days': instance.days,
      'since': instance.since.toIso8601String(),
      'points': instance.points.map((e) => e.toJson()).toList(),
      'events': instance.events.map((e) => e.toJson()).toList(),
    };

_HistoryPointDto _$HistoryPointDtoFromJson(Map<String, dynamic> json) =>
    _HistoryPointDto(
      observedAt: DateTime.parse(json['observed_at'] as String),
      priceMinor: (json['price_minor'] as num).toInt(),
      oldPriceMinor: (json['old_price_minor'] as num?)?.toInt(),
      isPromo: json['is_promo'] as bool,
      available: json['available'] as bool,
      chainCode: json['chain_code'] as String,
      storeId: (json['store_id'] as num?)?.toInt(),
      priceCluster: json['price_cluster'] as String?,
    );

Map<String, dynamic> _$HistoryPointDtoToJson(_HistoryPointDto instance) =>
    <String, dynamic>{
      'observed_at': instance.observedAt.toIso8601String(),
      'price_minor': instance.priceMinor,
      'old_price_minor': instance.oldPriceMinor,
      'is_promo': instance.isPromo,
      'available': instance.available,
      'chain_code': instance.chainCode,
      'store_id': instance.storeId,
      'price_cluster': instance.priceCluster,
    };

_HistoryEventDto _$HistoryEventDtoFromJson(Map<String, dynamic> json) =>
    _HistoryEventDto(
      observedAt: DateTime.parse(json['observed_at'] as String),
      kind: json['kind'] as String,
      chainCode: json['chain_code'] as String,
      priceMinor: (json['price_minor'] as num).toInt(),
      prevPriceMinor: (json['prev_price_minor'] as num).toInt(),
      oldPriceMinor: (json['old_price_minor'] as num?)?.toInt(),
      inflatedOldPrice: json['inflated_old_price'] as bool? ?? false,
    );

Map<String, dynamic> _$HistoryEventDtoToJson(_HistoryEventDto instance) =>
    <String, dynamic>{
      'observed_at': instance.observedAt.toIso8601String(),
      'kind': instance.kind,
      'chain_code': instance.chainCode,
      'price_minor': instance.priceMinor,
      'prev_price_minor': instance.prevPriceMinor,
      'old_price_minor': instance.oldPriceMinor,
      'inflated_old_price': instance.inflatedOldPrice,
    };
