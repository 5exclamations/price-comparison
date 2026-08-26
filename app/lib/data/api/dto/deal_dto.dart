import 'package:freezed_annotation/freezed_annotation.dart';

part 'deal_dto.freezed.dart';
part 'deal_dto.g.dart';

/// Ответ GET /v1/deals.
@freezed
abstract class DealsResponseDto with _$DealsResponseDto {
  const factory DealsResponseDto({
    @JsonKey(name: 'next_cursor') String? nextCursor,
    @JsonKey(name: 'has_more') required bool hasMore,
    required List<DealDto> items,
  }) = _DealsResponseDto;

  factory DealsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DealsResponseDtoFromJson(json);
}

@freezed
abstract class DealDto with _$DealDto {
  const factory DealDto({
    @JsonKey(name: 'deal_id') required int dealId,
    @JsonKey(name: 'product_id') required int productId,
    required String name,
    String? brand,
    String? ean,
    @JsonKey(name: 'image_url') String? imageUrl,
    @JsonKey(name: 'chain_code') required String chainCode,
    @JsonKey(name: 'store_id') int? storeId,
    @JsonKey(name: 'store_name') String? storeName,
    @JsonKey(name: 'price_cluster') String? priceCluster,
    @JsonKey(name: 'price_minor') required int priceMinor,
    @JsonKey(name: 'old_price_minor') required int oldPriceMinor,
    @JsonKey(name: 'market_price_minor') required int marketPriceMinor,
    @JsonKey(name: 'reference_chains') required int referenceChains,
    @JsonKey(name: 'claimed_discount') required double claimedDiscount,
    @JsonKey(name: 'real_discount') required double realDiscount,
    required double inflation,
    required bool inflated,
    @JsonKey(name: 'observed_at') required DateTime observedAt,
  }) = _DealDto;

  factory DealDto.fromJson(Map<String, dynamic> json) =>
      _$DealDtoFromJson(json);
}
