// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CatalogResponseDto _$CatalogResponseDtoFromJson(Map<String, dynamic> json) =>
    _CatalogResponseDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => SearchItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      nextCursor: json['next_cursor'] as String?,
      hasMore: json['has_more'] as bool,
    );

Map<String, dynamic> _$CatalogResponseDtoToJson(_CatalogResponseDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'next_cursor': instance.nextCursor,
      'has_more': instance.hasMore,
    };
