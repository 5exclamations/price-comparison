// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basket_prices_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BasketPricesDto _$BasketPricesDtoFromJson(Map<String, dynamic> json) =>
    _BasketPricesDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => BasketProductDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      missing: (json['missing'] as List<dynamic>)
          .map((e) => (e as num).toInt())
          .toList(),
      staleAfterHours: (json['stale_after_hours'] as num).toInt(),
    );

Map<String, dynamic> _$BasketPricesDtoToJson(_BasketPricesDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'missing': instance.missing,
      'stale_after_hours': instance.staleAfterHours,
    };

_BasketProductDto _$BasketProductDtoFromJson(Map<String, dynamic> json) =>
    _BasketProductDto(
      productId: (json['product_id'] as num).toInt(),
      name: json['name'] as String,
      brand: json['brand'] as String?,
      ean: json['ean'] as String?,
      unitValue: (json['unit_value'] as num?)?.toDouble(),
      unitType: json['unit_type'] as String?,
      prices: (json['prices'] as List<dynamic>)
          .map((e) => ChainPriceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BasketProductDtoToJson(_BasketProductDto instance) =>
    <String, dynamic>{
      'product_id': instance.productId,
      'name': instance.name,
      'brand': instance.brand,
      'ean': instance.ean,
      'unit_value': instance.unitValue,
      'unit_type': instance.unitType,
      'prices': instance.prices.map((e) => e.toJson()).toList(),
    };
