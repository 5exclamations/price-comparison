// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WatchInDto _$WatchInDtoFromJson(Map<String, dynamic> json) => _WatchInDto(
  productId: (json['product_id'] as num).toInt(),
  storeId: (json['store_id'] as num?)?.toInt(),
  targetPriceMinor: (json['target_price_minor'] as num?)?.toInt(),
);

Map<String, dynamic> _$WatchInDtoToJson(_WatchInDto instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'store_id': instance.storeId,
      'target_price_minor': instance.targetPriceMinor,
    };

_WatchOutDto _$WatchOutDtoFromJson(Map<String, dynamic> json) => _WatchOutDto(
  id: (json['id'] as num).toInt(),
  productId: (json['product_id'] as num).toInt(),
  productName: json['product_name'] as String,
  storeId: (json['store_id'] as num?)?.toInt(),
  storeName: json['store_name'] as String?,
  targetPriceMinor: (json['target_price_minor'] as num?)?.toInt(),
  active: json['active'] as bool,
  createdAt: DateTime.parse(json['created_at'] as String),
  currentBestPriceMinor: (json['current_best_price_minor'] as num?)?.toInt(),
  currentBestChain: json['current_best_chain'] as String?,
  observedAt: json['observed_at'] == null
      ? null
      : DateTime.parse(json['observed_at'] as String),
);

Map<String, dynamic> _$WatchOutDtoToJson(_WatchOutDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product_id': instance.productId,
      'product_name': instance.productName,
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'target_price_minor': instance.targetPriceMinor,
      'active': instance.active,
      'created_at': instance.createdAt.toIso8601String(),
      'current_best_price_minor': instance.currentBestPriceMinor,
      'current_best_chain': instance.currentBestChain,
      'observed_at': instance.observedAt?.toIso8601String(),
    };

_WatchesResponseDto _$WatchesResponseDtoFromJson(Map<String, dynamic> json) =>
    _WatchesResponseDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => WatchOutDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WatchesResponseDtoToJson(_WatchesResponseDto instance) =>
    <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
