import 'package:freezed_annotation/freezed_annotation.dart';

import 'product_card_dto.dart';

part 'basket_prices_dto.freezed.dart';
part 'basket_prices_dto.g.dart';

/// Ответ GET /v1/prices.
@freezed
abstract class BasketPricesDto with _$BasketPricesDto {
  const factory BasketPricesDto({
    required List<BasketProductDto> items,

    /// Запрошенные товары, которых нет: удалены либо склейка в карантине.
    /// Клиенту важно отличать «нет цены» от «мы это потеряли».
    required List<int> missing,
    @JsonKey(name: 'stale_after_hours') required int staleAfterHours,
  }) = _BasketPricesDto;

  factory BasketPricesDto.fromJson(Map<String, dynamic> json) =>
      _$BasketPricesDtoFromJson(json);
}

@freezed
abstract class BasketProductDto with _$BasketProductDto {
  const factory BasketProductDto({
    @JsonKey(name: 'product_id') required int productId,
    required String name,
    String? brand,
    String? ean,
    @JsonKey(name: 'unit_value') double? unitValue,
    @JsonKey(name: 'unit_type') String? unitType,
    required List<ChainPriceDto> prices,
  }) = _BasketProductDto;

  factory BasketProductDto.fromJson(Map<String, dynamic> json) =>
      _$BasketProductDtoFromJson(json);
}
