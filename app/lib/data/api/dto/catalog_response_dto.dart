import 'package:freezed_annotation/freezed_annotation.dart';

import 'search_response_dto.dart';

part 'catalog_response_dto.freezed.dart';
part 'catalog_response_dto.g.dart';

/// Ответ каталога. Строки те же, что у поиска, но без его полей: query и
/// matched_by объясняют, ПОЧЕМУ нашлось именно это, а в каталоге объяснять
/// нечего — человек не искал, он смотрит раздел целиком.
@freezed
abstract class CatalogResponseDto with _$CatalogResponseDto {
  const factory CatalogResponseDto({
    required List<SearchItemDto> items,
    @JsonKey(name: 'next_cursor') String? nextCursor,
    @JsonKey(name: 'has_more') required bool hasMore,
  }) = _CatalogResponseDto;

  factory CatalogResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CatalogResponseDtoFromJson(json);
}
