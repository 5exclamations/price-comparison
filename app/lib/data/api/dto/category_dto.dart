import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_dto.freezed.dart';
part 'category_dto.g.dart';

/// Ответ GET /v1/categories.
@freezed
abstract class CategoriesResponseDto with _$CategoriesResponseDto {
  const factory CategoriesResponseDto({required List<CategoryDto> items}) =
      _CategoriesResponseDto;

  factory CategoriesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseDtoFromJson(json);
}

@freezed
abstract class CategoryDto with _$CategoryDto {
  const factory CategoryDto({
    required String code,
    @JsonKey(name: 'deals_count') required int dealsCount,
  }) = _CategoryDto;

  factory CategoryDto.fromJson(Map<String, dynamic> json) =>
      _$CategoryDtoFromJson(json);
}
