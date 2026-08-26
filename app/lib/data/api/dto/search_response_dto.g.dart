// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SearchResponseDto _$SearchResponseDtoFromJson(Map<String, dynamic> json) =>
    _SearchResponseDto(
      nextCursor: json['next_cursor'] as String?,
      hasMore: json['has_more'] as bool,
      query: json['query'] as String,
      normalizedQuery: json['normalized_query'] as String,
      matchedBy: json['matched_by'] as String,
      items: (json['items'] as List<dynamic>)
          .map((e) => SearchItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchResponseDtoToJson(_SearchResponseDto instance) =>
    <String, dynamic>{
      'next_cursor': instance.nextCursor,
      'has_more': instance.hasMore,
      'query': instance.query,
      'normalized_query': instance.normalizedQuery,
      'matched_by': instance.matchedBy,
      'items': instance.items.map((e) => e.toJson()).toList(),
    };

_SearchItemDto _$SearchItemDtoFromJson(Map<String, dynamic> json) =>
    _SearchItemDto(
      productId: (json['product_id'] as num).toInt(),
      name: json['name'] as String,
      brand: json['brand'] as String?,
      ean: json['ean'] as String?,
      imageUrl: json['image_url'] as String?,
      unitValue: (json['unit_value'] as num?)?.toDouble(),
      unitType: json['unit_type'] as String?,
      bestPriceMinor: (json['best_price_minor'] as num?)?.toInt(),
      bestPriceChain: json['best_price_chain'] as String?,
      chainsCount: (json['chains_count'] as num).toInt(),
      hasPromo: json['has_promo'] as bool,
      observedAt: json['observed_at'] == null
          ? null
          : DateTime.parse(json['observed_at'] as String),
      needsStoreSelection: json['needs_store_selection'] as bool? ?? false,
    );

Map<String, dynamic> _$SearchItemDtoToJson(_SearchItemDto instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
      'brand': instance.brand,
      'ean': instance.ean,
      'image_url': instance.imageUrl,
      'unit_value': instance.unitValue,
      'unit_type': instance.unitType,
      'best_price_minor': instance.bestPriceMinor,
      'best_price_chain': instance.bestPriceChain,
      'chains_count': instance.chainsCount,
      'has_promo': instance.hasPromo,
      'observed_at': instance.observedAt?.toIso8601String(),
      'needs_store_selection': instance.needsStoreSelection,
    };
