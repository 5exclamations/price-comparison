// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CategoriesResponseDto _$CategoriesResponseDtoFromJson(
  Map<String, dynamic> json,
) => _CategoriesResponseDto(
  items: (json['items'] as List<dynamic>)
      .map((e) => CategoryDto.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CategoriesResponseDtoToJson(
  _CategoriesResponseDto instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};

_CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => _CategoryDto(
  code: json['code'] as String,
  dealsCount: (json['deals_count'] as num).toInt(),
);

Map<String, dynamic> _$CategoryDtoToJson(_CategoryDto instance) =>
    <String, dynamic>{
      'code': instance.code,
      'deals_count': instance.dealsCount,
    };
