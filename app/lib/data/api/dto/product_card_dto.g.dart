// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProductCardDto _$ProductCardDtoFromJson(Map<String, dynamic> json) =>
    _ProductCardDto(
      productId: (json['product_id'] as num).toInt(),
      name: json['name'] as String,
      brand: json['brand'] as String?,
      ean: json['ean'] as String?,
      unitValue: (json['unit_value'] as num?)?.toDouble(),
      unitType: json['unit_type'] as String?,
      prices: (json['prices'] as List<dynamic>)
          .map((e) => ChainPriceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      chainsCount: (json['chains_count'] as num).toInt(),
      bestPriceMinor: (json['best_price_minor'] as num?)?.toInt(),
      bestPriceChain: json['best_price_chain'] as String?,
      needsStoreSelection:
          (json['needs_store_selection'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const <String>[],
    );

Map<String, dynamic> _$ProductCardDtoToJson(_ProductCardDto instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
      'brand': instance.brand,
      'ean': instance.ean,
      'unit_value': instance.unitValue,
      'unit_type': instance.unitType,
      'prices': instance.prices.map((e) => e.toJson()).toList(),
      'chains_count': instance.chainsCount,
      'best_price_minor': instance.bestPriceMinor,
      'best_price_chain': instance.bestPriceChain,
      'needs_store_selection': instance.needsStoreSelection,
    };

_ChainPriceDto _$ChainPriceDtoFromJson(Map<String, dynamic> json) =>
    _ChainPriceDto(
      chainId: (json['chain_id'] as num).toInt(),
      chainCode: json['chain_code'] as String,
      chainName: json['chain_name'] as String,
      priceModel: json['price_model'] as String,
      storeId: (json['store_id'] as num?)?.toInt(),
      storeName: json['store_name'] as String?,
      priceCluster: json['price_cluster'] as String?,
      priceMinor: (json['price_minor'] as num).toInt(),
      oldPriceMinor: (json['old_price_minor'] as num?)?.toInt(),
      isPromo: json['is_promo'] as bool,
      available: json['available'] as bool,
      observedAt: DateTime.parse(json['observed_at'] as String),
      source: json['source'] as String,
      requiresStoreSelection:
          json['requires_store_selection'] as bool? ?? false,
    );

Map<String, dynamic> _$ChainPriceDtoToJson(_ChainPriceDto instance) =>
    <String, dynamic>{
      'chain_id': instance.chainId,
      'chain_code': instance.chainCode,
      'chain_name': instance.chainName,
      'price_model': instance.priceModel,
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'price_cluster': instance.priceCluster,
      'price_minor': instance.priceMinor,
      'old_price_minor': instance.oldPriceMinor,
      'is_promo': instance.isPromo,
      'available': instance.available,
      'observed_at': instance.observedAt.toIso8601String(),
      'source': instance.source,
      'requires_store_selection': instance.requiresStoreSelection,
    };
