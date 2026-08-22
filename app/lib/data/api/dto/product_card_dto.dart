import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_card_dto.freezed.dart';
part 'product_card_dto.g.dart';

/// Ответ GET /v1/product/{id}.
@freezed
abstract class ProductCardDto with _$ProductCardDto {
  const factory ProductCardDto({
    @JsonKey(name: 'product_id') required int productId,
    required String name,
    String? brand,
    String? ean,
    @JsonKey(name: 'unit_value') double? unitValue,
    @JsonKey(name: 'unit_type') String? unitType,
    required List<ChainPriceDto> prices,
    @JsonKey(name: 'chains_count') required int chainsCount,
    @JsonKey(name: 'best_price_minor') int? bestPriceMinor,
    @JsonKey(name: 'best_price_chain') String? bestPriceChain,
    @JsonKey(name: 'needs_store_selection')
    @Default(<String>[])
    List<String> needsStoreSelection,
  }) = _ProductCardDto;

  factory ProductCardDto.fromJson(Map<String, dynamic> json) =>
      _$ProductCardDtoFromJson(json);
}

@freezed
abstract class ChainPriceDto with _$ChainPriceDto {
  const factory ChainPriceDto({
    @JsonKey(name: 'chain_id') required int chainId,
    @JsonKey(name: 'chain_code') required String chainCode,
    @JsonKey(name: 'chain_name') required String chainName,
    @JsonKey(name: 'price_model') required String priceModel,
    @JsonKey(name: 'store_id') int? storeId,
    @JsonKey(name: 'store_name') String? storeName,
    @JsonKey(name: 'price_cluster') String? priceCluster,
    @JsonKey(name: 'price_minor') required int priceMinor,
    @JsonKey(name: 'old_price_minor') int? oldPriceMinor,
    @JsonKey(name: 'is_promo') required bool isPromo,
    required bool available,
    @JsonKey(name: 'observed_at') required DateTime observedAt,
    required String source,
    @JsonKey(name: 'requires_store_selection')
    @Default(false)
    bool requiresStoreSelection,
  }) = _ChainPriceDto;

  factory ChainPriceDto.fromJson(Map<String, dynamic> json) =>
      _$ChainPriceDtoFromJson(json);
}
