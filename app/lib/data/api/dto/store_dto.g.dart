// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoresResponseDto _$StoresResponseDtoFromJson(Map<String, dynamic> json) =>
    _StoresResponseDto(
      items: (json['items'] as List<dynamic>)
          .map((e) => StoreDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      coordinatesKnown: (json['coordinates_known'] as num).toInt(),
    );

Map<String, dynamic> _$StoresResponseDtoToJson(_StoresResponseDto instance) =>
    <String, dynamic>{
      'items': instance.items.map((e) => e.toJson()).toList(),
      'coordinates_known': instance.coordinatesKnown,
    };

_StoreDto _$StoreDtoFromJson(Map<String, dynamic> json) => _StoreDto(
  storeId: (json['store_id'] as num?)?.toInt(),
  chainId: (json['chain_id'] as num).toInt(),
  chainCode: json['chain_code'] as String,
  chainName: json['chain_name'] as String,
  priceModel: json['price_model'] as String,
  name: json['name'] as String,
  format: json['format'] as String?,
  priceCluster: json['price_cluster'] as String?,
  address: json['address'] as String?,
  lat: (json['lat'] as num?)?.toDouble(),
  lon: (json['lon'] as num?)?.toDouble(),
  distanceM: (json['distance_m'] as num?)?.toInt(),
  synthetic: json['synthetic'] as bool,
);

Map<String, dynamic> _$StoreDtoToJson(_StoreDto instance) => <String, dynamic>{
  'store_id': instance.storeId,
  'chain_id': instance.chainId,
  'chain_code': instance.chainCode,
  'chain_name': instance.chainName,
  'price_model': instance.priceModel,
  'name': instance.name,
  'format': instance.format,
  'price_cluster': instance.priceCluster,
  'address': instance.address,
  'lat': instance.lat,
  'lon': instance.lon,
  'distance_m': instance.distanceM,
  'synthetic': instance.synthetic,
};
