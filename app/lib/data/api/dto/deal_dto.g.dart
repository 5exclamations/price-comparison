// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'deal_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DealsResponseDto _$DealsResponseDtoFromJson(Map<String, dynamic> json) =>
    _DealsResponseDto(
      nextCursor: json['next_cursor'] as String?,
      hasMore: json['has_more'] as bool,
      items: (json['items'] as List<dynamic>)
          .map((e) => DealDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DealsResponseDtoToJson(_DealsResponseDto instance) =>
    <String, dynamic>{
      'next_cursor': instance.nextCursor,
      'has_more': instance.hasMore,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

_DealDto _$DealDtoFromJson(Map<String, dynamic> json) => _DealDto(
  dealId: (json['deal_id'] as num).toInt(),
  productId: (json['product_id'] as num).toInt(),
  name: json['name'] as String,
  brand: json['brand'] as String?,
  ean: json['ean'] as String?,
  imageUrl: json['image_url'] as String?,
  chainCode: json['chain_code'] as String,
  storeId: (json['store_id'] as num?)?.toInt(),
  storeName: json['store_name'] as String?,
  priceCluster: json['price_cluster'] as String?,
  priceMinor: (json['price_minor'] as num).toInt(),
  oldPriceMinor: (json['old_price_minor'] as num).toInt(),
  marketPriceMinor: (json['market_price_minor'] as num).toInt(),
  referenceChains: (json['reference_chains'] as num).toInt(),
  claimedDiscount: (json['claimed_discount'] as num).toDouble(),
  realDiscount: (json['real_discount'] as num).toDouble(),
  inflation: (json['inflation'] as num).toDouble(),
  inflated: json['inflated'] as bool,
  observedAt: DateTime.parse(json['observed_at'] as String),
);

Map<String, dynamic> _$DealDtoToJson(_DealDto instance) => <String, dynamic>{
  'deal_id': instance.dealId,
  'product_id': instance.productId,
  'name': instance.name,
  'brand': instance.brand,
  'ean': instance.ean,
  'image_url': instance.imageUrl,
  'chain_code': instance.chainCode,
  'store_id': instance.storeId,
  'store_name': instance.storeName,
  'price_cluster': instance.priceCluster,
  'price_minor': instance.priceMinor,
  'old_price_minor': instance.oldPriceMinor,
  'market_price_minor': instance.marketPriceMinor,
  'reference_chains': instance.referenceChains,
  'claimed_discount': instance.claimedDiscount,
  'real_discount': instance.realDiscount,
  'inflation': instance.inflation,
  'inflated': instance.inflated,
  'observed_at': instance.observedAt.toIso8601String(),
};
