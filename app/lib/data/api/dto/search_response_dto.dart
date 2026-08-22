import 'package:freezed_annotation/freezed_annotation.dart';

part 'search_response_dto.freezed.dart';
part 'search_response_dto.g.dart';

/// Ответ GET /v1/search. Поля соответствуют OpenAPI-схеме сервера.
///
/// Деньги приходят как *_minor — целые гяпики. Тип int здесь принципиален:
/// double в деньгах запрещён во всём проекте, и генератор моделей обязан
/// видеть в схеме integer, а не number.
@freezed
abstract class SearchResponseDto with _$SearchResponseDto {
  const factory SearchResponseDto({
    @JsonKey(name: 'next_cursor') String? nextCursor,
    @JsonKey(name: 'has_more') required bool hasMore,
    required String query,
    @JsonKey(name: 'normalized_query') required String normalizedQuery,
    @JsonKey(name: 'matched_by') required String matchedBy,
    required List<SearchItemDto> items,
  }) = _SearchResponseDto;

  factory SearchResponseDto.fromJson(Map<String, dynamic> json) =>
      _$SearchResponseDtoFromJson(json);
}

@freezed
abstract class SearchItemDto with _$SearchItemDto {
  const factory SearchItemDto({
    @JsonKey(name: 'product_id') required int productId,
    required String name,
    String? brand,
    String? ean,
    @JsonKey(name: 'unit_value') double? unitValue,
    @JsonKey(name: 'unit_type') String? unitType,
    @JsonKey(name: 'best_price_minor') int? bestPriceMinor,
    @JsonKey(name: 'best_price_chain') String? bestPriceChain,
    @JsonKey(name: 'chains_count') required int chainsCount,
    @JsonKey(name: 'has_promo') required bool hasPromo,
    @JsonKey(name: 'observed_at') DateTime? observedAt,
    @JsonKey(name: 'needs_store_selection')
    @Default(false)
    bool needsStoreSelection,
  }) = _SearchItemDto;

  factory SearchItemDto.fromJson(Map<String, dynamic> json) =>
      _$SearchItemDtoFromJson(json);
}
